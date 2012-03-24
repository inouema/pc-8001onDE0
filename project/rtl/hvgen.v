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

module HVGEN (
              input             I_CLK, // 25MHz
              input             I_RST, // High Active
              output reg        O_HS,
              output reg        O_VS,
              output reg [ 9:0] O_H_CNT,
              output reg [ 9:0] O_V_CNT
              );

   // 水平カウンタ
   parameter         HMAX = 800;
   wire              hcntend = (O_H_CNT == HMAX-10'h001);

   always @ (posedge I_CLK, posedge I_RST) begin
      if ( I_RST )
        O_H_CNT <= 10'h000;
      else if(hcntend)
        O_H_CNT <= 10'h000;
      else
        O_H_CNT <= O_H_CNT + 10'h001;
   end

   // 垂直カウンタ
   parameter VMAX = 525;

   always @(posedge I_CLK, posedge I_RST) begin
      if ( I_RST )
        O_V_CNT <= 10'h000;
      else if( hcntend ) begin
         if (O_V_CNT == VMAX - 10'h001)
           O_V_CNT <= 10'h000;
         else
           O_V_CNT <= O_V_CNT + 10'h001;
      end
   end


   // 同期信号
   //parameter HS_START = 663;
   //parameter HS_END   = 759;
   parameter HS_START = 656;
   parameter HS_END   = 752;
   parameter VS_START = 449;
   parameter VS_END   = 451;

   always @( posedge I_CLK or posedge I_RST) begin
      if ( I_RST )
        O_HS <= 1'b1;
      else if( O_H_CNT == HS_START )
        O_HS <= 1'b0;
      else if( O_H_CNT == HS_END )
        O_HS <= 1'b1;
   end

   always @( posedge I_CLK or posedge I_RST) begin
      if ( I_RST )
        O_VS <= 1'b1;
      else if(O_H_CNT == HS_START) begin
         if( O_V_CNT == VS_START )
           O_VS <= 1'b0;
         else if ( O_V_CNT == VS_END)
           O_VS <= 1'b1;
      end
   end

endmodule // HVGEN
