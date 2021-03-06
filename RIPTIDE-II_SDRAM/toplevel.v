//                     /\         /\__
//                   // \       (  0 )_____/\            __
//                  // \ \     (vv          o|          /^v\
//                //    \ \   (vvvv  ___-----^        /^^/\vv\
//              //  /     \ \ |vvvvv/               /^^/    \v\
//             //  /       (\\/vvvv/              /^^/       \v\
//            //  /  /  \ (  /vvvv/              /^^/---(     \v\
//           //  /  /    \( /vvvv/----(O        /^^/           \v\
//          //  /  /  \  (/vvvv/               /^^/             \v|
//        //  /  /    \( vvvv/                /^^/               ||
//       //  /  /    (  vvvv/                 |^^|              //
//      //  / /    (  |vvvv|                  /^^/            //
//     //  / /   (    \vvvvv\          )-----/^^/           //
//    // / / (          \vvvvv\            /^^^/          //
//   /// /(               \vvvvv\        /^^^^/          //
//  ///(              )-----\vvvvv\    /^^^^/-----(      \\
// //(                        \vvvvv\/^^^^/               \\
///(                            \vvvv^^^/                 //
//                                \vv^/         /        //
//                                             /<______//
//                                            <<<------/
//                                             \<
//                                              \
//**************************************************
//* Test platform for RIPTIDE-II processors.       *
//* Copyright (C) 2020 Esteban Looser-Rojas.       *
//* Instantiates the RIPTIDE-II CPU core along with*
//* cache controllers, an SDRAM controller, display*
//* controller, and input/output pripherals.       *
//**************************************************
module PVP(
		input wire reset,
		input wire clk,
		input wire[3:0] button,
		output wire[3:0] LED,
		
		input wire RXD,
		output wire TXD,
		
		input wire ps2_clk_d,
		input wire ps2_data_d,
		output wire ps2_clk_q,
		output wire ps2_data_q,
		
		output wire sdram_clk,
		output wire sdram_cke,
		output wire sdram_cs_n,
		output wire sdram_wre_n,
		output wire sdram_cas_n,
		output wire sdram_ras_n,
		output wire[11:0] sdram_a,
		output wire[1:0] sdram_ba,
		output wire[1:0] sdram_dqm,
		inout wire[15:0] sdram_dq,
		
      output wire R, G, B,
      output wire HSYNC, VSYNC,
		
		output wire[3:0] seg_sel,
		output wire[6:0] hex_out
		);

//Address map for left bank:
// 0x0000 to 0x0FFF	video memory (read write)
// 0x1000 to 0xFFEF	unused
// 0xFFF0 to 0xFFF3	timer module
// 0xFFF4 to 0xFFF5	keyboard module (read write)
// 0xFFF6 to 0xFFF7	video mode register (write only)
// 0xFFF8 to 0xFFFB	memory subsystem control registers	(write only)
// 0xFFFC to 0xFFFD	HEX display registers	(write only)
// 0xFFFE to 0xFFFF	RS-232 module	(read write)

//Address map for right bank:
// 0x0000 to 0xFFFF	active data memory page (cached)

//Address map for program space:
//0x0000 to 0xFFFF	active program memory page (cached)

// MSC Address map
// 0x0 program space control register
// 	bit0	reset bit
// 	bit1	reserved
// 	bit2	reserved
// 	bit3	control enable bit
// 0x1 program space page register
// 0x2 data space control register
// 	bit0	reset bit
// 	bit1	flush bit
// 	bit2	reserved
// 	bit3	control enable bit
// 0x3 data space page register

// RS-232 module address map
// 0 data register
// 1 status register
//		bit 0: TX overwrite
//		bit 1: RX overwrite
//		bit 2: TX ready
//		bit 3: RX ready
//		bit 4: TX queue empty
//		bit 5: RX queue full

// Keyboard module memory map
// 0 data register
// 1 status register
//		bit 0: TX overwrite
//		bit 1: RX overwrite
//		bit 2: TX ready
//		bit 3: RX ready
//		bit 4: TX queue empty
//		bit 5: RX queue full

// Timer module address map
// 0 counter bits 7:0
// 1 counter bits 15:8
// 2 counter bits 23:16
// 3 status
//		bit 0: counter 7:0 not zero
//		bit 1: counter 15:8 not zero
//		bit 2: counter 23:16 not zero
//		bit 3: counter 23:0 not zero
//		bit 4: VSYNC
//		bit 5: HSYNC

//####### PLL #################################################################
wire clk_25;
wire clk_sys;
PLL0 PLL_inst(.inclk0(clk), .c0(clk_25), .c1(clk_sys), .c2(sdram_clk));
//#############################################################################

//####### IO Control #########################################################
wire[15:0] data_address;
wire[7:0] from_CPU_left;
wire[7:0] to_CPU_left;
wire IO_WC;
wire IO_RC;
wire IO_n_LB_w;
wire IO_n_LB_r;
wire IO_wren;
wire IO_ren;
assign IO_wren = (~IO_n_LB_w & IO_WC);
assign IO_ren = (~IO_n_LB_r & IO_RC);

reg[3:0] button_s;
reg rst;
reg[7:0] hex_low;
reg[7:0] hex_high;

always @(posedge clk_sys)
begin
	button_s <= ~button;
	rst <= ~reset;
end

always @(posedge clk_sys or posedge rst)
begin
	if(rst)
	begin
		hex_low <= 8'h00;
		hex_high <= 8'h00;
	end
	else
	begin
		if(&data_address[15:2] && ~data_address[1] && ~data_address[0] && IO_wren)
			hex_low <= from_CPU_left[7:0];
		if(&data_address[15:2] && ~data_address[1] && data_address[0] && IO_wren)
			hex_high <= from_CPU_left[7:0];
	end
end

MULTIPLEXED_HEX_DRIVER multi_hex(
			.Clk(clk_sys),
			.SEG0(hex_low[3:0]),
			.SEG1(hex_low[7:4]),
			.SEG2(hex_high[3:0]),
			.SEG3(hex_high[7:4]),
			.SEG_SEL(seg_sel),
			.HEX_OUT(hex_out));
//#############################################################################

//####### Program Cache #######################################################
wire p_cache_miss;
wire[15:0] PRG_address;
wire[15:0] PRG_data;
wire[13:0] p1_address;
wire[63:0] p1_data;
wire p1_reset;
wire p1_req;
wire p1_ready;

p_cache p_cache_inst(
		.clk(clk_sys),
		.rst(p1_reset | button_s[2]),
		.p_cache_miss(p_cache_miss),
		.CPU_address(PRG_address),
		.CPU_data(PRG_data),
		.mem_address(p1_address),
		.mem_data(p1_data),
		.mem_req(p1_req),
		.mem_ready(p1_ready),
		.p_reset_active(LED[3]),
		.p_fetch_active(LED[2]));
//#############################################################################

//####### Data Cache ##########################################################
wire d_cache_miss;
wire[7:0] to_CPU_right;
wire[7:0] from_CPU_right;
wire[12:0] p2_address;
wire[63:0] p2_from_mem;
wire[63:0] p2_to_mem;
wire p2_reset;
wire p2_flush;
wire p2_req;
wire p2_wren;
wire p2_ready;

d_cache d_cache_inst(
		.clk(clk_sys),
		.rst(p2_reset | button_s[2]),
		.flush(p2_flush),
		.d_cache_miss(d_cache_miss),
		.CPU_wren(IO_WC & IO_n_LB_w),
		.CPU_ren(IO_RC & IO_n_LB_r),
		.CPU_address(data_address),
		.to_CPU(to_CPU_right),
		.from_CPU(from_CPU_right),
		.mem_address(p2_address),
		.from_mem(p2_from_mem),
		.to_mem(p2_to_mem),
		.mem_req(p2_req),
		.mem_wren(p2_wren),
		.mem_ready(p2_ready),
		.d_reset_active(LED[1]),
		.d_fetch_active(LED[0]));
//#############################################################################

//####### Main Memory #########################################################
wire[5:0] p1_page;
wire[6:0] p2_page;
wire init_req;
wire init_ready;
wire[15:0] init_data;
wire[11:0] init_address;

SDRAM_DP64_I SDRAM_controller(
		.clk(clk_sys),
		.rst(button_s[3] | rst),
		
		.p1_address(p1_address),
		.p1_page(p1_page),
		.p1_data(p1_data),
		.p1_req(p1_req),
		.p1_ready(p1_ready),
		
		.p2_address(p2_address),
		.p2_page(p2_page),
		.p2_to_mem(p2_to_mem),
		.p2_from_mem(p2_from_mem),
		.p2_req(p2_req),
		.p2_wren(p2_wren),
		.p2_ready(p2_ready),
		
		.sdram_cke(sdram_cke),
		.sdram_cs_n(sdram_cs_n),
		.sdram_wre_n(sdram_wre_n),
		.sdram_cas_n(sdram_cas_n),
		.sdram_ras_n(sdram_ras_n),
		.sdram_a(sdram_a),
		.sdram_ba(sdram_ba),
		.sdram_dqm(sdram_dqm),
		.sdram_dq(sdram_dq),
		
		.init_req(init_req),
		.init_ready(init_ready),
		.init_address(init_address),
		.init_data(init_data));
//#############################################################################
		
//####### ROM #################################################################
reg ROM_ready;
always @(posedge clk_sys)
begin
	ROM_ready <= init_req;
end
assign init_ready = ROM_ready;
	PRG_ROM PRG_inst(.address(init_address[11:0]), .clock(clk_sys), .q(init_data));
//############################################################################

//####### Serial Module #######################################################
wire serial_en;
wire[7:0] from_serial;
assign serial_en = &data_address[15:1];	//0xFFFE - 0xFFFF

serial serial_inst(
		.clk(clk_sys),
		.reset(rst),
		.A(data_address[0]),
		.CE(serial_en),
		.WREN(IO_wren),
		.REN(IO_ren),
		.rx(RXD),
		.tx(TXD),
		.to_CPU(from_serial),
		.from_CPU(from_CPU_left));
//#############################################################################

//####### keyboard Module #####################################################
wire keyboard_en;
wire[7:0] from_keyboard;
assign keyboard_en = (&data_address[15:4]) & ~data_address[3] & data_address[2] & ~data_address[1];	//0xFFF4 - 0xFFF5

keyboard keyboard_inst(
		.clk(clk_sys),
		.reset(rst),
		.A(data_address[0]),
		.CE(keyboard_en),
		.WREN(IO_wren),
		.REN(IO_ren),
		.ps2_data_d(ps2_data_d),
		.ps2_clk_d(ps2_clk_d),
		.ps2_data_q(ps2_data_q),
		.ps2_clk_q(ps2_clk_q),
		.to_CPU(from_keyboard),
		.from_CPU(from_CPU_left));
//#############################################################################

//####### Timer Module ########################################################
wire timer_en;
wire[7:0] from_timer;
assign timer_en = (&data_address[15:4]) & ~data_address[3] & ~data_address[2];

timer timer_inst(
		.clk(clk_sys),
		.rst(rst),
		.ce(timer_en),
		.wren(IO_wren),
		.ren(IO_ren),
		.hsync(HSYNC),
		.vsync(VSYNC),
		.addr(data_address[1:0]),
		.from_cpu(from_CPU_left),
		.to_cpu(from_timer));
//#############################################################################

//####### Memory Subsystem Control ############################################
wire MSC_en;
assign MSC_en = &data_address[15:3] && ~data_address[2] && IO_wren;

MSC MSC_inst(
		.clk(clk_sys),
		.rst(rst),
		.wren(MSC_en),
		.A(data_address[1:0]),
		.data(from_CPU_left[6:0]),
		.p1_page(p1_page),
		.p2_page(p2_page),
		.p1_reset(p1_reset),
		.p2_reset(p2_reset),
		.p2_flush(p2_flush),
		.p2_req(p2_req),
		.p1_req(p1_req),
		.p2_ready(p2_ready),
		.p1_ready(p1_ready));
//#############################################################################

//####### VGA Module ##########################################################
wire VGA_MS;
wire VGA_En;
wire VGA_WrEn;
wire[7:0] from_VGA;
assign VGA_MS = (&data_address[15:4]) & (~data_address[3]) & (&data_address[2:1]) & IO_wren;
assign VGA_En = ~(|data_address[15:12]);
assign VGA_WrEn = VGA_En & IO_wren;

VGA VGA_inst(
        .clk_sys(clk_sys),
        .clk_25(clk_25),
        .rst(rst),
        .VGA_MS(VGA_MS),
        .VGA_WrEn(VGA_WrEn),
        .VGA_Din(from_CPU_left),
        .VGA_A(data_address[11:0]),
        .VGA_Dout(from_VGA),
        .R(R), .G(G), .B(B),
        .HSYNC(HSYNC), .VSYNC(VSYNC));
//#############################################################################

//####### IO Multiplexer ######################################################
reg prev_VGA_en;
reg prev_keyboard_en;
reg prev_serial_en;
reg prev_timer_en;

always @(posedge clk_sys)
begin
	prev_VGA_en <= VGA_En;
	prev_keyboard_en <= keyboard_en;
	prev_serial_en <= serial_en;
	prev_timer_en <= timer_en;
end

wire[7:0] m_from_VGA;
wire[7:0] m_from_keyboard;
wire[7:0] m_from_serial;
wire[7:0] m_from_timer;

assign m_from_VGA = from_VGA & {8{prev_VGA_en}};
assign m_from_keyboard = from_keyboard & {8{prev_keyboard_en}};
assign m_from_serial = from_serial & {8{prev_serial_en}};
assign m_from_timer = from_timer & {8{prev_timer_en}};
assign to_CPU_left = m_from_VGA | m_from_keyboard | m_from_serial | m_from_timer;
//#############################################################################

//assign to_CPU_left = VGA_En ? from_VGA : (keyboard_en ? from_keyboard : from_serial);
//####### CPU Core ############################################################
RIPTIDE_II CPU_inst(
		.clk(clk_sys),
		.n_halt(~button_s[0]),
		.p_cache_miss(p_cache_miss),
		.d_cache_miss(d_cache_miss),
		.n_reset(~(rst | button_s[1])),
		.I(PRG_data),
		.A(PRG_address),
		.address(data_address),
		.data_out({from_CPU_left, from_CPU_right}),
		.data_in({to_CPU_left, to_CPU_right}),
		.IO_WC(IO_WC),
		.IO_RC(IO_RC),
		.IO_n_LB_w(IO_n_LB_w),
		.IO_n_LB_r(IO_n_LB_r));
//#############################################################################
endmodule
