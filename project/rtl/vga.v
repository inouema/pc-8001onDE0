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
            input             I_CLK,
            input             I_RST,
            input             I_PORT30_WE,
            input             I_CRTC_WE,
            input             I_ADR,      // cpu addr [0]
            input  [ 7:0]     I_DATA,     // CPU data
            input  [ 7:0]     I_RAM_DATA, // SRAM data
            output reg [14:0] O_RAM_ADR,
            output reg        O_BUSREQ,
            input             I_BUSACK,
            output reg [ 3:0] O_VGA_R,
            output reg [ 3:0] O_VGA_G,
            output reg [ 3:0] O_VGA_B,
            output            O_VGA_HS,
            output            O_VGA_VS
            );



//************************************//
//***  Modules   *********************//
//************************************//

////////////////////////////////////////
/// H/V Sync Genelator
///////////////////////////////////////

   wire [ 9:0]                w_hcnt;
   wire [ 9:0]                w_vcnt;

   HVGEN HVGEN (
              .I_CLK(I_CLK),
              .I_RST(I_RST),
              .O_HS(O_VGA_HS),
              .O_VS(O_VGA_VS),
              .O_H_CNT(w_hcnt),
              .O_V_CNT(w_vcnt)
              );



////////////////////////////////////////
// Re-timing
////////////////////////////////////////
   reg        r_port30_we;
   reg        r_crtc_we;
   reg        r_adr;
   reg [ 7:0] r_data;
   reg [ 7:0] r_ram_data;
   reg        r_busack;

   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_port30_we <= 1'b0;
         r_crtc_we   <= 1'b0;
         r_adr       <= 1'b0;
         r_data      <= 7'h00;
         r_ram_data  <= 7'h00;
         r_busack    <= 1'b0;
      end
      else begin
         r_port30_we <= I_PORT30_WE;
         r_crtc_we   <= I_CRTC_WE;
         r_adr       <= I_ADR;
         r_data      <= I_DATA;
         r_ram_data  <= I_RAM_DATA;
         r_busack    <= I_BUSACK;
      end
   end



////////////////////////////////////////
// Register access
////////////////////////////////////////

   reg [2:0] r_seq;
   reg [6:0] r_xcurs;
   reg [4:0] r_ycurs;
   reg [3:0] r_lpc;
   reg       r_colormode;
   reg       r_width80;

   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_seq <= 3'h0;
         r_xcurs <= 7'h00;
         r_ycurs <= 5'h00;
         r_lpc   <= 4'h9;
         r_colormode <= 1'b0;
         r_width80   <= 1'b0;
      end
      else begin
	     if ( r_port30_we ) begin
		    r_width80   <=  r_data[0];
		    r_colormode <= ~r_data[1];
	     end
	     if ( r_crtc_we ) begin
		    if (r_adr) begin
			   if (r_data == 8'h00) r_seq   <= 3'd5;
			   if (r_data == 8'h80) r_ycurs <= 5'd31;
			   if (r_data == 8'h81) r_seq   <= 3'd7;
		    end
		    else begin
			   if (r_seq == 3'd3) r_lpc   <= r_data[3:0]; // r_lpc -> Line per Charactor. 7: 8ライン/文字  9: 10ライン/文字
			   if (r_seq == 3'd7) r_xcurs <= r_data[6:0];
			   if (r_seq == 3'd6) r_ycurs <= r_data[4:0];
			   if (r_seq) r_seq <= (r_seq == 3'd6) ? 0 : (r_seq - 3'd1);
		    end
	     end
      end // else: !if( I_RST )
      
   end // always @ (posedge I_CLK)



///////////////////////////////////////////////////////
/// DMA state
//////////////////////////////////////////////////////
   reg [ 3:0] r_state;
   reg [ 6:0] r_dma_dst_adr;
   reg [ 6:0] r_dma_trans_count;
   reg [ 6:0] r_dma_att_adr;

   wire       w_chlast = (w_vdotcnt == r_lpc);
   wire       w_dma_trans_count_end = (r_dma_trans_count ==  7'd119);
   wire       w_dma_trans_vram      = (r_dma_trans_count <   7'd 80);
   wire       w_dma_trans_attribute = (r_dma_trans_count >   7'd 79);

   // 水平期間中にDMA転送する
   // DMAのソース/ディストアドレスはVライン最終行(524)を指定する.
   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_state           <= 4'h0;
         O_RAM_ADR           <= 15'h0000;
         r_dma_dst_adr     <= 7'h00;
         r_dma_att_adr     <= 7'h00;
         r_dma_trans_count <= 7'h00;
      end
      else begin
	     if (r_state == 4'd0 & w_hcnt == 10'd648) begin
		    if (w_vcnt == 10'd524) begin
               O_RAM_ADR       <= 15'h7300;
            end
            if ((w_vcnt == 10'd524 | w_chlast)) begin
			   r_state <= 4'h1;
			   r_dma_dst_adr <= 7'h00;
               r_dma_att_adr <= 7'h00;
    	    end
	     end
         // DMA転送中
	     if (r_state == 4'h1 & r_busack) begin
            // 120バイトDMA転送したら終了
            if(w_dma_trans_count_end) begin
               r_dma_trans_count <= 7'h00;
               r_state <= 4'h0;
            end
            else begin
               r_dma_trans_count <= r_dma_trans_count + 7'h01;
            end
            // VideoRAM転送中
		    if(w_dma_trans_vram) begin
               r_dma_dst_adr <= r_dma_dst_adr + 7'h01;
            end
            // Attribute転送中
            else if (w_dma_trans_attribute) begin
               if(r_dma_trans_count[0]) r_dma_att_adr <= r_dma_att_adr + 7'h01;
            end
            O_RAM_ADR  <= O_RAM_ADR + 15'h0001;
	     end

	     O_BUSREQ <= (r_state != 4'h0);
      end // else: !if( I_RST )
   end // always @ (posedge I_CLK)


/////////////////////////////////////////////
// 文字数カウント
////////////////////////////////////////////
   reg [6:0] r_text_adr;
   reg [7:0] r_xcnt;

   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_text_adr <= 7'h00;
         r_xcnt     <= 8'h00;
      end
      else begin
         if (w_hcnt == 10'd648) begin
            r_text_adr <= 7'h00;
            r_xcnt     <= 8'h00;
         end
         else if (w_hdisp_en & w_hdotcnt[2:0] == 3'b111) begin
		    r_text_adr <= r_text_adr + 7'h01;
		    r_xcnt     <= r_xcnt + 8'h01;
	     end
      end
   end // always @ (posedge I_CLK)


////////////////////////////////////////
/// ONE-ROW Buffer
///////////////////////////////////////
   wire [ 6:0] w_rowbuf_adr = r_text_adr;
   wire [ 7:0] w_rowbuf_outdata;
   wire [ 7:0] w_rowbuf_indata;
   wire        w_rowbuf_we = ( (r_state == 4'h1) & r_busack & w_dma_trans_vram);

   reg  [ 6:0] r_attbuf_adr = 7'h00;
   reg  [15:0] r_attbuf_indata;
   wire [15:0] w_attbuf_outdata;
   wire        w_attbuf_we = ( (r_state == 4'h1) & r_busack & w_dma_trans_attribute);


   // VRAMテキストデータビット
   assign w_rowbuf_indata = (w_dma_trans_vram & (r_state == 4'h1) & r_busack) ? r_ram_data : 8'h00;

   // VRAMテキストバッファアドレス タイミング調整
   reg [ 6:0] r_dma_dst_adr_0;
   reg [ 6:0] r_dma_dst_adr_1;
   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_dma_dst_adr_0 <= 7'h00;
         r_dma_dst_adr_1 <= 7'h00;
      end
      else begin
         r_dma_dst_adr_0 <= r_dma_dst_adr;
         r_dma_dst_adr_1 <= r_dma_dst_adr_0;
      end
   end

   // VRAMテキストバッファWEのタイミング調整
   reg  r_rowbuf_we;
   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_rowbuf_we <= 1'b0;
      end
      else begin
         r_rowbuf_we <= w_rowbuf_we;
      end
   end


   // アトリビュートデータバッファWEのタイミング調整
   reg [ 4:0] r_attbuf_we;
   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_attbuf_we <= 5'h00;
      end
      else begin
         r_attbuf_we <= {r_attbuf_we[3:0], w_attbuf_we};
      end
   end

   // アトリビュートデータバッファアドレスのタイミング調整
   reg [ 6:0] r_dma_att_adr_0;
   reg [ 6:0] r_dma_att_adr_1;
   reg [ 6:0] r_dma_att_adr_2;
   reg [ 6:0] r_dma_att_adr_3;
   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_dma_att_adr_0 <= 7'h00;
         r_dma_att_adr_1 <= 7'h00;
         r_dma_att_adr_2 <= 7'h00;
         r_dma_att_adr_3 <= 7'h00;
      end
      else begin
         r_dma_att_adr_0 <= r_dma_att_adr;
         r_dma_att_adr_1 <= r_dma_att_adr_0;
         r_dma_att_adr_2 <= r_dma_att_adr_1;
         r_dma_att_adr_3 <= r_dma_att_adr_2;
      end
   end


   // アトリビュートデータ 8bit を 16bit(上位8bit:桁 下位8bit:属性)に変換
   reg [ 7:0]  r_att_1st_data;
   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_att_1st_data <= 8'h00;
      end
      else begin
         if(w_dma_trans_attribute & ~r_dma_trans_count[0]) begin
            r_att_1st_data <= r_ram_data;
         end
      end
   end

   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_attbuf_indata  <= 16'h0000;
      end
      else begin
         if(w_dma_trans_attribute & r_dma_trans_count[0]) begin
            r_attbuf_indata <= {r_att_1st_data , r_ram_data};
         end
      end
   end



   // メインRAMのVRAMエリアから転送される, テキスト＋アトリビュートのデータを
   // 別々のメモリへ保存する.
   alt_vram ROWBUF (
	.clock     ( I_CLK ),
	.wraddress ( { 2'b00, r_dma_dst_adr_1} ),
	.wren      ( r_rowbuf_we ),
	.data      ( w_rowbuf_indata ),
	.rdaddress ( { 2'b00, w_rowbuf_adr } ),
	.q         ( w_rowbuf_outdata )
	);

  alt_vram_attribute ATTRIBUTE (
	.clock     ( I_CLK ),
	.wraddress ( { 2'b00, r_dma_att_adr_3} ),
	.wren      ( r_attbuf_we[4] ),
	.data      ( r_attbuf_indata ),
	.rdaddress ( {2'b00, r_attbuf_adr} ),
	.q         ( w_attbuf_outdata )
	);

   wire [ 7:0] w_text_data;
   assign      w_text_data = w_rowbuf_outdata[7:0];



////////////////////////////////////////////
// Attribute
///////////////////////////////////////////
    reg [ 6:0] r_atr;
	reg [ 4:0] r_ycnt;

   wire [15:0] w_atr_data;
   assign      w_atr_data[15:8] = w_attbuf_outdata[15:8]; //何桁目の文字から属性付加するか.
   assign      w_atr_data[ 7:0] = w_attbuf_outdata[ 7:0]; //属性情報

   always @(posedge I_CLK or posedge I_RST) begin

      if ( I_RST ) begin
         r_attbuf_adr <= 7'h00;
         r_atr        <= 7'b1110000;
         r_ycnt       <= 5'h00;
      end
      else begin
	     if (w_hdisp_en & (w_hdotcnt[2:0] == 3'b110) & (w_atr_data[15:8] == r_xcnt)) begin

            // 描画桁とアトリビュート指定桁が一致したらアドレスを更新する.
            r_attbuf_adr <= r_attbuf_adr + 7'h01;

            // カラーモードの場合
		    if (r_colormode & w_atr_data[3]) begin
               r_atr[6:3] <= w_atr_data[7:4]; // 上位3bit,色指定. 下位1bitグラフィックorキャラクタ
            end
            // カラーモード,白黒共通
		    else begin
               r_atr[2:0] <= w_atr_data[2:0];   // リバース,ブリンク等の指定
            end
            // 白黒モードの場合
		    if (~r_colormode) begin
			   r_atr[6:3] <= { 3'b111, w_atr_data[7] }; // T/G
            end
	     end

	     if (w_hcnt == 10'd648) begin
		    if (w_vcnt == 10'd524) begin
			   r_attbuf_adr <= 7'h00;
			   r_ycnt       <= 5'h00;
		    end
		    else if (w_chlast) begin
			   r_attbuf_adr <= 7'h00;
			   r_ycnt       <= r_ycnt + 5'h01;
		    end
		    else begin
			   r_attbuf_adr <= 7'h00;
		    end
	     end // if (w_hcnt == 10'd648)
      end // else: !if( I_RST )
   end // always @ (posedge I_CLK)



///////////////////////////////////////
/// Charactor ROM
///////////////////////////////////////
   // H_CNTとV_CNTを文字とドットのカウンタとして分けて考える
   wire [ 6:0]                w_hchacnt = w_hcnt[ 9:3]; // 水平文字カウンタ
   wire [ 2:0]                w_hdotcnt = w_hcnt[ 2:0]; // 水平ドットカウンタ
   wire [ 4:0]                w_vchacnt = w_vcnt[ 8:4]; // 垂直文字カウンタ
   wire [ 3:0]                w_vdotcnt = w_vcnt[ 3:0]; // 垂直ドットカウンタ
   wire [ 7:0]                w_cgout;                  // 文字のドットデータ

   alt_cgrom_8x16 CGROM (
	                     .address ( {w_text_data, w_vdotcnt} ),
	                     .clock   ( I_CLK ),
	                     .q       ( w_cgout )
	                    );


///////////////////////////////////
// atribute adding
//////////////////////////////////
   wire                       w_dotl;
   wire                       w_dotr;
   wire [ 7:0]                w_graphic;
   reg [ 7:0]                 r_chrline;

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

   assign w_dotl = sel2(w_vdotcnt[2:1], w_rowbuf_outdata[3:0]);
   assign w_dotr = sel2(w_vdotcnt[2:1], w_rowbuf_outdata[7:4]);
   assign w_graphic = { w_dotl, w_dotl, w_dotl, w_dotl, w_dotr, w_dotr, w_dotr, w_dotr };


   reg r_qinh;
   reg r_qrev;
   reg r_qcurs;

   always @(posedge I_CLK or posedge I_RST ) begin
      if ( I_RST ) begin
         r_qinh    <= 1'b0;
         r_qrev    <= 1'b0;
         r_qcurs   <= 1'b0;
         color     <= 3'h0;
         r_chrline <= 8'h00;
      end
      else begin
	     if (w_hcnt[2:0] == 3'b111 & (r_width80 | ~w_hcnt[3])) begin
		    if (w_hdisp_en  & w_vdisp_en  & ~w_vdotcnt[3])begin
               r_chrline <= r_atr[3] ? w_graphic : w_cgout;
            end
		    else begin
               r_chrline <= 8'h00;
            end

           r_qinh  <= r_atr[0]  | (r_atr[1] & w_vcnt[6:5] == 2'b00);
		    r_qrev  <= r_atr[2]  & w_hdisp_en & w_vdisp_en;
//		    r_qcurs <= w_vcnt[6] & w_hdisp_en & (r_xcnt == r_xcurs) & (r_ycnt == r_ycurs);
		    r_qcurs <= w_hdisp_en & (r_xcnt == r_xcurs) & (r_ycnt == r_ycurs);
		    color   <= r_atr[6:4];

	     end
	     else begin
		    if (r_width80 | w_hdotcnt[0]) r_chrline <= {r_chrline[6:0],1'b0};
         end // else: !if(w_hcnt[2:0] == 3'b111 & (r_width80 | ~w_hcnt[3]))
      end // else: !if( I_RST )
   end



   // 水平,垂直イネーブル信号
   wire w_hdisp_en = (10'd6 <= w_hcnt && w_hcnt <= 10'd646);
   wire w_vdisp_en = (w_vcnt < 10'd400);

   // RGB出力信号生成
   always @( posedge I_CLK, posedge I_RST) begin
      if ( I_RST ) begin
        O_VGA_R <= 4'h0;
        O_VGA_G <= 4'h0;
        O_VGA_B <= 4'h0;
      end
      else begin
        O_VGA_R <= {4{w_hdisp_en & w_vdisp_en}} & {4{(r_chrline[7] & ~r_qinh)^r_qrev^r_qcurs}};
        O_VGA_G <= {4{w_hdisp_en & w_vdisp_en}} & {4{(r_chrline[7] & ~r_qinh)^r_qrev^r_qcurs}};
        O_VGA_B <= {4{w_hdisp_en & w_vdisp_en}} & {4{(r_chrline[7] & ~r_qinh)^r_qrev^r_qcurs}};
      end
   end // always @ ( posedge I_CLK, posedge I_RST)

endmodule // VGA



//**************************************************//
//*** E.O.F ***************************************//
//**************************************************//
