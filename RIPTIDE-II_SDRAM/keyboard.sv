module keyboard(
		input logic clk,
		input logic reset, 
		input logic A,
		input logic CE,
		input logic WREN,
		input logic REN,
		input logic ps2_clk_d,
		input logic ps2_data_d,
		output logic ps2_clk_q,
		output logic ps2_data_q,
		output logic[7:0] to_CPU,
		input logic[7:0] from_CPU);
// A is the address LSB to select data or status registers.
// CE is chip enable.
// WREN is write enable.
logic rx_done;
logic tx_done;
logic rx_overwrite;
logic tx_overwrite;	//status bits.

logic rx_ready;
logic tx_ready;
logic[7:0] rx_data;
logic tx_req;

assign tx_req = CE & WREN;

always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
		rx_done <= 1'b0;
		tx_done <= 1'b1;
		rx_overwrite <= 1'b0;
		tx_overwrite <= 1'b0;
		to_CPU <= 8'h00;
	end
	else
	begin
		to_CPU <= A ? {4'h0, rx_done, tx_done, rx_overwrite, tx_overwrite} : rx_data;
		if(CE & WREN)	//write new
		begin
			tx_done <= 1'b0;
			if(~tx_done)
				tx_overwrite <= 1'b1;
		end
		if(CE && REN)	// read
		begin
			if(A)	//read status
			begin
				tx_overwrite <= 1'b0;	//these are held for only one read cycle.
				rx_overwrite <= 1'b0;
			end
			else	//read data
				rx_done <= 1'b0;
		end
		if(tx_ready)
			tx_done <= 1'b1;
		if(rx_ready)
		begin
			rx_done <= 1'b1;
			if(rx_done)
				rx_overwrite <= 1'b1;
		end
	end
end
ps2_host ps2_host_inst(clk, reset, ps2_clk_d, ps2_data_d, from_CPU, tx_req, ps2_clk_q, ps2_data_q, rx_data, rx_ready, tx_ready);
endmodule
