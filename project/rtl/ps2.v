//***************************************************************************************
// PC-8001 on the DE0 Altera CycloneIII version.
// PS2 controller
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

module PS2(
           input         I_CLK,
           input         I_RST,
           input  [ 1:0] I_ADDR,
           input         I_WRITE,
           input  [ 7:0] I_WRDATA,
           output [ 7:0] O_RDDATA,
           inout         IO_PS2CLK,
           inout         IO_PS2DATA
           //output reg    O_LOGCLK
           );

   reg [ 9:0]     sft;
   reg [ 7:0]     ps2rdata;
   reg            empty;
   reg            valid;

   parameter      HALT    = 3'h0;
   parameter      CLKLOW  = 3'h1;
   parameter      STBIT   = 3'h2;
   parameter      SENDBIT = 3'h3;
   parameter      WAITCLK = 3'h4;
   parameter      GETBIT  = 3'h5;
   parameter      SETFLG  = 3'h6;

   reg [ 2:0]     cur;
   reg [ 2:0]     nxt;



   // 送信時のシフトレジスタ書き込み信号
   wire           txregwr = (I_ADDR==2'h2) & I_WRITE;

   // レジスタ読み出し
   assign         O_RDDATA = (I_ADDR==2'h0) ? {6'b0, empty, valid} : ps2rdata;

   // PS2CLK ハザード防止
   reg            ps2clken;

   always @( posedge I_CLK or posedge I_RST ) begin
      if ( I_RST )
        ps2clken <= 1'b0;
      else
        ps2clken <= (cur==CLKLOW || cur==STBIT);
   end

   // PS2 出力
   assign IO_PS2CLK  = (ps2clken) ? 1'b0 : 1'bz;
   assign IO_PS2DATA = (cur==SENDBIT || cur==STBIT) ? sft[0]:1'bz;
   

// スタートビット送出時100us時計用カウンタ
   reg [12:0] txcnt;

//   parameter  TXMAX=13'd2500; // 1/25MHz x 2500 = 100us
   parameter  TXMAX=13'd2000; // 1/25MHz x 2000 = 80us
   wire       over100us = (txcnt==TXMAX-1);

   always @( posedge I_CLK or posedge I_RST) begin
      if (I_RST)
        txcnt <= 13'h0000;
      else if ( cur==HALT)
        txcnt <= 13'h0000;
      else if (over100us)
        txcnt <= 13'h0000;
      else
        txcnt <= txcnt + 13'h1;
   end

// 受信したPS2CLKの立下り検出および同期化
   reg [ 2:0] sreg;
   wire       clkfall;

   always @( posedge I_CLK or posedge I_RST) begin
      if ( I_RST )
        sreg <= 3'b000;
      else
        sreg <= {sreg[1:0], IO_PS2CLK};
   end

   assign clkfall = sreg[2] & ~sreg[1];

// 送受信ビット数カウンタ
   reg [ 3:0] bitcnt;

   always @(posedge I_CLK or posedge I_RST) begin
      if (I_RST)
        bitcnt <= 4'h0;
      else if ( cur == HALT )
        bitcnt <= 4'h0;
      else if ( (cur==SENDBIT || cur==GETBIT) & clkfall )
        bitcnt <= bitcnt + 4'h1;
   end

// ステートマシン
   always @( posedge I_CLK or posedge I_RST ) begin
      if ( I_RST )
        cur <= HALT;
      else
        cur <= nxt;
   end

   always @* begin
      case (cur)
        HALT:    if (txregwr)
                     nxt <= CLKLOW;
                 else if ( (IO_PS2DATA==1'b0) & clkfall)
                     nxt <= GETBIT;
                 else
                     nxt <= HALT;
        CLKLOW:  if( over100us)
                     nxt <= STBIT;
                 else
                     nxt <= CLKLOW;
        STBIT:   if( over100us )
                     nxt <= SENDBIT;
                 else
                     nxt <= STBIT;
        SENDBIT: if( (bitcnt==4'h9) & clkfall )
                     nxt <= WAITCLK;
                 else
                     nxt <= SENDBIT;
        WAITCLK: if( clkfall )
                     nxt <= HALT;
                 else
                     nxt <= WAITCLK;
        GETBIT:  if ( (bitcnt==4'h7) & clkfall )
                     nxt <= SETFLG;
                 else
                     nxt <= GETBIT;
        SETFLG:  if (clkfall)
                     nxt <= WAITCLK;
                 else
                 nxt <= SETFLG;
        default:
                 nxt <= HALT;
      endcase // case(cur)
   end // always @ *


// emptyフラグ(受信中も非empty)
   always @( posedge I_CLK or posedge I_RST ) begin
      if (I_RST)
        empty <= 1'b1;
      else
        empty <= (cur==HALT) ? 1'b1 : 1'b0;
   end

   // 受信データ有効フラグ
   always @(posedge I_CLK or posedge I_RST ) begin
      if ( I_RST )
        valid <= 1'b0;
      else if ( (I_ADDR==2'h0) & I_WRITE )
        valid <= I_WRDATA[0];
      else if ( cur==SETFLG & clkfall )
        valid <= 1'b1;
   end

   // シフトレジスタ
   always @( posedge I_CLK or posedge I_RST ) begin
      if ( I_RST )
        sft <= 10'h000;
      else if ( txregwr )
        sft <= { ~(^I_WRDATA),I_WRDATA,1'b0};
      else if ( cur==SENDBIT & clkfall )
        sft <= {1'b1, sft[9:1]};
      else if ( cur==GETBIT & clkfall )
        sft <= {IO_PS2DATA, sft[9:1]};
   end

   // 受信データ
   always @( posedge I_CLK or posedge I_RST ) begin
      if ( I_RST )
        ps2rdata <= 8'h00;
      else if ( cur==SETFLG & clkfall )
        ps2rdata <= sft[9:2];
   end

endmodule // PS2


   
//***************************************************************************************
// E.O.F
//***************************************************************************************
