// CRTC
// version 1.01

//`define SHRINK_CG

module crtc(
			clk,
            r_out,
            g_out,
            b_out,
            hs_out,
            vs_out,
			y_out,
			c_out,
			port30h_we,
			crtc_we,
			adr,
			data,
			busreq,
			busack,
			ram_ce_n,
			ram_oe_n,
			ram_we_n,
			ram_adr,
			ram_data
			);

   // INPUT ports
   input clk;
   input busack;
   input port30h_we;
   input crtc_we;
   input adr;
   input [7:0] ram_data;
   input [7:0] data;

   // OUTPUT ports
   output        busreq, ram_ce_n, ram_oe_n, ram_we_n;
   output [16:0] ram_adr;
   output [ 3:0]  y_out, c_out;
   output [ 3:0] r_out;
   output [ 3:0] g_out;
   output [ 3:0] b_out;
   output        hs_out;
   output        vs_out;

   // Parameter's
   parameter START_H = 48;
   parameter END_H = START_H + 640;
   parameter START_V = 33;
   parameter END_V = START_V + 480;
   parameter CHCNT_RESET_V = START_V - 1;

    reg 	  q0 = 0;
	reg [9:0] dotcnt = 0;
	reg [8:0] hcnt = 0;
	reg [3:0] chcnt = 0;
	reg [7:0] chrline = 0;
	reg [6:0] text_adr = 0;
	reg [5:0] atr_adr = 0;
	reg [6:0] xcnt = 0;
	reg [4:0] ycnt = 0;
	reg [6:0] atr = 7'b1110000, atr0 = 7'b1110000;
	reg [6:0] vcnt = 0;
	reg [11:0] dma_src_adr = 0;
	reg [6:0] dma_dst_adr = 0;
	reg [1:0] state = 0;
	reg [6:0] xcurs = 0;
	reg [4:0] ycurs = 0;
	reg qinh = 0, qrev = 0, qcurs = 0, busreq = 0, width80 = 0, colormode = 0;
	reg [2:0] seq = 0;
	reg [3:0] lpc = 9;
	reg [14:0] atr_data = 0;
	wire [7:0] chrline_c, chrline_g;
	wire [7:0] text_data;
	wire chlast, dotl, dotr, rowbuf_we;

	wire hvalid = (dotcnt >= START_H) & (dotcnt < END_H);
	wire vvalid = (hcnt >= START_V) & (hcnt < END_V);
   
	wire burst = dotcnt >= 76 & dotcnt < 112;
   
	wire hsync = (dotcnt >= 0) & (dotcnt < 96);
	wire vsync = (hcnt   >= 0) & (hcnt   < 2);

   assign hs_out = ~hsync;
   assign vs_out = ~vsync;

   assign chlast = chcnt == lpc;

	/////////////////////////////////////////
	// register access
	////////////////////////////////////////
   always @(posedge clk) begin
	  if (port30h_we) begin
		 width80 <= data[0];
		 colormode <= ~data[1];
	  end
	  if (crtc_we) begin
		 if (adr) begin
			if (data == 8'h00) seq <= 5;
			if (data == 8'h80) ycurs <= 31;
			if (data == 8'h81) seq <= 7;
		 end
		 else begin
			if (seq == 3) lpc <= data[3:0];
			if (seq == 7) xcurs <= data[6:0];
			if (seq == 6) ycurs <= data[4:0];
			if (seq) seq <= seq == 6 ? 0 : seq - 1;
		 end
	  end
   end // always @ (posedge clk)

   /////////////////////////////////
   // Sync Genelator
   ////////////////////////////////
   always @(posedge clk) begin
	  if (dotcnt == 799) begin
		 dotcnt <= 0;
		 if (hcnt == 524) begin
			hcnt <= 0;
			vcnt <= vcnt + 1;
		 end
		 else begin
			if (~vvalid | chlast)
              chcnt <= 4'b0000;
			else
              chcnt <= chcnt + 1;

			hcnt <= hcnt + 1;
		 end
	  end
	  else begin
         dotcnt <= dotcnt + 1;
      end // else: !if(dotcnt == 799)
      
   end // always @ (posedge clk)

   ///////////////////////////////////////////////////////
   // DMA state
   //////////////////////////////////////////////////////
   always @(posedge clk) begin
	  if (state == 0 & dotcnt == END_H) begin
		 if (hcnt == 0) dma_src_adr <= 12'h300;
		 if ((hcnt == CHCNT_RESET_V | chlast)) begin
			state <= 1;
			dma_dst_adr <= 0;
		 end
	  end
	  if (state == 1 & busack) state <= 2;
	  if (state == 2) state <= 3;
	  if (state == 3) begin
		 state <= dma_dst_adr == 7'h77 ? 0 : 2;
		 dma_src_adr <= dma_src_adr + 1;
		 dma_dst_adr <= dma_dst_adr + 1;
	  end
	  busreq <= state != 0;
   end // always @ (posedge clk)
   
   assign ram_ce_n = 1'b0;
   assign ram_oe_n = 1'b0;
   assign ram_we_n = 1'b1;
   
   assign ram_adr = { 5'h0f, dma_src_adr };

   /////////////////////////////////////////////
   // text
   ////////////////////////////////////////////
   always @(posedge clk) begin
	  if (hvalid & dotcnt[2:0] == 3'b111) begin
		 text_adr <= text_adr + 1;
		 xcnt <= xcnt + 1;
	  end
//	  if (dotcnt == 909) begin
	  if (dotcnt == 783) begin
		 text_adr <= 0;
		 xcnt <= 0;
	  end
   end // always @ (posedge clk)

   //
   // attribute
   //
   always @(posedge clk) begin
	  if (dotcnt[2:0] == 3'b001) atr_data[14:8] <= text_data[6:0];
	  if (dotcnt[2:0] == 3'b011) atr_data[7:0] <= text_data;
	  if (hvalid & dotcnt[2:0] == 3'b110 & atr_data[14:8] == xcnt) begin
		 atr_adr <= atr_adr + 1;
		 if (colormode & atr_data[3]) atr[6:3] <= atr_data[7:4];
		 else atr[2:0] <= atr_data[2:0];
		 if (~colormode) atr[6:3] <= { 3'b111, atr_data[7] };
	  end
//	  if (dotcnt == 909) begin
	  if (dotcnt == 783) begin
		 if (hcnt == CHCNT_RESET_V) begin
			atr_adr <= 6'h28;
			ycnt <= 0;
		 end
		 else if (chlast) begin
			atr_adr <= 6'h28;
			atr0 <= atr;
			ycnt <= ycnt + 1;
		 end
		 else begin
			atr_adr <= 6'h28;
			atr <= atr0;
		 end
	  end
   end
   //
   // color
   //
   reg  [2:0] color;
   wire [3:0] col;
   wire [2:0] ctmp;
   
   assign ctmp[2] = ~burst & color[2];
   assign ctmp[1] = ~burst & (color[2] ^ color[1]);
   assign ctmp[0] = ~burst & (color[2] ^ color[0]);
   
   colordata colordata(
					   .clk(clk),
					   .adr({ burst, ctmp[1:0], ctmp[2] ^ dotcnt[1] ^ hcnt[0], dotcnt[0] }),
					   .data(col)
					   );
   //
   assign rowbuf_we = state == 3;
   wire [6:0] rowbuf_adr = dotcnt[2] ? text_adr : { atr_adr, dotcnt[1] };

 `ifdef USE_XILINX
   RAMB4_S8_S8 rowbuf(
					  .WEA(1'b0),
					  .ENA(1'b1),
					  .RSTA(1'b0),
					  .CLKA(clk), 
					  .ADDRA({ 2'b00, rowbuf_adr }),
					  .DIA(8'h00),
					  .DOA(text_data),
					  .WEB(rowbuf_we),
					  .ENB(1'b1),
					  .RSTB(1'b0),
					  .CLKB(clk),
					  .ADDRB({ 2'b00, dma_dst_adr}),
					  .DIB(ram_data),
					  .DOB()
					  );
 `endif //  `ifdef USE_XILINX


   ARAMB4_S8_S8 rowbuf(
	                   .data_a(8'h00),
	                   .wren_a(1'b0),
	                   .address_a({ 2'b00, rowbuf_adr }),

	                   .data_b(ram_data),
	                   .address_b({ 2'b00, dma_dst_adr}),
	                   .wren_b(rowbuf_we),
	
	                   .clock_a(clk),
	                   .enable_a(1'b1),

	                   .clock_b(clk),
	                   .enable_b(1'b1),
	
	                   .aclr_a(1'b0),
	                   .aclr_b(1'b0),
	                   .q_a(text_data),
	                   .q_b()
	                   );


   cg cg(
		 .adr({ text_data, chcnt[2:0] }),
		 .clk(clk),
		 .data(chrline_c)
		 );




   function sel2;
	  input [1:0] s;
	  input [3:0] a;
	  case (s)
		2'b00: sel2 = a[0];
		2'b01: sel2 = a[1];
		2'b10: sel2 = a[2];
		2'b11: sel2 = a[3];
	  endcase
   endfunction // sel2


   assign dotl = sel2(chcnt[2:1], text_data[3:0]);
   assign dotr = sel2(chcnt[2:1], text_data[7:4]);
   assign chrline_g = { dotl, dotl, dotl, dotl, dotr, dotr, dotr, dotr };

   always @(posedge clk) begin
	  if (dotcnt[2:0] == 3'b111 & (width80 | ~dotcnt[3])) begin

		 if (hvalid & vvalid & ~chcnt[3])
		   chrline <= atr[3] ? chrline_g : chrline_c;
		 else
           chrline <= 8'b00000000;

		 qinh <= atr[0] | (atr[1] & vcnt[6:5] == 2'b00);
		 qrev <= atr[2] & hvalid & vvalid;
		 qcurs <= vcnt[5] & hvalid & xcnt == xcurs & ycnt == ycurs;
		 color <= atr[6:4];
	  end
	  else if (width80 | dotcnt[0]) begin
         chrline <= chrline << 1;
      end

   end // always @ (posedge clk)
   
   wire d0 = hsync ~^ vsync;
   wire y0 = (chrline[7] & ~qinh) ^ qrev ^ qcurs;
   
   always @(posedge clk)
	 q0 <= d0;

   reg [ 3:0] r_g;
   reg [ 3:0] r_b;

   assign     g_out = r_g;
   assign     r_out = chrline[7] ? 4'b1111 : 4'b0000;
   assign     b_out = r_b;
   
   always @(posedge clk) begin
       if(vvalid) begin
          r_b <= 4'b1111;
       end
      else begin
         r_b <= 4'b0000;
       end
   end

  always @(posedge clk) begin
       if(hvalid) begin
          r_g <= 4'b1111;
       end
       else begin
          r_g <= 4'b0000;
       end
   end


   assign y_out = y0 ? { 1'b1, color[2:0] } : q0 ? 4'h8 : 4'h4;
   assign c_out = burst | y0 ? col : 4'h8;

endmodule // crtc






module colordata(clk, adr, data);
   input clk;
   input [4:0] adr;
   output [3:0] data;
   reg [3:0] 	data;
   always @(posedge clk) begin
	  case (adr)
		5'b00100: data = 4'h2; // 0011
		5'b00101: data = 4'h7; // 0111
		5'b00110: data = 4'he; // 1110
		5'b00111: data = 4'h9; // 1001
		5'b01000: data = 4'ha; // 1010
		5'b01001: data = 4'he; // 1110
		5'b01010: data = 4'h6; // 0110
		5'b01011: data = 4'h2; // 0010
		5'b01100: data = 4'h4; // 0100
		5'b01101: data = 4'hd; // 1101
		5'b01110: data = 4'hc; // 1100
		5'b01111: data = 4'h3; // 0011
		5'b10000: data = 4'he; // 1110
		5'b10001: data = 4'h8; // 1000
		5'b10010: data = 4'h2; // 0010
		5'b10011: data = 4'h8; // 1000
		default: data = 4'h8;
	  endcase
   end
endmodule

// adr[10:3] character name
// adr[2:0] line of character

module cg(clk, adr, data);
	input clk;
	input [10:0] adr;
	output [7:0] data;
	reg [7:0] data;
	always @(posedge clk) begin
		case (adr)
			11'h000: data = 8'b00000000;
			11'h001: data = 8'b00000000;
			11'h002: data = 8'b00000000;
			11'h003: data = 8'b00000000;
			11'h004: data = 8'b00000000;
			11'h005: data = 8'b00000000;
			11'h006: data = 8'b00000000;
			11'h007: data = 8'b00000000;
			11'h008: data = 8'b01110000;
			11'h009: data = 8'b01000000;
			11'h00a: data = 8'b01110000;
			11'h00b: data = 8'b00011010;
			11'h00c: data = 8'b01111010;
			11'h00d: data = 8'b00001110;
			11'h00e: data = 8'b00001010;
			11'h00f: data = 8'b00001010;
			11'h010: data = 8'b01110000;
			11'h011: data = 8'b01000000;
			11'h012: data = 8'b01110000;
			11'h013: data = 8'b00010010;
			11'h014: data = 8'b01110100;
			11'h015: data = 8'b00001000;
			11'h016: data = 8'b00010100;
			11'h017: data = 8'b00100010;
			11'h018: data = 8'b01110000;
			11'h019: data = 8'b01000000;
			11'h01a: data = 8'b01110000;
			11'h01b: data = 8'b01000010;
			11'h01c: data = 8'b01110100;
			11'h01d: data = 8'b00001000;
			11'h01e: data = 8'b00010100;
			11'h01f: data = 8'b00100010;
			11'h020: data = 8'b01110000;
			11'h021: data = 8'b01000000;
			11'h022: data = 8'b01110000;
			11'h023: data = 8'b01000000;
			11'h024: data = 8'b01111110;
			11'h025: data = 8'b00000100;
			11'h026: data = 8'b00000100;
			11'h027: data = 8'b00000100;
			11'h028: data = 8'b11100000;
			11'h029: data = 8'b10000000;
			11'h02a: data = 8'b11100000;
			11'h02b: data = 8'b10001100;
			11'h02c: data = 8'b11110010;
			11'h02d: data = 8'b00010010;
			11'h02e: data = 8'b00010010;
			11'h02f: data = 8'b00001101;
			11'h030: data = 8'b00100000;
			11'h031: data = 8'b01010000;
			11'h032: data = 8'b01110000;
			11'h033: data = 8'b01010010;
			11'h034: data = 8'b01010100;
			11'h035: data = 8'b00011000;
			11'h036: data = 8'b00010100;
			11'h037: data = 8'b00010010;
			11'h038: data = 8'b01110000;
			11'h039: data = 8'b01001000;
			11'h03a: data = 8'b01110000;
			11'h03b: data = 8'b01001000;
			11'h03c: data = 8'b01110100;
			11'h03d: data = 8'b00000100;
			11'h03e: data = 8'b00000100;
			11'h03f: data = 8'b00000111;
			11'h040: data = 8'b01110000;
			11'h041: data = 8'b01001000;
			11'h042: data = 8'b01110000;
			11'h043: data = 8'b01001111;
			11'h044: data = 8'b01110100;
			11'h045: data = 8'b00000111;
			11'h046: data = 8'b00000001;
			11'h047: data = 8'b00000111;
			11'h048: data = 8'b01010000;
			11'h049: data = 8'b01010000;
			11'h04a: data = 8'b01110000;
			11'h04b: data = 8'b01010000;
			11'h04c: data = 8'b01011110;
			11'h04d: data = 8'b00000100;
			11'h04e: data = 8'b00000100;
			11'h04f: data = 8'b00000100;
			11'h050: data = 8'b01000000;
			11'h051: data = 8'b01000000;
			11'h052: data = 8'b01000000;
			11'h053: data = 8'b01001110;
			11'h054: data = 8'b01111000;
			11'h055: data = 8'b00001100;
			11'h056: data = 8'b00001000;
			11'h057: data = 8'b00001000;
			11'h058: data = 8'b01010000;
			11'h059: data = 8'b01010000;
			11'h05a: data = 8'b01110000;
			11'h05b: data = 8'b01010000;
			11'h05c: data = 8'b01010001;
			11'h05d: data = 8'b00011011;
			11'h05e: data = 8'b00010101;
			11'h05f: data = 8'b00010001;
			11'h060: data = 8'b00111100;
			11'h061: data = 8'b01000000;
			11'h062: data = 8'b01000000;
			11'h063: data = 8'b01000100;
			11'h064: data = 8'b00111000;
			11'h065: data = 8'b00001000;
			11'h066: data = 8'b00001000;
			11'h067: data = 8'b00001111;
			11'h068: data = 8'b00111000;
			11'h069: data = 8'b01000000;
			11'h06a: data = 8'b01000000;
			11'h06b: data = 8'b00111110;
			11'h06c: data = 8'b00001001;
			11'h06d: data = 8'b00001110;
			11'h06e: data = 8'b00001010;
			11'h06f: data = 8'b00001001;
			11'h070: data = 8'b01110000;
			11'h071: data = 8'b01000000;
			11'h072: data = 8'b01110000;
			11'h073: data = 8'b00010000;
			11'h074: data = 8'b01111100;
			11'h075: data = 8'b00010010;
			11'h076: data = 8'b00010010;
			11'h077: data = 8'b00001100;
			11'h078: data = 8'b01110000;
			11'h079: data = 8'b01000000;
			11'h07a: data = 8'b01110000;
			11'h07b: data = 8'b00010000;
			11'h07c: data = 8'b01111110;
			11'h07d: data = 8'b00000100;
			11'h07e: data = 8'b00000100;
			11'h07f: data = 8'b00001110;
			11'h080: data = 8'b01110000;
			11'h081: data = 8'b01001000;
			11'h082: data = 8'b01001000;
			11'h083: data = 8'b01001111;
			11'h084: data = 8'b01110100;
			11'h085: data = 8'b00000111;
			11'h086: data = 8'b00000100;
			11'h087: data = 8'b00000111;
			11'h088: data = 8'b01110000;
			11'h089: data = 8'b01001000;
			11'h08a: data = 8'b01001000;
			11'h08b: data = 8'b01001010;
			11'h08c: data = 8'b01110110;
			11'h08d: data = 8'b00000010;
			11'h08e: data = 8'b00000010;
			11'h08f: data = 8'b00000111;
			11'h090: data = 8'b01110000;
			11'h091: data = 8'b01001000;
			11'h092: data = 8'b01001000;
			11'h093: data = 8'b01001110;
			11'h094: data = 8'b01110001;
			11'h095: data = 8'b00000110;
			11'h096: data = 8'b00001000;
			11'h097: data = 8'b00001111;
			11'h098: data = 8'b01110000;
			11'h099: data = 8'b01001000;
			11'h09a: data = 8'b01001000;
			11'h09b: data = 8'b01001111;
			11'h09c: data = 8'b01110001;
			11'h09d: data = 8'b00000111;
			11'h09e: data = 8'b00000001;
			11'h09f: data = 8'b00001111;
			11'h0a0: data = 8'b01110000;
			11'h0a1: data = 8'b01001000;
			11'h0a2: data = 8'b01001000;
			11'h0a3: data = 8'b01001010;
			11'h0a4: data = 8'b01110110;
			11'h0a5: data = 8'b00001010;
			11'h0a6: data = 8'b00011111;
			11'h0a7: data = 8'b00000010;
			11'h0a8: data = 8'b01001000;
			11'h0a9: data = 8'b01101000;
			11'h0aa: data = 8'b01011000;
			11'h0ab: data = 8'b01001001;
			11'h0ac: data = 8'b01001010;
			11'h0ad: data = 8'b00001100;
			11'h0ae: data = 8'b00001010;
			11'h0af: data = 8'b00001001;
			11'h0b0: data = 8'b01110000;
			11'h0b1: data = 8'b01000000;
			11'h0b2: data = 8'b01110000;
			11'h0b3: data = 8'b00010000;
			11'h0b4: data = 8'b01111001;
			11'h0b5: data = 8'b00001101;
			11'h0b6: data = 8'b00001011;
			11'h0b7: data = 8'b00001001;
			11'h0b8: data = 8'b01110000;
			11'h0b9: data = 8'b01000000;
			11'h0ba: data = 8'b01110000;
			11'h0bb: data = 8'b01001110;
			11'h0bc: data = 8'b01111001;
			11'h0bd: data = 8'b00001110;
			11'h0be: data = 8'b00001001;
			11'h0bf: data = 8'b00001110;
			11'h0c0: data = 8'b00111000;
			11'h0c1: data = 8'b01000000;
			11'h0c2: data = 8'b01000000;
			11'h0c3: data = 8'b00111000;
			11'h0c4: data = 8'b00001001;
			11'h0c5: data = 8'b00001101;
			11'h0c6: data = 8'b00001011;
			11'h0c7: data = 8'b00001001;
			11'h0c8: data = 8'b01110000;
			11'h0c9: data = 8'b01000000;
			11'h0ca: data = 8'b01110000;
			11'h0cb: data = 8'b01000000;
			11'h0cc: data = 8'b01110001;
			11'h0cd: data = 8'b00011011;
			11'h0ce: data = 8'b00010101;
			11'h0cf: data = 8'b00010001;
			11'h0d0: data = 8'b01110000;
			11'h0d1: data = 8'b01000000;
			11'h0d2: data = 8'b01110000;
			11'h0d3: data = 8'b00011100;
			11'h0d4: data = 8'b01110010;
			11'h0d5: data = 8'b00011100;
			11'h0d6: data = 8'b00010010;
			11'h0d7: data = 8'b00011100;
			11'h0d8: data = 8'b01110000;
			11'h0d9: data = 8'b01000000;
			11'h0da: data = 8'b01110000;
			11'h0db: data = 8'b01000000;
			11'h0dc: data = 8'b01111110;
			11'h0dd: data = 8'b00010000;
			11'h0de: data = 8'b00010000;
			11'h0df: data = 8'b00001110;
			11'h0e0: data = 8'b00000000;
			11'h0e1: data = 8'b00001000;
			11'h0e2: data = 8'b00000100;
			11'h0e3: data = 8'b01111110;
			11'h0e4: data = 8'b00000100;
			11'h0e5: data = 8'b00001000;
			11'h0e6: data = 8'b00000000;
			11'h0e7: data = 8'b00000000;
			11'h0e8: data = 8'b00000000;
			11'h0e9: data = 8'b00010000;
			11'h0ea: data = 8'b00100000;
			11'h0eb: data = 8'b01111110;
			11'h0ec: data = 8'b00100000;
			11'h0ed: data = 8'b00010000;
			11'h0ee: data = 8'b00000000;
			11'h0ef: data = 8'b00000000;
			11'h0f0: data = 8'b00000000;
			11'h0f1: data = 8'b00001000;
			11'h0f2: data = 8'b00011100;
			11'h0f3: data = 8'b00101010;
			11'h0f4: data = 8'b00001000;
			11'h0f5: data = 8'b00001000;
			11'h0f6: data = 8'b00001000;
			11'h0f7: data = 8'b00000000;
			11'h0f8: data = 8'b00000000;
			11'h0f9: data = 8'b00001000;
			11'h0fa: data = 8'b00001000;
			11'h0fb: data = 8'b00001000;
			11'h0fc: data = 8'b00101010;
			11'h0fd: data = 8'b00011100;
			11'h0fe: data = 8'b00001000;
			11'h0ff: data = 8'b00000000;
			11'h100: data = 8'b00000000;
			11'h101: data = 8'b00000000;
			11'h102: data = 8'b00000000;
			11'h103: data = 8'b00000000;
			11'h104: data = 8'b00000000;
			11'h105: data = 8'b00000000;
			11'h106: data = 8'b00000000;
			11'h107: data = 8'b00000000;
			11'h108: data = 8'b00001000;
			11'h109: data = 8'b00001000;
			11'h10a: data = 8'b00001000;
			11'h10b: data = 8'b00001000;
			11'h10c: data = 8'b00000000;
			11'h10d: data = 8'b00000000;
			11'h10e: data = 8'b00001000;
			11'h10f: data = 8'b00000000;
			11'h110: data = 8'b00100100;
			11'h111: data = 8'b00100100;
			11'h112: data = 8'b00100100;
			11'h113: data = 8'b00000000;
			11'h114: data = 8'b00000000;
			11'h115: data = 8'b00000000;
			11'h116: data = 8'b00000000;
			11'h117: data = 8'b00000000;
			11'h118: data = 8'b00100100;
			11'h119: data = 8'b00100100;
			11'h11a: data = 8'b01111110;
			11'h11b: data = 8'b00100100;
			11'h11c: data = 8'b01111110;
			11'h11d: data = 8'b00100100;
			11'h11e: data = 8'b00100100;
			11'h11f: data = 8'b00000000;
			11'h120: data = 8'b00001000;
			11'h121: data = 8'b00011110;
			11'h122: data = 8'b00101000;
			11'h123: data = 8'b00011100;
			11'h124: data = 8'b00001010;
			11'h125: data = 8'b00111100;
			11'h126: data = 8'b00001000;
			11'h127: data = 8'b00000000;
			11'h128: data = 8'b00000000;
			11'h129: data = 8'b01100010;
			11'h12a: data = 8'b01100100;
			11'h12b: data = 8'b00001000;
			11'h12c: data = 8'b00010000;
			11'h12d: data = 8'b00100110;
			11'h12e: data = 8'b01000110;
			11'h12f: data = 8'b00000000;
			11'h130: data = 8'b00110000;
			11'h131: data = 8'b01001000;
			11'h132: data = 8'b01001000;
			11'h133: data = 8'b00110000;
			11'h134: data = 8'b01001010;
			11'h135: data = 8'b01000100;
			11'h136: data = 8'b00111010;
			11'h137: data = 8'b00000000;
			11'h138: data = 8'b00000100;
			11'h139: data = 8'b00001000;
			11'h13a: data = 8'b00010000;
			11'h13b: data = 8'b00000000;
			11'h13c: data = 8'b00000000;
			11'h13d: data = 8'b00000000;
			11'h13e: data = 8'b00000000;
			11'h13f: data = 8'b00000000;
			11'h140: data = 8'b00000100;
			11'h141: data = 8'b00001000;
			11'h142: data = 8'b00010000;
			11'h143: data = 8'b00010000;
			11'h144: data = 8'b00010000;
			11'h145: data = 8'b00001000;
			11'h146: data = 8'b00000100;
			11'h147: data = 8'b00000000;
			11'h148: data = 8'b00100000;
			11'h149: data = 8'b00010000;
			11'h14a: data = 8'b00001000;
			11'h14b: data = 8'b00001000;
			11'h14c: data = 8'b00001000;
			11'h14d: data = 8'b00010000;
			11'h14e: data = 8'b00100000;
			11'h14f: data = 8'b00000000;
			11'h150: data = 8'b00001000;
			11'h151: data = 8'b00101010;
			11'h152: data = 8'b00011100;
			11'h153: data = 8'b00111110;
			11'h154: data = 8'b00011100;
			11'h155: data = 8'b00101010;
			11'h156: data = 8'b00001000;
			11'h157: data = 8'b00000000;
			11'h158: data = 8'b00000000;
			11'h159: data = 8'b00001000;
			11'h15a: data = 8'b00001000;
			11'h15b: data = 8'b00111110;
			11'h15c: data = 8'b00001000;
			11'h15d: data = 8'b00001000;
			11'h15e: data = 8'b00000000;
			11'h15f: data = 8'b00000000;
			11'h160: data = 8'b00000000;
			11'h161: data = 8'b00000000;
			11'h162: data = 8'b00000000;
			11'h163: data = 8'b00000000;
			11'h164: data = 8'b00000000;
			11'h165: data = 8'b00001000;
			11'h166: data = 8'b00001000;
			11'h167: data = 8'b00010000;
			11'h168: data = 8'b00000000;
			11'h169: data = 8'b00000000;
			11'h16a: data = 8'b00000000;
			11'h16b: data = 8'b01111110;
			11'h16c: data = 8'b00000000;
			11'h16d: data = 8'b00000000;
			11'h16e: data = 8'b00000000;
			11'h16f: data = 8'b00000000;
			11'h170: data = 8'b00000000;
			11'h171: data = 8'b00000000;
			11'h172: data = 8'b00000000;
			11'h173: data = 8'b00000000;
			11'h174: data = 8'b00000000;
			11'h175: data = 8'b00011000;
			11'h176: data = 8'b00011000;
			11'h177: data = 8'b00000000;
			11'h178: data = 8'b00000000;
			11'h179: data = 8'b00000010;
			11'h17a: data = 8'b00000100;
			11'h17b: data = 8'b00001000;
			11'h17c: data = 8'b00010000;
			11'h17d: data = 8'b00100000;
			11'h17e: data = 8'b01000000;
			11'h17f: data = 8'b00000000;
			11'h180: data = 8'b00111100;
			11'h181: data = 8'b01000010;
			11'h182: data = 8'b01000110;
			11'h183: data = 8'b01011010;
			11'h184: data = 8'b01100010;
			11'h185: data = 8'b01000010;
			11'h186: data = 8'b00111100;
			11'h187: data = 8'b00000000;
			11'h188: data = 8'b00001000;
			11'h189: data = 8'b00011000;
			11'h18a: data = 8'b00101000;
			11'h18b: data = 8'b00001000;
			11'h18c: data = 8'b00001000;
			11'h18d: data = 8'b00001000;
			11'h18e: data = 8'b00111110;
			11'h18f: data = 8'b00000000;
			11'h190: data = 8'b00111100;
			11'h191: data = 8'b01000010;
			11'h192: data = 8'b00000010;
			11'h193: data = 8'b00001100;
			11'h194: data = 8'b00110000;
			11'h195: data = 8'b01000000;
			11'h196: data = 8'b01111110;
			11'h197: data = 8'b00000000;
			11'h198: data = 8'b00111100;
			11'h199: data = 8'b01000010;
			11'h19a: data = 8'b00000010;
			11'h19b: data = 8'b00011100;
			11'h19c: data = 8'b00000010;
			11'h19d: data = 8'b01000010;
			11'h19e: data = 8'b00111100;
			11'h19f: data = 8'b00000000;
			11'h1a0: data = 8'b00000100;
			11'h1a1: data = 8'b00001100;
			11'h1a2: data = 8'b00010100;
			11'h1a3: data = 8'b00100100;
			11'h1a4: data = 8'b01111110;
			11'h1a5: data = 8'b00000100;
			11'h1a6: data = 8'b00000100;
			11'h1a7: data = 8'b00000000;
			11'h1a8: data = 8'b01111110;
			11'h1a9: data = 8'b01000000;
			11'h1aa: data = 8'b01111000;
			11'h1ab: data = 8'b00000100;
			11'h1ac: data = 8'b00000010;
			11'h1ad: data = 8'b01000100;
			11'h1ae: data = 8'b00111000;
			11'h1af: data = 8'b00000000;
			11'h1b0: data = 8'b00011100;
			11'h1b1: data = 8'b00100000;
			11'h1b2: data = 8'b01000000;
			11'h1b3: data = 8'b01111100;
			11'h1b4: data = 8'b01000010;
			11'h1b5: data = 8'b01000010;
			11'h1b6: data = 8'b00111100;
			11'h1b7: data = 8'b00000000;
			11'h1b8: data = 8'b01111110;
			11'h1b9: data = 8'b01000010;
			11'h1ba: data = 8'b00000100;
			11'h1bb: data = 8'b00001000;
			11'h1bc: data = 8'b00010000;
			11'h1bd: data = 8'b00010000;
			11'h1be: data = 8'b00010000;
			11'h1bf: data = 8'b00000000;
			11'h1c0: data = 8'b00111100;
			11'h1c1: data = 8'b01000010;
			11'h1c2: data = 8'b01000010;
			11'h1c3: data = 8'b00111100;
			11'h1c4: data = 8'b01000010;
			11'h1c5: data = 8'b01000010;
			11'h1c6: data = 8'b00111100;
			11'h1c7: data = 8'b00000000;
			11'h1c8: data = 8'b00111100;
			11'h1c9: data = 8'b01000010;
			11'h1ca: data = 8'b01000010;
			11'h1cb: data = 8'b00111110;
			11'h1cc: data = 8'b00000010;
			11'h1cd: data = 8'b00000100;
			11'h1ce: data = 8'b00111000;
			11'h1cf: data = 8'b00000000;
			11'h1d0: data = 8'b00000000;
			11'h1d1: data = 8'b00000000;
			11'h1d2: data = 8'b00001000;
			11'h1d3: data = 8'b00000000;
			11'h1d4: data = 8'b00000000;
			11'h1d5: data = 8'b00001000;
			11'h1d6: data = 8'b00000000;
			11'h1d7: data = 8'b00000000;
			11'h1d8: data = 8'b00000000;
			11'h1d9: data = 8'b00000000;
			11'h1da: data = 8'b00001000;
			11'h1db: data = 8'b00000000;
			11'h1dc: data = 8'b00000000;
			11'h1dd: data = 8'b00001000;
			11'h1de: data = 8'b00001000;
			11'h1df: data = 8'b00010000;
			11'h1e0: data = 8'b00001110;
			11'h1e1: data = 8'b00011000;
			11'h1e2: data = 8'b00110000;
			11'h1e3: data = 8'b01100000;
			11'h1e4: data = 8'b00110000;
			11'h1e5: data = 8'b00011000;
			11'h1e6: data = 8'b00001110;
			11'h1e7: data = 8'b00000000;
			11'h1e8: data = 8'b00000000;
			11'h1e9: data = 8'b00000000;
			11'h1ea: data = 8'b01111110;
			11'h1eb: data = 8'b00000000;
			11'h1ec: data = 8'b01111110;
			11'h1ed: data = 8'b00000000;
			11'h1ee: data = 8'b00000000;
			11'h1ef: data = 8'b00000000;
			11'h1f0: data = 8'b01110000;
			11'h1f1: data = 8'b00011000;
			11'h1f2: data = 8'b00001100;
			11'h1f3: data = 8'b00000110;
			11'h1f4: data = 8'b00001100;
			11'h1f5: data = 8'b00011000;
			11'h1f6: data = 8'b01110000;
			11'h1f7: data = 8'b00000000;
			11'h1f8: data = 8'b00111100;
			11'h1f9: data = 8'b01000010;
			11'h1fa: data = 8'b00000010;
			11'h1fb: data = 8'b00001100;
			11'h1fc: data = 8'b00010000;
			11'h1fd: data = 8'b00000000;
			11'h1fe: data = 8'b00010000;
			11'h1ff: data = 8'b00000000;
			11'h200: data = 8'b00011100;
			11'h201: data = 8'b00100010;
			11'h202: data = 8'b01001010;
			11'h203: data = 8'b01010110;
			11'h204: data = 8'b01001100;
			11'h205: data = 8'b00100000;
			11'h206: data = 8'b00011110;
			11'h207: data = 8'b00000000;
			11'h208: data = 8'b00011000;
			11'h209: data = 8'b00100100;
			11'h20a: data = 8'b01000010;
			11'h20b: data = 8'b01111110;
			11'h20c: data = 8'b01000010;
			11'h20d: data = 8'b01000010;
			11'h20e: data = 8'b01000010;
			11'h20f: data = 8'b00000000;
			11'h210: data = 8'b01111100;
			11'h211: data = 8'b00100010;
			11'h212: data = 8'b00100010;
			11'h213: data = 8'b00111100;
			11'h214: data = 8'b00100010;
			11'h215: data = 8'b00100010;
			11'h216: data = 8'b01111100;
			11'h217: data = 8'b00000000;
			11'h218: data = 8'b00011100;
			11'h219: data = 8'b00100010;
			11'h21a: data = 8'b01000000;
			11'h21b: data = 8'b01000000;
			11'h21c: data = 8'b01000000;
			11'h21d: data = 8'b00100010;
			11'h21e: data = 8'b00011100;
			11'h21f: data = 8'b00000000;
			11'h220: data = 8'b01111000;
			11'h221: data = 8'b00100100;
			11'h222: data = 8'b00100010;
			11'h223: data = 8'b00100010;
			11'h224: data = 8'b00100010;
			11'h225: data = 8'b00100100;
			11'h226: data = 8'b01111000;
			11'h227: data = 8'b00000000;
			11'h228: data = 8'b01111110;
			11'h229: data = 8'b01000000;
			11'h22a: data = 8'b01000000;
			11'h22b: data = 8'b01111000;
			11'h22c: data = 8'b01000000;
			11'h22d: data = 8'b01000000;
			11'h22e: data = 8'b01111110;
			11'h22f: data = 8'b00000000;
			11'h230: data = 8'b01111110;
			11'h231: data = 8'b01000000;
			11'h232: data = 8'b01000000;
			11'h233: data = 8'b01111000;
			11'h234: data = 8'b01000000;
			11'h235: data = 8'b01000000;
			11'h236: data = 8'b01000000;
			11'h237: data = 8'b00000000;
			11'h238: data = 8'b00011100;
			11'h239: data = 8'b00100010;
			11'h23a: data = 8'b01000000;
			11'h23b: data = 8'b01001110;
			11'h23c: data = 8'b01000010;
			11'h23d: data = 8'b00100010;
			11'h23e: data = 8'b00011100;
			11'h23f: data = 8'b00000000;
			11'h240: data = 8'b01000010;
			11'h241: data = 8'b01000010;
			11'h242: data = 8'b01000010;
			11'h243: data = 8'b01111110;
			11'h244: data = 8'b01000010;
			11'h245: data = 8'b01000010;
			11'h246: data = 8'b01000010;
			11'h247: data = 8'b00000000;
			11'h248: data = 8'b00011100;
			11'h249: data = 8'b00001000;
			11'h24a: data = 8'b00001000;
			11'h24b: data = 8'b00001000;
			11'h24c: data = 8'b00001000;
			11'h24d: data = 8'b00001000;
			11'h24e: data = 8'b00011100;
			11'h24f: data = 8'b00000000;
			11'h250: data = 8'b00001110;
			11'h251: data = 8'b00000100;
			11'h252: data = 8'b00000100;
			11'h253: data = 8'b00000100;
			11'h254: data = 8'b00000100;
			11'h255: data = 8'b01000100;
			11'h256: data = 8'b00111000;
			11'h257: data = 8'b00000000;
			11'h258: data = 8'b01000010;
			11'h259: data = 8'b01000100;
			11'h25a: data = 8'b01001000;
			11'h25b: data = 8'b01110000;
			11'h25c: data = 8'b01001000;
			11'h25d: data = 8'b01000100;
			11'h25e: data = 8'b01000010;
			11'h25f: data = 8'b00000000;
			11'h260: data = 8'b01000000;
			11'h261: data = 8'b01000000;
			11'h262: data = 8'b01000000;
			11'h263: data = 8'b01000000;
			11'h264: data = 8'b01000000;
			11'h265: data = 8'b01000000;
			11'h266: data = 8'b01111110;
			11'h267: data = 8'b00000000;
			11'h268: data = 8'b01000010;
			11'h269: data = 8'b01100110;
			11'h26a: data = 8'b01011010;
			11'h26b: data = 8'b01011010;
			11'h26c: data = 8'b01000010;
			11'h26d: data = 8'b01000010;
			11'h26e: data = 8'b01000010;
			11'h26f: data = 8'b00000000;
			11'h270: data = 8'b01000010;
			11'h271: data = 8'b01100010;
			11'h272: data = 8'b01010010;
			11'h273: data = 8'b01001010;
			11'h274: data = 8'b01000110;
			11'h275: data = 8'b01000010;
			11'h276: data = 8'b01000010;
			11'h277: data = 8'b00000000;
			11'h278: data = 8'b00011000;
			11'h279: data = 8'b00100100;
			11'h27a: data = 8'b01000010;
			11'h27b: data = 8'b01000010;
			11'h27c: data = 8'b01000010;
			11'h27d: data = 8'b00100100;
			11'h27e: data = 8'b00011000;
			11'h27f: data = 8'b00000000;
			11'h280: data = 8'b01111100;
			11'h281: data = 8'b01000010;
			11'h282: data = 8'b01000010;
			11'h283: data = 8'b01111100;
			11'h284: data = 8'b01000000;
			11'h285: data = 8'b01000000;
			11'h286: data = 8'b01000000;
			11'h287: data = 8'b00000000;
			11'h288: data = 8'b00011000;
			11'h289: data = 8'b00100100;
			11'h28a: data = 8'b01000010;
			11'h28b: data = 8'b01000010;
			11'h28c: data = 8'b01001010;
			11'h28d: data = 8'b00100100;
			11'h28e: data = 8'b00011010;
			11'h28f: data = 8'b00000000;
			11'h290: data = 8'b01111100;
			11'h291: data = 8'b01000010;
			11'h292: data = 8'b01000010;
			11'h293: data = 8'b01111100;
			11'h294: data = 8'b01001000;
			11'h295: data = 8'b01000100;
			11'h296: data = 8'b01000010;
			11'h297: data = 8'b00000000;
			11'h298: data = 8'b00111100;
			11'h299: data = 8'b01000010;
			11'h29a: data = 8'b01000000;
			11'h29b: data = 8'b00111100;
			11'h29c: data = 8'b00000010;
			11'h29d: data = 8'b01000010;
			11'h29e: data = 8'b00111100;
			11'h29f: data = 8'b00000000;
			11'h2a0: data = 8'b00111110;
			11'h2a1: data = 8'b00001000;
			11'h2a2: data = 8'b00001000;
			11'h2a3: data = 8'b00001000;
			11'h2a4: data = 8'b00001000;
			11'h2a5: data = 8'b00001000;
			11'h2a6: data = 8'b00001000;
			11'h2a7: data = 8'b00000000;
			11'h2a8: data = 8'b01000010;
			11'h2a9: data = 8'b01000010;
			11'h2aa: data = 8'b01000010;
			11'h2ab: data = 8'b01000010;
			11'h2ac: data = 8'b01000010;
			11'h2ad: data = 8'b01000010;
			11'h2ae: data = 8'b00111100;
			11'h2af: data = 8'b00000000;
			11'h2b0: data = 8'b01000010;
			11'h2b1: data = 8'b01000010;
			11'h2b2: data = 8'b01000010;
			11'h2b3: data = 8'b00100100;
			11'h2b4: data = 8'b00100100;
			11'h2b5: data = 8'b00011000;
			11'h2b6: data = 8'b00011000;
			11'h2b7: data = 8'b00000000;
			11'h2b8: data = 8'b01000010;
			11'h2b9: data = 8'b01000010;
			11'h2ba: data = 8'b01000010;
			11'h2bb: data = 8'b01011010;
			11'h2bc: data = 8'b01011010;
			11'h2bd: data = 8'b01100110;
			11'h2be: data = 8'b01000010;
			11'h2bf: data = 8'b00000000;
			11'h2c0: data = 8'b01000010;
			11'h2c1: data = 8'b01000010;
			11'h2c2: data = 8'b00100100;
			11'h2c3: data = 8'b00011000;
			11'h2c4: data = 8'b00100100;
			11'h2c5: data = 8'b01000010;
			11'h2c6: data = 8'b01000010;
			11'h2c7: data = 8'b00000000;
			11'h2c8: data = 8'b00100010;
			11'h2c9: data = 8'b00100010;
			11'h2ca: data = 8'b00100010;
			11'h2cb: data = 8'b00011100;
			11'h2cc: data = 8'b00001000;
			11'h2cd: data = 8'b00001000;
			11'h2ce: data = 8'b00001000;
			11'h2cf: data = 8'b00000000;
			11'h2d0: data = 8'b01111110;
			11'h2d1: data = 8'b00000010;
			11'h2d2: data = 8'b00000100;
			11'h2d3: data = 8'b00011000;
			11'h2d4: data = 8'b00100000;
			11'h2d5: data = 8'b01000000;
			11'h2d6: data = 8'b01111110;
			11'h2d7: data = 8'b00000000;
			11'h2d8: data = 8'b00111100;
			11'h2d9: data = 8'b00100000;
			11'h2da: data = 8'b00100000;
			11'h2db: data = 8'b00100000;
			11'h2dc: data = 8'b00100000;
			11'h2dd: data = 8'b00100000;
			11'h2de: data = 8'b00111100;
			11'h2df: data = 8'b00000000;
			11'h2e0: data = 8'b00100010;
			11'h2e1: data = 8'b00100010;
			11'h2e2: data = 8'b00010100;
			11'h2e3: data = 8'b00111110;
			11'h2e4: data = 8'b00001000;
			11'h2e5: data = 8'b00111110;
			11'h2e6: data = 8'b00001000;
			11'h2e7: data = 8'b00000000;
			11'h2e8: data = 8'b00111100;
			11'h2e9: data = 8'b00000100;
			11'h2ea: data = 8'b00000100;
			11'h2eb: data = 8'b00000100;
			11'h2ec: data = 8'b00000100;
			11'h2ed: data = 8'b00000100;
			11'h2ee: data = 8'b00111100;
			11'h2ef: data = 8'b00000000;
			11'h2f0: data = 8'b00001000;
			11'h2f1: data = 8'b00010100;
			11'h2f2: data = 8'b00100010;
			11'h2f3: data = 8'b00000000;
			11'h2f4: data = 8'b00000000;
			11'h2f5: data = 8'b00000000;
			11'h2f6: data = 8'b00000000;
			11'h2f7: data = 8'b00000000;
			11'h2f8: data = 8'b00000000;
			11'h2f9: data = 8'b00000000;
			11'h2fa: data = 8'b00000000;
			11'h2fb: data = 8'b00000000;
			11'h2fc: data = 8'b00000000;
			11'h2fd: data = 8'b00000000;
			11'h2fe: data = 8'b01111110;
			11'h2ff: data = 8'b00000000;
			11'h300: data = 8'b00000000;
			11'h301: data = 8'b00000000;
			11'h302: data = 8'b00000000;
			11'h303: data = 8'b00000000;
			11'h304: data = 8'b00000000;
			11'h305: data = 8'b00000000;
			11'h306: data = 8'b00000000;
			11'h307: data = 8'b00000000;
			11'h308: data = 8'b00000000;
			11'h309: data = 8'b00000000;
			11'h30a: data = 8'b00111100;
			11'h30b: data = 8'b00000100;
			11'h30c: data = 8'b00111100;
			11'h30d: data = 8'b01000100;
			11'h30e: data = 8'b00111010;
			11'h30f: data = 8'b00000000;
			11'h310: data = 8'b01000000;
			11'h311: data = 8'b01000000;
			11'h312: data = 8'b01011100;
			11'h313: data = 8'b01100010;
			11'h314: data = 8'b01000010;
			11'h315: data = 8'b01100010;
			11'h316: data = 8'b01011100;
			11'h317: data = 8'b00000000;
			11'h318: data = 8'b00000000;
			11'h319: data = 8'b00000000;
			11'h31a: data = 8'b00111100;
			11'h31b: data = 8'b01000010;
			11'h31c: data = 8'b01000000;
			11'h31d: data = 8'b01000010;
			11'h31e: data = 8'b00111100;
			11'h31f: data = 8'b00000000;
			11'h320: data = 8'b00000010;
			11'h321: data = 8'b00000010;
			11'h322: data = 8'b00111010;
			11'h323: data = 8'b01000110;
			11'h324: data = 8'b01000010;
			11'h325: data = 8'b01000110;
			11'h326: data = 8'b00111010;
			11'h327: data = 8'b00000000;
			11'h328: data = 8'b00000000;
			11'h329: data = 8'b00000000;
			11'h32a: data = 8'b00111100;
			11'h32b: data = 8'b01000010;
			11'h32c: data = 8'b01111110;
			11'h32d: data = 8'b01000000;
			11'h32e: data = 8'b00111100;
			11'h32f: data = 8'b00000000;
			11'h330: data = 8'b00001100;
			11'h331: data = 8'b00010010;
			11'h332: data = 8'b00010000;
			11'h333: data = 8'b01111100;
			11'h334: data = 8'b00010000;
			11'h335: data = 8'b00010000;
			11'h336: data = 8'b00010000;
			11'h337: data = 8'b00000000;
			11'h338: data = 8'b00000000;
			11'h339: data = 8'b00000000;
			11'h33a: data = 8'b00111010;
			11'h33b: data = 8'b01000110;
			11'h33c: data = 8'b01000110;
			11'h33d: data = 8'b00111010;
			11'h33e: data = 8'b00000010;
			11'h33f: data = 8'b00111100;
			11'h340: data = 8'b01000000;
			11'h341: data = 8'b01000000;
			11'h342: data = 8'b01011100;
			11'h343: data = 8'b01100010;
			11'h344: data = 8'b01000010;
			11'h345: data = 8'b01000010;
			11'h346: data = 8'b01000010;
			11'h347: data = 8'b00000000;
			11'h348: data = 8'b00001000;
			11'h349: data = 8'b00000000;
			11'h34a: data = 8'b00011000;
			11'h34b: data = 8'b00001000;
			11'h34c: data = 8'b00001000;
			11'h34d: data = 8'b00001000;
			11'h34e: data = 8'b00011100;
			11'h34f: data = 8'b00000000;
			11'h350: data = 8'b00000100;
			11'h351: data = 8'b00000000;
			11'h352: data = 8'b00001100;
			11'h353: data = 8'b00000100;
			11'h354: data = 8'b00000100;
			11'h355: data = 8'b00000100;
			11'h356: data = 8'b01000100;
			11'h357: data = 8'b00111000;
			11'h358: data = 8'b01000000;
			11'h359: data = 8'b01000000;
			11'h35a: data = 8'b01000100;
			11'h35b: data = 8'b01001000;
			11'h35c: data = 8'b01010000;
			11'h35d: data = 8'b01101000;
			11'h35e: data = 8'b01000100;
			11'h35f: data = 8'b00000000;
			11'h360: data = 8'b00011000;
			11'h361: data = 8'b00001000;
			11'h362: data = 8'b00001000;
			11'h363: data = 8'b00001000;
			11'h364: data = 8'b00001000;
			11'h365: data = 8'b00001000;
			11'h366: data = 8'b00011100;
			11'h367: data = 8'b00000000;
			11'h368: data = 8'b00000000;
			11'h369: data = 8'b00000000;
			11'h36a: data = 8'b01110110;
			11'h36b: data = 8'b01001001;
			11'h36c: data = 8'b01001001;
			11'h36d: data = 8'b01001001;
			11'h36e: data = 8'b01001001;
			11'h36f: data = 8'b00000000;
			11'h370: data = 8'b00000000;
			11'h371: data = 8'b00000000;
			11'h372: data = 8'b01011100;
			11'h373: data = 8'b01100010;
			11'h374: data = 8'b01000010;
			11'h375: data = 8'b01000010;
			11'h376: data = 8'b01000010;
			11'h377: data = 8'b00000000;
			11'h378: data = 8'b00000000;
			11'h379: data = 8'b00000000;
			11'h37a: data = 8'b00111100;
			11'h37b: data = 8'b01000010;
			11'h37c: data = 8'b01000010;
			11'h37d: data = 8'b01000010;
			11'h37e: data = 8'b00111100;
			11'h37f: data = 8'b00000000;
			11'h380: data = 8'b00000000;
			11'h381: data = 8'b00000000;
			11'h382: data = 8'b01011100;
			11'h383: data = 8'b01100010;
			11'h384: data = 8'b01100010;
			11'h385: data = 8'b01011100;
			11'h386: data = 8'b01000000;
			11'h387: data = 8'b01000000;
			11'h388: data = 8'b00000000;
			11'h389: data = 8'b00000000;
			11'h38a: data = 8'b00111010;
			11'h38b: data = 8'b01000110;
			11'h38c: data = 8'b01000110;
			11'h38d: data = 8'b00111010;
			11'h38e: data = 8'b00000010;
			11'h38f: data = 8'b00000010;
			11'h390: data = 8'b00000000;
			11'h391: data = 8'b00000000;
			11'h392: data = 8'b01011100;
			11'h393: data = 8'b01100010;
			11'h394: data = 8'b01000000;
			11'h395: data = 8'b01000000;
			11'h396: data = 8'b01000000;
			11'h397: data = 8'b00000000;
			11'h398: data = 8'b00000000;
			11'h399: data = 8'b00000000;
			11'h39a: data = 8'b00111110;
			11'h39b: data = 8'b01000000;
			11'h39c: data = 8'b00111100;
			11'h39d: data = 8'b00000010;
			11'h39e: data = 8'b01111100;
			11'h39f: data = 8'b00000000;
			11'h3a0: data = 8'b00010000;
			11'h3a1: data = 8'b00010000;
			11'h3a2: data = 8'b01111100;
			11'h3a3: data = 8'b00010000;
			11'h3a4: data = 8'b00010000;
			11'h3a5: data = 8'b00010010;
			11'h3a6: data = 8'b00001100;
			11'h3a7: data = 8'b00000000;
			11'h3a8: data = 8'b00000000;
			11'h3a9: data = 8'b00000000;
			11'h3aa: data = 8'b01000010;
			11'h3ab: data = 8'b01000010;
			11'h3ac: data = 8'b01000010;
			11'h3ad: data = 8'b01000110;
			11'h3ae: data = 8'b00111010;
			11'h3af: data = 8'b00000000;
			11'h3b0: data = 8'b00000000;
			11'h3b1: data = 8'b00000000;
			11'h3b2: data = 8'b01000010;
			11'h3b3: data = 8'b01000010;
			11'h3b4: data = 8'b01000010;
			11'h3b5: data = 8'b00100100;
			11'h3b6: data = 8'b00011000;
			11'h3b7: data = 8'b00000000;
			11'h3b8: data = 8'b00000000;
			11'h3b9: data = 8'b00000000;
			11'h3ba: data = 8'b01000001;
			11'h3bb: data = 8'b01001001;
			11'h3bc: data = 8'b01001001;
			11'h3bd: data = 8'b01001001;
			11'h3be: data = 8'b00110110;
			11'h3bf: data = 8'b00000000;
			11'h3c0: data = 8'b00000000;
			11'h3c1: data = 8'b00000000;
			11'h3c2: data = 8'b01000010;
			11'h3c3: data = 8'b00100100;
			11'h3c4: data = 8'b00011000;
			11'h3c5: data = 8'b00100100;
			11'h3c6: data = 8'b01000010;
			11'h3c7: data = 8'b00000000;
			11'h3c8: data = 8'b00000000;
			11'h3c9: data = 8'b00000000;
			11'h3ca: data = 8'b01000010;
			11'h3cb: data = 8'b01000010;
			11'h3cc: data = 8'b01000110;
			11'h3cd: data = 8'b00111010;
			11'h3ce: data = 8'b00000010;
			11'h3cf: data = 8'b00111100;
			11'h3d0: data = 8'b00000000;
			11'h3d1: data = 8'b00000000;
			11'h3d2: data = 8'b01111110;
			11'h3d3: data = 8'b00000100;
			11'h3d4: data = 8'b00011000;
			11'h3d5: data = 8'b00100000;
			11'h3d6: data = 8'b01111110;
			11'h3d7: data = 8'b00000000;
			11'h3d8: data = 8'b00001110;
			11'h3d9: data = 8'b00010000;
			11'h3da: data = 8'b00010000;
			11'h3db: data = 8'b00100000;
			11'h3dc: data = 8'b00010000;
			11'h3dd: data = 8'b00010000;
			11'h3de: data = 8'b00001110;
			11'h3df: data = 8'b00000000;
			11'h3e0: data = 8'b00001000;
			11'h3e1: data = 8'b00001000;
			11'h3e2: data = 8'b00000000;
			11'h3e3: data = 8'b00000000;
			11'h3e4: data = 8'b00000000;
			11'h3e5: data = 8'b00001000;
			11'h3e6: data = 8'b00001000;
			11'h3e7: data = 8'b00000000;
			11'h3e8: data = 8'b01110000;
			11'h3e9: data = 8'b00001000;
			11'h3ea: data = 8'b00001000;
			11'h3eb: data = 8'b00000100;
			11'h3ec: data = 8'b00001000;
			11'h3ed: data = 8'b00001000;
			11'h3ee: data = 8'b01110000;
			11'h3ef: data = 8'b00000000;
			11'h3f0: data = 8'b00110000;
			11'h3f1: data = 8'b01001001;
			11'h3f2: data = 8'b00000110;
			11'h3f3: data = 8'b00000000;
			11'h3f4: data = 8'b00000000;
			11'h3f5: data = 8'b00000000;
			11'h3f6: data = 8'b00000000;
			11'h3f7: data = 8'b00000000;
			11'h3f8: data = 8'b00000000;
			11'h3f9: data = 8'b00000000;
			11'h3fa: data = 8'b00000000;
			11'h3fb: data = 8'b00000000;
			11'h3fc: data = 8'b00000000;
			11'h3fd: data = 8'b00000000;
			11'h3fe: data = 8'b00000000;
			11'h3ff: data = 8'b00000000;
`ifndef	SHRINK_CG
			11'h400: data = 8'b00000000;
			11'h401: data = 8'b00000000;
			11'h402: data = 8'b00000000;
			11'h403: data = 8'b00000000;
			11'h404: data = 8'b00000000;
			11'h405: data = 8'b00000000;
			11'h406: data = 8'b00000000;
			11'h407: data = 8'b11111111;
			11'h408: data = 8'b00000000;
			11'h409: data = 8'b00000000;
			11'h40a: data = 8'b00000000;
			11'h40b: data = 8'b00000000;
			11'h40c: data = 8'b00000000;
			11'h40d: data = 8'b00000000;
			11'h40e: data = 8'b11111111;
			11'h40f: data = 8'b11111111;
			11'h410: data = 8'b00000000;
			11'h411: data = 8'b00000000;
			11'h412: data = 8'b00000000;
			11'h413: data = 8'b00000000;
			11'h414: data = 8'b00000000;
			11'h415: data = 8'b11111111;
			11'h416: data = 8'b11111111;
			11'h417: data = 8'b11111111;
			11'h418: data = 8'b00000000;
			11'h419: data = 8'b00000000;
			11'h41a: data = 8'b00000000;
			11'h41b: data = 8'b00000000;
			11'h41c: data = 8'b11111111;
			11'h41d: data = 8'b11111111;
			11'h41e: data = 8'b11111111;
			11'h41f: data = 8'b11111111;
			11'h420: data = 8'b00000000;
			11'h421: data = 8'b00000000;
			11'h422: data = 8'b00000000;
			11'h423: data = 8'b11111111;
			11'h424: data = 8'b11111111;
			11'h425: data = 8'b11111111;
			11'h426: data = 8'b11111111;
			11'h427: data = 8'b11111111;
			11'h428: data = 8'b00000000;
			11'h429: data = 8'b00000000;
			11'h42a: data = 8'b11111111;
			11'h42b: data = 8'b11111111;
			11'h42c: data = 8'b11111111;
			11'h42d: data = 8'b11111111;
			11'h42e: data = 8'b11111111;
			11'h42f: data = 8'b11111111;
			11'h430: data = 8'b00000000;
			11'h431: data = 8'b11111111;
			11'h432: data = 8'b11111111;
			11'h433: data = 8'b11111111;
			11'h434: data = 8'b11111111;
			11'h435: data = 8'b11111111;
			11'h436: data = 8'b11111111;
			11'h437: data = 8'b11111111;
			11'h438: data = 8'b11111111;
			11'h439: data = 8'b11111111;
			11'h43a: data = 8'b11111111;
			11'h43b: data = 8'b11111111;
			11'h43c: data = 8'b11111111;
			11'h43d: data = 8'b11111111;
			11'h43e: data = 8'b11111111;
			11'h43f: data = 8'b11111111;
			11'h440: data = 8'b10000000;
			11'h441: data = 8'b10000000;
			11'h442: data = 8'b10000000;
			11'h443: data = 8'b10000000;
			11'h444: data = 8'b10000000;
			11'h445: data = 8'b10000000;
			11'h446: data = 8'b10000000;
			11'h447: data = 8'b10000000;
			11'h448: data = 8'b11000000;
			11'h449: data = 8'b11000000;
			11'h44a: data = 8'b11000000;
			11'h44b: data = 8'b11000000;
			11'h44c: data = 8'b11000000;
			11'h44d: data = 8'b11000000;
			11'h44e: data = 8'b11000000;
			11'h44f: data = 8'b11000000;
			11'h450: data = 8'b11100000;
			11'h451: data = 8'b11100000;
			11'h452: data = 8'b11100000;
			11'h453: data = 8'b11100000;
			11'h454: data = 8'b11100000;
			11'h455: data = 8'b11100000;
			11'h456: data = 8'b11100000;
			11'h457: data = 8'b11100000;
			11'h458: data = 8'b11110000;
			11'h459: data = 8'b11110000;
			11'h45a: data = 8'b11110000;
			11'h45b: data = 8'b11110000;
			11'h45c: data = 8'b11110000;
			11'h45d: data = 8'b11110000;
			11'h45e: data = 8'b11110000;
			11'h45f: data = 8'b11110000;
			11'h460: data = 8'b11111000;
			11'h461: data = 8'b11111000;
			11'h462: data = 8'b11111000;
			11'h463: data = 8'b11111000;
			11'h464: data = 8'b11111000;
			11'h465: data = 8'b11111000;
			11'h466: data = 8'b11111000;
			11'h467: data = 8'b11111000;
			11'h468: data = 8'b11111100;
			11'h469: data = 8'b11111100;
			11'h46a: data = 8'b11111100;
			11'h46b: data = 8'b11111100;
			11'h46c: data = 8'b11111100;
			11'h46d: data = 8'b11111100;
			11'h46e: data = 8'b11111100;
			11'h46f: data = 8'b11111100;
			11'h470: data = 8'b11111110;
			11'h471: data = 8'b11111110;
			11'h472: data = 8'b11111110;
			11'h473: data = 8'b11111110;
			11'h474: data = 8'b11111110;
			11'h475: data = 8'b11111110;
			11'h476: data = 8'b11111110;
			11'h477: data = 8'b11111110;
			11'h478: data = 8'b00001000;
			11'h479: data = 8'b00001000;
			11'h47a: data = 8'b00001000;
			11'h47b: data = 8'b00001000;
			11'h47c: data = 8'b11111111;
			11'h47d: data = 8'b00001000;
			11'h47e: data = 8'b00001000;
			11'h47f: data = 8'b00001000;
			11'h480: data = 8'b00001000;
			11'h481: data = 8'b00001000;
			11'h482: data = 8'b00001000;
			11'h483: data = 8'b00001000;
			11'h484: data = 8'b11111111;
			11'h485: data = 8'b00000000;
			11'h486: data = 8'b00000000;
			11'h487: data = 8'b00000000;
			11'h488: data = 8'b00000000;
			11'h489: data = 8'b00000000;
			11'h48a: data = 8'b00000000;
			11'h48b: data = 8'b00000000;
			11'h48c: data = 8'b11111111;
			11'h48d: data = 8'b00001000;
			11'h48e: data = 8'b00001000;
			11'h48f: data = 8'b00001000;
			11'h490: data = 8'b00001000;
			11'h491: data = 8'b00001000;
			11'h492: data = 8'b00001000;
			11'h493: data = 8'b00001000;
			11'h494: data = 8'b11111000;
			11'h495: data = 8'b00001000;
			11'h496: data = 8'b00001000;
			11'h497: data = 8'b00001000;
			11'h498: data = 8'b00001000;
			11'h499: data = 8'b00001000;
			11'h49a: data = 8'b00001000;
			11'h49b: data = 8'b00001000;
			11'h49c: data = 8'b00001111;
			11'h49d: data = 8'b00001000;
			11'h49e: data = 8'b00001000;
			11'h49f: data = 8'b00001000;
			11'h4a0: data = 8'b11111111;
			11'h4a1: data = 8'b00000000;
			11'h4a2: data = 8'b00000000;
			11'h4a3: data = 8'b00000000;
			11'h4a4: data = 8'b00000000;
			11'h4a5: data = 8'b00000000;
			11'h4a6: data = 8'b00000000;
			11'h4a7: data = 8'b00000000;
			11'h4a8: data = 8'b00000000;
			11'h4a9: data = 8'b00000000;
			11'h4aa: data = 8'b00000000;
			11'h4ab: data = 8'b00000000;
			11'h4ac: data = 8'b11111111;
			11'h4ad: data = 8'b00000000;
			11'h4ae: data = 8'b00000000;
			11'h4af: data = 8'b00000000;
			11'h4b0: data = 8'b00001000;
			11'h4b1: data = 8'b00001000;
			11'h4b2: data = 8'b00001000;
			11'h4b3: data = 8'b00001000;
			11'h4b4: data = 8'b00001000;
			11'h4b5: data = 8'b00001000;
			11'h4b6: data = 8'b00001000;
			11'h4b7: data = 8'b00001000;
			11'h4b8: data = 8'b00000001;
			11'h4b9: data = 8'b00000001;
			11'h4ba: data = 8'b00000001;
			11'h4bb: data = 8'b00000001;
			11'h4bc: data = 8'b00000001;
			11'h4bd: data = 8'b00000001;
			11'h4be: data = 8'b00000001;
			11'h4bf: data = 8'b00000001;
			11'h4c0: data = 8'b00000000;
			11'h4c1: data = 8'b00000000;
			11'h4c2: data = 8'b00000000;
			11'h4c3: data = 8'b00000000;
			11'h4c4: data = 8'b00001111;
			11'h4c5: data = 8'b00001000;
			11'h4c6: data = 8'b00001000;
			11'h4c7: data = 8'b00001000;
			11'h4c8: data = 8'b00000000;
			11'h4c9: data = 8'b00000000;
			11'h4ca: data = 8'b00000000;
			11'h4cb: data = 8'b00000000;
			11'h4cc: data = 8'b11111000;
			11'h4cd: data = 8'b00001000;
			11'h4ce: data = 8'b00001000;
			11'h4cf: data = 8'b00001000;
			11'h4d0: data = 8'b00001000;
			11'h4d1: data = 8'b00001000;
			11'h4d2: data = 8'b00001000;
			11'h4d3: data = 8'b00001000;
			11'h4d4: data = 8'b00001111;
			11'h4d5: data = 8'b00000000;
			11'h4d6: data = 8'b00000000;
			11'h4d7: data = 8'b00000000;
			11'h4d8: data = 8'b00001000;
			11'h4d9: data = 8'b00001000;
			11'h4da: data = 8'b00001000;
			11'h4db: data = 8'b00001000;
			11'h4dc: data = 8'b11111000;
			11'h4dd: data = 8'b00000000;
			11'h4de: data = 8'b00000000;
			11'h4df: data = 8'b00000000;
			11'h4e0: data = 8'b00000000;
			11'h4e1: data = 8'b00000000;
			11'h4e2: data = 8'b00000000;
			11'h4e3: data = 8'b00000000;
			11'h4e4: data = 8'b00000011;
			11'h4e5: data = 8'b00000100;
			11'h4e6: data = 8'b00001000;
			11'h4e7: data = 8'b00001000;
			11'h4e8: data = 8'b00000000;
			11'h4e9: data = 8'b00000000;
			11'h4ea: data = 8'b00000000;
			11'h4eb: data = 8'b00000000;
			11'h4ec: data = 8'b11100000;
			11'h4ed: data = 8'b00010000;
			11'h4ee: data = 8'b00001000;
			11'h4ef: data = 8'b00001000;
			11'h4f0: data = 8'b00001000;
			11'h4f1: data = 8'b00001000;
			11'h4f2: data = 8'b00001000;
			11'h4f3: data = 8'b00000100;
			11'h4f4: data = 8'b00000011;
			11'h4f5: data = 8'b00000000;
			11'h4f6: data = 8'b00000000;
			11'h4f7: data = 8'b00000000;
			11'h4f8: data = 8'b00001000;
			11'h4f9: data = 8'b00001000;
			11'h4fa: data = 8'b00001000;
			11'h4fb: data = 8'b00010000;
			11'h4fc: data = 8'b11100000;
			11'h4fd: data = 8'b00000000;
			11'h4fe: data = 8'b00000000;
			11'h4ff: data = 8'b00000000;
			11'h500: data = 8'b00000000;
			11'h501: data = 8'b00000000;
			11'h502: data = 8'b00000000;
			11'h503: data = 8'b00000000;
			11'h504: data = 8'b00000000;
			11'h505: data = 8'b00000000;
			11'h506: data = 8'b00000000;
			11'h507: data = 8'b00000000;
			11'h508: data = 8'b00000000;
			11'h509: data = 8'b00000000;
			11'h50a: data = 8'b00000000;
			11'h50b: data = 8'b00000000;
			11'h50c: data = 8'b00111000;
			11'h50d: data = 8'b00101000;
			11'h50e: data = 8'b00111000;
			11'h50f: data = 8'b00000000;
			11'h510: data = 8'b00011100;
			11'h511: data = 8'b00010000;
			11'h512: data = 8'b00010000;
			11'h513: data = 8'b00010000;
			11'h514: data = 8'b00000000;
			11'h515: data = 8'b00000000;
			11'h516: data = 8'b00000000;
			11'h517: data = 8'b00000000;
			11'h518: data = 8'b00000000;
			11'h519: data = 8'b00000000;
			11'h51a: data = 8'b00000000;
			11'h51b: data = 8'b00001000;
			11'h51c: data = 8'b00001000;
			11'h51d: data = 8'b00001000;
			11'h51e: data = 8'b00111000;
			11'h51f: data = 8'b00000000;
			11'h520: data = 8'b00000000;
			11'h521: data = 8'b00000000;
			11'h522: data = 8'b00000000;
			11'h523: data = 8'b00000000;
			11'h524: data = 8'b00100000;
			11'h525: data = 8'b00010000;
			11'h526: data = 8'b00001000;
			11'h527: data = 8'b00000000;
			11'h528: data = 8'b00000000;
			11'h529: data = 8'b00000000;
			11'h52a: data = 8'b00000000;
			11'h52b: data = 8'b00011000;
			11'h52c: data = 8'b00011000;
			11'h52d: data = 8'b00000000;
			11'h52e: data = 8'b00000000;
			11'h52f: data = 8'b00000000;
			11'h530: data = 8'b00000000;
			11'h531: data = 8'b01111110;
			11'h532: data = 8'b00000010;
			11'h533: data = 8'b01111110;
			11'h534: data = 8'b00000010;
			11'h535: data = 8'b00000100;
			11'h536: data = 8'b00111000;
			11'h537: data = 8'b00000000;
			11'h538: data = 8'b00000000;
			11'h539: data = 8'b00000000;
			11'h53a: data = 8'b00111110;
			11'h53b: data = 8'b00000010;
			11'h53c: data = 8'b00001100;
			11'h53d: data = 8'b00001000;
			11'h53e: data = 8'b00010000;
			11'h53f: data = 8'b00000000;
			11'h540: data = 8'b00000000;
			11'h541: data = 8'b00000000;
			11'h542: data = 8'b00000100;
			11'h543: data = 8'b00001000;
			11'h544: data = 8'b00011000;
			11'h545: data = 8'b00101000;
			11'h546: data = 8'b00001000;
			11'h547: data = 8'b00000000;
			11'h548: data = 8'b00000000;
			11'h549: data = 8'b00000000;
			11'h54a: data = 8'b00001000;
			11'h54b: data = 8'b00111110;
			11'h54c: data = 8'b00100010;
			11'h54d: data = 8'b00000010;
			11'h54e: data = 8'b00001100;
			11'h54f: data = 8'b00000000;
			11'h550: data = 8'b00000000;
			11'h551: data = 8'b00000000;
			11'h552: data = 8'b00000000;
			11'h553: data = 8'b00111110;
			11'h554: data = 8'b00001000;
			11'h555: data = 8'b00001000;
			11'h556: data = 8'b00111110;
			11'h557: data = 8'b00000000;
			11'h558: data = 8'b00000000;
			11'h559: data = 8'b00000000;
			11'h55a: data = 8'b00000100;
			11'h55b: data = 8'b00111110;
			11'h55c: data = 8'b00001100;
			11'h55d: data = 8'b00010100;
			11'h55e: data = 8'b00100100;
			11'h55f: data = 8'b00000000;
			11'h560: data = 8'b00000000;
			11'h561: data = 8'b00000000;
			11'h562: data = 8'b00010000;
			11'h563: data = 8'b00111110;
			11'h564: data = 8'b00010010;
			11'h565: data = 8'b00010100;
			11'h566: data = 8'b00010000;
			11'h567: data = 8'b00000000;
			11'h568: data = 8'b00000000;
			11'h569: data = 8'b00000000;
			11'h56a: data = 8'b00000000;
			11'h56b: data = 8'b00011100;
			11'h56c: data = 8'b00000100;
			11'h56d: data = 8'b00000100;
			11'h56e: data = 8'b00111110;
			11'h56f: data = 8'b00000000;
			11'h570: data = 8'b00000000;
			11'h571: data = 8'b00000000;
			11'h572: data = 8'b00111100;
			11'h573: data = 8'b00000100;
			11'h574: data = 8'b00111100;
			11'h575: data = 8'b00000100;
			11'h576: data = 8'b00111100;
			11'h577: data = 8'b00000000;
			11'h578: data = 8'b00000000;
			11'h579: data = 8'b00000000;
			11'h57a: data = 8'b00000000;
			11'h57b: data = 8'b00101010;
			11'h57c: data = 8'b00101010;
			11'h57d: data = 8'b00000010;
			11'h57e: data = 8'b00001100;
			11'h57f: data = 8'b00000000;
			11'h580: data = 8'b00000000;
			11'h581: data = 8'b00000000;
			11'h582: data = 8'b00000000;
			11'h583: data = 8'b00111110;
			11'h584: data = 8'b00000000;
			11'h585: data = 8'b00000000;
			11'h586: data = 8'b00000000;
			11'h587: data = 8'b00000000;
			11'h588: data = 8'b01111110;
			11'h589: data = 8'b00000010;
			11'h58a: data = 8'b00000010;
			11'h58b: data = 8'b00010100;
			11'h58c: data = 8'b00011000;
			11'h58d: data = 8'b00010000;
			11'h58e: data = 8'b00100000;
			11'h58f: data = 8'b00000000;
			11'h590: data = 8'b00000010;
			11'h591: data = 8'b00000100;
			11'h592: data = 8'b00001000;
			11'h593: data = 8'b00011000;
			11'h594: data = 8'b00101000;
			11'h595: data = 8'b01001000;
			11'h596: data = 8'b00001000;
			11'h597: data = 8'b00000000;
			11'h598: data = 8'b00001000;
			11'h599: data = 8'b01111110;
			11'h59a: data = 8'b01000010;
			11'h59b: data = 8'b01000010;
			11'h59c: data = 8'b00000010;
			11'h59d: data = 8'b00000100;
			11'h59e: data = 8'b00111000;
			11'h59f: data = 8'b00000000;
			11'h5a0: data = 8'b00000000;
			11'h5a1: data = 8'b00111110;
			11'h5a2: data = 8'b00001000;
			11'h5a3: data = 8'b00001000;
			11'h5a4: data = 8'b00001000;
			11'h5a5: data = 8'b00001000;
			11'h5a6: data = 8'b00111110;
			11'h5a7: data = 8'b00000000;
			11'h5a8: data = 8'b00001000;
			11'h5a9: data = 8'b01111110;
			11'h5aa: data = 8'b00001000;
			11'h5ab: data = 8'b00011000;
			11'h5ac: data = 8'b00101000;
			11'h5ad: data = 8'b01001000;
			11'h5ae: data = 8'b00001000;
			11'h5af: data = 8'b00000000;
			11'h5b0: data = 8'b00010000;
			11'h5b1: data = 8'b01111110;
			11'h5b2: data = 8'b00010010;
			11'h5b3: data = 8'b00010010;
			11'h5b4: data = 8'b00010010;
			11'h5b5: data = 8'b00010010;
			11'h5b6: data = 8'b00100100;
			11'h5b7: data = 8'b00000000;
			11'h5b8: data = 8'b00001000;
			11'h5b9: data = 8'b00111110;
			11'h5ba: data = 8'b00001000;
			11'h5bb: data = 8'b00111110;
			11'h5bc: data = 8'b00001000;
			11'h5bd: data = 8'b00001000;
			11'h5be: data = 8'b00001000;
			11'h5bf: data = 8'b00000000;
			11'h5c0: data = 8'b00011110;
			11'h5c1: data = 8'b00100010;
			11'h5c2: data = 8'b01000010;
			11'h5c3: data = 8'b00000100;
			11'h5c4: data = 8'b00001000;
			11'h5c5: data = 8'b00010000;
			11'h5c6: data = 8'b01100000;
			11'h5c7: data = 8'b00000000;
			11'h5c8: data = 8'b00100000;
			11'h5c9: data = 8'b00111110;
			11'h5ca: data = 8'b01001000;
			11'h5cb: data = 8'b00001000;
			11'h5cc: data = 8'b00001000;
			11'h5cd: data = 8'b00001000;
			11'h5ce: data = 8'b00010000;
			11'h5cf: data = 8'b00000000;
			11'h5d0: data = 8'b00000000;
			11'h5d1: data = 8'b01111110;
			11'h5d2: data = 8'b00000010;
			11'h5d3: data = 8'b00000010;
			11'h5d4: data = 8'b00000010;
			11'h5d5: data = 8'b00000010;
			11'h5d6: data = 8'b01111110;
			11'h5d7: data = 8'b00000000;
			11'h5d8: data = 8'b00100100;
			11'h5d9: data = 8'b01111110;
			11'h5da: data = 8'b00100100;
			11'h5db: data = 8'b00100100;
			11'h5dc: data = 8'b00000100;
			11'h5dd: data = 8'b00001000;
			11'h5de: data = 8'b00010000;
			11'h5df: data = 8'b00000000;
			11'h5e0: data = 8'b00000000;
			11'h5e1: data = 8'b01110000;
			11'h5e2: data = 8'b00000000;
			11'h5e3: data = 8'b01110010;
			11'h5e4: data = 8'b00000010;
			11'h5e5: data = 8'b00000100;
			11'h5e6: data = 8'b01111000;
			11'h5e7: data = 8'b00000000;
			11'h5e8: data = 8'b01111110;
			11'h5e9: data = 8'b00000010;
			11'h5ea: data = 8'b00000100;
			11'h5eb: data = 8'b00001000;
			11'h5ec: data = 8'b00011000;
			11'h5ed: data = 8'b00100100;
			11'h5ee: data = 8'b01000010;
			11'h5ef: data = 8'b00000000;
			11'h5f0: data = 8'b00100000;
			11'h5f1: data = 8'b01111110;
			11'h5f2: data = 8'b00100010;
			11'h5f3: data = 8'b00100100;
			11'h5f4: data = 8'b00100000;
			11'h5f5: data = 8'b00100000;
			11'h5f6: data = 8'b00011110;
			11'h5f7: data = 8'b00000000;
			11'h5f8: data = 8'b01000010;
			11'h5f9: data = 8'b01000010;
			11'h5fa: data = 8'b00100010;
			11'h5fb: data = 8'b00000010;
			11'h5fc: data = 8'b00000100;
			11'h5fd: data = 8'b00001000;
			11'h5fe: data = 8'b00110000;
			11'h5ff: data = 8'b00000000;
			11'h600: data = 8'b00011110;
			11'h601: data = 8'b00100010;
			11'h602: data = 8'b01100010;
			11'h603: data = 8'b00010100;
			11'h604: data = 8'b00001000;
			11'h605: data = 8'b00010000;
			11'h606: data = 8'b01100000;
			11'h607: data = 8'b00000000;
			11'h608: data = 8'b00000100;
			11'h609: data = 8'b00111000;
			11'h60a: data = 8'b00001000;
			11'h60b: data = 8'b01111110;
			11'h60c: data = 8'b00001000;
			11'h60d: data = 8'b00001000;
			11'h60e: data = 8'b01110000;
			11'h60f: data = 8'b00000000;
			11'h610: data = 8'b00000000;
			11'h611: data = 8'b01010010;
			11'h612: data = 8'b01010010;
			11'h613: data = 8'b01010010;
			11'h614: data = 8'b00000100;
			11'h615: data = 8'b00001000;
			11'h616: data = 8'b01110000;
			11'h617: data = 8'b00000000;
			11'h618: data = 8'b00111100;
			11'h619: data = 8'b00000000;
			11'h61a: data = 8'b01111110;
			11'h61b: data = 8'b00001000;
			11'h61c: data = 8'b00001000;
			11'h61d: data = 8'b00010000;
			11'h61e: data = 8'b00100000;
			11'h61f: data = 8'b00000000;
			11'h620: data = 8'b00010000;
			11'h621: data = 8'b00010000;
			11'h622: data = 8'b00010000;
			11'h623: data = 8'b00011000;
			11'h624: data = 8'b00010100;
			11'h625: data = 8'b00010000;
			11'h626: data = 8'b00010000;
			11'h627: data = 8'b00000000;
			11'h628: data = 8'b00001000;
			11'h629: data = 8'b00001000;
			11'h62a: data = 8'b01111110;
			11'h62b: data = 8'b00001000;
			11'h62c: data = 8'b00001000;
			11'h62d: data = 8'b00010000;
			11'h62e: data = 8'b00100000;
			11'h62f: data = 8'b00000000;
			11'h630: data = 8'b00000000;
			11'h631: data = 8'b00111100;
			11'h632: data = 8'b00000000;
			11'h633: data = 8'b00000000;
			11'h634: data = 8'b00000000;
			11'h635: data = 8'b00000000;
			11'h636: data = 8'b01111110;
			11'h637: data = 8'b00000000;
			11'h638: data = 8'b00000000;
			11'h639: data = 8'b00111110;
			11'h63a: data = 8'b00000010;
			11'h63b: data = 8'b00010100;
			11'h63c: data = 8'b00001000;
			11'h63d: data = 8'b00010100;
			11'h63e: data = 8'b00100000;
			11'h63f: data = 8'b00000000;
			11'h640: data = 8'b00001000;
			11'h641: data = 8'b00111110;
			11'h642: data = 8'b00000100;
			11'h643: data = 8'b00001000;
			11'h644: data = 8'b00011100;
			11'h645: data = 8'b00101010;
			11'h646: data = 8'b00001000;
			11'h647: data = 8'b00000000;
			11'h648: data = 8'b00000010;
			11'h649: data = 8'b00000010;
			11'h64a: data = 8'b00000010;
			11'h64b: data = 8'b00000100;
			11'h64c: data = 8'b00001000;
			11'h64d: data = 8'b00010000;
			11'h64e: data = 8'b00100000;
			11'h64f: data = 8'b00000000;
			11'h650: data = 8'b00010000;
			11'h651: data = 8'b00001000;
			11'h652: data = 8'b00000100;
			11'h653: data = 8'b01000010;
			11'h654: data = 8'b01000010;
			11'h655: data = 8'b01000010;
			11'h656: data = 8'b01000010;
			11'h657: data = 8'b00000000;
			11'h658: data = 8'b01000000;
			11'h659: data = 8'b01000000;
			11'h65a: data = 8'b01111110;
			11'h65b: data = 8'b01000000;
			11'h65c: data = 8'b01000000;
			11'h65d: data = 8'b01000000;
			11'h65e: data = 8'b00111110;
			11'h65f: data = 8'b00000000;
			11'h660: data = 8'b00000000;
			11'h661: data = 8'b01111110;
			11'h662: data = 8'b00000010;
			11'h663: data = 8'b00000010;
			11'h664: data = 8'b00000100;
			11'h665: data = 8'b00001000;
			11'h666: data = 8'b00110000;
			11'h667: data = 8'b00000000;
			11'h668: data = 8'b00000000;
			11'h669: data = 8'b00010000;
			11'h66a: data = 8'b00101000;
			11'h66b: data = 8'b01000100;
			11'h66c: data = 8'b00000010;
			11'h66d: data = 8'b00000010;
			11'h66e: data = 8'b00000000;
			11'h66f: data = 8'b00000000;
			11'h670: data = 8'b00001000;
			11'h671: data = 8'b00111110;
			11'h672: data = 8'b00001000;
			11'h673: data = 8'b00001000;
			11'h674: data = 8'b00101010;
			11'h675: data = 8'b00101010;
			11'h676: data = 8'b00001000;
			11'h677: data = 8'b00000000;
			11'h678: data = 8'b01111110;
			11'h679: data = 8'b00000010;
			11'h67a: data = 8'b00000010;
			11'h67b: data = 8'b00000100;
			11'h67c: data = 8'b00101000;
			11'h67d: data = 8'b00010000;
			11'h67e: data = 8'b00001000;
			11'h67f: data = 8'b00000000;
			11'h680: data = 8'b00000000;
			11'h681: data = 8'b00111100;
			11'h682: data = 8'b00000000;
			11'h683: data = 8'b00111100;
			11'h684: data = 8'b00000000;
			11'h685: data = 8'b01111100;
			11'h686: data = 8'b00000010;
			11'h687: data = 8'b00000000;
			11'h688: data = 8'b00000100;
			11'h689: data = 8'b00001000;
			11'h68a: data = 8'b00010000;
			11'h68b: data = 8'b00100000;
			11'h68c: data = 8'b01001000;
			11'h68d: data = 8'b01111100;
			11'h68e: data = 8'b00000010;
			11'h68f: data = 8'b00000000;
			11'h690: data = 8'b00000000;
			11'h691: data = 8'b00000010;
			11'h692: data = 8'b00000010;
			11'h693: data = 8'b00010100;
			11'h694: data = 8'b00001000;
			11'h695: data = 8'b00010100;
			11'h696: data = 8'b01100000;
			11'h697: data = 8'b00000000;
			11'h698: data = 8'b00000000;
			11'h699: data = 8'b01111110;
			11'h69a: data = 8'b00010000;
			11'h69b: data = 8'b01111110;
			11'h69c: data = 8'b00010000;
			11'h69d: data = 8'b00010000;
			11'h69e: data = 8'b00011110;
			11'h69f: data = 8'b00000000;
			11'h6a0: data = 8'b00100000;
			11'h6a1: data = 8'b00100000;
			11'h6a2: data = 8'b01111110;
			11'h6a3: data = 8'b00100010;
			11'h6a4: data = 8'b00100100;
			11'h6a5: data = 8'b00100000;
			11'h6a6: data = 8'b00100000;
			11'h6a7: data = 8'b00000000;
			11'h6a8: data = 8'b00000000;
			11'h6a9: data = 8'b00111000;
			11'h6aa: data = 8'b00001000;
			11'h6ab: data = 8'b00001000;
			11'h6ac: data = 8'b00001000;
			11'h6ad: data = 8'b00001000;
			11'h6ae: data = 8'b01111110;
			11'h6af: data = 8'b00000000;
			11'h6b0: data = 8'b01111110;
			11'h6b1: data = 8'b00000010;
			11'h6b2: data = 8'b00000010;
			11'h6b3: data = 8'b01111110;
			11'h6b4: data = 8'b00000010;
			11'h6b5: data = 8'b00000010;
			11'h6b6: data = 8'b01111110;
			11'h6b7: data = 8'b00000000;
			11'h6b8: data = 8'b00111100;
			11'h6b9: data = 8'b00000000;
			11'h6ba: data = 8'b01111110;
			11'h6bb: data = 8'b00000010;
			11'h6bc: data = 8'b00000100;
			11'h6bd: data = 8'b00001000;
			11'h6be: data = 8'b00010000;
			11'h6bf: data = 8'b00000000;
			11'h6c0: data = 8'b01000010;
			11'h6c1: data = 8'b01000010;
			11'h6c2: data = 8'b01000010;
			11'h6c3: data = 8'b01000010;
			11'h6c4: data = 8'b00000010;
			11'h6c5: data = 8'b00000100;
			11'h6c6: data = 8'b00011000;
			11'h6c7: data = 8'b00000000;
			11'h6c8: data = 8'b00101000;
			11'h6c9: data = 8'b00101000;
			11'h6ca: data = 8'b00101000;
			11'h6cb: data = 8'b00101010;
			11'h6cc: data = 8'b00101010;
			11'h6cd: data = 8'b00101100;
			11'h6ce: data = 8'b01001000;
			11'h6cf: data = 8'b00000000;
			11'h6d0: data = 8'b00100000;
			11'h6d1: data = 8'b00100000;
			11'h6d2: data = 8'b00100000;
			11'h6d3: data = 8'b00100010;
			11'h6d4: data = 8'b00100100;
			11'h6d5: data = 8'b00101000;
			11'h6d6: data = 8'b00110000;
			11'h6d7: data = 8'b00000000;
			11'h6d8: data = 8'b00000000;
			11'h6d9: data = 8'b01111110;
			11'h6da: data = 8'b01000010;
			11'h6db: data = 8'b01000010;
			11'h6dc: data = 8'b01000010;
			11'h6dd: data = 8'b01000010;
			11'h6de: data = 8'b01111110;
			11'h6df: data = 8'b00000000;
			11'h6e0: data = 8'b00000000;
			11'h6e1: data = 8'b01111110;
			11'h6e2: data = 8'b01000010;
			11'h6e3: data = 8'b01000010;
			11'h6e4: data = 8'b00000010;
			11'h6e5: data = 8'b00000100;
			11'h6e6: data = 8'b00011000;
			11'h6e7: data = 8'b00000000;
			11'h6e8: data = 8'b00000000;
			11'h6e9: data = 8'b01110000;
			11'h6ea: data = 8'b00000010;
			11'h6eb: data = 8'b00000010;
			11'h6ec: data = 8'b00000100;
			11'h6ed: data = 8'b00001000;
			11'h6ee: data = 8'b01110000;
			11'h6ef: data = 8'b00000000;
			11'h6f0: data = 8'b00010000;
			11'h6f1: data = 8'b01001000;
			11'h6f2: data = 8'b00100000;
			11'h6f3: data = 8'b00000000;
			11'h6f4: data = 8'b00000000;
			11'h6f5: data = 8'b00000000;
			11'h6f6: data = 8'b00000000;
			11'h6f7: data = 8'b00000000;
			11'h6f8: data = 8'b01110000;
			11'h6f9: data = 8'b01010000;
			11'h6fa: data = 8'b01110000;
			11'h6fb: data = 8'b00000000;
			11'h6fc: data = 8'b00000000;
			11'h6fd: data = 8'b00000000;
			11'h6fe: data = 8'b00000000;
			11'h6ff: data = 8'b00000000;
			11'h700: data = 8'b00000000;
			11'h701: data = 8'b00000000;
			11'h702: data = 8'b11111111;
			11'h703: data = 8'b00000000;
			11'h704: data = 8'b00000000;
			11'h705: data = 8'b11111111;
			11'h706: data = 8'b00000000;
			11'h707: data = 8'b00000000;
			11'h708: data = 8'b00001000;
			11'h709: data = 8'b00001000;
			11'h70a: data = 8'b00001111;
			11'h70b: data = 8'b00001000;
			11'h70c: data = 8'b00001000;
			11'h70d: data = 8'b00001111;
			11'h70e: data = 8'b00001000;
			11'h70f: data = 8'b00001000;
			11'h710: data = 8'b00001000;
			11'h711: data = 8'b00001000;
			11'h712: data = 8'b11111111;
			11'h713: data = 8'b00001000;
			11'h714: data = 8'b00001000;
			11'h715: data = 8'b11111111;
			11'h716: data = 8'b00001000;
			11'h717: data = 8'b00001000;
			11'h718: data = 8'b00001000;
			11'h719: data = 8'b00001000;
			11'h71a: data = 8'b11111000;
			11'h71b: data = 8'b00001000;
			11'h71c: data = 8'b00001000;
			11'h71d: data = 8'b11111000;
			11'h71e: data = 8'b00001000;
			11'h71f: data = 8'b00001000;
			11'h720: data = 8'b00000001;
			11'h721: data = 8'b00000011;
			11'h722: data = 8'b00000111;
			11'h723: data = 8'b00001111;
			11'h724: data = 8'b00011111;
			11'h725: data = 8'b00111111;
			11'h726: data = 8'b01111111;
			11'h727: data = 8'b11111111;
			11'h728: data = 8'b10000000;
			11'h729: data = 8'b11000000;
			11'h72a: data = 8'b11100000;
			11'h72b: data = 8'b11110000;
			11'h72c: data = 8'b11111000;
			11'h72d: data = 8'b11111100;
			11'h72e: data = 8'b11111110;
			11'h72f: data = 8'b11111111;
			11'h730: data = 8'b11111111;
			11'h731: data = 8'b01111111;
			11'h732: data = 8'b00111111;
			11'h733: data = 8'b00011111;
			11'h734: data = 8'b00001111;
			11'h735: data = 8'b00000111;
			11'h736: data = 8'b00000011;
			11'h737: data = 8'b00000001;
			11'h738: data = 8'b11111111;
			11'h739: data = 8'b11111110;
			11'h73a: data = 8'b11111100;
			11'h73b: data = 8'b11111000;
			11'h73c: data = 8'b11110000;
			11'h73d: data = 8'b11100000;
			11'h73e: data = 8'b11000000;
			11'h73f: data = 8'b10000000;
			11'h740: data = 8'b00001000;
			11'h741: data = 8'b00011100;
			11'h742: data = 8'b00111110;
			11'h743: data = 8'b01111111;
			11'h744: data = 8'b01111111;
			11'h745: data = 8'b00011100;
			11'h746: data = 8'b00111110;
			11'h747: data = 8'b00000000;
			11'h748: data = 8'b00110110;
			11'h749: data = 8'b01111111;
			11'h74a: data = 8'b01111111;
			11'h74b: data = 8'b01111111;
			11'h74c: data = 8'b00111110;
			11'h74d: data = 8'b00011100;
			11'h74e: data = 8'b00001000;
			11'h74f: data = 8'b00000000;
			11'h750: data = 8'b00001000;
			11'h751: data = 8'b00011100;
			11'h752: data = 8'b00111110;
			11'h753: data = 8'b01111111;
			11'h754: data = 8'b00111110;
			11'h755: data = 8'b00011100;
			11'h756: data = 8'b00001000;
			11'h757: data = 8'b00000000;
			11'h758: data = 8'b00011100;
			11'h759: data = 8'b00011100;
			11'h75a: data = 8'b01111111;
			11'h75b: data = 8'b01111111;
			11'h75c: data = 8'b01101011;
			11'h75d: data = 8'b00001000;
			11'h75e: data = 8'b00111110;
			11'h75f: data = 8'b00000000;
			11'h760: data = 8'b00000000;
			11'h761: data = 8'b00111100;
			11'h762: data = 8'b01111110;
			11'h763: data = 8'b01111110;
			11'h764: data = 8'b01111110;
			11'h765: data = 8'b01111110;
			11'h766: data = 8'b00111100;
			11'h767: data = 8'b00000000;
			11'h768: data = 8'b00000000;
			11'h769: data = 8'b00111100;
			11'h76a: data = 8'b01000010;
			11'h76b: data = 8'b01000010;
			11'h76c: data = 8'b01000010;
			11'h76d: data = 8'b01000010;
			11'h76e: data = 8'b00111100;
			11'h76f: data = 8'b00000000;
			11'h770: data = 8'b00000001;
			11'h771: data = 8'b00000010;
			11'h772: data = 8'b00000100;
			11'h773: data = 8'b00001000;
			11'h774: data = 8'b00010000;
			11'h775: data = 8'b00100000;
			11'h776: data = 8'b01000000;
			11'h777: data = 8'b10000000;
			11'h778: data = 8'b10000000;
			11'h779: data = 8'b01000000;
			11'h77a: data = 8'b00100000;
			11'h77b: data = 8'b00010000;
			11'h77c: data = 8'b00001000;
			11'h77d: data = 8'b00000100;
			11'h77e: data = 8'b00000010;
			11'h77f: data = 8'b00000001;
			11'h780: data = 8'b10000001;
			11'h781: data = 8'b01000010;
			11'h782: data = 8'b00100100;
			11'h783: data = 8'b00011000;
			11'h784: data = 8'b00011000;
			11'h785: data = 8'b00100100;
			11'h786: data = 8'b01000010;
			11'h787: data = 8'b10000001;
			11'h788: data = 8'b01111111;
			11'h789: data = 8'b01001001;
			11'h78a: data = 8'b01001001;
			11'h78b: data = 8'b01111111;
			11'h78c: data = 8'b01000001;
			11'h78d: data = 8'b01000001;
			11'h78e: data = 8'b01000001;
			11'h78f: data = 8'b00000000;
			11'h790: data = 8'b01000000;
			11'h791: data = 8'b01111110;
			11'h792: data = 8'b01001000;
			11'h793: data = 8'b00111100;
			11'h794: data = 8'b00101000;
			11'h795: data = 8'b01111110;
			11'h796: data = 8'b00001000;
			11'h797: data = 8'b00000000;
			11'h798: data = 8'b00111111;
			11'h799: data = 8'b00100001;
			11'h79a: data = 8'b00111111;
			11'h79b: data = 8'b00100001;
			11'h79c: data = 8'b00111111;
			11'h79d: data = 8'b00100001;
			11'h79e: data = 8'b01000001;
			11'h79f: data = 8'b00000000;
			11'h7a0: data = 8'b01111111;
			11'h7a1: data = 8'b01000001;
			11'h7a2: data = 8'b01000001;
			11'h7a3: data = 8'b01111111;
			11'h7a4: data = 8'b01000001;
			11'h7a5: data = 8'b01000001;
			11'h7a6: data = 8'b01111111;
			11'h7a7: data = 8'b00000000;
			11'h7a8: data = 8'b00000100;
			11'h7a9: data = 8'b11101110;
			11'h7aa: data = 8'b10100100;
			11'h7ab: data = 8'b11101111;
			11'h7ac: data = 8'b10100010;
			11'h7ad: data = 8'b11101111;
			11'h7ae: data = 8'b00001010;
			11'h7af: data = 8'b00000010;
			11'h7b0: data = 8'b00000000;
			11'h7b1: data = 8'b00011000;
			11'h7b2: data = 8'b00100100;
			11'h7b3: data = 8'b01000010;
			11'h7b4: data = 8'b00111100;
			11'h7b5: data = 8'b00010100;
			11'h7b6: data = 8'b00100100;
			11'h7b7: data = 8'b00000000;
			11'h7b8: data = 8'b00111010;
			11'h7b9: data = 8'b00010010;
			11'h7ba: data = 8'b01111111;
			11'h7bb: data = 8'b00010111;
			11'h7bc: data = 8'b00111011;
			11'h7bd: data = 8'b01010010;
			11'h7be: data = 8'b00010100;
			11'h7bf: data = 8'b00000000;
			11'h7c0: data = 8'b00000000;
			11'h7c1: data = 8'b00000000;
			11'h7c2: data = 8'b00000000;
			11'h7c3: data = 8'b00000000;
			11'h7c4: data = 8'b00000000;
			11'h7c5: data = 8'b00000000;
			11'h7c6: data = 8'b00000000;
			11'h7c7: data = 8'b00000000;
			11'h7c8: data = 8'b00000000;
			11'h7c9: data = 8'b00000000;
			11'h7ca: data = 8'b00000000;
			11'h7cb: data = 8'b00000000;
			11'h7cc: data = 8'b00000000;
			11'h7cd: data = 8'b00000000;
			11'h7ce: data = 8'b00000000;
			11'h7cf: data = 8'b00000000;
			11'h7d0: data = 8'b00000000;
			11'h7d1: data = 8'b00000000;
			11'h7d2: data = 8'b00000000;
			11'h7d3: data = 8'b00000000;
			11'h7d4: data = 8'b00000000;
			11'h7d5: data = 8'b00000000;
			11'h7d6: data = 8'b00000000;
			11'h7d7: data = 8'b00000000;
			11'h7d8: data = 8'b00000000;
			11'h7d9: data = 8'b00000000;
			11'h7da: data = 8'b00000000;
			11'h7db: data = 8'b00000000;
			11'h7dc: data = 8'b00000000;
			11'h7dd: data = 8'b00000000;
			11'h7de: data = 8'b00000000;
			11'h7df: data = 8'b00000000;
			11'h7e0: data = 8'b00000000;
			11'h7e1: data = 8'b00000000;
			11'h7e2: data = 8'b00000000;
			11'h7e3: data = 8'b00000000;
			11'h7e4: data = 8'b00000000;
			11'h7e5: data = 8'b00000000;
			11'h7e6: data = 8'b00000000;
			11'h7e7: data = 8'b00000000;
			11'h7e8: data = 8'b00000000;
			11'h7e9: data = 8'b00000000;
			11'h7ea: data = 8'b00000000;
			11'h7eb: data = 8'b00000000;
			11'h7ec: data = 8'b00000000;
			11'h7ed: data = 8'b00000000;
			11'h7ee: data = 8'b00000000;
			11'h7ef: data = 8'b00000000;
			11'h7f0: data = 8'b00000000;
			11'h7f1: data = 8'b00000000;
			11'h7f2: data = 8'b00000000;
			11'h7f3: data = 8'b00000000;
			11'h7f4: data = 8'b00000000;
			11'h7f5: data = 8'b00000000;
			11'h7f6: data = 8'b00000000;
			11'h7f7: data = 8'b00000000;
			11'h7f8: data = 8'b00000000;
			11'h7f9: data = 8'b00000000;
			11'h7fa: data = 8'b00000000;
			11'h7fb: data = 8'b00000000;
			11'h7fc: data = 8'b00000000;
			11'h7fd: data = 8'b00000000;
			11'h7fe: data = 8'b00000000;
			11'h7ff: data = 8'b00000000;
`endif
			default: data = 8'bXXXXXXXX;
		endcase
	end
endmodule
