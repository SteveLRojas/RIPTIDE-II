module d_cache(
		input wire clk,
		input wire rst,
		input wire flush,
		output d_cache_miss,
		input wire CPU_wren,
		input wire CPU_ren,
		input wire[15:0] CPU_address,
		output reg[7:0] to_CPU,
		input wire[7:0] from_CPU,
		output wire[12:0] mem_address,
		input wire[63:0] from_mem,
		output wire[63:0] to_mem,
		output wire mem_req,
		output wire mem_wren,
		input wire mem_ready,
		//debug outputs
		output wire d_reset_active,
		output wire d_fetch_active);

reg [2:0] byte_address;
wire [8:0] block_address;
wire [8:0] block_address_hold;
reg [3:0] CPU_tag;
wire[3:0] CPU_tag_hold;
reg CPU_wren_hold;
reg[7:0] CPU_data_hold;
wire [3:0] mem_tag;
reg [71:0] cache_d;
wire [7:0] byte_0;
wire [7:0] byte_1;
wire [7:0] byte_2;
wire [7:0] byte_3;
wire [7:0] byte_4;
wire [7:0] byte_5;
wire [7:0] byte_6;
wire [7:0] byte_7;
wire [7:0] tag_byte;
reg [8:0] cache_address;
wire d_miss;
reg cache_wren;
reg prev_cache_wren;
reg d_miss_hold;
//reg prev_mem_ready;
reg fetch_active;
reg [15:0] CPU_address_hold;
reg reset_active;
reg flush_active;
reg write_active;
reg[63:0] mod_data;
wire mod_bit;
wire[12:0] writeback_address;

assign block_address = CPU_address[11:3];
assign block_address_hold = CPU_address_hold[11:3];
assign CPU_tag_hold = CPU_address_hold[15:12];
assign mem_req = fetch_active & ~mem_ready;
assign mem_address = write_active ? writeback_address : CPU_address_hold[15:3];
assign d_miss = (mem_tag != CPU_tag) & (CPU_wren | CPU_ren);
//assign d_cache_miss = d_miss | d_miss_hold | (CPU_wren_hold & CPU_ren);
assign d_cache_miss = d_miss | d_miss_hold | (prev_cache_wren & CPU_ren) | (fetch_active & CPU_wren);
assign mem_wren = write_active;
assign mem_tag = tag_byte[3:0];
assign mod_bit = tag_byte[4];
assign to_mem = {byte_7, byte_6, byte_5, byte_4, byte_3, byte_2, byte_1, byte_0};
assign writeback_address = {mem_tag, block_address_hold};
//debug outputs
assign d_reset_active = reset_active;
assign d_fetch_active = fetch_active;

always @(posedge clk)
begin
	if(rst | flush)
	begin
		write_active <= flush;
		flush_active <= flush;
		reset_active <= rst;
		d_miss_hold <= 1'b1;
		CPU_address_hold <= 16'h0000;
		fetch_active <= 1'b0;
		CPU_wren_hold <= 1'b0;
	end
	else if(reset_active | flush_active)
	begin
		if(~fetch_active)
			fetch_active <= 1'b1;
		if(mem_ready)
		begin
			CPU_address_hold <= CPU_address_hold + 16'h0008;
			fetch_active <= 1'b0;
			if(&CPU_address_hold[11:3])
			begin
				write_active <= 1'b0;
				flush_active <= 1'b0;
				reset_active <= 1'b0;
				CPU_address_hold <= 16'h0000;
				//if(write_active)
				//begin
				//	write_active <= 1'b0;
				//	CPU_address_hold <= 16'h0000;
				//end
				//else
				//	reset_active <= 1'b0;
			end
		end
	end
	else
	begin
		d_miss_hold <= d_miss;
		byte_address <= CPU_address[2:0];
		if((~d_miss & ~fetch_active) | mem_ready)
		begin
			CPU_address_hold <= CPU_address;
			CPU_data_hold <= from_CPU;
		end
		if(~d_miss & ~fetch_active)
			CPU_wren_hold <= CPU_wren;
		//if(d_miss & ~mem_ready & ~prev_mem_ready)
		if(d_miss & ~mem_ready)
			fetch_active <= 1'b1;
		if(mem_ready & ~write_active)
			fetch_active <= 1'b0;
		if(d_miss & ~mem_ready & mod_bit & ~fetch_active)
			write_active <= 1'b1;
		if(mem_ready)
			write_active <= 1'b0;
	end
	CPU_tag <= CPU_address[15:12];
	//prev_mem_ready <= mem_ready;
	prev_cache_wren <= cache_wren;
end

always @(*)
begin
	case(byte_address)
	3'b000: mod_data = {byte_7, byte_6, byte_5, byte_4, byte_3, byte_2, byte_1, CPU_data_hold};
	3'b001: mod_data = {byte_7, byte_6, byte_5, byte_4, byte_3, byte_2, CPU_data_hold, byte_0};
	3'b010: mod_data = {byte_7, byte_6, byte_5, byte_4, byte_3, CPU_data_hold, byte_1, byte_0};
	3'b011: mod_data = {byte_7, byte_6, byte_5, byte_4, CPU_data_hold, byte_2, byte_1, byte_0};
	3'b100: mod_data = {byte_7, byte_6, byte_5, CPU_data_hold, byte_3, byte_2, byte_1, byte_0};
	3'b101: mod_data = {byte_7, byte_6, CPU_data_hold, byte_4, byte_3, byte_2, byte_1, byte_0};
	3'b110: mod_data = {byte_7, CPU_data_hold, byte_5, byte_4, byte_3, byte_2, byte_1, byte_0};
	3'b111: mod_data = {CPU_data_hold, byte_6, byte_5, byte_4, byte_3, byte_2, byte_1, byte_0};
	endcase
	case(byte_address)
	3'b000: to_CPU = byte_0;
	3'b001: to_CPU = byte_1;
	3'b010: to_CPU = byte_2;
	3'b011: to_CPU = byte_3;
	3'b100: to_CPU = byte_4;
	3'b101: to_CPU = byte_5;
	3'b110: to_CPU = byte_6;
	3'b111: to_CPU = byte_7;
	endcase
	if(fetch_active & mem_ready)
		cache_d = {3'h0, CPU_tag_hold, from_mem};
	else
		cache_d = {3'h1, CPU_tag_hold, mod_data};
	if((fetch_active & mem_ready) | CPU_wren_hold | flush_active)
		cache_address = block_address_hold;
	else
		cache_address = block_address;
	cache_wren = (fetch_active & ~write_active & mem_ready) | (CPU_wren_hold & ~(d_miss & ~mem_ready));	//CPU_wren_hold & ~mem_req
	//cache wren is high when we are fetching from meory and memory is ready or when CPU is writing and we are not waiting on memory.
end

p_mem d_mem_inst(.address(cache_address),	.clock(clk), .data(cache_d), .wren(cache_wren), .q({tag_byte, byte_7, byte_6, byte_5, byte_4, byte_3, byte_2, byte_1, byte_0}));
	
endmodule

		