//***************************************************************************************
// PC-8001 on the DE0 Altera CycloneIII version.
// Test bench fot 8251ContReg.v
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

`timescale 1ns/1ps

module TEST_CONTREG_8251;
   reg I_CLK=0;
   reg I_RST;
   reg I_CONTROL_EN;
   reg I_DATA_EN;
   reg I_WE;
   reg I_RD;
   reg  [7:0] I_DATA;
   wire [7:0] O_DATA;
   wire [7:0] O_DEBUG_CMD;
   wire [1:0] O_DEBUG_STATE;

	// Test target
	CONTREG_8251 CONTREG_8251(
		     .I_CONTROL_EN(I_CONTROL_EN),
		     .I_DATA_EN(I_DATA_EN),
		     .I_WE(I_WE),
		     .I_RD(I_RD),
		     .I_DATA(I_DATA),
		     .O_DATA(O_DATA),
		     .O_DEBUG_CMD(O_DEBUG_CMD),
		     .O_DEBUG_STATE(O_DEBUG_STATE),
		     .I_RST(I_RST),
		     .I_CLK(I_CLK)
		     );

	// Genelate Clock
	always begin
		 #5 I_CLK = ~I_CLK;
	end

	initial begin
	   I_RST = 1;
	   repeat(10) @(posedge I_CLK);
	   I_RST = 0;
	   repeat(10) @(posedge I_CLK);
	   // 8251 Soft Reset
	   I_CONTROL_EN = 1;
	   I_WE = 1;
	   I_DATA = 8'h0E;
	   repeat(10) @(posedge I_CLK);
	   I_CONTROL_EN = 0;
	   I_WE = 0;
	   I_DATA = 8'hFF;
	   repeat(10) @(posedge I_CLK);
	   I_CONTROL_EN = 1;
	   I_WE = 1;
	   I_DATA = 8'h40;
	   repeat(10) @(posedge I_CLK);
	   I_CONTROL_EN = 0;
	   I_WE = 0;
	   I_DATA = 8'hFF;
	   repeat(10) @(posedge I_CLK);

	   $stop;
	end // initial begin

endmodule




//**************************************************//
//*** E.O.F ****************************************//
//**************************************************//
