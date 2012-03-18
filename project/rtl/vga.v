//***************************************************************************************
// PC-8001 on the DE0 Altera CycloneIII version.
// VGA controller
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
//***************************************************************************************



module VGA (
            input CLK,
            input RST,
			input port30h_we,
			input crtc_we,
            input adr,  // cpu addr [0]
            input [ 7:0] data, // CPU data
            input [ 7:0] ram_data, // SRAM data
            output [16:0] ram_adr,
  			output reg busreq,
			input busack,
            output reg [ 3:0] VGA_R,
            output reg [ 3:0] VGA_G,
            output reg [ 3:0] VGA_B,
            output            VGA_HS,
            output            VGA_VS
            );

////////////////////////////////////////
/// H/V Sync Genelator
///////////////////////////////////////

   wire [ 9:0]                w_hcnt;
   wire [ 9:0]                w_vcnt;

   HVGEN HVGEN (
              .CLK(CLK),
              .RST(RST),
              .HS(VGA_HS),
              .VS(VGA_VS),
              .H_CNT(w_hcnt),
              .V_CNT(w_vcnt)
              );

////////////////////////////////////////
// Register access
////////////////////////////////////////

   reg [2:0] seq;
   reg [6:0] xcurs = 0;
   reg [4:0] ycurs = 0;
   reg [3:0] lpc = 9;
   reg       colormode;
   reg       width80 = 0;
   
   always @(posedge CLK) begin
	  if (port30h_we) begin
		 width80   <= data[0];
		 colormode <= ~data[1];
	  end
	  if (crtc_we) begin
		 if (adr) begin
			if (data == 8'h00) seq <= 5;
			if (data == 8'h80) ycurs <= 31;
			if (data == 8'h81) seq <= 7;
		 end
		 else begin
			if (seq == 3) lpc   <= data[3:0]; // lpc -> Line per Charactor. 7: 8ライン/文字  9: 10ライン/文字
			if (seq == 7) xcurs <= data[6:0];
			if (seq == 6) ycurs <= data[4:0];
			if (seq) seq <= seq == 6 ? 0 : seq - 1;
		 end
	  end
   end // always @ (posedge CLK)


///////////////////////////////////////////////////////
/// DMA state
//////////////////////////////////////////////////////
   reg [ 1:0] state = 0;
   reg [11:0] dma_src_adr = 12'h300;
   reg [ 6:0] dma_dst_adr = 0;
   
   wire       chlast;
   assign     chlast = {1'b0, w_vdotcnt} == lpc;
   
   // 水平期間中にDMA転送する
   // DMAのソース/ディストアドレスはVライン最終行(524)を指定する.
   always @(posedge CLK) begin

	  if (state == 0 & w_hcnt == 648) begin
		 if (w_vcnt == 524) begin
			dma_src_adr <= 12'h300;
         end
//		 if ( (w_vcnt == 481 | chlast)) begin
		 if ( (w_vcnt == 524 | w_vdotcnt == 4'b1111)) begin
			state <= 1;
			dma_dst_adr <= 7'h00;
		 end
	  end
	  if (state == 1 & busack) begin
		state <= 2'h2;
      end
//	  if (state == 2)
//		state <= 2'h3;
//	  if (state == 3) begin
	  if (state == 2) begin
		 state <= (dma_dst_adr == 7'd119) ? 0 : 2;
		 dma_src_adr <= dma_src_adr + 12'h001;
		 dma_dst_adr <= dma_dst_adr + 7'h01;
	  end

	  busreq <= state != 0;
   end // always @ (posedge CLK)

   assign ram_adr = { 5'h0f, dma_src_adr };


/////////////////////////////////////////////
// text
////////////////////////////////////////////
   reg [6:0] text_adr = 0;
   reg [6:0] xcnt = 0;

   always @(posedge CLK) begin
      if (w_hcnt == 648) begin
         text_adr <= 7'h00;
         xcnt     <= 7'h00;
      end
      else if (w_hdisp_en & w_hdotcnt[2:0] == 3'b111) begin
		 text_adr <= text_adr + 7'h01;
		 xcnt     <= xcnt + 7'h01;
	  end
   end // always @ (posedge CLK)


////////////////////////////////////////
/// VRAM
///////////////////////////////////////
   wire [ 6:0] rowbuf_adr  = w_hcnt[2] ? text_adr : { atr_adr, w_hcnt[1] };
//   wire [ 6:0] rowbuf_adr = text_adr;
   wire        rowbuf_we;
   wire [ 7:0] text_data;
   
//   assign      rowbuf_we = (state == 3);
   assign      rowbuf_we = (state == 2);

   alt_vram VRAM (
	.clock     ( CLK ),
	.wraddress ( { 2'b00, dma_dst_adr} ),
	.wren      ( rowbuf_we ),
	.data      ( ram_data ),
	.rdaddress ( { 2'b00, rowbuf_adr } ),
	.q         ( text_data )
	);


////////////////////////////////////////////
// attribute
///////////////////////////////////////////
	reg [ 5:0] atr_adr  = 6'h00;
	reg [14:0] atr_data = 15'h0000;
    reg [ 6:0] atr  = 7'b1110000;
    reg [ 6:0] atr0 = 7'b1110000;
	reg [ 4:0] ycnt = 5'h00;

   always @(posedge CLK) begin

	  if (w_hcnt[2:0] == 3'b001) begin
		 atr_data[14:8] <= text_data[6:0]; //何番目の文字に属性を付加するか.
      end

	  if (w_hcnt[2:0] == 3'b011) begin
         atr_data[7:0]  <= text_data[7:0]; // 属性内容
      end

	  if (w_hdisp_en & w_hcnt[2:0] == 3'b110 & atr_data[14:8] == xcnt) begin

		 atr_adr <= atr_adr + 6'h01;
         
		 if (colormode & atr_data[3]) begin
            atr[6:3] <= atr_data[7:4]; // 色指定
         end
		 else begin
            atr[2:0] <= atr_data[2:0]; // 機能指定
         end
         
		 if (~colormode) begin
			atr[6:3] <= { 3'b111, atr_data[7] }; // T/G(?)
         end

	  end // if (w_hdisp_en & w_hcnt[2:0] == 3'b110 & atr_data[14:8] == xcnt)

	  if (w_hcnt == 648) begin
		 if (w_vcnt == 524) begin
			atr_adr <= 6'h28;
			ycnt    <= 5'h00;
		 end
		 else if (w_vdotcnt == 4'b1111) begin
			atr_adr <= 6'h28;
			atr0    <= atr;
			ycnt    <= ycnt + 5'h01;
		 end
		 else begin
			atr_adr <= 6'h28;
			atr <= atr0;
		 end
	  end // if (w_hcnt == 799)

   end // always @ (posedge CLK)
   



///////////////////////////////////////
/// Charactor ROM
///////////////////////////////////////
   // H_CNTとV_CNTを文字とドットのカウンタとして分けて考える
   wire [ 6:0]                w_hchacnt = w_hcnt[ 9:3]; // 水平文字カウンタ
   wire [ 2:0]                w_hdotcnt = w_hcnt[ 2:0]; // 水平ドットカウンタ
//   wire [ 5:0]                w_vchacnt = w_vcnt[ 8:3]; // 垂直文字カウンタ
//   wire [ 2:0]                w_vdotcnt;
//   assign                     w_vdotcnt = w_vcnt[ 2:0]; // 垂直ドットカウンタ
   wire [ 4:0]                w_vchacnt = w_vcnt[ 8:4]; // 垂直文字カウンタ
   wire [ 3:0]                w_vdotcnt;
   assign                     w_vdotcnt = w_vcnt[ 3:0]; // 垂直ドットカウンタ

   wire [ 7:0]                w_cgout;

   alt_cgrom_8x16 CGROM (
	                     .address ( {text_data, w_vdotcnt} ),
	                     .clock ( CLK ),
	                     .q ( w_cgout )
	                    );


///////////////////////////////////
// atribute adding
//////////////////////////////////
   wire                       dotl;
   wire                       doth;
   wire [ 7:0]                w_graphic;
   reg [ 7:0]                 r_chrline;
   reg                        qinh = 1'b0;
   reg                        qrev = 1'b0;
   reg                        qcurs = 1'b0;

   reg  [2:0] color; // colorデコーダを作ったらもっていく

   
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

   assign dotl = sel2(w_vdotcnt[2:1], text_data[3:0]);
   assign dotr = sel2(w_vdotcnt[2:1], text_data[7:4]);
   assign w_graphic = { dotl, dotl, dotl, dotl, dotr, dotr, dotr, dotr };

   always @(posedge CLK) begin
	  if (w_hcnt[2:0] == 3'b111 & (width80 | ~w_hcnt[3])) begin
		 if (w_hdisp_en  & w_vdisp_en  & ~w_vdotcnt[3])begin
		   r_chrline <= atr[3] ? w_graphic : w_cgout;
         end
		 else begin
            r_chrline <= 8'b00000000;
         end

		 qinh  <= atr[0] | (atr[1] & w_vcnt[6:5] == 2'b00);
		 qrev  <= atr[2] & w_hdisp_en & w_vdisp_en;
		 qcurs <= w_vcnt[5] & w_hdisp_en & xcnt == xcurs & ycnt == ycurs;
		 color <= atr[6:4];
	  end
	  else begin
		if (width80 | w_hdotcnt[0]) r_chrline <= r_chrline << 1;
      end
   end // always @ (posedge clk)


   // シフトレジスタ
   reg [ 7:0]                 r_sreg;
   wire                       w_sreg_ld = (w_hdotcnt == 3'h6 && w_hcnt < 10'd640);

   always @( posedge CLK , posedge RST) begin
      if ( RST )
        r_sreg <= 8'h00;
      else if ( w_sreg_ld )
//        r_sreg <= w_cgout;
        r_sreg <= r_chrline;
      else
        r_sreg <= {r_sreg[6:0],1'b0};
   end


   // 水平,垂直イネーブル信号
   wire w_hdisp_en = (10'd7 <= w_hcnt && w_hcnt <= 10'd647);
   wire w_vdisp_en = (w_vcnt < 9'd400);

   // RGB出力信号生成
   always @( posedge CLK, posedge RST) begin
      if ( RST ) begin
        VGA_R <= 4'h0;
        VGA_G <= 4'h0;
        VGA_B <= 4'h0;
      end
      else begin
         VGA_R <= {4{w_hdisp_en & w_vdisp_en}} & {4{r_sreg[7]}};
         VGA_G <= {4{w_hdisp_en & w_vdisp_en}} & {4{r_sreg[7]}};
         VGA_B <= {4{w_hdisp_en & w_vdisp_en}} & {4{r_sreg[7]}};
      end
   end // always @ ( posedge CLK, posedge RST)

endmodule // VGA
