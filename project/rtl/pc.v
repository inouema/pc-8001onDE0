//***************************************************************************************
// PC-8001 on the DE0 Altera CycloneIII version.
//
// Copyright (c) 2012 Masato INOUE
//***************************************************************************************
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


/////////////////////////////////////////////////////////////////////////////
// INCLUDE FILES
/////////////////////////////////////////////////////////////////////////////
//`include src/switch.v


/////////////////////////////////////////////////////////////////////////////
// MACRO
/////////////////////////////////////////////////////////////////////////////

////// DEBUG
//`define ICE
//`define TESTROM
`define PROTECT

////// USE CPU SELECTION
`define MCPU_FZ80
//`define MCPU_TV80

//`define USE_BOOT
//`define USE_BEEP_ON_OFF_ROM

/////////////////////////////////////////////////////////////////////////////
// PC-8001 I/O Interface
/////////////////////////////////////////////////////////////////////////////
module pc8001(
	input 		  I_CLK_50M, // Board Clock 50MHz.
	input 		  I_nRESET, // Board Reset. Low Active.

`ifdef ICE
	input 		  sclk,
	output 		  sdata,
`endif
	output 		  vtune,
	output 		  clk_out,
	inout 		  IO_USB_DP,
	inout 		  IO_USB_DM,
	output 		  ind,

	output [21:0] O_FL_ADDR, // Flash ROM Address Bus.
	input [ 7:0]  I_FL_DQ, // ROM Data Bus.
	output 		  O_FL_OE_N, // ROM OE.
	output 		  O_FL_CE_N, // Flash ROM Chip Enable.

	output [ 3:0] O_VGA_R,
	output [ 3:0] O_VGA_G,
	output [ 3:0] O_VGA_B,
	output 		  O_VGA_HS,
	output 		  O_VGA_VS,

	inout 		  IO_PS2_KBCLK,
	inout 		  IO_PS2_KBDAT,

	output 		  O_SD_CLK,
	output 		  O_SD_CMD,
	output 		  O_SD_DAT3,
	input 		  I_SD_DAT0,
	input 		  I_SD_WP_N,

	output 		  O_EPCS_DCLK,
	output 		  O_EPCS_CSO_N,
	output 		  O_EPCS_ASDO,
	input 		  I_EPCS_DATA,

	output [11:0] O_DRAM_ADDR,
	output [ 1:0] O_DRAM_BA,
	output 		  O_DRAM_CAS_N,
	output 		  O_DRAM_CKE,
	output        O_DRAM_CLK,
	output 		  O_DRAM_CS_N,
	inout [15:0]  IO_DRAM_DQ,
	output [ 1:0] O_DRAM_DQM,
	output 		  O_DRAM_RAS_N,
	output 		  O_DRAM_WE_N,

	output 		  beep_out,
	output reg 	  motor,
	output [ 9:0] O_LED,
	input [ 9:0]  I_SLIDE_SWITCH
          );

/////////////////////////////////////////////////////////////////////////////
// wire & register decralation
/////////////////////////////////////////////////////////////////////////////
   wire [15:0]   cpu_adr;
   wire [14:0]   dma_adr;
   wire [ 7:0]   cpu_data_in;
   wire [ 7:0]   cpu_data_out;
   wire [ 7:0]   kbd_data;

   wire         start;
   wire         waitreq;
   wire         cpu_reset_n;
   wire         mreq;
   wire         iorq;
   wire         rd;
   wire         wr;
   wire         busreq;
   wire         busack;

   wire        w_ram_ce;
   wire [ 7:0] w_ram_data;

   
`ifdef ICE
   reg ice_enable = 0;
`endif

 
 reg [ 5:0] waitcount = 0;   
 //reg [ 4:0] waitcount = 0;

  wire cdata;


`ifdef TESTROM
   wire  testrom_g;
   wire [ 7:0] testrom_data;
`endif

   reg [ 5:0]  vrtc = 0;
   reg        iorq0 = 0;
   reg        rd0 = 0;
   reg        port40h0 = 0;
   reg        reset1 = 0;
   reg        reset2 = 0;


/*
 * I_SLIDE_SWITCH Assign
 */
   wire       w_vga_charactor_size = I_SLIDE_SWITCH[0]; // 0: 8x8/Chara  1:16x8/Chara

// Key board
   wire [ 7:0] w_keyboard_data;


/////////////////////////////////////////////////////////////////////////////
// Sub System's wire,register's
/////////////////////////////////////////////////////////////////////////////
   wire [ 7:0] w_sub_gpio0;


/////////////////////////////////////////////////////////////////////////////
// Clock generate with ALT PLL
/////////////////////////////////////////////////////////////////////////////

   wire        w_clk_4m;
   wire        w_clk_8m;
   wire        w_clk_25m;
   wire        w_clk_14m;
   
   wire        clk;

  pll system_clk (
	              .inclk0 ( I_CLK_50M ),
	              .c0 ( w_clk_4m ),
	              .c1 ( w_clk_8m ),
	              .c2 ( w_clk_25m ),
	              .c3 ( w_clk_14m ) // 14.318M
	              );

   assign      clk = w_clk_25m;

   assign waitreq = start | waitcount < 16; // FZ80
// assign waitreq = start | waitcount < 21;

	always @(posedge clk) begin
		if (start) waitcount <= 0;
		else waitcount <= waitcount + 1;
	end

//
// Reset fillter
//
   wire w_n_reset;
   assign w_n_reset = I_nRESET;

   always @(posedge clk) begin
	  reset1 <= ~w_n_reset;
	  reset2 <= reset1;
   end

// wire reset = ~cpu_reset_n | ~reset1 & reset2;
   wire reset = ~reset1 & reset2;


	/**
	 * I/O Device's
	 */
	// key board
   wire port00h = cpu_adr[7:4] == 4'h0;  // Keyboard
   wire [7:0] port00data;

	// SIO
	wire port20h = cpu_adr[7:0] == 8'h20; // SIO data register
	wire port21h = cpu_adr[7:0] == 8'h21; // SIO control register
	wire [ 7:0] port20data;
	wire [ 7:0] port21data;
   
	// motor etc...
   wire port30h = cpu_adr[7:0] == 8'h30;

   // RTC
   wire port40h = cpu_adr[7:4] == 4'h4;
   wire [7:0] port40data;

   wire port80h = cpu_adr[7:4] == 4'h8;
   wire porte0h = cpu_adr[7:3] == 5'b11100;
   wire portefh = cpu_adr[7:0] == 8'hef;

   wire [7:0] porte0data;

//   assign      port00data = ~kbd_data;
   assign      port00data = ~w_keyboard_data;
//   assign      port40data = { 2'b00, vrtc[5], cdata, 4'b1010 };
   assign      port40data = { 2'b00, vrtc[5], cdata, 4'b1110 }; // bit2 is CMT CDIN detected.
 //  assign    porte0data = boot_data_out;
   assign      porte0data = 8'hFF;

/*
 function [7:0] selin;
	input [3:0] sel;
	input [23:0] a;
	case (sel)
	4'h0: selin = a[23:16]; // keyboard
	4'h4: selin = a[15:8]; // rtc
	4'h8: selin = a[23:16]; // keyboard
	4'he: selin = a[7:0]; // boot
	default: selin = 8'hff;
	endcase
endfunction // selin

   	reg [7:0]   input_data;
	always @(posedge clk)
		input_data <= selin(cpu_adr[7:4], { port00data, port40data, porte0data });
*/

 function [7:0] selin;
		input [ 7:0] sel;
		input [ 7:0] port00;
		input [ 7:0] port20;
		input [ 7:0] port21;
		input [ 7:0] port40;
		input [ 7:0] porte0;

			case (sel)
				8'h00: selin = port00; // keyboard
				8'h01: selin = port00; // keyboard
				8'h02: selin = port00; // keyboard
				8'h03: selin = port00; // keyboard
				8'h04: selin = port00; // keyboard
				8'h05: selin = port00; // keyboard
				8'h06: selin = port00; // keyboard
				8'h07: selin = port00; // keyboard
				8'h08: selin = port00; // keyboard
				8'h09: selin = port00; // keyboard
				8'h20: selin = port20; // SIO data
				8'h21: selin = port21; // SIO control
				8'h40: selin = port40; // rtc
				8'h80: selin = port00; // keyboard(UKP)
				8'he0: selin = porte0; // boot
				default: selin = 8'hff;
			endcase
	endfunction // selin

	reg [7:0]   input_data;
	always @(posedge clk)
		input_data <= selin(cpu_adr[7:0], port00data, port20data, port21data, port40data, porte0data );




////////////////////////////////////////////
// --- Z80 Data Input Data Selector
/////////////////////////////////////////////
   wire [ 7:0]       w_memmory_data;
   assign            w_memmory_data = (w_ram_ce == 1'b1) ? w_ram_data : I_FL_DQ;

   function [7:0] f_selector_indata;
      input iorq;
      input rd;
      input [7:0] port_data;
      input [7:0] memmory_data;

      if     (iorq)         f_selector_indata = port_data;
      else if(rd) f_selector_indata = memmory_data;
      else                  f_selector_indata = 8'hFF;
   endfunction // f_selector_indata

   assign   cpu_data_in = f_selector_indata(iorq, rd, input_data, w_memmory_data);




	always @(posedge clk) begin
		if (~iorq & iorq0 & rd0 & port40h0) vrtc <= vrtc + 1;
		iorq0 <= iorq;
		rd0 <= rd;
		port40h0 <= port40h;
`ifdef ICE
		if (iorq & wr & portefh) ice_enable <= cpu_data_out[0];
`endif
	end



/////////////////////////////////////////////////////////////////////////////
// Z80 core
/////////////////////////////////////////////////////////////////////////////
`ifdef MCPU_KX_Z80
	kx_z80 kx_z80(
		.data_in(cpu_data_in),
		.data_out(cpu_data_out),
		.reset_in(reset),
		.clk(clk),
		.intreq(1'b0),
		.nmireq(1'b0),
		.busreq(busreq), 
		.mreq(mreq),
		.iorq(iorq),
		.rd(rd),
		.wr(wr),
		.busack_out(busack),
		.adr(cpu_adr),
		.waitreq(waitreq),
`ifdef ICE
		.ice_enable(ice_enable),
		.sclk(sclk),
		.sdata(sdata),
`endif // `ifdef ICE
		.start(start)
	);
`endif //  `ifdef MCPU_KX_Z80


//----------- FZ80 -----------
`ifdef MCPU_FZ80
   fz80 Z80(
             .data_in(cpu_data_in),
             //.data_in(w_iplrom_do),
             .reset_in(reset),
             .clk(clk),
             .adr(cpu_adr),
             .intreq(1'b0),
             .nmireq(1'b0),
             .busreq(busreq),
             .start(start),
             .mreq(mreq),
             .iorq(iorq),
             .rd(rd),
             .wr(wr),
             .data_out(cpu_data_out),
             .busack_out(busack),
             .intack_out(),
             .mr(),
             .m1(m1),
             //  .halt(halt),
             .radr(),
             .nmiack_out(),
             .waitreq(waitreq)
             );
`endif

//----------- TV80 -----------
`ifdef MCPU_TV80

wire [15:0] ZA;
wire [7:0] ZDO,ZDI;
wire ZMREQ_n,ZIORQ_n,ZM1_n,ZRD_n,ZWR_n, ZRFSH_n;
wire ZCLK, ZINT_n, ZRESET_n, ZWAIT_n;
wire ZBUSAK_n;

   assign ZRESET_n = ~reset;
   assign mreq     = ~ZMREQ_n;
   assign iorq     = ~ZIORQ_n;
   assign rd       = ~ZRD_n;
   assign wr       = ~ZWR_n;
   assign ZWAIT_n  = ~waitreq;
   assign busack   = ~ZBUSAK_n;
//   assign start    = 1'b1;

   
tv80c Z80(
  .reset_n(ZRESET_n),
  .clk(clk),
  .A(cpu_adr),
  .do(cpu_data_out),
  .di(cpu_data_in),
  .m1_n(),
  .mreq_n(ZMREQ_n),
  .iorq_n(ZIORQ_n),
  .rd_n(ZRD_n),
  .wr_n(ZWR_n),
  .wait_n(ZWAIT_n),
  .rfsh_n(),
  .int_n(1'b1),
  .nmi_n(1'b1),
  .busrq_n(~busreq),
  .halt_n(),
  .busak_n(ZBUSAK_n)
);
`endif


/////////////////////////////////////////////////////////////////////////////
// NOR Flash ROM
/////////////////////////////////////////////////////////////////////////////
   assign O_FL_CE_N  = busack ? 1'b1 : cpu_adr[15];
   assign O_FL_OE_N  = busack ? 1'b1 : (~mreq | ~rd);
//   assign IO_FL_DQ   = (wr & ~busack ) ? cpu_data_out : 8'hzz;
//   assign IO_FL_DQ   = (wr & ~busack ) ? 8'hFF : 8'hzz;
   assign O_FL_ADDR  = {7'b000_0000,cpu_adr[14:0]};

/////////////////////////////////////////////////////////////////////////////
// INSIDE RAM 32KByte
/////////////////////////////////////////////////////////////////////////////
   wire [14:0]  w_address;
   assign       w_address = busack ? dma_adr[14:0] : cpu_adr[14:0];

   wire         w_ram_rd;
   assign       w_ram_rd  = busack ? 1'b1 : mreq & rd;

   assign       w_ram_ce  = busack ? 1'b1 : cpu_adr[15] ? mreq : 1'b0;

   wire         w_ram_wr;
   assign       w_ram_wr  = busack ? 1'b0 : (mreq & wr);


   alt_ram_32kB ram(
	                .address ( w_address ),
	                .clken   ( w_ram_ce ),
	                .clock   ( clk ),
	                .data    ( cpu_data_out ),
	                .rden    ( w_ram_rd ),
	                .wren    ( w_ram_wr ),
	                .q       ( w_ram_data )
	                );



/////////////////////////////////////////////////////////////////////////////
/// CRTC
/////////////////////////////////////////////////////////////////////////////
`ifdef USE_CRTC
   crtc crtc(
             .clk        (clk),
             .r_out      (),
             .g_out      (),
             .b_out      (),
             .hs_out     (),
             .vs_out     (),
             .y_out      (y_out),
             .c_out      (c_out),
             .port30h_we (iorq & wr & start & cpu_adr[7:4] == 4'h3),
		     .crtc_we    (iorq & wr & start & cpu_adr[7:4] == 4'h5),
		     .adr        (cpu_adr[0]),
		     .data       (cpu_data_out),
		     .busreq     (busreq),
             .busack     (busack),
		     .ram_adr    (dma_adr),
             .ram_data   (w_ram_data)
             );
`endif //  `ifdef USE_CRTC

`ifdef TESTROM
	assign testrom_g = cpu_adr[15:11] == 5'b01100; // 6000h-67ffh
	testrom testrom(clk, cpu_adr[10:0], testrom_data);
`endif

`ifdef PROTECT
	wire narrow_wr = wr & ~start & (cpu_adr[15] | cpu_adr[14] & cpu_adr[13]);
`else
//	wire narrow_wr = wr & ~start;
//   	wire narrow_wr = wr & ;
`endif


/////////////////////////////////////////////////////////////////////////////
// UKP
/////////////////////////////////////////////////////////////////////////////

	wire [3:0] kbd_adr;
	assign kbd_adr[0] = cpu_adr[0] | port80h;
	assign kbd_adr[1] = cpu_adr[1] | port80h;
	assign kbd_adr[2] = cpu_adr[2] | port80h;
	assign kbd_adr[3] = cpu_adr[3] | port80h;
	ukp ukp(.clk(clk), .vcoclk(clk), .vtune(vtune), .usbclk(clk),
	.clk_out(clk_out), .usb_dm(IO_USB_DM), .usb_dp(IO_USB_DP), .record_n(ind),
	.kbd_adr(kbd_adr[3:0]), .kbd_data(kbd_data));
	//
	// RTC
	//
	reg [3:0] cin;
	reg cstb, cclk;
	always @(posedge clk) begin
		if (iorq & wr) begin
			if (cpu_adr[7:4] == 4'h1) cin <= cpu_data_out[3:0];
			if (cpu_adr[7:4] == 4'h4) begin
				cstb <= cpu_data_out[1];
				cclk <= cpu_data_out[2];
			end
		end
	end
	rtc rtc(.clk(clk), .cstb(cstb), .cclk(cclk), .cin(cin), .cdata(cdata), .ind());


/////////////////////////////////////////////////////////////////////////////
// BEEP
/////////////////////////////////////////////////////////////////////////////
   reg [11:0] beep_cnt;
   reg        beep_osc;
   reg        beep_gate;
   wire       beep_cy = beep_cnt == 2499;

	always @(posedge clk) begin
		beep_cnt <= beep_cy ? 0 : beep_cnt + 1;
		if (beep_cy) beep_osc <= ~beep_osc;
	end

	always @(posedge clk) begin
//		if (iorq & wr & port40h) beep_gate <= cpu_data_out[5];
		if (iorq & wr & port40h) beep_gate <= cpu_data_out[0];
	end

// AAAAA: debug
//	assign beep_out = beep_gate & beep_osc;
   assign beep_out = beep_gate;


/////////////////////////////////////////////////////////////////////////////
// MOTOR
/////////////////////////////////////////////////////////////////////////////
//	reg motor = 0;

//	always @(posedge clk) begin
//		if (iorq & wr & port30h) motor <= cpu_data_out[3];
//	end

	always @(posedge clk or posedge reset) begin
	   if(reset) begin
	      motor <= 0;
	   end
	   else begin
		if (iorq & wr & port30h) motor <= cpu_data_out[3];
	   end
	end

/////////////////////////////////////////////////////////////////////////////
// VGA
/////////////////////////////////////////////////////////////////////////////
   VGA VGA(
            .I_CLK(clk),
            .I_RST(reset),
            .I_PORT30_WE  (iorq & wr & start & cpu_adr[7:4] == 4'h3),
            .I_CRTC_WE    (iorq & wr & start & cpu_adr[7:4] == 4'h5),
            .I_ADR(cpu_adr[0]),
            .I_DATA(cpu_data_out),
            .I_RAM_DATA(w_ram_data),
            .O_RAM_ADR(dma_adr),
            .O_BUSREQ(busreq),
            .I_BUSACK(busack),
            .O_VGA_R(O_VGA_R),
            .O_VGA_G(O_VGA_G),
            .O_VGA_B(O_VGA_B),
            .O_VGA_HS(O_VGA_HS),
            .O_VGA_VS(O_VGA_VS),
            .I_VGA_CHARACTOR_SIZE(w_vga_charactor_size)
            );

/////////////////////////////////////////////////////////////////////////////
// KEY BOARD
/////////////////////////////////////////////////////////////////////////////
   
	KEYBOARD KEYBOARD(
           .I_CLK         (clk),
           .I_RST         (reset),
           .I_CPU_ADDR    (cpu_adr[3:0]),
           .I_CPU_IORQ    (iorq),
           .I_CPU_PORT00H (port00h),
           .O_KB_DATA     (w_keyboard_data),
           .IO_PS2CLK     (IO_PS2_KBCLK),
           .IO_PS2DATA    (IO_PS2_KBDAT)
           );



/////////////////////////////////////////////////////////////////////////////
// SIO Interface
/////////////////////////////////////////////////////////////////////////////

   CONTREG_8251 CONTREG_8251(
							 .I_CONTROL_EN   (port21h & iorq & start),
							 .I_DATA_EN      (port20h & iorq & start),
							 .I_WE           (wr),
							 .I_RD           (rd),
							 .I_DATA         (cpu_data_out),
							 .O_DATA         (port20data),
							 .O_CONTROL_DATA (port21data),
							 .I_MCU_WR       (w_sub_mcu_cmt_gpio_out[0]),
							 .I_MCU_RD       (w_sub_mcu_cmt_gpio_out[1]),
							 .I_MCU_DATA     (w_sub_mcu_cmt_dout),
							 .O_MCU_DATA     (w_sub_mcu_cmt_din),
							 .O_CMT_LOAD     (w_sub_mcu_cmt_gpio_in[0]),
							 .O_nCMTTxRDY    (w_sub_mcu_cmt_gpio_in[1]),
							 .O_CMT_SAVE     (w_sub_mcu_cmt_gpio_in[2]),
							 .O_nCMTRxRDY    (w_sub_mcu_cmt_gpio_in[3]),
							 .I_RST          (reset),
							 .I_CLK          (clk)
							 );


/////////////////////////////////////////////////////////////////////////////
// Sub System
/////////////////////////////////////////////////////////////////////////////


	wire [ 7:0] w_sub_mcu_cmt_din;
	wire [ 7:0] w_sub_mcu_cmt_gpio_in;
	wire [ 7:0] w_sub_mcu_cmt_dout;
	wire [ 7:0] w_sub_mcu_cmt_gpio_out;
	wire [ 7:0] w_sub_mcu_gpio0;
   
	assign w_sub_mcu_cmt_gpio_in[4] = motor;
	assign O_LED[0] = w_sub_mcu_gpio0[0];

	pc8001_sub_system SUB_SYSTEM(
	// GPIO interface
      .in_port_to_the_gpio1              (),
      .out_port_from_the_gpio0           (w_sub_mcu_gpio0),

	// CMT-SD Interface
      .in_port_to_the_cmt_din            (w_sub_mcu_cmt_din),
      .in_port_to_the_cmt_gpio_in        (w_sub_mcu_cmt_gpio_in),
      .out_port_from_the_cmt_dout        (w_sub_mcu_cmt_dout),
      .out_port_from_the_cmt_gpio_out    (w_sub_mcu_cmt_gpio_out),

	// SD/MMC Interface
      .MMC_CD_to_the_mmc_spi             (1'b0),
      .MMC_SCK_from_the_mmc_spi          (O_SD_CLK),
      .MMC_SDI_to_the_mmc_spi            (I_SD_DAT0),
      .MMC_SDO_from_the_mmc_spi          (O_SD_CMD),
      .MMC_WP_to_the_mmc_spi             (I_SD_WP_N),
      .MMC_nCS_from_the_mmc_spi          (O_SD_DAT3),

	// EPCS interface
      .data0_to_the_epcs_flash_controller  (I_EPCS_DATA),
      .dclk_from_the_epcs_flash_controller (O_EPCS_DCLK),
      .sce_from_the_epcs_flash_controller  (O_EPCS_CSO_N),
      .sdo_from_the_epcs_flash_controller  (O_EPCS_ASDO),

	// SDRAM interface
      .zs_addr_from_the_sdram              (O_DRAM_ADDR),
      .zs_ba_from_the_sdram                (O_DRAM_BA),
      .zs_cas_n_from_the_sdram             (O_DRAM_CAS_N),
      .zs_cke_from_the_sdram               (O_DRAM_CKE),
      .zs_cs_n_from_the_sdram              (O_DRAM_CS_N),
      .zs_dq_to_and_from_the_sdram         (IO_DRAM_DQ),
      .zs_dqm_from_the_sdram               (O_DRAM_DQM),
      .zs_ras_n_from_the_sdram             (O_DRAM_RAS_N),
      .zs_we_n_from_the_sdram              (O_DRAM_WE_N),
      .pll_sdram                           (O_DRAM_CLK),

	// SystemInterface
      .clk_0                             (I_CLK_50M), // 50MHz
      .reset_n                           (~reset)
    );


endmodule // module pc




/////////////////////////////////////////////////////////////////////////////
// E.O.F
/////////////////////////////////////////////////////////////////////////////