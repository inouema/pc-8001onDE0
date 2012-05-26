//***************************************************************************************
// PC-8001 on the DE0 Altera CycloneIII version.
// 8251 cont reg
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

module CONTREG_8251 (
		     input            I_PORT21_WE,
		     input      [7:0] I_DATA,
		     output     [7:0] O_DEBUG,
		     input            I_RST,
		     input            I_CLK
		     );

	///////////////////////////////////////////////////////////////
	// re-timing
	//////////////////////////////////////////////////////////////
	reg [7:0] 				r_input_data;
	reg 					r_port21_we;
   
	always @(posedge I_CLK or posedge I_RST) begin
		if(I_RST) begin
			r_input_data <= 8'h00;
			r_port21_we  <= 1'h0;
		end
		else begin
			r_input_data <= I_DATA;
			r_port21_we  <= I_PORT21_WE;
		end
	end


	/**
	 * Device Register's
	 */
    reg [7:0]  r_command; // 8251 Command registers
    reg [7:0]  r_status;  // 8251 Status  registers

	// Bit assign of the Command Registers
	wire w_bit_ir   = r_command[6]; // Internal reset
	wire w_bit_rxe  = r_command[2]; // receive enable (1:enable 0:disable)
	wire w_bit_txen = r_command[0]; // send enable    (1:enable 0:disable)

	// debug port assign
	assign O_DEBUG[6] = w_bit_ir;
	assign O_DEBUG[2] = w_bit_rxe;
	assign O_DEBUG[0] = w_bit_txen;


    wire       w_reset;
    assign     w_reset = I_RST | w_bit_ir;
   
   // Edge Detect.
	reg [1:0] r_port21_we_sreg;
	wire 	  w_port21_rise;

	always @(posedge I_CLK or posedge w_reset) begin
		if(w_reset) begin
			r_port21_we_sreg <= 2'h0;
		end
		else begin
			r_port21_we_sreg <= {r_port21_we_sreg[0], I_PORT21_WE};
		end
	end

	assign w_port21_rise = ~r_port21_we_sreg[1] & r_port21_we_sreg[0];


	// Decode
	always @(posedge I_CLK or posedge w_reset) begin
		if(w_reset) begin
			r_command <= 8'h00;
			r_status  <= 8'h00;
		end
		else if(w_port21_rise & r_port21_we) begin
			r_command <= r_input_data;
		end
	end



endmodule // CONTREG_8251

//**************************************************//
//*** E.O.F ****************************************//
//**************************************************//
