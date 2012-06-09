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
`timescale 1ns/1ps

module CONTREG_8251 (
		     input 			  I_CONTROL_EN,
		     input 			  I_DATA_EN,
		     input 			  I_WE,
		     input 			  I_RD,
		     input [7:0] 	  I_DATA, // from Z80
		     output reg [7:0] O_DATA, // to Z80 (port 20h)
		     output reg [7:0] O_CONTROL_DATA, // to Z80 (port 21h)
		     input 			  I_MCU_WR, // write enable from sub system (nios2)
		     input 			  I_MCU_RD, // read  enable from sub system (nios2)
		     input      [7:0] I_MCU_DATA, // from sub system (nios2)
		     output reg [7:0] O_MCU_DATA, // to   sub system (nios2)
		     output 		  O_CMT_LOAD, // to sub system (nios2)
		     output 		  O_nCMTTxRDY, // to sub system (nios2)
		     output 		  O_CMT_SAVE, // to sub system (nios2)
		     output 		  O_nCMTRxRDY, // to sub system (nios2)
		     input 			  I_RST,
		     input 			  I_CLK
		     );



	///////////////////////////////////////////////////////////////
	// wire's and register's
	//////////////////////////////////////////////////////////////
	reg [7:0] 				r_input_data;
	reg 					r_control_en;
	reg 					r_data_en;
	reg 					r_we;
	reg 					r_rd;
	reg 					r_i_mcu_wr;
	reg 					r_i_mcu_rd;
	reg [7:0] 				r_i_mcu_data;



	///////////////////////////////////////////////////////////////
	// re-timing
	//////////////////////////////////////////////////////////////

	always @(posedge I_CLK or posedge I_RST) begin
		if(I_RST) begin
		   r_input_data <= 8'h00;
		   r_control_en <= 1'h0;
		   r_data_en    <= 1'h0;
		   r_we         <= 1'h0;
		   r_rd         <= 1'h0;
		   r_i_mcu_wr   <= 1'h0;
		   r_i_mcu_rd   <= 1'h0;
		   r_i_mcu_data <= 8'h00;
		end
		else begin
		   r_input_data <= I_DATA;
		   r_control_en <= I_CONTROL_EN;
		   r_data_en    <= I_DATA_EN;
		   r_we         <= I_WE;
		   r_rd         <= I_RD;
		   r_i_mcu_wr   <= I_MCU_WR;
		   r_i_mcu_rd   <= I_MCU_RD;
		   r_i_mcu_data <= I_MCU_DATA;
		end
	end


	/**
	 * Device Register's
	 */
	reg [7:0]  r_command; // 8251 Command registers

//	wire w_bit_eh    = r_command[7];
	wire w_bit_ir    = r_command[6]; // Internal reset
//	wire w_bit_rts   = r_command[5];
//	wire w_bit_er    = r_command[4];
//	wire w_bit_sbrk  = r_command[3];
	wire w_bit_rxe   = r_command[2]; // receive enable (1:enable 0:disable)
//	wire w_bit_dtr   = r_command[1];
	wire w_bit_txen  = r_command[0]; // send enable    (1:enable 0:disable)

	assign O_CMT_LOAD = w_bit_rxe;  // 1:Z80 is Loading now.   0:Not
	assign O_CMT_SAVE = w_bit_txen; // 1:Z80 is Saveing now .  0:Not


	// 8251 Status  registers
	reg [7:0]  r_status;
	wire w_bit_txemp = r_status[2]; // TxE(mpty). (1.empty 0:full)
	wire w_bit_rxrdy = r_status[1]; // RxRDY.     (1:ready 0:busy)
	wire w_bit_txrdy = r_status[0]; // TxRDY.     (1:ready 0:busy)

	assign O_nCMTRxRDY = w_bit_rxrdy; // 0:MCU is data receibe ok 1:Not
	assign O_nCMTTxRDY = w_bit_txrdy; // 0:MCU is data write ok   1:Not
   

	wire       w_reset;
	assign     w_reset = I_RST | w_bit_ir;

   // Edge Detect.
   // Z80 is first, send RST command.
   // If receive it, first state to "MODE Setting" next to "CMD Setting"
	reg [1:0] r_control_we_sreg;
	wire 	  w_control_we_fall;

	always @(posedge I_CLK or posedge w_reset) begin
		if(w_reset) begin
			r_control_we_sreg <= 2'h0;
		end
		else begin
			r_control_we_sreg <= {r_control_we_sreg[0], I_CONTROL_EN & I_WE};
		end
	end
	assign w_control_we_fall = r_control_we_sreg[1] & ~r_control_we_sreg[0];


	reg [1:0] r_control_en_sreg;
	wire 	  w_control_en_fall;

	always @(posedge I_CLK or posedge w_reset) begin
		if(w_reset) begin
		   r_control_en_sreg <= 2'h0;
		end
		else begin
		   r_control_en_sreg <= {r_control_en_sreg[0], r_control_en};
		end
	end
	assign w_control_en_fall = r_control_en_sreg[1] & ~r_control_en_sreg[0];



	reg [1:0] r_data_en_sreg;
	wire 	  w_data_en_fall;

	always @(posedge I_CLK or posedge w_reset) begin
		if(w_reset) begin
		   r_data_en_sreg <= 2'h0;
		end
		else begin
		   r_data_en_sreg <= {r_data_en_sreg[0], r_data_en};
		end
	end
	assign w_data_en_fall = r_data_en_sreg[1] & ~r_data_en_sreg[0];



   /**
	* Edge Detect
	*/
	reg [1:0] r_i_mcu_wr_sreg;
	wire 	  w_i_mcu_wr_fall;

	always @(posedge I_CLK or posedge w_reset) begin
	   if(w_reset) begin
		  r_i_mcu_wr_sreg <= 2'h0;
	   end
	   else begin
		  r_i_mcu_wr_sreg <= {r_i_mcu_wr_sreg[0], r_i_mcu_wr};
	   end
	end

   assign w_i_mcu_wr_fall = r_i_mcu_wr_sreg[1] & ~r_i_mcu_wr_sreg[0];


	reg [1:0] r_i_mcu_rd_sreg;
	wire 	  w_i_mcu_rd_fall;

	always @(posedge I_CLK or posedge w_reset) begin
	   if(w_reset) begin
		  r_i_mcu_rd_sreg <= 2'h0;
	   end
	   else begin
		  r_i_mcu_rd_sreg <= {r_i_mcu_rd_sreg[0], r_i_mcu_rd};
	   end
	end

   assign w_i_mcu_rd_fall = r_i_mcu_rd_sreg[1] & ~r_i_mcu_rd_sreg[0];



	/**
	 *  State machine of 8251
	 */
	parameter P_SIO_STATE_MODE_SETTING = 4'h0;
	parameter P_SIO_STATE_CMD_SETTING  = 4'h1;
	reg [3:0] r_state;

	always @(posedge I_CLK or posedge w_reset) begin
		if(w_reset) begin
			r_state        <= P_SIO_STATE_MODE_SETTING;
			r_command      <= 8'h00;
			O_CONTROL_DATA <= 8'h00;
		end
		else begin
		   case(r_state)
			 P_SIO_STATE_MODE_SETTING: begin
				if(w_control_we_fall) r_state <= P_SIO_STATE_CMD_SETTING;
			 end
			 P_SIO_STATE_CMD_SETTING: begin
				if(w_control_en_fall & r_we) r_command      <= r_input_data;
				//if(r_control_en & r_we) r_command      <= r_input_data;
				if(w_control_en_fall & r_rd) O_CONTROL_DATA <= r_status;
				//if(r_control_en & r_rd) O_CONTROL_DATA <= r_status;
				r_state <= r_state;
			 end
			 default: begin
				r_state <= P_SIO_STATE_MODE_SETTING;
			 end
		   endcase // case (r_state)
		end
	end // always @ (posedge I_CLK or posedge w_reset)


	/**
	 *  8251 data interface between Z80 and MCU(nios2)
	 */
	reg [7:0] r_cmt_data;

	always @(posedge I_CLK or posedge w_reset) begin
	   if(w_reset)begin
		  r_status   <= 8'h00;
		  O_DATA     <= 8'h00;
		  r_cmt_data <= 8'h00;
	   end
	   else begin
		  if(w_data_en_fall & r_rd) begin  // read request from Z80.
			O_DATA     <= r_cmt_data;
			r_cmt_data <= 8'h00; // to be del... AAAAA
			r_status   <= 8'h00; // Sub MCU is data set ok.
		  end
		  if(w_data_en_fall & r_we) begin // write request from Z80.
			r_cmt_data <= r_input_data;
			r_status   <= 8'h00; // Sub MCU is data get ok.
		  end
		  if(w_i_mcu_wr_fall & w_bit_rxe) begin // Write request from Nios2
			r_cmt_data <= r_i_mcu_data;
			r_status   <= 8'h02;
		  end
		  if(w_i_mcu_rd_fall) begin // Read request from Nios2
			O_MCU_DATA <= r_cmt_data;
			r_status   <= 8'h05;
		  end
	   end
	end // always @ (posedge I_CLK or posedge w_reset)


	/**
	 * debug port assign
	 */
//	assign O_DEBUG_CMD = r_command;
//	assign O_DEBUG_STATE = r_state;



endmodule // CONTREG_8251


//**************************************************//
//*** E.O.F ****************************************//
//**************************************************//
