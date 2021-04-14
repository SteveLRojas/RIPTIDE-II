module serial(input logic clk, reset, A, CE, WREN, REN, rx, output logic tx, output logic[7:0] to_CPU, input logic[7:0] from_CPU);
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
UART UART_inst(clk, reset, tx_req, from_CPU, rx, tx, rx_data, tx_ready, rx_ready);
endmodule
