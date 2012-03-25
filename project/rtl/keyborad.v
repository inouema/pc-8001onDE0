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
           output     [ 7:0] O_KB_DATA,
           inout             IO_PS2CLK,
           inout             IO_PS2DATA
           );

    /*
     * Z80からのIORQの立下り検出
     */
    wire w_cpu_iorq_fall;
    reg [ 2:0] sreg;
    always @( posedge I_CLK or posedge I_RST ) begin
       if ( I_RST )
         sreg <= 3'b000;
       else
         sreg <= {sreg[1:0],I_CPU_IORQ};
    end

   assign w_cpu_iorq_fall = sreg[2] & ~sreg[1];

   /**
    * PS2モジュールのValidを判断して,データを受信する.
    * IORQ終了時は O_KB_DATA をリセットする.
    */
   wire [ 7:0] w_ps2_data;
   wire  w_ps2_valid = w_ps2_data[0];
   reg  [ 1:0] r_ps2_addr;
   reg         r_ps2_write_en;
   reg  [ 7:0] r_ps2_write_data;
   reg  [ 1:0] r_state;
   reg  [ 7:0] r_kb_data;

   always @(posedge I_CLK or posedge I_RST ) begin
      if (I_RST) begin
         r_kb_data        <= 8'h00;
         r_ps2_addr       <= 2'h0;
         r_ps2_write_en   <= 1'b0;
         r_ps2_write_data <= 8'h00;
         r_state          <= 2'h0;
      end
      else if(w_ps2_valid && (r_state == 2'h0)) begin
         r_ps2_addr <= 2'h1; // PS2 READ アドレスを指定
         r_state    <= 2'h1;
      end
      else if(r_state == 2'h1) begin
         r_kb_data        <= w_keymap_data;
         r_ps2_addr       <= 2'h0;  // PS2 STATUS アドレスに戻す.
         r_ps2_write_en   <= 1'b1;
         r_ps2_write_data <= 8'h02; // validレジスタをクリアする.
         r_state          <= 2'h2;
      end
      else if(r_state == 2'h2) begin
         r_kb_data      <= r_kb_data; // CPUのキーボードスキャンタイミングまで保持
         r_ps2_write_en <= 1'b0;
         r_state        <= 2'h3;
      end
      else if(w_cpu_iorq_fall && (r_state == 2'h3) && I_CPU_PORT00H) begin
         r_kb_data <= 8'h00;
         r_state   <= 2'h0;
      end
   end // always @ (posedge I_CLK or posedge I_RST )


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
   wire [ 7:0] w_keymap_data;
   KBTBL KBTBL (
                .I_PS2_DATA (w_ps2_data),
                .O_KB_DATA  (w_keymap_data)
                );


   /**
    * @brief Address decoder.
    */
   function [ 7:0] f_kbtbldata_sel;
      input [ 3:0] addr;
      input [ 7:0] kbdata_0;

      case(addr)
        4'b0000 : f_kbtbldata_sel = kbdata_0;
        default : f_kbtbldata_sel = 8'h00;
      endcase // case(addr)
   endfunction // f_kbtbldata_sel

// assign w_kb_data = f_kbtbldata_sel (I_CPU_ADDR, w_keymap_data);
   assign O_KB_DATA = f_kbtbldata_sel (I_CPU_ADDR, r_kb_data);

endmodule // KEYBOARD



module KBTBL (I_PS2_DATA, O_KB_DATA);

   parameter _0 = 8'h45;
   parameter _1 = 8'h16;
   parameter _2 = 8'h1E;
   parameter _3 = 8'h26;
   parameter _4 = 8'h25;
   parameter _5 = 8'h2E;
   parameter _6 = 8'h36;
   parameter _7 = 8'h3D;
  
  input      [ 7:0] I_PS2_DATA;
  output reg [ 7:0] O_KB_DATA;

   always @* begin
      case (I_PS2_DATA)
        _0 : O_KB_DATA <= 8'b00000001;
        _1 : O_KB_DATA <= 8'b00000010;
        _2 : O_KB_DATA <= 8'b00000100;
        _3 : O_KB_DATA <= 8'b00001000;
        _4 : O_KB_DATA <= 8'b00010000;
        _5 : O_KB_DATA <= 8'b00100000;
        _6 : O_KB_DATA <= 8'b01000000;
        _7 : O_KB_DATA <= 8'b10000000;
        default : O_KB_DATA <= 8'b00000000;
      endcase // case(I_PS2_DATA)
   end // always @ *
endmodule // kbtbldata


//**************************************************//
//*** E.O.F ***************************************//
//**************************************************//

