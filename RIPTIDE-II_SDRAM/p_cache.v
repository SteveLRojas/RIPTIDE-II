module p_cache(
		input wire clk,
		input wire rst,
		output wire p_cache_miss,
		input wire[15:0] CPU_address,
		output reg[15:0] CPU_data,
		output wire[13:0] mem_address,
		input wire[63:0] mem_data,
		output wire mem_req,
		input wire mem_ready,
		//debug outputs
		output wire p_reset_active,
		output wire p_fetch_active);

reg [1:0] word_address;
wire [8:0] block_address;
wire [8:0] block_address_hold;
reg [4:0] CPU_tag;
wire[4:0] CPU_tag_hold;
wire [4:0] mem_tag;
wire [71:0] cache_d;
wire [71:0] cache_q;
wire [15:0] word_0;
wire [15:0] word_1;
wire [15:0] word_2;
wire [15:0] word_3;
wire [8:0] cache_address;
wire p_miss;
reg p_miss_hold;
//reg prev_mem_ready;
reg fetch_active;
reg [15:0] CPU_address_hold;
reg reset_active;

assign block_address = CPU_address[10:2];
assign block_address_hold = CPU_address_hold[10:2];
assign CPU_tag_hold = CPU_address_hold[15:11];
assign word_0 = cache_q[15:0];
assign word_1 = cache_q[31:16];
assign word_2 = cache_q[47:32];
assign word_3 = cache_q[63:48];
assign mem_tag = cache_q[68:64];
assign cache_address = (fetch_active & mem_ready) ? block_address_hold : block_address;
assign cache_d = {3'h0, CPU_tag_hold, mem_data};
//assign mem_req = (p_miss & ~mem_ready & ~reset_active) | (reset_active & ~fetch_active);
assign mem_req = fetch_active & ~mem_ready;
assign mem_address = CPU_address_hold[15:2];
assign p_miss = (mem_tag != CPU_tag);
assign p_cache_miss = p_miss | p_miss_hold;
//debug outputs
assign p_reset_active = reset_active;
assign p_fetch_active = fetch_active;

always @(posedge clk)
begin
	if(rst)
	begin
		reset_active <= 1'b1;
		p_miss_hold <= 1'b1;
		CPU_address_hold <= 16'h0000;
		fetch_active <= 1'b0;
	end
	else if(reset_active)
	begin
		if(~fetch_active)
			fetch_active <= 1'b1;
		if(mem_ready)
		begin
			CPU_address_hold <= CPU_address_hold + 16'h0004;
			fetch_active <= 1'b0;
			if(&CPU_address_hold[10:2])
				reset_active <= 1'b0;
		end
	end
	else
	begin
		p_miss_hold <= p_miss;
		word_address <= CPU_address[1:0];
		if((~p_miss & ~fetch_active) | mem_ready)
			CPU_address_hold <= CPU_address;
		if(p_miss & ~mem_ready)
			fetch_active <= 1'b1;
		if(mem_ready)
			fetch_active <= 1'b0;
	end
	CPU_tag <= CPU_address[15:11];
	//prev_mem_ready <= mem_ready;
end

always @(*)
begin
	case(word_address)
	2'b00: CPU_data = word_0;
	2'b01: CPU_data = word_1;
	2'b10: CPU_data = word_2;
	2'b11: CPU_data = word_3;
	endcase
end

//`ifdef ALTERA_RESERVED_QIS
	p_mem p_mem_inst(.address(cache_address),	.clock(clk), .data(cache_d), .wren(mem_ready), .q(cache_q));
//`else
//	p_mem_model p_mem_model_inst(.address(cache_address),	.clock(clk), .data(cache_d), .wren(mem_ready), .q(cache_q));
//`endif
		
endmodule
