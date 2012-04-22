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
/// H/V Sync Genelator
///////////////////////////////////////

   wire [ 9:0] w_hcnt;
   wire [ 9:0] w_vcnt;
   wire        w_hsync;
   wire        w_vsync;

   HVGEN HVGEN (
              .I_CLK(I_CLK),
              .I_RST(I_RST),
              .O_HS(w_hsync),
              .O_VS(w_vsync),
              .O_H_CNT(w_hcnt),
              .O_V_CNT(w_vcnt)
              );

   // ����,�����C�l�[�u���M��
// wire w_hdisp_en = (10'd6 <= w_hcnt && w_hcnt <= 10'd646);
   wire w_hdisp_en = (10'd0 <= w_hcnt && w_hcnt < 10'd640);
   wire w_vdisp_en = (w_vcnt < 10'd400);



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
			   if (r_seq == 3'd3) r_lpc   <= r_data[3:0]; // r_lpc -> Line per Charactor. 7: 8���C��/����  9: 10���C��/����
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

   // �������Ԓ���DMA�]������
   // DMA�̃\�[�X/�f�B�X�g�A�h���X��V���C���ŏI�s(524)���w�肷��.
   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_state           <= 4'h0;
         O_RAM_ADR         <= 15'h0000;
         r_dma_dst_adr     <= 7'h00;
         r_dma_att_adr     <= 7'h00;
         r_dma_trans_count <= 7'h00;
      end
      else begin
//	     if (r_state == 4'd0 & w_hcnt == 10'd648) begin // AAAAA
	     if (r_state == 4'd0 & w_hcnt == 10'd639) begin
		    if (w_vcnt == 10'd524) begin
               O_RAM_ADR       <= 15'h7300;
            end
            if ((w_vcnt == 10'd524 | w_chlast)) begin
			   r_state <= 4'h1;
			   r_dma_dst_adr <= 7'h00;
               r_dma_att_adr <= 7'h00;
    	    end
	     end
         // DMA�]����
	     if (r_state == 4'h1 & r_busack) begin
            // 120�o�C�gDMA�]��������I��
            if(w_dma_trans_count_end) begin
               r_dma_trans_count <= 7'h00;
               r_state <= 4'h0;
            end
            else begin
               r_dma_trans_count <= r_dma_trans_count + 7'h01;
            end
            // VideoRAM�]����
		    if(w_dma_trans_vram) begin
               r_dma_dst_adr <= r_dma_dst_adr + 7'h01;
            end
            // Attribute�]����
            else if (w_dma_trans_attribute) begin
               if(r_dma_trans_count[0]) r_dma_att_adr <= r_dma_att_adr + 7'h01;
            end
            O_RAM_ADR  <= O_RAM_ADR + 15'h0001;
	     end

	     O_BUSREQ <= (r_state != 4'h0);
      end // else: !if( I_RST )
   end // always @ (posedge I_CLK)


/////////////////////////////////////////////
// �������J�E���g
////////////////////////////////////////////
   reg [6:0] r_text_adr;
   reg [7:0] r_xcnt;

   always @(posedge I_CLK or posedge I_RST) begin
      if ( I_RST ) begin
         r_text_adr <= 7'h00;
         r_xcnt     <= 8'h00;
      end
      else begin
//         if (w_hcnt == 10'd648) begin // AAAAA
         if (w_hcnt == 10'd639) begin
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



   // VRAM�e�L�X�g�o�b�t�@�A�h���X �^�C�~���O����
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

   // VRAM�e�L�X�g�o�b�t�@WE�̃^�C�~���O����
   reg [1:0] r_rowbuf_we;
   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_rowbuf_we <= 2'h0;
      end
      else begin
         r_rowbuf_we <= {r_rowbuf_we[0], w_rowbuf_we};
      end
   end

   // VRAM�e�L�X�g�f�[�^�r�b�g
//   assign w_rowbuf_indata = (w_dma_trans_vram & (r_state == 4'h1) & r_busack & r_rowbuf_we[1]) ? r_ram_data : 8'h00;
   assign w_rowbuf_indata = (r_rowbuf_we[1]) ? r_ram_data : 8'h00;


   // �A�g���r���[�g�f�[�^�o�b�t�@WE�̃^�C�~���O����
   reg [ 3:0] r_attbuf_we;
   always @(posedge I_CLK or posedge I_RST) begin
      if( I_RST ) begin
         r_attbuf_we <= 4'h0;
      end
      else begin
         r_attbuf_we <= {r_attbuf_we[2:0], w_attbuf_we};
      end
   end

   // �A�g���r���[�g�f�[�^�o�b�t�@�A�h���X�̃^�C�~���O����
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


   // �A�g���r���[�g�f�[�^ 8bit �� 16bit(���8bit:�� ����8bit:����)�ɕϊ�
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



   // ���C��RAM��VRAM�G���A����]�������, �e�L�X�g�{�A�g���r���[�g�̃f�[�^��
   // �ʁX�̃������֕ۑ�����.
   alt_vram ROWBUF (
	.clock     ( I_CLK ),
	.wraddress ( { 2'b00, r_dma_dst_adr_1} ),
	.wren      ( r_rowbuf_we[1] ),
	.data      ( w_rowbuf_indata ),
	.rdaddress ( { 2'b00, w_rowbuf_adr } ),
	.q         ( w_rowbuf_outdata )
	);

  alt_vram_attribute ATTRIBUTE (
	.clock     ( I_CLK ),
	.wraddress ( { 2'b00, r_dma_att_adr_3} ),
	.wren      ( r_attbuf_we[3] ),
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
	assign      w_atr_data[15:8] = w_attbuf_outdata[15:8]; //�����ڂ̕������瑮���t�����邩.
	assign      w_atr_data[ 7:0] = w_attbuf_outdata[ 7:0]; //�������

   wire        w_atr_color_en;
   assign      w_atr_color_en = (r_colormode & w_atr_data[3]);

   always @(posedge I_CLK or posedge I_RST) begin

      if ( I_RST ) begin
         r_attbuf_adr <= 7'h00;
         r_atr        <= 7'b1110000;
         r_ycnt       <= 5'h00;
      end
      else begin
	     if (w_hdisp_en & (w_hdotcnt[2:0] == 3'b110) & (w_atr_data[15:8] == r_xcnt)) begin

            // �`�挅�ƃA�g���r���[�g�w�茅����v������A�h���X���X�V����.
            r_attbuf_adr <= r_attbuf_adr + 7'h01;

            // �J���[���[�h�̏ꍇ
		    if(w_atr_color_en) begin
               r_atr[6:3] <= w_atr_data[7:4]; // ���3bit,�F�w��(MSB����G/R/B). ����1bit�O���t�B�b�Nor�L�����N�^
            end
            // �������[�h�̏ꍇ
		    if(~r_colormode) begin
			   r_atr[6:3] <= { 3'b111, w_atr_data[7] }; // T/G
            end
            // �J���[���[�h,��������
            r_atr[2:0] <= w_atr_data[2:0];   // ���o�[�X,�u�����N,�V�[�N���b�g
	     end

//	     if (w_hcnt == 10'd648) begin // AAAAA
	     if (w_hcnt == 10'd639) begin
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
   // H_CNT��V_CNT�𕶎��ƃh�b�g�̃J�E���^�Ƃ��ĕ����čl����
   wire [ 6:0]                w_hchacnt = w_hcnt[ 9:3]; // ���������J�E���^
   wire [ 2:0]                w_hdotcnt = w_hcnt[ 2:0]; // �����h�b�g�J�E���^
// wire [ 4:0]                w_vchacnt = w_vcnt[ 8:4]; // ���������J�E���^
   wire [ 3:0]                w_vdotcnt = w_vcnt[ 3:0]; // �����h�b�g�J�E���^
   wire [ 7:0]                w_cgout;                  // �����̃h�b�g�f�[�^

`ifdef NO_USE
   alt_cgrom_8x16 CGROM (
	                     .address ( {w_text_data, w_vdotcnt} ),
	                     .clock   ( I_CLK ),
	                     .q       ( w_cgout )
	                    );
`endif
   cgrom CGROM (
                .clk(I_CLK),
                .adr( {w_text_data, w_vdotcnt[2:0]} ),
                .data (w_cgout)
                );

///////////////////////////////////
// atribute adding
//////////////////////////////////

   /*
    * �O���t�B�b�N�`��
    */
   wire        w_dotl;
   wire        w_dotr;
   wire [ 7:0] w_graphic;

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


   /*
    * �A�g���r���[�g�t��
    */
   reg       r_qinh;
   reg       r_qrev;
   reg       r_qcurs;
   reg [2:0] r_color;
   reg [7:0] r_chrline;

   always @(posedge I_CLK or posedge I_RST ) begin
      if ( I_RST ) begin
         r_qinh    <= 1'b0;
         r_qrev    <= 1'b0;
         r_qcurs   <= 1'b0;
         r_color   <= 3'b111;
         r_chrline <= 8'h00;
      end
      else begin
	     if (w_hcnt[2:0] == 3'b111 & (r_width80 | ~w_hcnt[3])) begin
            // ~w_vdotcnt[3]�����邱�Ƃ� 10line/�����ł�9,10�Ԗڂ̓}�X�N�����̂ŕ\������Ȃ�.
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
		    r_color <= r_atr[6:4];

	     end
	     else begin
		    if (r_width80 | w_hdotcnt[0]) r_chrline <= {r_chrline[6:0],1'b0};
         end // else: !if(w_hcnt[2:0] == 3'b111 & (r_width80 | ~w_hcnt[3]))
      end // else: !if( I_RST )
   end



   /*
    * �o�̓^�C�~���O����
    */
   // RGB�o�̓f�[�^�^�C�~���O�ɍ��킹��H/Vsync�𒲐�����.
   reg [ 7:0] r_vga_hs;
   reg [ 7:0] r_vga_vs;

   always @( posedge I_CLK or posedge I_RST) begin
      if(I_RST) begin
         r_vga_hs <= 8'h00;
         r_vga_hs <= 8'h00;
      end
      else begin
         r_vga_hs <= {r_vga_hs[6:0], w_hsync};
         r_vga_vs <= {r_vga_vs[6:0], w_vsync};
      end
   end

   assign O_VGA_HS = r_vga_hs[7];
   assign O_VGA_VS = r_vga_vs[7];

   // RGB�o�̓f�[�^�^�C�~���O�ɍ��킹�ĕ\���͈͂𒲐�����.
   reg [ 7:0] r_hdisp_en;
   reg [ 7:0] r_vdisp_en;

   always @( posedge I_CLK or posedge I_RST) begin
      if(I_RST) begin
         r_hdisp_en <= 8'h00;
         r_vdisp_en <= 8'h00;
      end
      else begin
         r_hdisp_en <= {r_hdisp_en[ 6:0], w_hdisp_en};
         r_vdisp_en <= {r_vdisp_en[ 6:0], w_vdisp_en};
      end
   end

   // R/G/B�������
   wire   w_green_en;
   wire   w_red_en;
   wire   w_blue_en;

   assign w_green_en = (r_colormode) ? r_color[2] : 1'b1;
   assign w_red_en   = (r_colormode) ? r_color[1] : 1'b1;
   assign w_blue_en  = (r_colormode) ? r_color[0] : 1'b1;

   // RGB�o�͐M������
   always @( posedge I_CLK, posedge I_RST) begin
      if ( I_RST ) begin
        O_VGA_G <= 4'h0;
        O_VGA_R <= 4'h0;
        O_VGA_B <= 4'h0;
      end
`ifdef VGA_CHECK
      else if( w_hcnt == 10'd319 || w_hcnt == 10'd639 || w_hcnt == 10'd0) begin
        O_VGA_G <= {4{r_hdisp_en[7] & r_vdisp_en[7]}} & {4{w_hcnt == 10'd319}};
        O_VGA_R <= {4{r_hdisp_en[7] & r_vdisp_en[7]}} & {4{w_hcnt == 10'd639}};
        O_VGA_B <= {4{r_hdisp_en[7] & r_vdisp_en[7]}} & {4{w_hcnt == 10'd0}};
      end // else: !if( I_RST )
`endif
     else begin
        O_VGA_G <= {4{r_hdisp_en[7] & r_vdisp_en[7]}} & {4{(r_chrline[7] & ~r_qinh)^r_qrev^r_qcurs}} & {4{w_green_en}};
        O_VGA_R <= {4{r_hdisp_en[7] & r_vdisp_en[7]}} & {4{(r_chrline[7] & ~r_qinh)^r_qrev^r_qcurs}} & {4{w_red_en}};
        O_VGA_B <= {4{r_hdisp_en[7] & r_vdisp_en[7]}} & {4{(r_chrline[7] & ~r_qinh)^r_qrev^r_qcurs}} & {4{w_blue_en}};
     end // else: !if( I_RST )
   end // always @ ( posedge I_CLK, posedge I_RST)




endmodule // VGA



//**************************************************//
//*** E.O.F ***************************************//
//**************************************************//
