//
// Z80 Compatible Bus wrapper for TV80 8-Bit Microprocessor Core
//
// Copyright (c) 2004 Tatsuyuki Sato
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

//`define TV80C_USER_NGC_LINK

module tv80c (/*AUTOARG*/
  // Inputs
  reset_n, clk, wait_n, int_n, nmi_n, busrq_n, di,
  // Outputs
  m1_n, mreq_n, iorq_n, rd_n, wr_n, rfsh_n, halt_n, busak_n, A, do
);

parameter Mode = 0;    // 0 => Z80, 1 => Fast Z80, 2 => 8080, 3 => GB
parameter IOWait  = 1; // 0 => Single cycle I/O, 1 => Std I/O cycle

input reset_n,clk;
input wait_n , busrq_n; 
input int_n,nmi_n; 
input [7:0] di;

output  m1_n; 
output  mreq_n; 
output  iorq_n; 
output  rd_n; 
output  wr_n; 
output  rfsh_n; 
output  halt_n; 
output  busak_n; 
output [15:0] A;
output [7:0]  do;

`ifndef TV80C_USER_NGC_LINK

// internal register
reg [7:0] di_r;
reg  wait_r;
reg  mreq_r;
reg  iorq_r,iorq_f;
reg  rd_r;
reg  wr_r;
reg  m1_dw;
reg  t2,t22;

// internal wire
wire m1_t3_h;
wire iord_n;
wire iowr_n;
wire sp_m1;

// TV80 internal wire
wire          cen;
wire          intcycle_n;
wire          no_read;
wire          write;
wire          iorq;
wire [2:0]    mcycle;
wire [2:0]    tstate;

// TV80 module
tv80_core tv80_core(
  .cen (cen),
  .m1_n (m1_n),
  .iorq (iorq),
  .no_read (no_read),
  .write (write),
  .rfsh_n (rfsh_n),
  .halt_n (halt_n),
  .wait_n (wait_r),
  .int_n (int_n),
  .nmi_n (nmi_n),
  .reset_n (reset_n),
  .busrq_n (busrq_n),
  .busak_n (busak_n),
  .clk (clk),
  .IntE (),
  .stop (),
  .A (A),
  .dinst (di),
  .di (di_r),
  .do (do),
  .mc (mcycle),
  .ts (tstate),
  .intcycle_n (intcycle_n)
);

// clk raise event
always @(posedge clk)
begin
  if (!reset_n)
  begin
    iorq_f <= #1 1'b1;
  end else begin
    // IORQ fast cycle
    iorq_f <= #1 ~(tstate==1) | ~iorq;
  end
end

// clk fall event
always @(negedge clk)
begin
  if (!reset_n)
  begin
    iorq_r <= #1 1'b1;
    mreq_r <= #1 1'b1;
    m1_dw  <= #1 1'b1;
    rd_r   <= #1 1'b1;
    wr_r   <= #1 1'b1;
    di_r   <= #1 8'h00;
    wait_r <= #1 1'b1;
    t2     <= #1 1'b0;
    t22    <= #1 1'b0;
  end else begin

    // t2(after t1) for SpecialM1
    t2  <= #1 (tstate==1);
    t22 <= #1 t2;

    // IORQ
    if(tstate==1)
      iorq_r <= #1 iorq_f; // IORQ after half cycle
    if(t22 & sp_m1)  // Special M1
      iorq_r <= #1 1'b0;
    if(tstate==3)
      iorq_r <= #1 1'b1;      // inactive

    // MREQ disable window ,t2(w) to t3
    m1_dw <= #1 (tstate==2);

    // MREQ
    if(tstate==1)          // M1 , mem
      mreq_r <= #1 no_read | iorq | sp_m1;
    if(tstate==3 & rfsh_n) // mem finish
      mreq_r <= #1 rfsh_n;
    if(tstate==4)          // M1 finish
      mreq_r <= #1 1'b1;

    // RD (mem)
    if(tstate==1) // mreq
      rd_r <= #1 no_read | write | sp_m1;
    if(tstate==3)
      rd_r <= #1 1'b1;

    // WR (mem)
    if(tstate==2)
      wr_r <= #1 no_read | ~write;
    if(tstate==3)
      wr_r <= #1 1'b1;

    // Data Read Latch
    if(tstate==3)
      di_r  <= #1 di;

    // wait sense (T2 raise)
    wait_r <= #1 wait_n;

  end
end

/////////////////////////////////////////////////////////////////
assign m1_t3_h = m1_dw & ~rfsh_n;        // M1 & T3 & CLK=H
assign sp_m1 = ~intcycle_n & ~m1_n;      // Special M1 cycle

assign iord_n = ~iorq | iorq_n | write;  //
assign iowr_n = (iorq_n | ~write);       //

assign cen = 1;
assign iorq_n = m1_t3_h | (iorq_r & iorq_f);
assign mreq_n = m1_t3_h | mreq_r;
assign rd_n   = (iord_n & (rd_r | m1_t3_h));
assign wr_n   = iowr_n &  wr_r           ;

`endif // TV80C_USER_NGC_LINK


endmodule // t80s

