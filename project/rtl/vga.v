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
            input             CLK,
            input             RST,
            input             PORT30_WE,
            input             CRTC_WE,
            input             ADR,  // cpu addr [0]
            input  [ 7:0]     DATA, // CPU data
            input  [ 7:0]     RAM_DATA, // SRAM data
            output [16:0]     RAM_ADR,
            output reg        BUSREQ,
            input             BUSACK,
            output reg [ 3:0] VGA_R,
            output reg [ 3:0] VGA_G,
            output reg [ 3:0] VGA_B,
            output            VGA_HS,
            output            VGA_VS
            );


////////////////////////////////////////
// re-timing
////////////////////////////////////////


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
	  if (PORT30_WE) begin
		 width80   <= DATA[0];
		 colormode <= ~DATA[1];
	  end
	  if (CRTC_WE) begin
		 if (ADR) begin
			if (DATA == 8'h00) seq <= 5;
			if (DATA == 8'h80) ycurs <= 31;
			if (DATA == 8'h81) seq <= 7;
		 end
		 else begin
			if (seq == 3) lpc   <= DATA[3:0]; // lpc -> Line per Charactor. 7: 8ライン/文字  9: 10ライン/文字
			if (seq == 7) xcurs <= DATA[6:0];
			if (seq == 6) ycurs <= DATA[4:0];
			if (seq) seq <= seq == 6 ? 0 : seq - 1;
		 end
	  end
   end // always @ (posedge CLK)



///////////////////////////////////////////////////////
/// DMA state
//////////////////////////////////////////////////////
   reg [ 3:0] state = 4'h0;
   reg [11:0] dma_src_adr = 12'h000;
   reg [ 6:0] dma_dst_adr = 7'h00;
   reg [ 6:0] dma_trans_count = 7'h00;
   reg [ 6:0] dma_att_adr = 7'h00;

   wire       chlast;
   assign     chlast = (w_vdotcnt == lpc);

   wire       dma_trans_count_end = (dma_trans_count ==  7'd119);
   wire       dma_vram_end        = (dma_trans_count ==  7'd 79);
   wire       dma_trans_vram      = (dma_trans_count <   7'd 80);
   wire       dma_trans_attribute = (dma_trans_count >   7'd 79);

   // 水平期間中にDMA転送する
   // DMAのソース/ディストアドレスはVライン最終行(524)を指定する.
   always @(posedge CLK) begin

	  if (state == 0 & w_hcnt == 648) begin
		 if (w_vcnt == 524) begin
			dma_src_adr <= 12'h300;
         end
         if ( (w_vcnt == 524 | chlast)) begin
			state <= 4'h1;
			dma_dst_adr <= 7'h00;
            dma_att_adr <= 7'h00;
    	 end
	  end
      // DMA許可待ち
//	  if (state == 1 & BUSACK) begin
//		 state <= 4'h2;
//      end
      // DMA転送中
	  if (state == 1 & BUSACK) begin
         // 120バイトDMA転送したら終了
         if(dma_trans_count_end) begin
            dma_trans_count <= 7'h00;
            state <= 4'h0;
         end
         else begin
            dma_trans_count <= dma_trans_count + 7'h01;
         end
         // VideoRAM転送中
		 if(dma_trans_vram) begin
            dma_dst_adr <= dma_dst_adr + 7'h01;
         end
         // Attribute転送中
         else if (dma_trans_attribute) begin
            if(dma_trans_count[0]) dma_att_adr <= dma_att_adr + 7'h01;
         end

		 dma_src_adr     <= dma_src_adr + 12'h001;
	  end

	  BUSREQ <= state != 0;
   end // always @ (posedge CLK)

   assign RAM_ADR = { 5'h0f, dma_src_adr };


/////////////////////////////////////////////
// text
////////////////////////////////////////////
   reg [6:0] text_adr;
   reg [7:0] xcnt;

   always @(posedge CLK or posedge RST) begin
      if ( RST ) begin
         text_adr <= 7'h00;
         xcnt     <= 8'h00;
      end
      else begin
         if (w_hcnt == 10'd648) begin
            text_adr <= 7'h00;
            xcnt     <= 8'h00;
         end
         else if (w_hdisp_en & w_hdotcnt[2:0] == 3'b111) begin
		    text_adr <= text_adr + 7'h01;
		    xcnt     <= xcnt + 8'h01;
	     end
      end
   end // always @ (posedge CLK)


////////////////////////////////////////
/// ONE-ROW Buffer
///////////////////////////////////////
 //wire [ 6:0] rowbuf_adr  = w_hcnt[2] ? text_adr : { atr_adr, w_hcnt[1] };
   wire [ 6:0] rowbuf_adr = text_adr;
   wire [ 7:0] rowbuf_outdata;
   wire [ 7:0] rowbuf_indata;

   reg  [ 6:0] attbuf_adr = 7'h00;
   wire [15:0] attbuf_outdata;
   reg  [15:0] attbuf_indata;

   wire        rowbuf_we;
//   assign      rowbuf_we = (state == 2);
   assign      rowbuf_we = (state == 1 & BUSACK & dma_trans_vram);

   wire        attbuf_we;
//   assign      attbuf_we = (state == 2);
   assign      attbuf_we = (state == 1 & BUSACK & dma_trans_attribute);

   reg [ 4:0] r_attbuf_we;
   always @(posedge CLK or posedge RST) begin
      if( RST ) begin
         r_attbuf_we <= 5'h0;
      end
      else begin
         r_attbuf_we <= {r_attbuf_we[3:0], attbuf_we};
      end
   end
   

//   assign      rowbuf_indata = (dma_trans_vram & state == 2) ? RAM_DATA : 8'h00;
   assign      rowbuf_indata = (dma_trans_vram & state == 1 & BUSACK) ? RAM_DATA : 8'h00;

   reg [ 7:0]  r_ram_data;
   always @(posedge CLK or posedge RST) begin
      if( RST ) begin
         r_ram_data <= 7'h00;
      end
      else begin
         r_ram_data <= RAM_DATA;
      end
   end

//`ifdef debug
   reg [ 6:0] dma_att_adr_0;
   reg [ 6:0] dma_att_adr_1;
   reg [ 6:0] dma_att_adr_2;
   reg [ 6:0] dma_att_adr_3;
   always @(posedge CLK or posedge RST) begin
      if ( RST ) begin
         dma_att_adr_0 <= 7'h00;
         dma_att_adr_1 <= 7'h00;
         dma_att_adr_2 <= 7'h00;
         dma_att_adr_3 <= 7'h00;
      end
      else begin
         dma_att_adr_0 <= dma_att_adr;
         dma_att_adr_1 <= dma_att_adr_0;
         dma_att_adr_2 <= dma_att_adr_1;
         dma_att_adr_3 <= dma_att_adr_2;
      end
   end
//`endif
 
   reg [ 7:0]  r_att_1st_data;
   always @(posedge CLK or posedge RST) begin
      if( RST ) begin
         r_att_1st_data <= 8'h00;
      end
      else begin
         if(dma_trans_attribute & ~dma_trans_count[0]) begin
            r_att_1st_data <= r_ram_data;
         end
      end
   end

   always @(posedge CLK or posedge RST) begin
      if( RST ) begin
         attbuf_indata  <= 16'h0000;
      end
      else begin
         if(dma_trans_attribute & dma_trans_count[0]) begin
            attbuf_indata <= {r_att_1st_data , r_ram_data};
         end
      end // else: !if( RST )
   end // always @ (posedge CLK or posedge RST)



   // VRAMから転送されるデータをROWバッファにメモリする際に,
   // ビデオRAMエリアを下位8bitとアトリビュート(上位16bit)に振りわけて,メモリする.
   reg [ 6:0] dma_dst_adr_0;
   always @(posedge CLK or posedge RST) begin
      if( RST ) begin
         dma_dst_adr_0 <= 7'h00;
      end
      else begin
         dma_dst_adr_0 <= dma_dst_adr;
      end
   end

   alt_vram ROWBUF (
	.clock     ( CLK ),
	.wraddress ( { 2'b00, dma_dst_adr_0} ),
	.wren      ( rowbuf_we ),
	.data      ( rowbuf_indata ),
	.rdaddress ( { 2'b00, rowbuf_adr } ),
	.q         ( rowbuf_outdata )
	);

  alt_vram_attribute ATTRIBUTE (
	.clock     ( CLK ),
	.wraddress ( { 2'b00, dma_att_adr_3} ),
	.wren      ( r_attbuf_we[4] ),
	.data      ( attbuf_indata ),
	.rdaddress ( {2'b00, attbuf_adr} ),
	.q         ( attbuf_outdata )
	);

   wire [ 7:0] w_text_data;
   assign      w_text_data = rowbuf_outdata[7:0];

////////////////////////////////////////////
// attribute
///////////////////////////////////////////
	//reg [ 5:0] atr_adr  = 6'h00;
    reg [ 6:0] atr  = 7'b1110000;
    reg [ 6:0] atr0 = 7'b1110000;
	reg [ 4:0] ycnt = 5'h00;

   wire [15:0] w_atr_data;
   assign      w_atr_data[15:8] = attbuf_outdata[15:8]; //何桁目の文字から属性付加するか.
   assign      w_atr_data[ 7:0] = attbuf_outdata[ 7:0]; //属性情報
   
   always @(posedge CLK) begin

	  if (w_hdisp_en & (w_hdotcnt[2:0] == 3'b110) & (w_atr_data[15:8] == xcnt)) begin

         // 描画桁とアトリビュート指定桁が一致したらアドレスを更新する.
         attbuf_adr <= attbuf_adr + 7'h01;

         // カラーモードの場合
		 if (colormode & w_atr_data[3]) begin
            atr[6:3] <= w_atr_data[7:4]; // 上位3bit,色指定. 下位1bitグラフィックorキャラクタ
         end
         // カラーモード,白黒共通
		 else begin
            atr[2:0] <= w_atr_data[2:0];   // リバース,ブリンク等の指定
         end
         // 白黒モードの場合
		 if (~colormode) begin
			atr[6:3] <= { 3'b111, w_atr_data[7] }; // T/G
         end
	  end

	  if (w_hcnt == 648) begin
		 if (w_vcnt == 524) begin
			attbuf_adr <= 7'h00;
			ycnt       <= 5'h00;
		 end
		 else if (chlast) begin
			attbuf_adr <= 7'h00;
			atr0    <= atr;
			ycnt    <= ycnt + 5'h01;
		 end
		 else begin
			attbuf_adr <= 7'h00;
			atr <= atr0;
		 end
	  end
   end // always @ (posedge CLK)
   



///////////////////////////////////////
/// Charactor ROM
///////////////////////////////////////
   // H_CNTとV_CNTを文字とドットのカウンタとして分けて考える
   wire [ 6:0]                w_hchacnt = w_hcnt[ 9:3]; // 水平文字カウンタ
   wire [ 2:0]                w_hdotcnt = w_hcnt[ 2:0]; // 水平ドットカウンタ
   wire [ 4:0]                w_vchacnt = w_vcnt[ 8:4]; // 垂直文字カウンタ
   wire [ 3:0]                w_vdotcnt;
   assign                     w_vdotcnt = w_vcnt[ 3:0]; // 垂直ドットカウンタ
   wire [ 7:0]                w_cgout;

   alt_cgrom_8x16 CGROM (
	                     .address ( {w_text_data, w_vdotcnt} ),
	                     .clock   ( CLK ),
	                     .q       ( w_cgout )
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

   assign dotl = sel2(w_vdotcnt[2:1], rowbuf_outdata[3:0]);
   assign dotr = sel2(w_vdotcnt[2:1], rowbuf_outdata[7:4]);
   assign w_graphic = { dotl, dotl, dotl, dotl, dotr, dotr, dotr, dotr };

   always @(posedge CLK) begin
	  if (w_hcnt[2:0] == 3'b111 & (width80 | ~w_hcnt[3])) begin
		 if (w_hdisp_en  & w_vdisp_en  & ~w_vdotcnt[3])begin
            r_chrline <= atr[3] ? w_graphic : w_cgout;
         end
		 else begin
            r_chrline <= 8'h00;
         end

         qinh  <= atr[0] | (atr[1] & w_vcnt[6:5] == 2'b00);
		 qrev  <= atr[2] & w_hdisp_en & w_vdisp_en;
		 qcurs <= w_vcnt[6] & w_hdisp_en & xcnt == xcurs & ycnt == ycurs;
		 color <= atr[6:4];

	  end
	  else begin
		 if (width80 | w_hdotcnt[0]) r_chrline <= {r_chrline[6:0],1'b0};
      end
   end



   // 水平,垂直イネーブル信号
   wire w_hdisp_en = (10'd5 <= w_hcnt && w_hcnt <= 10'd645);
//   wire w_hdisp_en = (10'd4 <= w_hcnt && w_hcnt <= 10'd644);
   wire w_vdisp_en = (w_vcnt < 10'd400);

   // RGB出力信号生成
   always @( posedge CLK, posedge RST) begin
      if ( RST ) begin
        VGA_R <= 4'h0;
        VGA_G <= 4'h0;
        VGA_B <= 4'h0;
      end
      else begin
         VGA_R <= {4{w_hdisp_en & w_vdisp_en}} & {4{(r_chrline[7] & ~qinh)^qrev^qcurs}};
         VGA_G <= {4{w_hdisp_en & w_vdisp_en}} & {4{(r_chrline[7] & ~qinh)^qrev^qcurs}};
         VGA_B <= {4{w_hdisp_en & w_vdisp_en}} & {4{(r_chrline[7] & ~qinh)^qrev^qcurs}};
      end
   end // always @ ( posedge CLK, posedge RST)

endmodule // VGA
