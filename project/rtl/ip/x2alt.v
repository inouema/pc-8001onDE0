/////////////////////////////////////////////////////////////////////////////
// FPGA PACMAN
// Xilinx to ALTERA Prim Conversion
//
// Copyright(c) 2003 Katsumi Degawa , All rights reserved
//
// Important !
//
// This program is freeware for non-commercial use. 
// An author does no guarantee about this program.
// You can use this under your own risk. 
//
/////////////////////////////////////////////////////////////////////////////

module BUFG(I,O);
input I;
output O;

//assign O = I;
LCELL(I,O);

endmodule

module IBUFG(I,O);
input I;
output O;

//assign O = I;
LCELL(I,O);

endmodule

module OBUFT_S_24(I,O,T);
input I,T;
output O;

assign O = (T==0)? I:1'bz;

endmodule

module OBUFT_S_2(I,O,T);
input I,T;
output O;

assign O = (T==0)? I:1'bz;

endmodule

module OBUF_F_24(I,O);
input I;
output O;

assign O = I;

endmodule