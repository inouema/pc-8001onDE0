//***************************************************************************************
// PC-8001 on the DE0 Altera CycloneIII version.
// Keyboard controller for PC-8001
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


module KEYBOARD(
           input             I_CLK,
           input             I_RST,
           input      [ 3:0] I_CPU_ADDR,
           input             I_CPU_IORQ,
           input             I_CPU_PORT00H,
           output reg [ 7:0] O_KB_DATA,
           inout             IO_PS2CLK,
           inout             IO_PS2DATA
           );

    /*
     * Z80からのIORQの立ち上がり/立ち下がり検出
     */
    wire w_cpu_iorq_fall;
    wire w_cpu_iorq_rise;
    reg [ 1:0] iorq_sreg;
    always @( posedge I_CLK or posedge I_RST ) begin
       if ( I_RST )
         iorq_sreg <= 2'b00;
       else
         iorq_sreg <= {iorq_sreg[0],I_CPU_IORQ};
    end

   assign w_cpu_iorq_fall =  iorq_sreg[1] & ~iorq_sreg[0];
   assign w_cpu_iorq_rise = ~iorq_sreg[1] &  iorq_sreg[0];

   /*
    * PS2モジュールからのValidを監視する
    */
   parameter P_PS2_ADDR_STATUS = 2'h0;
   parameter P_PS2_ADDR_READ   = 2'h1;

   wire [ 7:0] w_ps2_data;
   wire        w_ps2_valid = w_ps2_data[0];

   reg  [ 1:0] r_ps2_addr;
   reg         r_ps2_data_en;
   reg         r_ps2_write_en;
   reg  [ 7:0] r_ps2_write_data;
   reg  [ 2:0] r_ps2_state;

   always @(posedge I_CLK or posedge I_RST) begin
      if(I_RST) begin
         r_ps2_addr       <= P_PS2_ADDR_STATUS;
         r_ps2_write_en   <= 1'b0;
         r_ps2_write_data <= 8'h00;
         r_ps2_state      <= 3'h0;
         r_ps2_data_en    <= 1'b0;
      end
      // PS/2データがValidになったらReadアドレスを指定する.
      else if((r_ps2_state == 3'h0) && w_ps2_valid ) begin
         r_ps2_addr    <= P_PS2_ADDR_READ;
         r_ps2_data_en <= 1'b1;
         r_ps2_state   <= 3'h1;
      end
      //
      else if(r_ps2_state == 3'h1) begin
         r_ps2_data_en    <= 1'b0;
         r_ps2_addr       <= P_PS2_ADDR_STATUS;
         r_ps2_write_en   <= 1'b1;
         r_ps2_write_data <= 8'h00; // STATUSレジスタのvalidビットをクリアする.
         r_ps2_state      <= 3'h2;
      end
      else if(r_ps2_state == 3'h2) begin
         r_ps2_write_en <= 1'b0;
         r_ps2_state    <= 3'h0;
      end
   end // always @ (posedge I_CLK or posedge I_RST)




   /*
    * Z80に対してキーマトリクスコードを出力する.
    */
   parameter P_PS2_CODE_BREAK       = 8'hF0;
   parameter P_PS2_CODE_LEFT_SHIFT  = 8'h12;
   parameter P_PS2_CODE_KANA        = 8'h13;
   parameter P_PS2_CODE_CTRL        = 8'h14;
   parameter P_PS2_CODE_GRAPH       = 8'h11;

   reg  [ 7:0] r_kb_data;
   reg         r_kb_data_en;
   reg  [ 3:0] r_kb_addr;
   reg  [ 3:0] r_kb_status;
   reg  [ 3:0] r_kb_scan_cnt;
   reg         r_kb_break;
   reg         r_kb_shift;
   reg         r_kb_kana;
   reg         r_kb_ctrl;
   reg         r_kb_graph;

   wire [ 7:0] w_out_kb_data;


   always @(posedge I_CLK or posedge I_RST ) begin
      if (I_RST) begin
         r_kb_data     <= 8'h00;
         r_kb_addr     <= 4'hF;
         r_kb_status   <= 4'h0;
         r_kb_scan_cnt <= 4'h0;
         r_kb_break    <= 1'b0;
         r_kb_data_en  <= 1'b0;
         r_kb_shift    <= 1'b0;
         r_kb_kana     <= 1'b0;
         r_kb_ctrl     <= 1'b0;
         r_kb_graph    <= 1'b0;
      end
      // Shift,Kana,Ctrlはブレークコードがくるまで保持しブレークが来たらリリースする.
      else if ( r_ps2_data_en == 1'b1 ) begin
         if( w_kb_data[7:0] == P_PS2_CODE_BREAK ) begin
            r_kb_break <= 1'b1;
         end
         else if ( r_kb_break && r_kb_shift && (w_kb_data[7:0] == P_PS2_CODE_LEFT_SHIFT) ) begin
            r_kb_break <= 1'b0;
            r_kb_shift <= 1'b0;
         end
         else if ( r_kb_break && r_kb_kana  && (w_kb_data[7:0] == P_PS2_CODE_KANA) ) begin
            r_kb_break <= 1'b0;
            r_kb_kana  <= 1'b0;
         end
         else if ( r_kb_break && r_kb_ctrl  && (w_kb_data[7:0] == P_PS2_CODE_CTRL) ) begin
            r_kb_break <= 1'b0;
            r_kb_ctrl  <= 1'b0;
         end
         else if ( r_kb_break && r_kb_graph  && (w_kb_data[7:0] == P_PS2_CODE_GRAPH) ) begin
            r_kb_break <= 1'b0;
            r_kb_graph  <= 1'b0;
         end
         else if ( r_kb_break == 1'b1 ) begin
            r_kb_break <= 1'b0;
         end
         else if ( w_kb_data[7:0] == P_PS2_CODE_LEFT_SHIFT ) begin
            r_kb_shift <= 1'b1;
         end
         else if ( w_kb_data[7:0] == P_PS2_CODE_KANA ) begin
            r_kb_kana <= 1'b1;
         end
         else if ( w_kb_data[7:0] == P_PS2_CODE_CTRL ) begin
            r_kb_ctrl <= 1'b1;
         end
         else if ( w_kb_data[7:0] == P_PS2_CODE_GRAPH ) begin
            r_kb_graph <= 1'b1;
         end
         else if ( w_kb_data[15:0] == 16'hF000 ) begin //invalid data.
            r_kb_data_en <= 1'b0;
         end
         else begin
            r_kb_addr    <= w_kb_data[15:12];
            r_kb_status  <= w_kb_data[11: 8];
            r_kb_data    <= w_kb_data[ 7: 0];
            r_kb_data_en <= 1'b1;
         end
      end
      // CPUのキーボードスキャンタイミング
      else if( (r_kb_data_en == 1'b1) && w_cpu_iorq_rise && I_CPU_PORT00H) begin
         if( r_kb_scan_cnt == 4'hD ) begin
            r_kb_addr     <= 4'hF;
            r_kb_status   <= 4'h0;
            r_kb_data     <= 8'h00;
            r_kb_data_en  <= 1'b0;
            r_kb_scan_cnt <= 4'h0;
         end
         else begin
            r_kb_scan_cnt <= r_kb_scan_cnt + 4'h1;
         end
      end
   end // always @ (posedge I_CLK or posedge I_RST )

   /*
    * ヒットしたキーボードデータのテーブル番号と CPUのインプットアドレスが等しければデータ有効とする.
    */
   assign w_out_kb_data = ((I_CPU_ADDR == 4'h8) && (r_kb_shift     == 1'b1)) ? 8'h40 :
                          ((I_CPU_ADDR == 4'h8) && (r_kb_status[0] == 1'b1)) ? (8'h40 | r_kb_data) :
                          ((I_CPU_ADDR == 4'h8) && (r_kb_kana      == 1'b1)) ? 8'h20 :
                          ((I_CPU_ADDR == 4'h8) && (r_kb_graph     == 1'b1)) ? 8'h10 :
                          ((I_CPU_ADDR == 4'h8) && (r_kb_ctrl      == 1'b1)) ? 8'h80 :
                          ( I_CPU_ADDR == r_kb_addr ) ? r_kb_data : 8'h00;



   /*
    * Output Re-timing
    */
   always @(posedge I_CLK or posedge I_RST ) begin
      if (I_RST) begin
         O_KB_DATA <= 8'h00;
      end
      else begin
         O_KB_DATA <= w_out_kb_data;
      end
   end


   /**
    * @brief PS2 module
    */
   PS2 PS2 (
            .I_CLK      (I_CLK),
            .I_RST      (I_RST),
            .I_ADDR     (r_ps2_addr),
            .I_WRITE    (r_ps2_write_en),
            .I_WRDATA   (r_ps2_write_data),
            .O_RDDATA   (w_ps2_data),
            .IO_PS2CLK  (IO_PS2CLK),
            .IO_PS2DATA (IO_PS2DATA)
            );

   /**
    * @brief Keymap Data Table module
    */
   wire [11:0]                 w_keymap_data_1,w_keymap_data_2,w_keymap_data_3,
               w_keymap_data_4,w_keymap_data_5,w_keymap_data_6,w_keymap_data_7,
               w_keymap_data_8,w_keymap_data_9,w_keymap_data_10;

   KBTBL_1 KBTBL_1 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_1)
                );

   KBTBL_2 KBTBL_2 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_2)
                );

   KBTBL_3 KBTBL_3 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_3)
                );

   KBTBL_4 KBTBL_4 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_4)
                );

   KBTBL_5 KBTBL_5 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_5)
                );

   KBTBL_6 KBTBL_6 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_6)
                );

   KBTBL_7 KBTBL_7 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_7)
                );

   KBTBL_8 KBTBL_8 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_8)
                );

   KBTBL_9 KBTBL_9 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_9)
                );

   KBTBL_10 KBTBL_10 (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data_10)
                );

   wire [10:0]   w_keymap_en;
   assign        w_keymap_en[0]  = 1'b0;
   assign        w_keymap_en[1]  = | w_keymap_data_1;
   assign        w_keymap_en[2]  = | w_keymap_data_2;
   assign        w_keymap_en[3]  = | w_keymap_data_3;
   assign        w_keymap_en[4]  = | w_keymap_data_4;
   assign        w_keymap_en[5]  = | w_keymap_data_5;
   assign        w_keymap_en[6]  = | w_keymap_data_6;
   assign        w_keymap_en[7]  = | w_keymap_data_7;
   assign        w_keymap_en[8]  = | w_keymap_data_8;
   assign        w_keymap_en[9]  = | w_keymap_data_9;
   assign        w_keymap_en[10] = | w_keymap_data_10;

   /**
    * @brief Valid kb data selector.
    */
   function [15:0] f_kbtbldata_sel;

      input [10:0] en;
      input [11:0] kbdata_1;
      input [11:0] kbdata_2;
      input [11:0] kbdata_3;
      input [11:0] kbdata_4;
      input [11:0] kbdata_5;
      input [11:0] kbdata_6;
      input [11:0] kbdata_7;
      input [11:0] kbdata_8;
      input [11:0] kbdata_9;
      input [11:0] kbdata_10;

      case(en)
        11'b000_0000_0010 : f_kbtbldata_sel = {4'h1, kbdata_1};
        11'b000_0000_0100 : f_kbtbldata_sel = {4'h2, kbdata_2};
        11'b000_0000_1000 : f_kbtbldata_sel = {4'h3, kbdata_3};
        11'b000_0001_0000 : f_kbtbldata_sel = {4'h4, kbdata_4};
        11'b000_0010_0000 : f_kbtbldata_sel = {4'h5, kbdata_5};
        11'b000_0100_0000 : f_kbtbldata_sel = {4'h6, kbdata_6};
        11'b000_1000_0000 : f_kbtbldata_sel = {4'h7, kbdata_7};
        11'b001_0000_0000 : f_kbtbldata_sel = {4'h8, kbdata_8};
        11'b010_0000_0000 : f_kbtbldata_sel = {4'h9, kbdata_9};
        11'b100_0000_0000 : f_kbtbldata_sel = {4'hF, kbdata_10};
        default           : f_kbtbldata_sel = {4'hF, 12'h000};
      endcase // case(en)

   endfunction // f_kbtbldata_sel



   /*
    * w_kb_data仕様
    * b15 - b12 : ヒットしたキーボードのテーブル番号
    * b11 : Reserve
    * b10 : Reserve
    * b 9 : Reserve
    * b 8 : 強制 Shift Key Enable
    * b 7 - b0 : PC-8001のマトリックスキーに対応したデータ
    */
   wire [15:0]  w_kb_data;
   assign w_kb_data = f_kbtbldata_sel (
                                        w_keymap_en,
                                        w_keymap_data_1,
                                        w_keymap_data_2,
                                        w_keymap_data_3,
                                        w_keymap_data_4,
                                        w_keymap_data_5,
                                        w_keymap_data_6,
                                        w_keymap_data_7,
                                        w_keymap_data_8,
                                        w_keymap_data_9,
                                        w_keymap_data_10
                                      );

endmodule // KEYBOARD


module KBTBL_1 (I_PS2_DATA, O_KB_DATA);

  parameter _enter    = 8'h5A;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
          case (I_PS2_DATA)
              _enter :    O_KB_DATA <= 12'b0000_10000000;
              default :   O_KB_DATA <= 12'b0000_00000000;
          endcase // case(I_PS2_DATA)
   end // always @ *

endmodule // kbtbldata



module KBTBL_2 (I_PS2_DATA, O_KB_DATA);

   parameter _atmark = 8'h54;
   parameter _A = 8'h1C;
   parameter _B = 8'h32;
   parameter _C = 8'h21;
   parameter _D = 8'h23;
   parameter _E = 8'h24;
   parameter _F = 8'h2B;
   parameter _G = 8'h34;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _atmark : O_KB_DATA <= 12'b0000_00000001;
        _A      : O_KB_DATA <= 12'b0000_00000010;
        _B      : O_KB_DATA <= 12'b0000_00000100;
        _C      : O_KB_DATA <= 12'b0000_00001000;
        _D      : O_KB_DATA <= 12'b0000_00010000;
        _E      : O_KB_DATA <= 12'b0000_00100000;
        _F      : O_KB_DATA <= 12'b0000_01000000;
        _G      : O_KB_DATA <= 12'b0000_10000000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata



module KBTBL_3 (I_PS2_DATA, O_KB_DATA);

   parameter _H = 8'h33;
   parameter _I = 8'h43;
   parameter _J = 8'h3B;
   parameter _K = 8'h42;
   parameter _L = 8'h4B;
   parameter _M = 8'h3A;
   parameter _N = 8'h31;
   parameter _O = 8'h44;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _H : O_KB_DATA <= 12'b0000_00000001;
        _I : O_KB_DATA <= 12'b0000_00000010;
        _J : O_KB_DATA <= 12'b0000_00000100;
        _K : O_KB_DATA <= 12'b0000_00001000;
        _L : O_KB_DATA <= 12'b0000_00010000;
        _M : O_KB_DATA <= 12'b0000_00100000;
        _N : O_KB_DATA <= 12'b0000_01000000;
        _O : O_KB_DATA <= 12'b0000_10000000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata



module KBTBL_4 (I_PS2_DATA, O_KB_DATA);

   parameter _P = 8'h4D;
   parameter _Q = 8'h15;
   parameter _R = 8'h2D;
   parameter _S = 8'h1B;
   parameter _T = 8'h2C;
   parameter _U = 8'h3C;
   parameter _V = 8'h2A;
   parameter _W = 8'h1D;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _P : O_KB_DATA <= 12'b0000_00000001;
        _Q : O_KB_DATA <= 12'b0000_00000010;
        _R : O_KB_DATA <= 12'b0000_00000100;
        _S : O_KB_DATA <= 12'b0000_00001000;
        _T : O_KB_DATA <= 12'b0000_00010000;
        _U : O_KB_DATA <= 12'b0000_00100000;
        _V : O_KB_DATA <= 12'b0000_01000000;
        _W : O_KB_DATA <= 12'b0000_10000000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata



module KBTBL_5 (I_PS2_DATA, O_KB_DATA);

   parameter _X = 8'h22;
   parameter _Y = 8'h35;
   parameter _Z = 8'h1A;
   parameter _leftbracket  = 8'h5B;
   parameter _yen          = 8'h6A;
   parameter _rightbracket = 8'h5D;
   parameter _oyobi        = 8'h55; // is -> "^"
   parameter _hyphen       = 8'h4E;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _X :            O_KB_DATA <= 12'b0000_00000001;
        _Y :            O_KB_DATA <= 12'b0000_00000010;
        _Z :            O_KB_DATA <= 12'b0000_00000100;
        _leftbracket :  O_KB_DATA <= 12'b0000_00001000;
        _yen :          O_KB_DATA <= 12'b0000_00010000;
        _rightbracket : O_KB_DATA <= 12'b0000_00100000;
        _oyobi :        O_KB_DATA <= 12'b0000_01000000;
        _hyphen :       O_KB_DATA <= 12'b0000_10000000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata




module KBTBL_6 (I_PS2_DATA, O_KB_DATA);

   parameter _0 = 8'h45;
   parameter _1 = 8'h16;
   parameter _2 = 8'h1E;
   parameter _3 = 8'h26;
   parameter _4 = 8'h25;
   parameter _5 = 8'h2E;
   parameter _6 = 8'h36;
   parameter _7 = 8'h3D;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _0 : O_KB_DATA <= 12'b0000_00000001;
        _1 : O_KB_DATA <= 12'b0000_00000010;
        _2 : O_KB_DATA <= 12'b0000_00000100;
        _3 : O_KB_DATA <= 12'b0000_00001000;
        _4 : O_KB_DATA <= 12'b0000_00010000;
        _5 : O_KB_DATA <= 12'b0000_00100000;
        _6 : O_KB_DATA <= 12'b0000_01000000;
        _7 : O_KB_DATA <= 12'b0000_10000000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata



module KBTBL_7 (I_PS2_DATA, O_KB_DATA);

   parameter _8          = 8'h3E;
   parameter _9          = 8'h46;
   parameter _colon      = 8'h52;
   parameter _semicolon  = 8'h4C;
   parameter _comma      = 8'h41;
   parameter _dot        = 8'h49;
   parameter _slash      = 8'h4A;
   parameter _back_slash = 8'h51;

   input      [ 7:0] I_PS2_DATA;
   output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _8          : O_KB_DATA <= 12'b0000_00000001;
        _9          : O_KB_DATA <= 12'b0000_00000010;
        _colon      : O_KB_DATA <= 12'b0000_00000100;
        _semicolon  : O_KB_DATA <= 12'b0000_00001000;
        _comma      : O_KB_DATA <= 12'b0000_00010000;
        _dot        : O_KB_DATA <= 12'b0000_00100000;
        _slash      : O_KB_DATA <= 12'b0000_01000000;
        _back_slash : O_KB_DATA <= 12'b0000_10000000;
        default     : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata


module KBTBL_8 (I_PS2_DATA, O_KB_DATA);

  parameter _home  = 8'h6C; // and "CLR" key
  parameter _up    = 8'h75;
  parameter _down  = 8'h72;
  parameter _right = 8'h74;
  parameter _left  = 8'h6B;
  parameter _ins   = 8'h70;
  parameter _del   = 8'h71;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _home  : O_KB_DATA <= 12'b0000_00000001;
        _up    : O_KB_DATA <= 12'b0000_00000010;
        _down  : O_KB_DATA <= 12'b0001_00000010;
        _right : O_KB_DATA <= 12'b0000_00000100;
        _left  : O_KB_DATA <= 12'b0001_00000100;
        _ins   : O_KB_DATA <= 12'b0001_00001000;
        _del   : O_KB_DATA <= 12'b0000_00001000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata


module KBTBL_9 (I_PS2_DATA, O_KB_DATA);

   parameter _stop  = 8'h77; // Pause
   parameter _f1    = 8'h05;
   parameter _f2    = 8'h06;
   parameter _f3    = 8'h04;
   parameter _f4    = 8'h0C;
   parameter _f5    = 8'h03;
   parameter _space = 8'h29;
   parameter _esc   = 8'h76;

  input      [ 7:0] I_PS2_DATA;
  output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _stop  : O_KB_DATA  <= 12'b0000_00000001;
        _f1    : O_KB_DATA  <= 12'b0000_00000010;
        _f2    : O_KB_DATA  <= 12'b0000_00000100;
        _f3    : O_KB_DATA  <= 12'b0000_00001000;
        _f4    : O_KB_DATA  <= 12'b0000_00010000;
        _f5    : O_KB_DATA  <= 12'b0000_00100000;
        _space : O_KB_DATA  <= 12'b0000_01000000;
        _esc   : O_KB_DATA  <= 12'b0000_10000000;
        default : O_KB_DATA <= 12'b0000_00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata



/**
 * @brief  機能,ファンクション キーコードデコード
 * @detail PS/2スキャンコードのデータをそのままデコードする.
 */
module KBTBL_10 (I_PS2_DATA, O_KB_DATA);

   parameter _break       = 8'hF0;
   parameter _left_shift  = 8'h12;
   parameter _kana        = 8'h13;
   parameter _left_ctrl   = 8'h14;
   parameter _graph       = 8'h11; // PS/2キーボードには"GRAPH"キーは無いので左Altに割り当てる.

   input      [ 7:0] I_PS2_DATA;
   output reg [11:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _break       : O_KB_DATA <= 12'h0_F0;
        _left_shift  : O_KB_DATA <= 12'h0_12;
        _kana        : O_KB_DATA <= 12'h0_13;
        _left_ctrl   : O_KB_DATA <= 12'h0_14;
        _graph       : O_KB_DATA <= 12'h0_11;
        default      : O_KB_DATA <= 12'h0_00;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata



//**************************************************//
//*** E.O.F ***************************************//
//**************************************************//

