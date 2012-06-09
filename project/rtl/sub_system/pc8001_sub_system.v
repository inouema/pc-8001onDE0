//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2012 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cmt_din_s1_arbitrator (
                               // inputs:
                                clk,
                                cmt_din_s1_readdata,
                                nios2_data_master_address_to_slave,
                                nios2_data_master_read,
                                nios2_data_master_write,
                                reset_n,

                               // outputs:
                                cmt_din_s1_address,
                                cmt_din_s1_readdata_from_sa,
                                cmt_din_s1_reset_n,
                                d1_cmt_din_s1_end_xfer,
                                nios2_data_master_granted_cmt_din_s1,
                                nios2_data_master_qualified_request_cmt_din_s1,
                                nios2_data_master_read_data_valid_cmt_din_s1,
                                nios2_data_master_requests_cmt_din_s1
                             )
;

  output  [  1: 0] cmt_din_s1_address;
  output  [ 31: 0] cmt_din_s1_readdata_from_sa;
  output           cmt_din_s1_reset_n;
  output           d1_cmt_din_s1_end_xfer;
  output           nios2_data_master_granted_cmt_din_s1;
  output           nios2_data_master_qualified_request_cmt_din_s1;
  output           nios2_data_master_read_data_valid_cmt_din_s1;
  output           nios2_data_master_requests_cmt_din_s1;
  input            clk;
  input   [ 31: 0] cmt_din_s1_readdata;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_write;
  input            reset_n;

  wire    [  1: 0] cmt_din_s1_address;
  wire             cmt_din_s1_allgrants;
  wire             cmt_din_s1_allow_new_arb_cycle;
  wire             cmt_din_s1_any_bursting_master_saved_grant;
  wire             cmt_din_s1_any_continuerequest;
  wire             cmt_din_s1_arb_counter_enable;
  reg              cmt_din_s1_arb_share_counter;
  wire             cmt_din_s1_arb_share_counter_next_value;
  wire             cmt_din_s1_arb_share_set_values;
  wire             cmt_din_s1_beginbursttransfer_internal;
  wire             cmt_din_s1_begins_xfer;
  wire             cmt_din_s1_end_xfer;
  wire             cmt_din_s1_firsttransfer;
  wire             cmt_din_s1_grant_vector;
  wire             cmt_din_s1_in_a_read_cycle;
  wire             cmt_din_s1_in_a_write_cycle;
  wire             cmt_din_s1_master_qreq_vector;
  wire             cmt_din_s1_non_bursting_master_requests;
  wire    [ 31: 0] cmt_din_s1_readdata_from_sa;
  reg              cmt_din_s1_reg_firsttransfer;
  wire             cmt_din_s1_reset_n;
  reg              cmt_din_s1_slavearbiterlockenable;
  wire             cmt_din_s1_slavearbiterlockenable2;
  wire             cmt_din_s1_unreg_firsttransfer;
  wire             cmt_din_s1_waits_for_read;
  wire             cmt_din_s1_waits_for_write;
  reg              d1_cmt_din_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cmt_din_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_cmt_din_s1;
  wire             nios2_data_master_qualified_request_cmt_din_s1;
  wire             nios2_data_master_read_data_valid_cmt_din_s1;
  wire             nios2_data_master_requests_cmt_din_s1;
  wire             nios2_data_master_saved_grant_cmt_din_s1;
  wire    [ 13: 0] shifted_address_to_cmt_din_s1_from_nios2_data_master;
  wire             wait_for_cmt_din_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_din_s1_end_xfer;
    end


  assign cmt_din_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_cmt_din_s1));
  //assign cmt_din_s1_readdata_from_sa = cmt_din_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_din_s1_readdata_from_sa = cmt_din_s1_readdata;

  assign nios2_data_master_requests_cmt_din_s1 = (({nios2_data_master_address_to_slave[13 : 4] , 4'b0} == 14'h40) & (nios2_data_master_read | nios2_data_master_write)) & nios2_data_master_read;
  //cmt_din_s1_arb_share_counter set values, which is an e_mux
  assign cmt_din_s1_arb_share_set_values = 1;

  //cmt_din_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_din_s1_non_bursting_master_requests = nios2_data_master_requests_cmt_din_s1;

  //cmt_din_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign cmt_din_s1_any_bursting_master_saved_grant = 0;

  //cmt_din_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign cmt_din_s1_arb_share_counter_next_value = cmt_din_s1_firsttransfer ? (cmt_din_s1_arb_share_set_values - 1) : |cmt_din_s1_arb_share_counter ? (cmt_din_s1_arb_share_counter - 1) : 0;

  //cmt_din_s1_allgrants all slave grants, which is an e_mux
  assign cmt_din_s1_allgrants = |cmt_din_s1_grant_vector;

  //cmt_din_s1_end_xfer assignment, which is an e_assign
  assign cmt_din_s1_end_xfer = ~(cmt_din_s1_waits_for_read | cmt_din_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_cmt_din_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cmt_din_s1 = cmt_din_s1_end_xfer & (~cmt_din_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cmt_din_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign cmt_din_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_cmt_din_s1 & cmt_din_s1_allgrants) | (end_xfer_arb_share_counter_term_cmt_din_s1 & ~cmt_din_s1_non_bursting_master_requests);

  //cmt_din_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_din_s1_arb_share_counter <= 0;
      else if (cmt_din_s1_arb_counter_enable)
          cmt_din_s1_arb_share_counter <= cmt_din_s1_arb_share_counter_next_value;
    end


  //cmt_din_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_din_s1_slavearbiterlockenable <= 0;
      else if ((|cmt_din_s1_master_qreq_vector & end_xfer_arb_share_counter_term_cmt_din_s1) | (end_xfer_arb_share_counter_term_cmt_din_s1 & ~cmt_din_s1_non_bursting_master_requests))
          cmt_din_s1_slavearbiterlockenable <= |cmt_din_s1_arb_share_counter_next_value;
    end


  //nios2/data_master cmt_din/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = cmt_din_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //cmt_din_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_din_s1_slavearbiterlockenable2 = |cmt_din_s1_arb_share_counter_next_value;

  //nios2/data_master cmt_din/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = cmt_din_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //cmt_din_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_din_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_cmt_din_s1 = nios2_data_master_requests_cmt_din_s1;
  //master is always granted when requested
  assign nios2_data_master_granted_cmt_din_s1 = nios2_data_master_qualified_request_cmt_din_s1;

  //nios2/data_master saved-grant cmt_din/s1, which is an e_assign
  assign nios2_data_master_saved_grant_cmt_din_s1 = nios2_data_master_requests_cmt_din_s1;

  //allow new arb cycle for cmt_din/s1, which is an e_assign
  assign cmt_din_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign cmt_din_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign cmt_din_s1_master_qreq_vector = 1;

  //cmt_din_s1_reset_n assignment, which is an e_assign
  assign cmt_din_s1_reset_n = reset_n;

  //cmt_din_s1_firsttransfer first transaction, which is an e_assign
  assign cmt_din_s1_firsttransfer = cmt_din_s1_begins_xfer ? cmt_din_s1_unreg_firsttransfer : cmt_din_s1_reg_firsttransfer;

  //cmt_din_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign cmt_din_s1_unreg_firsttransfer = ~(cmt_din_s1_slavearbiterlockenable & cmt_din_s1_any_continuerequest);

  //cmt_din_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_din_s1_reg_firsttransfer <= 1'b1;
      else if (cmt_din_s1_begins_xfer)
          cmt_din_s1_reg_firsttransfer <= cmt_din_s1_unreg_firsttransfer;
    end


  //cmt_din_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cmt_din_s1_beginbursttransfer_internal = cmt_din_s1_begins_xfer;

  assign shifted_address_to_cmt_din_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //cmt_din_s1_address mux, which is an e_mux
  assign cmt_din_s1_address = shifted_address_to_cmt_din_s1_from_nios2_data_master >> 2;

  //d1_cmt_din_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cmt_din_s1_end_xfer <= 1;
      else 
        d1_cmt_din_s1_end_xfer <= cmt_din_s1_end_xfer;
    end


  //cmt_din_s1_waits_for_read in a cycle, which is an e_mux
  assign cmt_din_s1_waits_for_read = cmt_din_s1_in_a_read_cycle & cmt_din_s1_begins_xfer;

  //cmt_din_s1_in_a_read_cycle assignment, which is an e_assign
  assign cmt_din_s1_in_a_read_cycle = nios2_data_master_granted_cmt_din_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_din_s1_in_a_read_cycle;

  //cmt_din_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_din_s1_waits_for_write = cmt_din_s1_in_a_write_cycle & 0;

  //cmt_din_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_din_s1_in_a_write_cycle = nios2_data_master_granted_cmt_din_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cmt_din_s1_in_a_write_cycle;

  assign wait_for_cmt_din_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cmt_din/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cmt_dout_s1_arbitrator (
                                // inputs:
                                 clk,
                                 cmt_dout_s1_readdata,
                                 nios2_data_master_address_to_slave,
                                 nios2_data_master_read,
                                 nios2_data_master_waitrequest,
                                 nios2_data_master_write,
                                 nios2_data_master_writedata,
                                 reset_n,

                                // outputs:
                                 cmt_dout_s1_address,
                                 cmt_dout_s1_chipselect,
                                 cmt_dout_s1_readdata_from_sa,
                                 cmt_dout_s1_reset_n,
                                 cmt_dout_s1_write_n,
                                 cmt_dout_s1_writedata,
                                 d1_cmt_dout_s1_end_xfer,
                                 nios2_data_master_granted_cmt_dout_s1,
                                 nios2_data_master_qualified_request_cmt_dout_s1,
                                 nios2_data_master_read_data_valid_cmt_dout_s1,
                                 nios2_data_master_requests_cmt_dout_s1
                              )
;

  output  [  1: 0] cmt_dout_s1_address;
  output           cmt_dout_s1_chipselect;
  output  [ 31: 0] cmt_dout_s1_readdata_from_sa;
  output           cmt_dout_s1_reset_n;
  output           cmt_dout_s1_write_n;
  output  [ 31: 0] cmt_dout_s1_writedata;
  output           d1_cmt_dout_s1_end_xfer;
  output           nios2_data_master_granted_cmt_dout_s1;
  output           nios2_data_master_qualified_request_cmt_dout_s1;
  output           nios2_data_master_read_data_valid_cmt_dout_s1;
  output           nios2_data_master_requests_cmt_dout_s1;
  input            clk;
  input   [ 31: 0] cmt_dout_s1_readdata;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] cmt_dout_s1_address;
  wire             cmt_dout_s1_allgrants;
  wire             cmt_dout_s1_allow_new_arb_cycle;
  wire             cmt_dout_s1_any_bursting_master_saved_grant;
  wire             cmt_dout_s1_any_continuerequest;
  wire             cmt_dout_s1_arb_counter_enable;
  reg              cmt_dout_s1_arb_share_counter;
  wire             cmt_dout_s1_arb_share_counter_next_value;
  wire             cmt_dout_s1_arb_share_set_values;
  wire             cmt_dout_s1_beginbursttransfer_internal;
  wire             cmt_dout_s1_begins_xfer;
  wire             cmt_dout_s1_chipselect;
  wire             cmt_dout_s1_end_xfer;
  wire             cmt_dout_s1_firsttransfer;
  wire             cmt_dout_s1_grant_vector;
  wire             cmt_dout_s1_in_a_read_cycle;
  wire             cmt_dout_s1_in_a_write_cycle;
  wire             cmt_dout_s1_master_qreq_vector;
  wire             cmt_dout_s1_non_bursting_master_requests;
  wire    [ 31: 0] cmt_dout_s1_readdata_from_sa;
  reg              cmt_dout_s1_reg_firsttransfer;
  wire             cmt_dout_s1_reset_n;
  reg              cmt_dout_s1_slavearbiterlockenable;
  wire             cmt_dout_s1_slavearbiterlockenable2;
  wire             cmt_dout_s1_unreg_firsttransfer;
  wire             cmt_dout_s1_waits_for_read;
  wire             cmt_dout_s1_waits_for_write;
  wire             cmt_dout_s1_write_n;
  wire    [ 31: 0] cmt_dout_s1_writedata;
  reg              d1_cmt_dout_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cmt_dout_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_cmt_dout_s1;
  wire             nios2_data_master_qualified_request_cmt_dout_s1;
  wire             nios2_data_master_read_data_valid_cmt_dout_s1;
  wire             nios2_data_master_requests_cmt_dout_s1;
  wire             nios2_data_master_saved_grant_cmt_dout_s1;
  wire    [ 13: 0] shifted_address_to_cmt_dout_s1_from_nios2_data_master;
  wire             wait_for_cmt_dout_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_dout_s1_end_xfer;
    end


  assign cmt_dout_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_cmt_dout_s1));
  //assign cmt_dout_s1_readdata_from_sa = cmt_dout_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_dout_s1_readdata_from_sa = cmt_dout_s1_readdata;

  assign nios2_data_master_requests_cmt_dout_s1 = ({nios2_data_master_address_to_slave[13 : 4] , 4'b0} == 14'h30) & (nios2_data_master_read | nios2_data_master_write);
  //cmt_dout_s1_arb_share_counter set values, which is an e_mux
  assign cmt_dout_s1_arb_share_set_values = 1;

  //cmt_dout_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_dout_s1_non_bursting_master_requests = nios2_data_master_requests_cmt_dout_s1;

  //cmt_dout_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign cmt_dout_s1_any_bursting_master_saved_grant = 0;

  //cmt_dout_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign cmt_dout_s1_arb_share_counter_next_value = cmt_dout_s1_firsttransfer ? (cmt_dout_s1_arb_share_set_values - 1) : |cmt_dout_s1_arb_share_counter ? (cmt_dout_s1_arb_share_counter - 1) : 0;

  //cmt_dout_s1_allgrants all slave grants, which is an e_mux
  assign cmt_dout_s1_allgrants = |cmt_dout_s1_grant_vector;

  //cmt_dout_s1_end_xfer assignment, which is an e_assign
  assign cmt_dout_s1_end_xfer = ~(cmt_dout_s1_waits_for_read | cmt_dout_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_cmt_dout_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cmt_dout_s1 = cmt_dout_s1_end_xfer & (~cmt_dout_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cmt_dout_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign cmt_dout_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_cmt_dout_s1 & cmt_dout_s1_allgrants) | (end_xfer_arb_share_counter_term_cmt_dout_s1 & ~cmt_dout_s1_non_bursting_master_requests);

  //cmt_dout_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_dout_s1_arb_share_counter <= 0;
      else if (cmt_dout_s1_arb_counter_enable)
          cmt_dout_s1_arb_share_counter <= cmt_dout_s1_arb_share_counter_next_value;
    end


  //cmt_dout_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_dout_s1_slavearbiterlockenable <= 0;
      else if ((|cmt_dout_s1_master_qreq_vector & end_xfer_arb_share_counter_term_cmt_dout_s1) | (end_xfer_arb_share_counter_term_cmt_dout_s1 & ~cmt_dout_s1_non_bursting_master_requests))
          cmt_dout_s1_slavearbiterlockenable <= |cmt_dout_s1_arb_share_counter_next_value;
    end


  //nios2/data_master cmt_dout/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = cmt_dout_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //cmt_dout_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_dout_s1_slavearbiterlockenable2 = |cmt_dout_s1_arb_share_counter_next_value;

  //nios2/data_master cmt_dout/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = cmt_dout_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //cmt_dout_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_dout_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_cmt_dout_s1 = nios2_data_master_requests_cmt_dout_s1 & ~(((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //cmt_dout_s1_writedata mux, which is an e_mux
  assign cmt_dout_s1_writedata = nios2_data_master_writedata;

  //master is always granted when requested
  assign nios2_data_master_granted_cmt_dout_s1 = nios2_data_master_qualified_request_cmt_dout_s1;

  //nios2/data_master saved-grant cmt_dout/s1, which is an e_assign
  assign nios2_data_master_saved_grant_cmt_dout_s1 = nios2_data_master_requests_cmt_dout_s1;

  //allow new arb cycle for cmt_dout/s1, which is an e_assign
  assign cmt_dout_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign cmt_dout_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign cmt_dout_s1_master_qreq_vector = 1;

  //cmt_dout_s1_reset_n assignment, which is an e_assign
  assign cmt_dout_s1_reset_n = reset_n;

  assign cmt_dout_s1_chipselect = nios2_data_master_granted_cmt_dout_s1;
  //cmt_dout_s1_firsttransfer first transaction, which is an e_assign
  assign cmt_dout_s1_firsttransfer = cmt_dout_s1_begins_xfer ? cmt_dout_s1_unreg_firsttransfer : cmt_dout_s1_reg_firsttransfer;

  //cmt_dout_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign cmt_dout_s1_unreg_firsttransfer = ~(cmt_dout_s1_slavearbiterlockenable & cmt_dout_s1_any_continuerequest);

  //cmt_dout_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_dout_s1_reg_firsttransfer <= 1'b1;
      else if (cmt_dout_s1_begins_xfer)
          cmt_dout_s1_reg_firsttransfer <= cmt_dout_s1_unreg_firsttransfer;
    end


  //cmt_dout_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cmt_dout_s1_beginbursttransfer_internal = cmt_dout_s1_begins_xfer;

  //~cmt_dout_s1_write_n assignment, which is an e_mux
  assign cmt_dout_s1_write_n = ~(nios2_data_master_granted_cmt_dout_s1 & nios2_data_master_write);

  assign shifted_address_to_cmt_dout_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //cmt_dout_s1_address mux, which is an e_mux
  assign cmt_dout_s1_address = shifted_address_to_cmt_dout_s1_from_nios2_data_master >> 2;

  //d1_cmt_dout_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cmt_dout_s1_end_xfer <= 1;
      else 
        d1_cmt_dout_s1_end_xfer <= cmt_dout_s1_end_xfer;
    end


  //cmt_dout_s1_waits_for_read in a cycle, which is an e_mux
  assign cmt_dout_s1_waits_for_read = cmt_dout_s1_in_a_read_cycle & cmt_dout_s1_begins_xfer;

  //cmt_dout_s1_in_a_read_cycle assignment, which is an e_assign
  assign cmt_dout_s1_in_a_read_cycle = nios2_data_master_granted_cmt_dout_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_dout_s1_in_a_read_cycle;

  //cmt_dout_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_dout_s1_waits_for_write = cmt_dout_s1_in_a_write_cycle & 0;

  //cmt_dout_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_dout_s1_in_a_write_cycle = nios2_data_master_granted_cmt_dout_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cmt_dout_s1_in_a_write_cycle;

  assign wait_for_cmt_dout_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cmt_dout/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cmt_gpio_in_s1_arbitrator (
                                   // inputs:
                                    clk,
                                    cmt_gpio_in_s1_readdata,
                                    nios2_data_master_address_to_slave,
                                    nios2_data_master_read,
                                    nios2_data_master_write,
                                    reset_n,

                                   // outputs:
                                    cmt_gpio_in_s1_address,
                                    cmt_gpio_in_s1_readdata_from_sa,
                                    cmt_gpio_in_s1_reset_n,
                                    d1_cmt_gpio_in_s1_end_xfer,
                                    nios2_data_master_granted_cmt_gpio_in_s1,
                                    nios2_data_master_qualified_request_cmt_gpio_in_s1,
                                    nios2_data_master_read_data_valid_cmt_gpio_in_s1,
                                    nios2_data_master_requests_cmt_gpio_in_s1
                                 )
;

  output  [  1: 0] cmt_gpio_in_s1_address;
  output  [ 31: 0] cmt_gpio_in_s1_readdata_from_sa;
  output           cmt_gpio_in_s1_reset_n;
  output           d1_cmt_gpio_in_s1_end_xfer;
  output           nios2_data_master_granted_cmt_gpio_in_s1;
  output           nios2_data_master_qualified_request_cmt_gpio_in_s1;
  output           nios2_data_master_read_data_valid_cmt_gpio_in_s1;
  output           nios2_data_master_requests_cmt_gpio_in_s1;
  input            clk;
  input   [ 31: 0] cmt_gpio_in_s1_readdata;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_write;
  input            reset_n;

  wire    [  1: 0] cmt_gpio_in_s1_address;
  wire             cmt_gpio_in_s1_allgrants;
  wire             cmt_gpio_in_s1_allow_new_arb_cycle;
  wire             cmt_gpio_in_s1_any_bursting_master_saved_grant;
  wire             cmt_gpio_in_s1_any_continuerequest;
  wire             cmt_gpio_in_s1_arb_counter_enable;
  reg              cmt_gpio_in_s1_arb_share_counter;
  wire             cmt_gpio_in_s1_arb_share_counter_next_value;
  wire             cmt_gpio_in_s1_arb_share_set_values;
  wire             cmt_gpio_in_s1_beginbursttransfer_internal;
  wire             cmt_gpio_in_s1_begins_xfer;
  wire             cmt_gpio_in_s1_end_xfer;
  wire             cmt_gpio_in_s1_firsttransfer;
  wire             cmt_gpio_in_s1_grant_vector;
  wire             cmt_gpio_in_s1_in_a_read_cycle;
  wire             cmt_gpio_in_s1_in_a_write_cycle;
  wire             cmt_gpio_in_s1_master_qreq_vector;
  wire             cmt_gpio_in_s1_non_bursting_master_requests;
  wire    [ 31: 0] cmt_gpio_in_s1_readdata_from_sa;
  reg              cmt_gpio_in_s1_reg_firsttransfer;
  wire             cmt_gpio_in_s1_reset_n;
  reg              cmt_gpio_in_s1_slavearbiterlockenable;
  wire             cmt_gpio_in_s1_slavearbiterlockenable2;
  wire             cmt_gpio_in_s1_unreg_firsttransfer;
  wire             cmt_gpio_in_s1_waits_for_read;
  wire             cmt_gpio_in_s1_waits_for_write;
  reg              d1_cmt_gpio_in_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cmt_gpio_in_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_cmt_gpio_in_s1;
  wire             nios2_data_master_qualified_request_cmt_gpio_in_s1;
  wire             nios2_data_master_read_data_valid_cmt_gpio_in_s1;
  wire             nios2_data_master_requests_cmt_gpio_in_s1;
  wire             nios2_data_master_saved_grant_cmt_gpio_in_s1;
  wire    [ 13: 0] shifted_address_to_cmt_gpio_in_s1_from_nios2_data_master;
  wire             wait_for_cmt_gpio_in_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_gpio_in_s1_end_xfer;
    end


  assign cmt_gpio_in_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_cmt_gpio_in_s1));
  //assign cmt_gpio_in_s1_readdata_from_sa = cmt_gpio_in_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_gpio_in_s1_readdata_from_sa = cmt_gpio_in_s1_readdata;

  assign nios2_data_master_requests_cmt_gpio_in_s1 = (({nios2_data_master_address_to_slave[13 : 4] , 4'b0} == 14'h60) & (nios2_data_master_read | nios2_data_master_write)) & nios2_data_master_read;
  //cmt_gpio_in_s1_arb_share_counter set values, which is an e_mux
  assign cmt_gpio_in_s1_arb_share_set_values = 1;

  //cmt_gpio_in_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_gpio_in_s1_non_bursting_master_requests = nios2_data_master_requests_cmt_gpio_in_s1;

  //cmt_gpio_in_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign cmt_gpio_in_s1_any_bursting_master_saved_grant = 0;

  //cmt_gpio_in_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign cmt_gpio_in_s1_arb_share_counter_next_value = cmt_gpio_in_s1_firsttransfer ? (cmt_gpio_in_s1_arb_share_set_values - 1) : |cmt_gpio_in_s1_arb_share_counter ? (cmt_gpio_in_s1_arb_share_counter - 1) : 0;

  //cmt_gpio_in_s1_allgrants all slave grants, which is an e_mux
  assign cmt_gpio_in_s1_allgrants = |cmt_gpio_in_s1_grant_vector;

  //cmt_gpio_in_s1_end_xfer assignment, which is an e_assign
  assign cmt_gpio_in_s1_end_xfer = ~(cmt_gpio_in_s1_waits_for_read | cmt_gpio_in_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_cmt_gpio_in_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cmt_gpio_in_s1 = cmt_gpio_in_s1_end_xfer & (~cmt_gpio_in_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cmt_gpio_in_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign cmt_gpio_in_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_cmt_gpio_in_s1 & cmt_gpio_in_s1_allgrants) | (end_xfer_arb_share_counter_term_cmt_gpio_in_s1 & ~cmt_gpio_in_s1_non_bursting_master_requests);

  //cmt_gpio_in_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_gpio_in_s1_arb_share_counter <= 0;
      else if (cmt_gpio_in_s1_arb_counter_enable)
          cmt_gpio_in_s1_arb_share_counter <= cmt_gpio_in_s1_arb_share_counter_next_value;
    end


  //cmt_gpio_in_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_gpio_in_s1_slavearbiterlockenable <= 0;
      else if ((|cmt_gpio_in_s1_master_qreq_vector & end_xfer_arb_share_counter_term_cmt_gpio_in_s1) | (end_xfer_arb_share_counter_term_cmt_gpio_in_s1 & ~cmt_gpio_in_s1_non_bursting_master_requests))
          cmt_gpio_in_s1_slavearbiterlockenable <= |cmt_gpio_in_s1_arb_share_counter_next_value;
    end


  //nios2/data_master cmt_gpio_in/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = cmt_gpio_in_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //cmt_gpio_in_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_gpio_in_s1_slavearbiterlockenable2 = |cmt_gpio_in_s1_arb_share_counter_next_value;

  //nios2/data_master cmt_gpio_in/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = cmt_gpio_in_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //cmt_gpio_in_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_gpio_in_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_cmt_gpio_in_s1 = nios2_data_master_requests_cmt_gpio_in_s1;
  //master is always granted when requested
  assign nios2_data_master_granted_cmt_gpio_in_s1 = nios2_data_master_qualified_request_cmt_gpio_in_s1;

  //nios2/data_master saved-grant cmt_gpio_in/s1, which is an e_assign
  assign nios2_data_master_saved_grant_cmt_gpio_in_s1 = nios2_data_master_requests_cmt_gpio_in_s1;

  //allow new arb cycle for cmt_gpio_in/s1, which is an e_assign
  assign cmt_gpio_in_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign cmt_gpio_in_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign cmt_gpio_in_s1_master_qreq_vector = 1;

  //cmt_gpio_in_s1_reset_n assignment, which is an e_assign
  assign cmt_gpio_in_s1_reset_n = reset_n;

  //cmt_gpio_in_s1_firsttransfer first transaction, which is an e_assign
  assign cmt_gpio_in_s1_firsttransfer = cmt_gpio_in_s1_begins_xfer ? cmt_gpio_in_s1_unreg_firsttransfer : cmt_gpio_in_s1_reg_firsttransfer;

  //cmt_gpio_in_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign cmt_gpio_in_s1_unreg_firsttransfer = ~(cmt_gpio_in_s1_slavearbiterlockenable & cmt_gpio_in_s1_any_continuerequest);

  //cmt_gpio_in_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_gpio_in_s1_reg_firsttransfer <= 1'b1;
      else if (cmt_gpio_in_s1_begins_xfer)
          cmt_gpio_in_s1_reg_firsttransfer <= cmt_gpio_in_s1_unreg_firsttransfer;
    end


  //cmt_gpio_in_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cmt_gpio_in_s1_beginbursttransfer_internal = cmt_gpio_in_s1_begins_xfer;

  assign shifted_address_to_cmt_gpio_in_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //cmt_gpio_in_s1_address mux, which is an e_mux
  assign cmt_gpio_in_s1_address = shifted_address_to_cmt_gpio_in_s1_from_nios2_data_master >> 2;

  //d1_cmt_gpio_in_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cmt_gpio_in_s1_end_xfer <= 1;
      else 
        d1_cmt_gpio_in_s1_end_xfer <= cmt_gpio_in_s1_end_xfer;
    end


  //cmt_gpio_in_s1_waits_for_read in a cycle, which is an e_mux
  assign cmt_gpio_in_s1_waits_for_read = cmt_gpio_in_s1_in_a_read_cycle & cmt_gpio_in_s1_begins_xfer;

  //cmt_gpio_in_s1_in_a_read_cycle assignment, which is an e_assign
  assign cmt_gpio_in_s1_in_a_read_cycle = nios2_data_master_granted_cmt_gpio_in_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_gpio_in_s1_in_a_read_cycle;

  //cmt_gpio_in_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_gpio_in_s1_waits_for_write = cmt_gpio_in_s1_in_a_write_cycle & 0;

  //cmt_gpio_in_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_gpio_in_s1_in_a_write_cycle = nios2_data_master_granted_cmt_gpio_in_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cmt_gpio_in_s1_in_a_write_cycle;

  assign wait_for_cmt_gpio_in_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cmt_gpio_in/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cmt_gpio_out_s1_arbitrator (
                                    // inputs:
                                     clk,
                                     cmt_gpio_out_s1_readdata,
                                     nios2_data_master_address_to_slave,
                                     nios2_data_master_read,
                                     nios2_data_master_waitrequest,
                                     nios2_data_master_write,
                                     nios2_data_master_writedata,
                                     reset_n,

                                    // outputs:
                                     cmt_gpio_out_s1_address,
                                     cmt_gpio_out_s1_chipselect,
                                     cmt_gpio_out_s1_readdata_from_sa,
                                     cmt_gpio_out_s1_reset_n,
                                     cmt_gpio_out_s1_write_n,
                                     cmt_gpio_out_s1_writedata,
                                     d1_cmt_gpio_out_s1_end_xfer,
                                     nios2_data_master_granted_cmt_gpio_out_s1,
                                     nios2_data_master_qualified_request_cmt_gpio_out_s1,
                                     nios2_data_master_read_data_valid_cmt_gpio_out_s1,
                                     nios2_data_master_requests_cmt_gpio_out_s1
                                  )
;

  output  [  1: 0] cmt_gpio_out_s1_address;
  output           cmt_gpio_out_s1_chipselect;
  output  [ 31: 0] cmt_gpio_out_s1_readdata_from_sa;
  output           cmt_gpio_out_s1_reset_n;
  output           cmt_gpio_out_s1_write_n;
  output  [ 31: 0] cmt_gpio_out_s1_writedata;
  output           d1_cmt_gpio_out_s1_end_xfer;
  output           nios2_data_master_granted_cmt_gpio_out_s1;
  output           nios2_data_master_qualified_request_cmt_gpio_out_s1;
  output           nios2_data_master_read_data_valid_cmt_gpio_out_s1;
  output           nios2_data_master_requests_cmt_gpio_out_s1;
  input            clk;
  input   [ 31: 0] cmt_gpio_out_s1_readdata;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] cmt_gpio_out_s1_address;
  wire             cmt_gpio_out_s1_allgrants;
  wire             cmt_gpio_out_s1_allow_new_arb_cycle;
  wire             cmt_gpio_out_s1_any_bursting_master_saved_grant;
  wire             cmt_gpio_out_s1_any_continuerequest;
  wire             cmt_gpio_out_s1_arb_counter_enable;
  reg              cmt_gpio_out_s1_arb_share_counter;
  wire             cmt_gpio_out_s1_arb_share_counter_next_value;
  wire             cmt_gpio_out_s1_arb_share_set_values;
  wire             cmt_gpio_out_s1_beginbursttransfer_internal;
  wire             cmt_gpio_out_s1_begins_xfer;
  wire             cmt_gpio_out_s1_chipselect;
  wire             cmt_gpio_out_s1_end_xfer;
  wire             cmt_gpio_out_s1_firsttransfer;
  wire             cmt_gpio_out_s1_grant_vector;
  wire             cmt_gpio_out_s1_in_a_read_cycle;
  wire             cmt_gpio_out_s1_in_a_write_cycle;
  wire             cmt_gpio_out_s1_master_qreq_vector;
  wire             cmt_gpio_out_s1_non_bursting_master_requests;
  wire    [ 31: 0] cmt_gpio_out_s1_readdata_from_sa;
  reg              cmt_gpio_out_s1_reg_firsttransfer;
  wire             cmt_gpio_out_s1_reset_n;
  reg              cmt_gpio_out_s1_slavearbiterlockenable;
  wire             cmt_gpio_out_s1_slavearbiterlockenable2;
  wire             cmt_gpio_out_s1_unreg_firsttransfer;
  wire             cmt_gpio_out_s1_waits_for_read;
  wire             cmt_gpio_out_s1_waits_for_write;
  wire             cmt_gpio_out_s1_write_n;
  wire    [ 31: 0] cmt_gpio_out_s1_writedata;
  reg              d1_cmt_gpio_out_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_cmt_gpio_out_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_cmt_gpio_out_s1;
  wire             nios2_data_master_qualified_request_cmt_gpio_out_s1;
  wire             nios2_data_master_read_data_valid_cmt_gpio_out_s1;
  wire             nios2_data_master_requests_cmt_gpio_out_s1;
  wire             nios2_data_master_saved_grant_cmt_gpio_out_s1;
  wire    [ 13: 0] shifted_address_to_cmt_gpio_out_s1_from_nios2_data_master;
  wire             wait_for_cmt_gpio_out_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_gpio_out_s1_end_xfer;
    end


  assign cmt_gpio_out_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_cmt_gpio_out_s1));
  //assign cmt_gpio_out_s1_readdata_from_sa = cmt_gpio_out_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_gpio_out_s1_readdata_from_sa = cmt_gpio_out_s1_readdata;

  assign nios2_data_master_requests_cmt_gpio_out_s1 = ({nios2_data_master_address_to_slave[13 : 4] , 4'b0} == 14'h50) & (nios2_data_master_read | nios2_data_master_write);
  //cmt_gpio_out_s1_arb_share_counter set values, which is an e_mux
  assign cmt_gpio_out_s1_arb_share_set_values = 1;

  //cmt_gpio_out_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_gpio_out_s1_non_bursting_master_requests = nios2_data_master_requests_cmt_gpio_out_s1;

  //cmt_gpio_out_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign cmt_gpio_out_s1_any_bursting_master_saved_grant = 0;

  //cmt_gpio_out_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign cmt_gpio_out_s1_arb_share_counter_next_value = cmt_gpio_out_s1_firsttransfer ? (cmt_gpio_out_s1_arb_share_set_values - 1) : |cmt_gpio_out_s1_arb_share_counter ? (cmt_gpio_out_s1_arb_share_counter - 1) : 0;

  //cmt_gpio_out_s1_allgrants all slave grants, which is an e_mux
  assign cmt_gpio_out_s1_allgrants = |cmt_gpio_out_s1_grant_vector;

  //cmt_gpio_out_s1_end_xfer assignment, which is an e_assign
  assign cmt_gpio_out_s1_end_xfer = ~(cmt_gpio_out_s1_waits_for_read | cmt_gpio_out_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_cmt_gpio_out_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_cmt_gpio_out_s1 = cmt_gpio_out_s1_end_xfer & (~cmt_gpio_out_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //cmt_gpio_out_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign cmt_gpio_out_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_cmt_gpio_out_s1 & cmt_gpio_out_s1_allgrants) | (end_xfer_arb_share_counter_term_cmt_gpio_out_s1 & ~cmt_gpio_out_s1_non_bursting_master_requests);

  //cmt_gpio_out_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_gpio_out_s1_arb_share_counter <= 0;
      else if (cmt_gpio_out_s1_arb_counter_enable)
          cmt_gpio_out_s1_arb_share_counter <= cmt_gpio_out_s1_arb_share_counter_next_value;
    end


  //cmt_gpio_out_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_gpio_out_s1_slavearbiterlockenable <= 0;
      else if ((|cmt_gpio_out_s1_master_qreq_vector & end_xfer_arb_share_counter_term_cmt_gpio_out_s1) | (end_xfer_arb_share_counter_term_cmt_gpio_out_s1 & ~cmt_gpio_out_s1_non_bursting_master_requests))
          cmt_gpio_out_s1_slavearbiterlockenable <= |cmt_gpio_out_s1_arb_share_counter_next_value;
    end


  //nios2/data_master cmt_gpio_out/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = cmt_gpio_out_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //cmt_gpio_out_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_gpio_out_s1_slavearbiterlockenable2 = |cmt_gpio_out_s1_arb_share_counter_next_value;

  //nios2/data_master cmt_gpio_out/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = cmt_gpio_out_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //cmt_gpio_out_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_gpio_out_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_cmt_gpio_out_s1 = nios2_data_master_requests_cmt_gpio_out_s1 & ~(((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //cmt_gpio_out_s1_writedata mux, which is an e_mux
  assign cmt_gpio_out_s1_writedata = nios2_data_master_writedata;

  //master is always granted when requested
  assign nios2_data_master_granted_cmt_gpio_out_s1 = nios2_data_master_qualified_request_cmt_gpio_out_s1;

  //nios2/data_master saved-grant cmt_gpio_out/s1, which is an e_assign
  assign nios2_data_master_saved_grant_cmt_gpio_out_s1 = nios2_data_master_requests_cmt_gpio_out_s1;

  //allow new arb cycle for cmt_gpio_out/s1, which is an e_assign
  assign cmt_gpio_out_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign cmt_gpio_out_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign cmt_gpio_out_s1_master_qreq_vector = 1;

  //cmt_gpio_out_s1_reset_n assignment, which is an e_assign
  assign cmt_gpio_out_s1_reset_n = reset_n;

  assign cmt_gpio_out_s1_chipselect = nios2_data_master_granted_cmt_gpio_out_s1;
  //cmt_gpio_out_s1_firsttransfer first transaction, which is an e_assign
  assign cmt_gpio_out_s1_firsttransfer = cmt_gpio_out_s1_begins_xfer ? cmt_gpio_out_s1_unreg_firsttransfer : cmt_gpio_out_s1_reg_firsttransfer;

  //cmt_gpio_out_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign cmt_gpio_out_s1_unreg_firsttransfer = ~(cmt_gpio_out_s1_slavearbiterlockenable & cmt_gpio_out_s1_any_continuerequest);

  //cmt_gpio_out_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cmt_gpio_out_s1_reg_firsttransfer <= 1'b1;
      else if (cmt_gpio_out_s1_begins_xfer)
          cmt_gpio_out_s1_reg_firsttransfer <= cmt_gpio_out_s1_unreg_firsttransfer;
    end


  //cmt_gpio_out_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cmt_gpio_out_s1_beginbursttransfer_internal = cmt_gpio_out_s1_begins_xfer;

  //~cmt_gpio_out_s1_write_n assignment, which is an e_mux
  assign cmt_gpio_out_s1_write_n = ~(nios2_data_master_granted_cmt_gpio_out_s1 & nios2_data_master_write);

  assign shifted_address_to_cmt_gpio_out_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //cmt_gpio_out_s1_address mux, which is an e_mux
  assign cmt_gpio_out_s1_address = shifted_address_to_cmt_gpio_out_s1_from_nios2_data_master >> 2;

  //d1_cmt_gpio_out_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cmt_gpio_out_s1_end_xfer <= 1;
      else 
        d1_cmt_gpio_out_s1_end_xfer <= cmt_gpio_out_s1_end_xfer;
    end


  //cmt_gpio_out_s1_waits_for_read in a cycle, which is an e_mux
  assign cmt_gpio_out_s1_waits_for_read = cmt_gpio_out_s1_in_a_read_cycle & cmt_gpio_out_s1_begins_xfer;

  //cmt_gpio_out_s1_in_a_read_cycle assignment, which is an e_assign
  assign cmt_gpio_out_s1_in_a_read_cycle = nios2_data_master_granted_cmt_gpio_out_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_gpio_out_s1_in_a_read_cycle;

  //cmt_gpio_out_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_gpio_out_s1_waits_for_write = cmt_gpio_out_s1_in_a_write_cycle & 0;

  //cmt_gpio_out_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_gpio_out_s1_in_a_write_cycle = nios2_data_master_granted_cmt_gpio_out_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cmt_gpio_out_s1_in_a_write_cycle;

  assign wait_for_cmt_gpio_out_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cmt_gpio_out/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gpio0_s1_arbitrator (
                             // inputs:
                              clk,
                              gpio0_s1_readdata,
                              nios2_data_master_address_to_slave,
                              nios2_data_master_read,
                              nios2_data_master_waitrequest,
                              nios2_data_master_write,
                              nios2_data_master_writedata,
                              reset_n,

                             // outputs:
                              d1_gpio0_s1_end_xfer,
                              gpio0_s1_address,
                              gpio0_s1_chipselect,
                              gpio0_s1_readdata_from_sa,
                              gpio0_s1_reset_n,
                              gpio0_s1_write_n,
                              gpio0_s1_writedata,
                              nios2_data_master_granted_gpio0_s1,
                              nios2_data_master_qualified_request_gpio0_s1,
                              nios2_data_master_read_data_valid_gpio0_s1,
                              nios2_data_master_requests_gpio0_s1
                           )
;

  output           d1_gpio0_s1_end_xfer;
  output  [  1: 0] gpio0_s1_address;
  output           gpio0_s1_chipselect;
  output  [ 31: 0] gpio0_s1_readdata_from_sa;
  output           gpio0_s1_reset_n;
  output           gpio0_s1_write_n;
  output  [ 31: 0] gpio0_s1_writedata;
  output           nios2_data_master_granted_gpio0_s1;
  output           nios2_data_master_qualified_request_gpio0_s1;
  output           nios2_data_master_read_data_valid_gpio0_s1;
  output           nios2_data_master_requests_gpio0_s1;
  input            clk;
  input   [ 31: 0] gpio0_s1_readdata;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            reset_n;

  reg              d1_gpio0_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_gpio0_s1;
  wire    [  1: 0] gpio0_s1_address;
  wire             gpio0_s1_allgrants;
  wire             gpio0_s1_allow_new_arb_cycle;
  wire             gpio0_s1_any_bursting_master_saved_grant;
  wire             gpio0_s1_any_continuerequest;
  wire             gpio0_s1_arb_counter_enable;
  reg              gpio0_s1_arb_share_counter;
  wire             gpio0_s1_arb_share_counter_next_value;
  wire             gpio0_s1_arb_share_set_values;
  wire             gpio0_s1_beginbursttransfer_internal;
  wire             gpio0_s1_begins_xfer;
  wire             gpio0_s1_chipselect;
  wire             gpio0_s1_end_xfer;
  wire             gpio0_s1_firsttransfer;
  wire             gpio0_s1_grant_vector;
  wire             gpio0_s1_in_a_read_cycle;
  wire             gpio0_s1_in_a_write_cycle;
  wire             gpio0_s1_master_qreq_vector;
  wire             gpio0_s1_non_bursting_master_requests;
  wire    [ 31: 0] gpio0_s1_readdata_from_sa;
  reg              gpio0_s1_reg_firsttransfer;
  wire             gpio0_s1_reset_n;
  reg              gpio0_s1_slavearbiterlockenable;
  wire             gpio0_s1_slavearbiterlockenable2;
  wire             gpio0_s1_unreg_firsttransfer;
  wire             gpio0_s1_waits_for_read;
  wire             gpio0_s1_waits_for_write;
  wire             gpio0_s1_write_n;
  wire    [ 31: 0] gpio0_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_gpio0_s1;
  wire             nios2_data_master_qualified_request_gpio0_s1;
  wire             nios2_data_master_read_data_valid_gpio0_s1;
  wire             nios2_data_master_requests_gpio0_s1;
  wire             nios2_data_master_saved_grant_gpio0_s1;
  wire    [ 13: 0] shifted_address_to_gpio0_s1_from_nios2_data_master;
  wire             wait_for_gpio0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~gpio0_s1_end_xfer;
    end


  assign gpio0_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_gpio0_s1));
  //assign gpio0_s1_readdata_from_sa = gpio0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign gpio0_s1_readdata_from_sa = gpio0_s1_readdata;

  assign nios2_data_master_requests_gpio0_s1 = ({nios2_data_master_address_to_slave[13 : 4] , 4'b0} == 14'h0) & (nios2_data_master_read | nios2_data_master_write);
  //gpio0_s1_arb_share_counter set values, which is an e_mux
  assign gpio0_s1_arb_share_set_values = 1;

  //gpio0_s1_non_bursting_master_requests mux, which is an e_mux
  assign gpio0_s1_non_bursting_master_requests = nios2_data_master_requests_gpio0_s1;

  //gpio0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign gpio0_s1_any_bursting_master_saved_grant = 0;

  //gpio0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign gpio0_s1_arb_share_counter_next_value = gpio0_s1_firsttransfer ? (gpio0_s1_arb_share_set_values - 1) : |gpio0_s1_arb_share_counter ? (gpio0_s1_arb_share_counter - 1) : 0;

  //gpio0_s1_allgrants all slave grants, which is an e_mux
  assign gpio0_s1_allgrants = |gpio0_s1_grant_vector;

  //gpio0_s1_end_xfer assignment, which is an e_assign
  assign gpio0_s1_end_xfer = ~(gpio0_s1_waits_for_read | gpio0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_gpio0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_gpio0_s1 = gpio0_s1_end_xfer & (~gpio0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //gpio0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign gpio0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_gpio0_s1 & gpio0_s1_allgrants) | (end_xfer_arb_share_counter_term_gpio0_s1 & ~gpio0_s1_non_bursting_master_requests);

  //gpio0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gpio0_s1_arb_share_counter <= 0;
      else if (gpio0_s1_arb_counter_enable)
          gpio0_s1_arb_share_counter <= gpio0_s1_arb_share_counter_next_value;
    end


  //gpio0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gpio0_s1_slavearbiterlockenable <= 0;
      else if ((|gpio0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_gpio0_s1) | (end_xfer_arb_share_counter_term_gpio0_s1 & ~gpio0_s1_non_bursting_master_requests))
          gpio0_s1_slavearbiterlockenable <= |gpio0_s1_arb_share_counter_next_value;
    end


  //nios2/data_master gpio0/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = gpio0_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //gpio0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign gpio0_s1_slavearbiterlockenable2 = |gpio0_s1_arb_share_counter_next_value;

  //nios2/data_master gpio0/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = gpio0_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //gpio0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign gpio0_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_gpio0_s1 = nios2_data_master_requests_gpio0_s1 & ~(((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //gpio0_s1_writedata mux, which is an e_mux
  assign gpio0_s1_writedata = nios2_data_master_writedata;

  //master is always granted when requested
  assign nios2_data_master_granted_gpio0_s1 = nios2_data_master_qualified_request_gpio0_s1;

  //nios2/data_master saved-grant gpio0/s1, which is an e_assign
  assign nios2_data_master_saved_grant_gpio0_s1 = nios2_data_master_requests_gpio0_s1;

  //allow new arb cycle for gpio0/s1, which is an e_assign
  assign gpio0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign gpio0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign gpio0_s1_master_qreq_vector = 1;

  //gpio0_s1_reset_n assignment, which is an e_assign
  assign gpio0_s1_reset_n = reset_n;

  assign gpio0_s1_chipselect = nios2_data_master_granted_gpio0_s1;
  //gpio0_s1_firsttransfer first transaction, which is an e_assign
  assign gpio0_s1_firsttransfer = gpio0_s1_begins_xfer ? gpio0_s1_unreg_firsttransfer : gpio0_s1_reg_firsttransfer;

  //gpio0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign gpio0_s1_unreg_firsttransfer = ~(gpio0_s1_slavearbiterlockenable & gpio0_s1_any_continuerequest);

  //gpio0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gpio0_s1_reg_firsttransfer <= 1'b1;
      else if (gpio0_s1_begins_xfer)
          gpio0_s1_reg_firsttransfer <= gpio0_s1_unreg_firsttransfer;
    end


  //gpio0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign gpio0_s1_beginbursttransfer_internal = gpio0_s1_begins_xfer;

  //~gpio0_s1_write_n assignment, which is an e_mux
  assign gpio0_s1_write_n = ~(nios2_data_master_granted_gpio0_s1 & nios2_data_master_write);

  assign shifted_address_to_gpio0_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //gpio0_s1_address mux, which is an e_mux
  assign gpio0_s1_address = shifted_address_to_gpio0_s1_from_nios2_data_master >> 2;

  //d1_gpio0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_gpio0_s1_end_xfer <= 1;
      else 
        d1_gpio0_s1_end_xfer <= gpio0_s1_end_xfer;
    end


  //gpio0_s1_waits_for_read in a cycle, which is an e_mux
  assign gpio0_s1_waits_for_read = gpio0_s1_in_a_read_cycle & gpio0_s1_begins_xfer;

  //gpio0_s1_in_a_read_cycle assignment, which is an e_assign
  assign gpio0_s1_in_a_read_cycle = nios2_data_master_granted_gpio0_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = gpio0_s1_in_a_read_cycle;

  //gpio0_s1_waits_for_write in a cycle, which is an e_mux
  assign gpio0_s1_waits_for_write = gpio0_s1_in_a_write_cycle & 0;

  //gpio0_s1_in_a_write_cycle assignment, which is an e_assign
  assign gpio0_s1_in_a_write_cycle = nios2_data_master_granted_gpio0_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = gpio0_s1_in_a_write_cycle;

  assign wait_for_gpio0_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //gpio0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gpio1_s1_arbitrator (
                             // inputs:
                              clk,
                              gpio1_s1_readdata,
                              nios2_data_master_address_to_slave,
                              nios2_data_master_read,
                              nios2_data_master_write,
                              reset_n,

                             // outputs:
                              d1_gpio1_s1_end_xfer,
                              gpio1_s1_address,
                              gpio1_s1_readdata_from_sa,
                              gpio1_s1_reset_n,
                              nios2_data_master_granted_gpio1_s1,
                              nios2_data_master_qualified_request_gpio1_s1,
                              nios2_data_master_read_data_valid_gpio1_s1,
                              nios2_data_master_requests_gpio1_s1
                           )
;

  output           d1_gpio1_s1_end_xfer;
  output  [  1: 0] gpio1_s1_address;
  output  [ 31: 0] gpio1_s1_readdata_from_sa;
  output           gpio1_s1_reset_n;
  output           nios2_data_master_granted_gpio1_s1;
  output           nios2_data_master_qualified_request_gpio1_s1;
  output           nios2_data_master_read_data_valid_gpio1_s1;
  output           nios2_data_master_requests_gpio1_s1;
  input            clk;
  input   [ 31: 0] gpio1_s1_readdata;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_write;
  input            reset_n;

  reg              d1_gpio1_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_gpio1_s1;
  wire    [  1: 0] gpio1_s1_address;
  wire             gpio1_s1_allgrants;
  wire             gpio1_s1_allow_new_arb_cycle;
  wire             gpio1_s1_any_bursting_master_saved_grant;
  wire             gpio1_s1_any_continuerequest;
  wire             gpio1_s1_arb_counter_enable;
  reg              gpio1_s1_arb_share_counter;
  wire             gpio1_s1_arb_share_counter_next_value;
  wire             gpio1_s1_arb_share_set_values;
  wire             gpio1_s1_beginbursttransfer_internal;
  wire             gpio1_s1_begins_xfer;
  wire             gpio1_s1_end_xfer;
  wire             gpio1_s1_firsttransfer;
  wire             gpio1_s1_grant_vector;
  wire             gpio1_s1_in_a_read_cycle;
  wire             gpio1_s1_in_a_write_cycle;
  wire             gpio1_s1_master_qreq_vector;
  wire             gpio1_s1_non_bursting_master_requests;
  wire    [ 31: 0] gpio1_s1_readdata_from_sa;
  reg              gpio1_s1_reg_firsttransfer;
  wire             gpio1_s1_reset_n;
  reg              gpio1_s1_slavearbiterlockenable;
  wire             gpio1_s1_slavearbiterlockenable2;
  wire             gpio1_s1_unreg_firsttransfer;
  wire             gpio1_s1_waits_for_read;
  wire             gpio1_s1_waits_for_write;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_gpio1_s1;
  wire             nios2_data_master_qualified_request_gpio1_s1;
  wire             nios2_data_master_read_data_valid_gpio1_s1;
  wire             nios2_data_master_requests_gpio1_s1;
  wire             nios2_data_master_saved_grant_gpio1_s1;
  wire    [ 13: 0] shifted_address_to_gpio1_s1_from_nios2_data_master;
  wire             wait_for_gpio1_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~gpio1_s1_end_xfer;
    end


  assign gpio1_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_gpio1_s1));
  //assign gpio1_s1_readdata_from_sa = gpio1_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign gpio1_s1_readdata_from_sa = gpio1_s1_readdata;

  assign nios2_data_master_requests_gpio1_s1 = (({nios2_data_master_address_to_slave[13 : 4] , 4'b0} == 14'h10) & (nios2_data_master_read | nios2_data_master_write)) & nios2_data_master_read;
  //gpio1_s1_arb_share_counter set values, which is an e_mux
  assign gpio1_s1_arb_share_set_values = 1;

  //gpio1_s1_non_bursting_master_requests mux, which is an e_mux
  assign gpio1_s1_non_bursting_master_requests = nios2_data_master_requests_gpio1_s1;

  //gpio1_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign gpio1_s1_any_bursting_master_saved_grant = 0;

  //gpio1_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign gpio1_s1_arb_share_counter_next_value = gpio1_s1_firsttransfer ? (gpio1_s1_arb_share_set_values - 1) : |gpio1_s1_arb_share_counter ? (gpio1_s1_arb_share_counter - 1) : 0;

  //gpio1_s1_allgrants all slave grants, which is an e_mux
  assign gpio1_s1_allgrants = |gpio1_s1_grant_vector;

  //gpio1_s1_end_xfer assignment, which is an e_assign
  assign gpio1_s1_end_xfer = ~(gpio1_s1_waits_for_read | gpio1_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_gpio1_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_gpio1_s1 = gpio1_s1_end_xfer & (~gpio1_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //gpio1_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign gpio1_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_gpio1_s1 & gpio1_s1_allgrants) | (end_xfer_arb_share_counter_term_gpio1_s1 & ~gpio1_s1_non_bursting_master_requests);

  //gpio1_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gpio1_s1_arb_share_counter <= 0;
      else if (gpio1_s1_arb_counter_enable)
          gpio1_s1_arb_share_counter <= gpio1_s1_arb_share_counter_next_value;
    end


  //gpio1_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gpio1_s1_slavearbiterlockenable <= 0;
      else if ((|gpio1_s1_master_qreq_vector & end_xfer_arb_share_counter_term_gpio1_s1) | (end_xfer_arb_share_counter_term_gpio1_s1 & ~gpio1_s1_non_bursting_master_requests))
          gpio1_s1_slavearbiterlockenable <= |gpio1_s1_arb_share_counter_next_value;
    end


  //nios2/data_master gpio1/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = gpio1_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //gpio1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign gpio1_s1_slavearbiterlockenable2 = |gpio1_s1_arb_share_counter_next_value;

  //nios2/data_master gpio1/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = gpio1_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //gpio1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign gpio1_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_gpio1_s1 = nios2_data_master_requests_gpio1_s1;
  //master is always granted when requested
  assign nios2_data_master_granted_gpio1_s1 = nios2_data_master_qualified_request_gpio1_s1;

  //nios2/data_master saved-grant gpio1/s1, which is an e_assign
  assign nios2_data_master_saved_grant_gpio1_s1 = nios2_data_master_requests_gpio1_s1;

  //allow new arb cycle for gpio1/s1, which is an e_assign
  assign gpio1_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign gpio1_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign gpio1_s1_master_qreq_vector = 1;

  //gpio1_s1_reset_n assignment, which is an e_assign
  assign gpio1_s1_reset_n = reset_n;

  //gpio1_s1_firsttransfer first transaction, which is an e_assign
  assign gpio1_s1_firsttransfer = gpio1_s1_begins_xfer ? gpio1_s1_unreg_firsttransfer : gpio1_s1_reg_firsttransfer;

  //gpio1_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign gpio1_s1_unreg_firsttransfer = ~(gpio1_s1_slavearbiterlockenable & gpio1_s1_any_continuerequest);

  //gpio1_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gpio1_s1_reg_firsttransfer <= 1'b1;
      else if (gpio1_s1_begins_xfer)
          gpio1_s1_reg_firsttransfer <= gpio1_s1_unreg_firsttransfer;
    end


  //gpio1_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign gpio1_s1_beginbursttransfer_internal = gpio1_s1_begins_xfer;

  assign shifted_address_to_gpio1_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //gpio1_s1_address mux, which is an e_mux
  assign gpio1_s1_address = shifted_address_to_gpio1_s1_from_nios2_data_master >> 2;

  //d1_gpio1_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_gpio1_s1_end_xfer <= 1;
      else 
        d1_gpio1_s1_end_xfer <= gpio1_s1_end_xfer;
    end


  //gpio1_s1_waits_for_read in a cycle, which is an e_mux
  assign gpio1_s1_waits_for_read = gpio1_s1_in_a_read_cycle & gpio1_s1_begins_xfer;

  //gpio1_s1_in_a_read_cycle assignment, which is an e_assign
  assign gpio1_s1_in_a_read_cycle = nios2_data_master_granted_gpio1_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = gpio1_s1_in_a_read_cycle;

  //gpio1_s1_waits_for_write in a cycle, which is an e_mux
  assign gpio1_s1_waits_for_write = gpio1_s1_in_a_write_cycle & 0;

  //gpio1_s1_in_a_write_cycle assignment, which is an e_assign
  assign gpio1_s1_in_a_write_cycle = nios2_data_master_granted_gpio1_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = gpio1_s1_in_a_write_cycle;

  assign wait_for_gpio1_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //gpio1/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_avalon_jtag_slave_arbitrator (
                                                // inputs:
                                                 clk,
                                                 jtag_uart_avalon_jtag_slave_dataavailable,
                                                 jtag_uart_avalon_jtag_slave_irq,
                                                 jtag_uart_avalon_jtag_slave_readdata,
                                                 jtag_uart_avalon_jtag_slave_readyfordata,
                                                 jtag_uart_avalon_jtag_slave_waitrequest,
                                                 nios2_data_master_address_to_slave,
                                                 nios2_data_master_read,
                                                 nios2_data_master_waitrequest,
                                                 nios2_data_master_write,
                                                 nios2_data_master_writedata,
                                                 reset_n,

                                                // outputs:
                                                 d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                                 jtag_uart_avalon_jtag_slave_address,
                                                 jtag_uart_avalon_jtag_slave_chipselect,
                                                 jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
                                                 jtag_uart_avalon_jtag_slave_irq_from_sa,
                                                 jtag_uart_avalon_jtag_slave_read_n,
                                                 jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_reset_n,
                                                 jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                                 jtag_uart_avalon_jtag_slave_write_n,
                                                 jtag_uart_avalon_jtag_slave_writedata,
                                                 nios2_data_master_granted_jtag_uart_avalon_jtag_slave,
                                                 nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                                 nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                                 nios2_data_master_requests_jtag_uart_avalon_jtag_slave
                                              )
;

  output           d1_jtag_uart_avalon_jtag_slave_end_xfer;
  output           jtag_uart_avalon_jtag_slave_address;
  output           jtag_uart_avalon_jtag_slave_chipselect;
  output           jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_avalon_jtag_slave_reset_n;
  output           jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  output           nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  output           nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  output           nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  output           nios2_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            clk;
  input            jtag_uart_avalon_jtag_slave_dataavailable;
  input            jtag_uart_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  input            jtag_uart_avalon_jtag_slave_readyfordata;
  input            jtag_uart_avalon_jtag_slave_waitrequest;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            reset_n;

  reg              d1_jtag_uart_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_allgrants;
  wire             jtag_uart_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_avalon_jtag_slave_arb_counter_enable;
  reg              jtag_uart_avalon_jtag_slave_arb_share_counter;
  wire             jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  wire             jtag_uart_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  reg              jtag_uart_avalon_jtag_slave_reg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  reg              jtag_uart_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_saved_grant_jtag_uart_avalon_jtag_slave;
  wire    [ 13: 0] shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios2_data_master;
  wire             wait_for_jtag_uart_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~jtag_uart_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave));
  //assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata;

  assign nios2_data_master_requests_jtag_uart_avalon_jtag_slave = ({nios2_data_master_address_to_slave[13 : 3] , 3'b0} == 14'h20) & (nios2_data_master_read | nios2_data_master_write);
  //assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest;

  //jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_non_bursting_master_requests = nios2_data_master_requests_jtag_uart_avalon_jtag_slave;

  //jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_avalon_jtag_slave_firsttransfer ? (jtag_uart_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_avalon_jtag_slave_arb_share_counter ? (jtag_uart_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_allgrants = |jtag_uart_avalon_jtag_slave_grant_vector;

  //jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_end_xfer = ~(jtag_uart_avalon_jtag_slave_waits_for_read | jtag_uart_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave = jtag_uart_avalon_jtag_slave_end_xfer & (~jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & jtag_uart_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //nios2/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = jtag_uart_avalon_jtag_slave_slavearbiterlockenable & nios2_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;

  //nios2/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave = nios2_data_master_requests_jtag_uart_avalon_jtag_slave & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_writedata = nios2_data_master_writedata;

  //master is always granted when requested
  assign nios2_data_master_granted_jtag_uart_avalon_jtag_slave = nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;

  //nios2/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  assign nios2_data_master_saved_grant_jtag_uart_avalon_jtag_slave = nios2_data_master_requests_jtag_uart_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_avalon_jtag_slave_chipselect = nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  //jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_firsttransfer = jtag_uart_avalon_jtag_slave_begins_xfer ? jtag_uart_avalon_jtag_slave_unreg_firsttransfer : jtag_uart_avalon_jtag_slave_reg_firsttransfer;

  //jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_unreg_firsttransfer = ~(jtag_uart_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= 1'b1;
      else if (jtag_uart_avalon_jtag_slave_begins_xfer)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
    end


  //jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_read_n = ~(nios2_data_master_granted_jtag_uart_avalon_jtag_slave & nios2_data_master_read);

  //~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_write_n = ~(nios2_data_master_granted_jtag_uart_avalon_jtag_slave & nios2_data_master_write);

  assign shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios2_data_master = nios2_data_master_address_to_slave;
  //jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_address = shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios2_data_master >> 2;

  //d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_avalon_jtag_slave_end_xfer <= 1;
      else 
        d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_read = jtag_uart_avalon_jtag_slave_in_a_read_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_read_cycle = nios2_data_master_granted_jtag_uart_avalon_jtag_slave & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_write = jtag_uart_avalon_jtag_slave_in_a_write_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_write_cycle = nios2_data_master_granted_jtag_uart_avalon_jtag_slave & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_jtag_debug_module_arbitrator (
                                            // inputs:
                                             clk,
                                             nios2_data_master_address_to_slave,
                                             nios2_data_master_byteenable,
                                             nios2_data_master_debugaccess,
                                             nios2_data_master_read,
                                             nios2_data_master_waitrequest,
                                             nios2_data_master_write,
                                             nios2_data_master_writedata,
                                             nios2_instruction_master_address_to_slave,
                                             nios2_instruction_master_read,
                                             nios2_jtag_debug_module_readdata,
                                             nios2_jtag_debug_module_resetrequest,
                                             reset_n,

                                            // outputs:
                                             d1_nios2_jtag_debug_module_end_xfer,
                                             nios2_data_master_granted_nios2_jtag_debug_module,
                                             nios2_data_master_qualified_request_nios2_jtag_debug_module,
                                             nios2_data_master_read_data_valid_nios2_jtag_debug_module,
                                             nios2_data_master_requests_nios2_jtag_debug_module,
                                             nios2_instruction_master_granted_nios2_jtag_debug_module,
                                             nios2_instruction_master_qualified_request_nios2_jtag_debug_module,
                                             nios2_instruction_master_read_data_valid_nios2_jtag_debug_module,
                                             nios2_instruction_master_requests_nios2_jtag_debug_module,
                                             nios2_jtag_debug_module_address,
                                             nios2_jtag_debug_module_begintransfer,
                                             nios2_jtag_debug_module_byteenable,
                                             nios2_jtag_debug_module_chipselect,
                                             nios2_jtag_debug_module_debugaccess,
                                             nios2_jtag_debug_module_readdata_from_sa,
                                             nios2_jtag_debug_module_reset_n,
                                             nios2_jtag_debug_module_resetrequest_from_sa,
                                             nios2_jtag_debug_module_write,
                                             nios2_jtag_debug_module_writedata
                                          )
;

  output           d1_nios2_jtag_debug_module_end_xfer;
  output           nios2_data_master_granted_nios2_jtag_debug_module;
  output           nios2_data_master_qualified_request_nios2_jtag_debug_module;
  output           nios2_data_master_read_data_valid_nios2_jtag_debug_module;
  output           nios2_data_master_requests_nios2_jtag_debug_module;
  output           nios2_instruction_master_granted_nios2_jtag_debug_module;
  output           nios2_instruction_master_qualified_request_nios2_jtag_debug_module;
  output           nios2_instruction_master_read_data_valid_nios2_jtag_debug_module;
  output           nios2_instruction_master_requests_nios2_jtag_debug_module;
  output  [  8: 0] nios2_jtag_debug_module_address;
  output           nios2_jtag_debug_module_begintransfer;
  output  [  3: 0] nios2_jtag_debug_module_byteenable;
  output           nios2_jtag_debug_module_chipselect;
  output           nios2_jtag_debug_module_debugaccess;
  output  [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  output           nios2_jtag_debug_module_reset_n;
  output           nios2_jtag_debug_module_resetrequest_from_sa;
  output           nios2_jtag_debug_module_write;
  output  [ 31: 0] nios2_jtag_debug_module_writedata;
  input            clk;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_debugaccess;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input   [ 13: 0] nios2_instruction_master_address_to_slave;
  input            nios2_instruction_master_read;
  input   [ 31: 0] nios2_jtag_debug_module_readdata;
  input            nios2_jtag_debug_module_resetrequest;
  input            reset_n;

  reg              d1_nios2_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_nios2_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios2_data_master_granted_slave_nios2_jtag_debug_module;
  reg              last_cycle_nios2_instruction_master_granted_slave_nios2_jtag_debug_module;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_nios2_jtag_debug_module;
  wire             nios2_data_master_qualified_request_nios2_jtag_debug_module;
  wire             nios2_data_master_read_data_valid_nios2_jtag_debug_module;
  wire             nios2_data_master_requests_nios2_jtag_debug_module;
  wire             nios2_data_master_saved_grant_nios2_jtag_debug_module;
  wire             nios2_instruction_master_arbiterlock;
  wire             nios2_instruction_master_arbiterlock2;
  wire             nios2_instruction_master_continuerequest;
  wire             nios2_instruction_master_granted_nios2_jtag_debug_module;
  wire             nios2_instruction_master_qualified_request_nios2_jtag_debug_module;
  wire             nios2_instruction_master_read_data_valid_nios2_jtag_debug_module;
  wire             nios2_instruction_master_requests_nios2_jtag_debug_module;
  wire             nios2_instruction_master_saved_grant_nios2_jtag_debug_module;
  wire    [  8: 0] nios2_jtag_debug_module_address;
  wire             nios2_jtag_debug_module_allgrants;
  wire             nios2_jtag_debug_module_allow_new_arb_cycle;
  wire             nios2_jtag_debug_module_any_bursting_master_saved_grant;
  wire             nios2_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] nios2_jtag_debug_module_arb_addend;
  wire             nios2_jtag_debug_module_arb_counter_enable;
  reg              nios2_jtag_debug_module_arb_share_counter;
  wire             nios2_jtag_debug_module_arb_share_counter_next_value;
  wire             nios2_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] nios2_jtag_debug_module_arb_winner;
  wire             nios2_jtag_debug_module_arbitration_holdoff_internal;
  wire             nios2_jtag_debug_module_beginbursttransfer_internal;
  wire             nios2_jtag_debug_module_begins_xfer;
  wire             nios2_jtag_debug_module_begintransfer;
  wire    [  3: 0] nios2_jtag_debug_module_byteenable;
  wire             nios2_jtag_debug_module_chipselect;
  wire    [  3: 0] nios2_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] nios2_jtag_debug_module_chosen_master_rot_left;
  wire             nios2_jtag_debug_module_debugaccess;
  wire             nios2_jtag_debug_module_end_xfer;
  wire             nios2_jtag_debug_module_firsttransfer;
  wire    [  1: 0] nios2_jtag_debug_module_grant_vector;
  wire             nios2_jtag_debug_module_in_a_read_cycle;
  wire             nios2_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] nios2_jtag_debug_module_master_qreq_vector;
  wire             nios2_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  reg              nios2_jtag_debug_module_reg_firsttransfer;
  wire             nios2_jtag_debug_module_reset_n;
  wire             nios2_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] nios2_jtag_debug_module_saved_chosen_master_vector;
  reg              nios2_jtag_debug_module_slavearbiterlockenable;
  wire             nios2_jtag_debug_module_slavearbiterlockenable2;
  wire             nios2_jtag_debug_module_unreg_firsttransfer;
  wire             nios2_jtag_debug_module_waits_for_read;
  wire             nios2_jtag_debug_module_waits_for_write;
  wire             nios2_jtag_debug_module_write;
  wire    [ 31: 0] nios2_jtag_debug_module_writedata;
  wire    [ 13: 0] shifted_address_to_nios2_jtag_debug_module_from_nios2_data_master;
  wire    [ 13: 0] shifted_address_to_nios2_jtag_debug_module_from_nios2_instruction_master;
  wire             wait_for_nios2_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~nios2_jtag_debug_module_end_xfer;
    end


  assign nios2_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_nios2_jtag_debug_module | nios2_instruction_master_qualified_request_nios2_jtag_debug_module));
  //assign nios2_jtag_debug_module_readdata_from_sa = nios2_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_jtag_debug_module_readdata_from_sa = nios2_jtag_debug_module_readdata;

  assign nios2_data_master_requests_nios2_jtag_debug_module = ({nios2_data_master_address_to_slave[13 : 11] , 11'b0} == 14'h800) & (nios2_data_master_read | nios2_data_master_write);
  //nios2_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign nios2_jtag_debug_module_arb_share_set_values = 1;

  //nios2_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign nios2_jtag_debug_module_non_bursting_master_requests = nios2_data_master_requests_nios2_jtag_debug_module |
    nios2_instruction_master_requests_nios2_jtag_debug_module |
    nios2_data_master_requests_nios2_jtag_debug_module |
    nios2_instruction_master_requests_nios2_jtag_debug_module;

  //nios2_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign nios2_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //nios2_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign nios2_jtag_debug_module_arb_share_counter_next_value = nios2_jtag_debug_module_firsttransfer ? (nios2_jtag_debug_module_arb_share_set_values - 1) : |nios2_jtag_debug_module_arb_share_counter ? (nios2_jtag_debug_module_arb_share_counter - 1) : 0;

  //nios2_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign nios2_jtag_debug_module_allgrants = (|nios2_jtag_debug_module_grant_vector) |
    (|nios2_jtag_debug_module_grant_vector) |
    (|nios2_jtag_debug_module_grant_vector) |
    (|nios2_jtag_debug_module_grant_vector);

  //nios2_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign nios2_jtag_debug_module_end_xfer = ~(nios2_jtag_debug_module_waits_for_read | nios2_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_nios2_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_nios2_jtag_debug_module = nios2_jtag_debug_module_end_xfer & (~nios2_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //nios2_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign nios2_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_nios2_jtag_debug_module & nios2_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_nios2_jtag_debug_module & ~nios2_jtag_debug_module_non_bursting_master_requests);

  //nios2_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_jtag_debug_module_arb_share_counter <= 0;
      else if (nios2_jtag_debug_module_arb_counter_enable)
          nios2_jtag_debug_module_arb_share_counter <= nios2_jtag_debug_module_arb_share_counter_next_value;
    end


  //nios2_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|nios2_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_nios2_jtag_debug_module) | (end_xfer_arb_share_counter_term_nios2_jtag_debug_module & ~nios2_jtag_debug_module_non_bursting_master_requests))
          nios2_jtag_debug_module_slavearbiterlockenable <= |nios2_jtag_debug_module_arb_share_counter_next_value;
    end


  //nios2/data_master nios2/jtag_debug_module arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = nios2_jtag_debug_module_slavearbiterlockenable & nios2_data_master_continuerequest;

  //nios2_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign nios2_jtag_debug_module_slavearbiterlockenable2 = |nios2_jtag_debug_module_arb_share_counter_next_value;

  //nios2/data_master nios2/jtag_debug_module arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = nios2_jtag_debug_module_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //nios2/instruction_master nios2/jtag_debug_module arbiterlock, which is an e_assign
  assign nios2_instruction_master_arbiterlock = nios2_jtag_debug_module_slavearbiterlockenable & nios2_instruction_master_continuerequest;

  //nios2/instruction_master nios2/jtag_debug_module arbiterlock2, which is an e_assign
  assign nios2_instruction_master_arbiterlock2 = nios2_jtag_debug_module_slavearbiterlockenable2 & nios2_instruction_master_continuerequest;

  //nios2/instruction_master granted nios2/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_instruction_master_granted_slave_nios2_jtag_debug_module <= 0;
      else 
        last_cycle_nios2_instruction_master_granted_slave_nios2_jtag_debug_module <= nios2_instruction_master_saved_grant_nios2_jtag_debug_module ? 1 : (nios2_jtag_debug_module_arbitration_holdoff_internal | ~nios2_instruction_master_requests_nios2_jtag_debug_module) ? 0 : last_cycle_nios2_instruction_master_granted_slave_nios2_jtag_debug_module;
    end


  //nios2_instruction_master_continuerequest continued request, which is an e_mux
  assign nios2_instruction_master_continuerequest = last_cycle_nios2_instruction_master_granted_slave_nios2_jtag_debug_module & nios2_instruction_master_requests_nios2_jtag_debug_module;

  //nios2_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign nios2_jtag_debug_module_any_continuerequest = nios2_instruction_master_continuerequest |
    nios2_data_master_continuerequest;

  assign nios2_data_master_qualified_request_nios2_jtag_debug_module = nios2_data_master_requests_nios2_jtag_debug_module & ~(((~nios2_data_master_waitrequest) & nios2_data_master_write) | nios2_instruction_master_arbiterlock);
  //nios2_jtag_debug_module_writedata mux, which is an e_mux
  assign nios2_jtag_debug_module_writedata = nios2_data_master_writedata;

  assign nios2_instruction_master_requests_nios2_jtag_debug_module = (({nios2_instruction_master_address_to_slave[13 : 11] , 11'b0} == 14'h800) & (nios2_instruction_master_read)) & nios2_instruction_master_read;
  //nios2/data_master granted nios2/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_data_master_granted_slave_nios2_jtag_debug_module <= 0;
      else 
        last_cycle_nios2_data_master_granted_slave_nios2_jtag_debug_module <= nios2_data_master_saved_grant_nios2_jtag_debug_module ? 1 : (nios2_jtag_debug_module_arbitration_holdoff_internal | ~nios2_data_master_requests_nios2_jtag_debug_module) ? 0 : last_cycle_nios2_data_master_granted_slave_nios2_jtag_debug_module;
    end


  //nios2_data_master_continuerequest continued request, which is an e_mux
  assign nios2_data_master_continuerequest = last_cycle_nios2_data_master_granted_slave_nios2_jtag_debug_module & nios2_data_master_requests_nios2_jtag_debug_module;

  assign nios2_instruction_master_qualified_request_nios2_jtag_debug_module = nios2_instruction_master_requests_nios2_jtag_debug_module & ~(nios2_data_master_arbiterlock);
  //allow new arb cycle for nios2/jtag_debug_module, which is an e_assign
  assign nios2_jtag_debug_module_allow_new_arb_cycle = ~nios2_data_master_arbiterlock & ~nios2_instruction_master_arbiterlock;

  //nios2/instruction_master assignment into master qualified-requests vector for nios2/jtag_debug_module, which is an e_assign
  assign nios2_jtag_debug_module_master_qreq_vector[0] = nios2_instruction_master_qualified_request_nios2_jtag_debug_module;

  //nios2/instruction_master grant nios2/jtag_debug_module, which is an e_assign
  assign nios2_instruction_master_granted_nios2_jtag_debug_module = nios2_jtag_debug_module_grant_vector[0];

  //nios2/instruction_master saved-grant nios2/jtag_debug_module, which is an e_assign
  assign nios2_instruction_master_saved_grant_nios2_jtag_debug_module = nios2_jtag_debug_module_arb_winner[0] && nios2_instruction_master_requests_nios2_jtag_debug_module;

  //nios2/data_master assignment into master qualified-requests vector for nios2/jtag_debug_module, which is an e_assign
  assign nios2_jtag_debug_module_master_qreq_vector[1] = nios2_data_master_qualified_request_nios2_jtag_debug_module;

  //nios2/data_master grant nios2/jtag_debug_module, which is an e_assign
  assign nios2_data_master_granted_nios2_jtag_debug_module = nios2_jtag_debug_module_grant_vector[1];

  //nios2/data_master saved-grant nios2/jtag_debug_module, which is an e_assign
  assign nios2_data_master_saved_grant_nios2_jtag_debug_module = nios2_jtag_debug_module_arb_winner[1] && nios2_data_master_requests_nios2_jtag_debug_module;

  //nios2/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign nios2_jtag_debug_module_chosen_master_double_vector = {nios2_jtag_debug_module_master_qreq_vector, nios2_jtag_debug_module_master_qreq_vector} & ({~nios2_jtag_debug_module_master_qreq_vector, ~nios2_jtag_debug_module_master_qreq_vector} + nios2_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign nios2_jtag_debug_module_arb_winner = (nios2_jtag_debug_module_allow_new_arb_cycle & | nios2_jtag_debug_module_grant_vector) ? nios2_jtag_debug_module_grant_vector : nios2_jtag_debug_module_saved_chosen_master_vector;

  //saved nios2_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (nios2_jtag_debug_module_allow_new_arb_cycle)
          nios2_jtag_debug_module_saved_chosen_master_vector <= |nios2_jtag_debug_module_grant_vector ? nios2_jtag_debug_module_grant_vector : nios2_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign nios2_jtag_debug_module_grant_vector = {(nios2_jtag_debug_module_chosen_master_double_vector[1] | nios2_jtag_debug_module_chosen_master_double_vector[3]),
    (nios2_jtag_debug_module_chosen_master_double_vector[0] | nios2_jtag_debug_module_chosen_master_double_vector[2])};

  //nios2/jtag_debug_module chosen master rotated left, which is an e_assign
  assign nios2_jtag_debug_module_chosen_master_rot_left = (nios2_jtag_debug_module_arb_winner << 1) ? (nios2_jtag_debug_module_arb_winner << 1) : 1;

  //nios2/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_jtag_debug_module_arb_addend <= 1;
      else if (|nios2_jtag_debug_module_grant_vector)
          nios2_jtag_debug_module_arb_addend <= nios2_jtag_debug_module_end_xfer? nios2_jtag_debug_module_chosen_master_rot_left : nios2_jtag_debug_module_grant_vector;
    end


  assign nios2_jtag_debug_module_begintransfer = nios2_jtag_debug_module_begins_xfer;
  //nios2_jtag_debug_module_reset_n assignment, which is an e_assign
  assign nios2_jtag_debug_module_reset_n = reset_n;

  //assign nios2_jtag_debug_module_resetrequest_from_sa = nios2_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios2_jtag_debug_module_resetrequest_from_sa = nios2_jtag_debug_module_resetrequest;

  assign nios2_jtag_debug_module_chipselect = nios2_data_master_granted_nios2_jtag_debug_module | nios2_instruction_master_granted_nios2_jtag_debug_module;
  //nios2_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign nios2_jtag_debug_module_firsttransfer = nios2_jtag_debug_module_begins_xfer ? nios2_jtag_debug_module_unreg_firsttransfer : nios2_jtag_debug_module_reg_firsttransfer;

  //nios2_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  assign nios2_jtag_debug_module_unreg_firsttransfer = ~(nios2_jtag_debug_module_slavearbiterlockenable & nios2_jtag_debug_module_any_continuerequest);

  //nios2_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_jtag_debug_module_reg_firsttransfer <= 1'b1;
      else if (nios2_jtag_debug_module_begins_xfer)
          nios2_jtag_debug_module_reg_firsttransfer <= nios2_jtag_debug_module_unreg_firsttransfer;
    end


  //nios2_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign nios2_jtag_debug_module_beginbursttransfer_internal = nios2_jtag_debug_module_begins_xfer;

  //nios2_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign nios2_jtag_debug_module_arbitration_holdoff_internal = nios2_jtag_debug_module_begins_xfer & nios2_jtag_debug_module_firsttransfer;

  //nios2_jtag_debug_module_write assignment, which is an e_mux
  assign nios2_jtag_debug_module_write = nios2_data_master_granted_nios2_jtag_debug_module & nios2_data_master_write;

  assign shifted_address_to_nios2_jtag_debug_module_from_nios2_data_master = nios2_data_master_address_to_slave;
  //nios2_jtag_debug_module_address mux, which is an e_mux
  assign nios2_jtag_debug_module_address = (nios2_data_master_granted_nios2_jtag_debug_module)? (shifted_address_to_nios2_jtag_debug_module_from_nios2_data_master >> 2) :
    (shifted_address_to_nios2_jtag_debug_module_from_nios2_instruction_master >> 2);

  assign shifted_address_to_nios2_jtag_debug_module_from_nios2_instruction_master = nios2_instruction_master_address_to_slave;
  //d1_nios2_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_nios2_jtag_debug_module_end_xfer <= 1;
      else 
        d1_nios2_jtag_debug_module_end_xfer <= nios2_jtag_debug_module_end_xfer;
    end


  //nios2_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign nios2_jtag_debug_module_waits_for_read = nios2_jtag_debug_module_in_a_read_cycle & nios2_jtag_debug_module_begins_xfer;

  //nios2_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign nios2_jtag_debug_module_in_a_read_cycle = (nios2_data_master_granted_nios2_jtag_debug_module & nios2_data_master_read) | (nios2_instruction_master_granted_nios2_jtag_debug_module & nios2_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = nios2_jtag_debug_module_in_a_read_cycle;

  //nios2_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign nios2_jtag_debug_module_waits_for_write = nios2_jtag_debug_module_in_a_write_cycle & 0;

  //nios2_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign nios2_jtag_debug_module_in_a_write_cycle = nios2_data_master_granted_nios2_jtag_debug_module & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = nios2_jtag_debug_module_in_a_write_cycle;

  assign wait_for_nios2_jtag_debug_module_counter = 0;
  //nios2_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign nios2_jtag_debug_module_byteenable = (nios2_data_master_granted_nios2_jtag_debug_module)? nios2_data_master_byteenable :
    -1;

  //debugaccess mux, which is an e_mux
  assign nios2_jtag_debug_module_debugaccess = (nios2_data_master_granted_nios2_jtag_debug_module)? nios2_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios2/jtag_debug_module enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_data_master_granted_nios2_jtag_debug_module + nios2_instruction_master_granted_nios2_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_data_master_saved_grant_nios2_jtag_debug_module + nios2_instruction_master_saved_grant_nios2_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_data_master_arbitrator (
                                      // inputs:
                                       clk,
                                       cmt_din_s1_readdata_from_sa,
                                       cmt_dout_s1_readdata_from_sa,
                                       cmt_gpio_in_s1_readdata_from_sa,
                                       cmt_gpio_out_s1_readdata_from_sa,
                                       d1_cmt_din_s1_end_xfer,
                                       d1_cmt_dout_s1_end_xfer,
                                       d1_cmt_gpio_in_s1_end_xfer,
                                       d1_cmt_gpio_out_s1_end_xfer,
                                       d1_gpio0_s1_end_xfer,
                                       d1_gpio1_s1_end_xfer,
                                       d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                       d1_nios2_jtag_debug_module_end_xfer,
                                       d1_sram_s1_end_xfer,
                                       d1_sysid_control_slave_end_xfer,
                                       d1_timer_0_s1_end_xfer,
                                       gpio0_s1_readdata_from_sa,
                                       gpio1_s1_readdata_from_sa,
                                       jtag_uart_avalon_jtag_slave_irq_from_sa,
                                       jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                       jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                       nios2_data_master_address,
                                       nios2_data_master_granted_cmt_din_s1,
                                       nios2_data_master_granted_cmt_dout_s1,
                                       nios2_data_master_granted_cmt_gpio_in_s1,
                                       nios2_data_master_granted_cmt_gpio_out_s1,
                                       nios2_data_master_granted_gpio0_s1,
                                       nios2_data_master_granted_gpio1_s1,
                                       nios2_data_master_granted_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_granted_nios2_jtag_debug_module,
                                       nios2_data_master_granted_sram_s1,
                                       nios2_data_master_granted_sysid_control_slave,
                                       nios2_data_master_granted_timer_0_s1,
                                       nios2_data_master_qualified_request_cmt_din_s1,
                                       nios2_data_master_qualified_request_cmt_dout_s1,
                                       nios2_data_master_qualified_request_cmt_gpio_in_s1,
                                       nios2_data_master_qualified_request_cmt_gpio_out_s1,
                                       nios2_data_master_qualified_request_gpio0_s1,
                                       nios2_data_master_qualified_request_gpio1_s1,
                                       nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_qualified_request_nios2_jtag_debug_module,
                                       nios2_data_master_qualified_request_sram_s1,
                                       nios2_data_master_qualified_request_sysid_control_slave,
                                       nios2_data_master_qualified_request_timer_0_s1,
                                       nios2_data_master_read,
                                       nios2_data_master_read_data_valid_cmt_din_s1,
                                       nios2_data_master_read_data_valid_cmt_dout_s1,
                                       nios2_data_master_read_data_valid_cmt_gpio_in_s1,
                                       nios2_data_master_read_data_valid_cmt_gpio_out_s1,
                                       nios2_data_master_read_data_valid_gpio0_s1,
                                       nios2_data_master_read_data_valid_gpio1_s1,
                                       nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_read_data_valid_nios2_jtag_debug_module,
                                       nios2_data_master_read_data_valid_sram_s1,
                                       nios2_data_master_read_data_valid_sysid_control_slave,
                                       nios2_data_master_read_data_valid_timer_0_s1,
                                       nios2_data_master_requests_cmt_din_s1,
                                       nios2_data_master_requests_cmt_dout_s1,
                                       nios2_data_master_requests_cmt_gpio_in_s1,
                                       nios2_data_master_requests_cmt_gpio_out_s1,
                                       nios2_data_master_requests_gpio0_s1,
                                       nios2_data_master_requests_gpio1_s1,
                                       nios2_data_master_requests_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_requests_nios2_jtag_debug_module,
                                       nios2_data_master_requests_sram_s1,
                                       nios2_data_master_requests_sysid_control_slave,
                                       nios2_data_master_requests_timer_0_s1,
                                       nios2_data_master_write,
                                       nios2_jtag_debug_module_readdata_from_sa,
                                       registered_nios2_data_master_read_data_valid_sram_s1,
                                       reset_n,
                                       sram_s1_readdata_from_sa,
                                       sysid_control_slave_readdata_from_sa,
                                       timer_0_s1_irq_from_sa,
                                       timer_0_s1_readdata_from_sa,

                                      // outputs:
                                       nios2_data_master_address_to_slave,
                                       nios2_data_master_irq,
                                       nios2_data_master_readdata,
                                       nios2_data_master_waitrequest
                                    )
;

  output  [ 13: 0] nios2_data_master_address_to_slave;
  output  [ 31: 0] nios2_data_master_irq;
  output  [ 31: 0] nios2_data_master_readdata;
  output           nios2_data_master_waitrequest;
  input            clk;
  input   [ 31: 0] cmt_din_s1_readdata_from_sa;
  input   [ 31: 0] cmt_dout_s1_readdata_from_sa;
  input   [ 31: 0] cmt_gpio_in_s1_readdata_from_sa;
  input   [ 31: 0] cmt_gpio_out_s1_readdata_from_sa;
  input            d1_cmt_din_s1_end_xfer;
  input            d1_cmt_dout_s1_end_xfer;
  input            d1_cmt_gpio_in_s1_end_xfer;
  input            d1_cmt_gpio_out_s1_end_xfer;
  input            d1_gpio0_s1_end_xfer;
  input            d1_gpio1_s1_end_xfer;
  input            d1_jtag_uart_avalon_jtag_slave_end_xfer;
  input            d1_nios2_jtag_debug_module_end_xfer;
  input            d1_sram_s1_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_timer_0_s1_end_xfer;
  input   [ 31: 0] gpio0_s1_readdata_from_sa;
  input   [ 31: 0] gpio1_s1_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  input   [ 13: 0] nios2_data_master_address;
  input            nios2_data_master_granted_cmt_din_s1;
  input            nios2_data_master_granted_cmt_dout_s1;
  input            nios2_data_master_granted_cmt_gpio_in_s1;
  input            nios2_data_master_granted_cmt_gpio_out_s1;
  input            nios2_data_master_granted_gpio0_s1;
  input            nios2_data_master_granted_gpio1_s1;
  input            nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_granted_nios2_jtag_debug_module;
  input            nios2_data_master_granted_sram_s1;
  input            nios2_data_master_granted_sysid_control_slave;
  input            nios2_data_master_granted_timer_0_s1;
  input            nios2_data_master_qualified_request_cmt_din_s1;
  input            nios2_data_master_qualified_request_cmt_dout_s1;
  input            nios2_data_master_qualified_request_cmt_gpio_in_s1;
  input            nios2_data_master_qualified_request_cmt_gpio_out_s1;
  input            nios2_data_master_qualified_request_gpio0_s1;
  input            nios2_data_master_qualified_request_gpio1_s1;
  input            nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_qualified_request_nios2_jtag_debug_module;
  input            nios2_data_master_qualified_request_sram_s1;
  input            nios2_data_master_qualified_request_sysid_control_slave;
  input            nios2_data_master_qualified_request_timer_0_s1;
  input            nios2_data_master_read;
  input            nios2_data_master_read_data_valid_cmt_din_s1;
  input            nios2_data_master_read_data_valid_cmt_dout_s1;
  input            nios2_data_master_read_data_valid_cmt_gpio_in_s1;
  input            nios2_data_master_read_data_valid_cmt_gpio_out_s1;
  input            nios2_data_master_read_data_valid_gpio0_s1;
  input            nios2_data_master_read_data_valid_gpio1_s1;
  input            nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_read_data_valid_nios2_jtag_debug_module;
  input            nios2_data_master_read_data_valid_sram_s1;
  input            nios2_data_master_read_data_valid_sysid_control_slave;
  input            nios2_data_master_read_data_valid_timer_0_s1;
  input            nios2_data_master_requests_cmt_din_s1;
  input            nios2_data_master_requests_cmt_dout_s1;
  input            nios2_data_master_requests_cmt_gpio_in_s1;
  input            nios2_data_master_requests_cmt_gpio_out_s1;
  input            nios2_data_master_requests_gpio0_s1;
  input            nios2_data_master_requests_gpio1_s1;
  input            nios2_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_requests_nios2_jtag_debug_module;
  input            nios2_data_master_requests_sram_s1;
  input            nios2_data_master_requests_sysid_control_slave;
  input            nios2_data_master_requests_timer_0_s1;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  input            registered_nios2_data_master_read_data_valid_sram_s1;
  input            reset_n;
  input   [ 31: 0] sram_s1_readdata_from_sa;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input            timer_0_s1_irq_from_sa;
  input   [ 15: 0] timer_0_s1_readdata_from_sa;

  wire    [ 13: 0] nios2_data_master_address_to_slave;
  wire    [ 31: 0] nios2_data_master_irq;
  wire    [ 31: 0] nios2_data_master_readdata;
  wire             nios2_data_master_run;
  reg              nios2_data_master_waitrequest;
  wire    [ 31: 0] p1_registered_nios2_data_master_readdata;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  reg     [ 31: 0] registered_nios2_data_master_readdata;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~nios2_data_master_qualified_request_cmt_din_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_cmt_din_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_cmt_dout_s1 | ~nios2_data_master_requests_cmt_dout_s1) & ((~nios2_data_master_qualified_request_cmt_dout_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_cmt_dout_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & ((~nios2_data_master_qualified_request_cmt_gpio_in_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_cmt_gpio_in_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_cmt_gpio_out_s1 | ~nios2_data_master_requests_cmt_gpio_out_s1) & ((~nios2_data_master_qualified_request_cmt_gpio_out_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_cmt_gpio_out_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_gpio0_s1 | ~nios2_data_master_requests_gpio0_s1) & ((~nios2_data_master_qualified_request_gpio0_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_gpio0_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & ((~nios2_data_master_qualified_request_gpio1_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign nios2_data_master_run = r_0 & r_1 & r_2;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = ((~nios2_data_master_qualified_request_gpio1_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~nios2_data_master_requests_jtag_uart_avalon_jtag_slave) & ((~nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_nios2_jtag_debug_module | ~nios2_data_master_requests_nios2_jtag_debug_module) & (nios2_data_master_granted_nios2_jtag_debug_module | ~nios2_data_master_qualified_request_nios2_jtag_debug_module) & ((~nios2_data_master_qualified_request_nios2_jtag_debug_module | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_nios2_jtag_debug_module | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_sram_s1 | registered_nios2_data_master_read_data_valid_sram_s1 | ~nios2_data_master_requests_sram_s1) & (nios2_data_master_granted_sram_s1 | ~nios2_data_master_qualified_request_sram_s1) & ((~nios2_data_master_qualified_request_sram_s1 | ~nios2_data_master_read | (registered_nios2_data_master_read_data_valid_sram_s1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_sram_s1 | ~(nios2_data_master_read | nios2_data_master_write) | (1 & (nios2_data_master_read | nios2_data_master_write)))) & 1 & ((~nios2_data_master_qualified_request_sysid_control_slave | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_sysid_control_slave | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_timer_0_s1 | ~nios2_data_master_requests_timer_0_s1);

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = ((~nios2_data_master_qualified_request_timer_0_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_timer_0_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write)));

  //optimize select-logic by passing only those address bits which matter.
  assign nios2_data_master_address_to_slave = nios2_data_master_address[13 : 0];

  //nios2/data_master readdata mux, which is an e_mux
  assign nios2_data_master_readdata = ({32 {~nios2_data_master_requests_cmt_din_s1}} | cmt_din_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_cmt_dout_s1}} | cmt_dout_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_cmt_gpio_in_s1}} | cmt_gpio_in_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_cmt_gpio_out_s1}} | cmt_gpio_out_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_gpio0_s1}} | gpio0_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_gpio1_s1}} | gpio1_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_jtag_uart_avalon_jtag_slave}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_nios2_jtag_debug_module}} | nios2_jtag_debug_module_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_sram_s1}} | sram_s1_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_sysid_control_slave}} | sysid_control_slave_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_timer_0_s1}} | timer_0_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_data_master_waitrequest <= ~0;
      else 
        nios2_data_master_waitrequest <= ~((~(nios2_data_master_read | nios2_data_master_write))? 0: (nios2_data_master_run & nios2_data_master_waitrequest));
    end


  //unpredictable registered wait state incoming data, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          registered_nios2_data_master_readdata <= 0;
      else 
        registered_nios2_data_master_readdata <= p1_registered_nios2_data_master_readdata;
    end


  //registered readdata mux, which is an e_mux
  assign p1_registered_nios2_data_master_readdata = {32 {~nios2_data_master_requests_jtag_uart_avalon_jtag_slave}} | jtag_uart_avalon_jtag_slave_readdata_from_sa;

  //irq assign, which is an e_assign
  assign nios2_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    timer_0_s1_irq_from_sa,
    jtag_uart_avalon_jtag_slave_irq_from_sa};


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios2_instruction_master_arbitrator (
                                             // inputs:
                                              clk,
                                              d1_nios2_jtag_debug_module_end_xfer,
                                              d1_sram_s1_end_xfer,
                                              nios2_instruction_master_address,
                                              nios2_instruction_master_granted_nios2_jtag_debug_module,
                                              nios2_instruction_master_granted_sram_s1,
                                              nios2_instruction_master_qualified_request_nios2_jtag_debug_module,
                                              nios2_instruction_master_qualified_request_sram_s1,
                                              nios2_instruction_master_read,
                                              nios2_instruction_master_read_data_valid_nios2_jtag_debug_module,
                                              nios2_instruction_master_read_data_valid_sram_s1,
                                              nios2_instruction_master_requests_nios2_jtag_debug_module,
                                              nios2_instruction_master_requests_sram_s1,
                                              nios2_jtag_debug_module_readdata_from_sa,
                                              reset_n,
                                              sram_s1_readdata_from_sa,

                                             // outputs:
                                              nios2_instruction_master_address_to_slave,
                                              nios2_instruction_master_readdata,
                                              nios2_instruction_master_waitrequest
                                           )
;

  output  [ 13: 0] nios2_instruction_master_address_to_slave;
  output  [ 31: 0] nios2_instruction_master_readdata;
  output           nios2_instruction_master_waitrequest;
  input            clk;
  input            d1_nios2_jtag_debug_module_end_xfer;
  input            d1_sram_s1_end_xfer;
  input   [ 13: 0] nios2_instruction_master_address;
  input            nios2_instruction_master_granted_nios2_jtag_debug_module;
  input            nios2_instruction_master_granted_sram_s1;
  input            nios2_instruction_master_qualified_request_nios2_jtag_debug_module;
  input            nios2_instruction_master_qualified_request_sram_s1;
  input            nios2_instruction_master_read;
  input            nios2_instruction_master_read_data_valid_nios2_jtag_debug_module;
  input            nios2_instruction_master_read_data_valid_sram_s1;
  input            nios2_instruction_master_requests_nios2_jtag_debug_module;
  input            nios2_instruction_master_requests_sram_s1;
  input   [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  input            reset_n;
  input   [ 31: 0] sram_s1_readdata_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 13: 0] nios2_instruction_master_address_last_time;
  wire    [ 13: 0] nios2_instruction_master_address_to_slave;
  reg              nios2_instruction_master_read_last_time;
  wire    [ 31: 0] nios2_instruction_master_readdata;
  wire             nios2_instruction_master_run;
  wire             nios2_instruction_master_waitrequest;
  wire             r_1;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (nios2_instruction_master_qualified_request_nios2_jtag_debug_module | ~nios2_instruction_master_requests_nios2_jtag_debug_module) & (nios2_instruction_master_granted_nios2_jtag_debug_module | ~nios2_instruction_master_qualified_request_nios2_jtag_debug_module) & ((~nios2_instruction_master_qualified_request_nios2_jtag_debug_module | ~nios2_instruction_master_read | (1 & ~d1_nios2_jtag_debug_module_end_xfer & nios2_instruction_master_read))) & 1 & (nios2_instruction_master_qualified_request_sram_s1 | nios2_instruction_master_read_data_valid_sram_s1 | ~nios2_instruction_master_requests_sram_s1) & (nios2_instruction_master_granted_sram_s1 | ~nios2_instruction_master_qualified_request_sram_s1) & ((~nios2_instruction_master_qualified_request_sram_s1 | ~nios2_instruction_master_read | (nios2_instruction_master_read_data_valid_sram_s1 & nios2_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign nios2_instruction_master_run = r_1;

  //optimize select-logic by passing only those address bits which matter.
  assign nios2_instruction_master_address_to_slave = nios2_instruction_master_address[13 : 0];

  //nios2/instruction_master readdata mux, which is an e_mux
  assign nios2_instruction_master_readdata = ({32 {~nios2_instruction_master_requests_nios2_jtag_debug_module}} | nios2_jtag_debug_module_readdata_from_sa) &
    ({32 {~nios2_instruction_master_requests_sram_s1}} | sram_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign nios2_instruction_master_waitrequest = ~nios2_instruction_master_run;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios2_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_instruction_master_address_last_time <= 0;
      else 
        nios2_instruction_master_address_last_time <= nios2_instruction_master_address;
    end


  //nios2/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= nios2_instruction_master_waitrequest & (nios2_instruction_master_read);
    end


  //nios2_instruction_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_instruction_master_address != nios2_instruction_master_address_last_time))
        begin
          $write("%0d ns: nios2_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios2_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_instruction_master_read_last_time <= 0;
      else 
        nios2_instruction_master_read_last_time <= nios2_instruction_master_read;
    end


  //nios2_instruction_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios2_instruction_master_read != nios2_instruction_master_read_last_time))
        begin
          $write("%0d ns: nios2_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sram_s1_arbitrator (
                            // inputs:
                             clk,
                             nios2_data_master_address_to_slave,
                             nios2_data_master_byteenable,
                             nios2_data_master_read,
                             nios2_data_master_waitrequest,
                             nios2_data_master_write,
                             nios2_data_master_writedata,
                             nios2_instruction_master_address_to_slave,
                             nios2_instruction_master_read,
                             reset_n,
                             sram_s1_readdata,

                            // outputs:
                             d1_sram_s1_end_xfer,
                             nios2_data_master_granted_sram_s1,
                             nios2_data_master_qualified_request_sram_s1,
                             nios2_data_master_read_data_valid_sram_s1,
                             nios2_data_master_requests_sram_s1,
                             nios2_instruction_master_granted_sram_s1,
                             nios2_instruction_master_qualified_request_sram_s1,
                             nios2_instruction_master_read_data_valid_sram_s1,
                             nios2_instruction_master_requests_sram_s1,
                             registered_nios2_data_master_read_data_valid_sram_s1,
                             sram_s1_address,
                             sram_s1_byteenable,
                             sram_s1_chipselect,
                             sram_s1_clken,
                             sram_s1_readdata_from_sa,
                             sram_s1_reset,
                             sram_s1_write,
                             sram_s1_writedata
                          )
;

  output           d1_sram_s1_end_xfer;
  output           nios2_data_master_granted_sram_s1;
  output           nios2_data_master_qualified_request_sram_s1;
  output           nios2_data_master_read_data_valid_sram_s1;
  output           nios2_data_master_requests_sram_s1;
  output           nios2_instruction_master_granted_sram_s1;
  output           nios2_instruction_master_qualified_request_sram_s1;
  output           nios2_instruction_master_read_data_valid_sram_s1;
  output           nios2_instruction_master_requests_sram_s1;
  output           registered_nios2_data_master_read_data_valid_sram_s1;
  output  [ 10: 0] sram_s1_address;
  output  [  3: 0] sram_s1_byteenable;
  output           sram_s1_chipselect;
  output           sram_s1_clken;
  output  [ 31: 0] sram_s1_readdata_from_sa;
  output           sram_s1_reset;
  output           sram_s1_write;
  output  [ 31: 0] sram_s1_writedata;
  input            clk;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input   [ 13: 0] nios2_instruction_master_address_to_slave;
  input            nios2_instruction_master_read;
  input            reset_n;
  input   [ 31: 0] sram_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sram_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sram_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios2_data_master_granted_slave_sram_s1;
  reg              last_cycle_nios2_instruction_master_granted_slave_sram_s1;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_sram_s1;
  wire             nios2_data_master_qualified_request_sram_s1;
  wire             nios2_data_master_read_data_valid_sram_s1;
  reg              nios2_data_master_read_data_valid_sram_s1_shift_register;
  wire             nios2_data_master_read_data_valid_sram_s1_shift_register_in;
  wire             nios2_data_master_requests_sram_s1;
  wire             nios2_data_master_saved_grant_sram_s1;
  wire             nios2_instruction_master_arbiterlock;
  wire             nios2_instruction_master_arbiterlock2;
  wire             nios2_instruction_master_continuerequest;
  wire             nios2_instruction_master_granted_sram_s1;
  wire             nios2_instruction_master_qualified_request_sram_s1;
  wire             nios2_instruction_master_read_data_valid_sram_s1;
  reg              nios2_instruction_master_read_data_valid_sram_s1_shift_register;
  wire             nios2_instruction_master_read_data_valid_sram_s1_shift_register_in;
  wire             nios2_instruction_master_requests_sram_s1;
  wire             nios2_instruction_master_saved_grant_sram_s1;
  wire             p1_nios2_data_master_read_data_valid_sram_s1_shift_register;
  wire             p1_nios2_instruction_master_read_data_valid_sram_s1_shift_register;
  wire             registered_nios2_data_master_read_data_valid_sram_s1;
  wire    [ 13: 0] shifted_address_to_sram_s1_from_nios2_data_master;
  wire    [ 13: 0] shifted_address_to_sram_s1_from_nios2_instruction_master;
  wire    [ 10: 0] sram_s1_address;
  wire             sram_s1_allgrants;
  wire             sram_s1_allow_new_arb_cycle;
  wire             sram_s1_any_bursting_master_saved_grant;
  wire             sram_s1_any_continuerequest;
  reg     [  1: 0] sram_s1_arb_addend;
  wire             sram_s1_arb_counter_enable;
  reg              sram_s1_arb_share_counter;
  wire             sram_s1_arb_share_counter_next_value;
  wire             sram_s1_arb_share_set_values;
  wire    [  1: 0] sram_s1_arb_winner;
  wire             sram_s1_arbitration_holdoff_internal;
  wire             sram_s1_beginbursttransfer_internal;
  wire             sram_s1_begins_xfer;
  wire    [  3: 0] sram_s1_byteenable;
  wire             sram_s1_chipselect;
  wire    [  3: 0] sram_s1_chosen_master_double_vector;
  wire    [  1: 0] sram_s1_chosen_master_rot_left;
  wire             sram_s1_clken;
  wire             sram_s1_end_xfer;
  wire             sram_s1_firsttransfer;
  wire    [  1: 0] sram_s1_grant_vector;
  wire             sram_s1_in_a_read_cycle;
  wire             sram_s1_in_a_write_cycle;
  wire    [  1: 0] sram_s1_master_qreq_vector;
  wire             sram_s1_non_bursting_master_requests;
  wire    [ 31: 0] sram_s1_readdata_from_sa;
  reg              sram_s1_reg_firsttransfer;
  wire             sram_s1_reset;
  reg     [  1: 0] sram_s1_saved_chosen_master_vector;
  reg              sram_s1_slavearbiterlockenable;
  wire             sram_s1_slavearbiterlockenable2;
  wire             sram_s1_unreg_firsttransfer;
  wire             sram_s1_waits_for_read;
  wire             sram_s1_waits_for_write;
  wire             sram_s1_write;
  wire    [ 31: 0] sram_s1_writedata;
  wire             wait_for_sram_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sram_s1_end_xfer;
    end


  assign sram_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_sram_s1 | nios2_instruction_master_qualified_request_sram_s1));
  //assign sram_s1_readdata_from_sa = sram_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sram_s1_readdata_from_sa = sram_s1_readdata;

  assign nios2_data_master_requests_sram_s1 = ({nios2_data_master_address_to_slave[13] , 13'b0} == 14'h2000) & (nios2_data_master_read | nios2_data_master_write);
  //registered rdv signal_name registered_nios2_data_master_read_data_valid_sram_s1 assignment, which is an e_assign
  assign registered_nios2_data_master_read_data_valid_sram_s1 = nios2_data_master_read_data_valid_sram_s1_shift_register_in;

  //sram_s1_arb_share_counter set values, which is an e_mux
  assign sram_s1_arb_share_set_values = 1;

  //sram_s1_non_bursting_master_requests mux, which is an e_mux
  assign sram_s1_non_bursting_master_requests = nios2_data_master_requests_sram_s1 |
    nios2_instruction_master_requests_sram_s1 |
    nios2_data_master_requests_sram_s1 |
    nios2_instruction_master_requests_sram_s1;

  //sram_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sram_s1_any_bursting_master_saved_grant = 0;

  //sram_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sram_s1_arb_share_counter_next_value = sram_s1_firsttransfer ? (sram_s1_arb_share_set_values - 1) : |sram_s1_arb_share_counter ? (sram_s1_arb_share_counter - 1) : 0;

  //sram_s1_allgrants all slave grants, which is an e_mux
  assign sram_s1_allgrants = (|sram_s1_grant_vector) |
    (|sram_s1_grant_vector) |
    (|sram_s1_grant_vector) |
    (|sram_s1_grant_vector);

  //sram_s1_end_xfer assignment, which is an e_assign
  assign sram_s1_end_xfer = ~(sram_s1_waits_for_read | sram_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sram_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sram_s1 = sram_s1_end_xfer & (~sram_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sram_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sram_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sram_s1 & sram_s1_allgrants) | (end_xfer_arb_share_counter_term_sram_s1 & ~sram_s1_non_bursting_master_requests);

  //sram_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_s1_arb_share_counter <= 0;
      else if (sram_s1_arb_counter_enable)
          sram_s1_arb_share_counter <= sram_s1_arb_share_counter_next_value;
    end


  //sram_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_s1_slavearbiterlockenable <= 0;
      else if ((|sram_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sram_s1) | (end_xfer_arb_share_counter_term_sram_s1 & ~sram_s1_non_bursting_master_requests))
          sram_s1_slavearbiterlockenable <= |sram_s1_arb_share_counter_next_value;
    end


  //nios2/data_master sram/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = sram_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //sram_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sram_s1_slavearbiterlockenable2 = |sram_s1_arb_share_counter_next_value;

  //nios2/data_master sram/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = sram_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //nios2/instruction_master sram/s1 arbiterlock, which is an e_assign
  assign nios2_instruction_master_arbiterlock = sram_s1_slavearbiterlockenable & nios2_instruction_master_continuerequest;

  //nios2/instruction_master sram/s1 arbiterlock2, which is an e_assign
  assign nios2_instruction_master_arbiterlock2 = sram_s1_slavearbiterlockenable2 & nios2_instruction_master_continuerequest;

  //nios2/instruction_master granted sram/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_instruction_master_granted_slave_sram_s1 <= 0;
      else 
        last_cycle_nios2_instruction_master_granted_slave_sram_s1 <= nios2_instruction_master_saved_grant_sram_s1 ? 1 : (sram_s1_arbitration_holdoff_internal | ~nios2_instruction_master_requests_sram_s1) ? 0 : last_cycle_nios2_instruction_master_granted_slave_sram_s1;
    end


  //nios2_instruction_master_continuerequest continued request, which is an e_mux
  assign nios2_instruction_master_continuerequest = last_cycle_nios2_instruction_master_granted_slave_sram_s1 & nios2_instruction_master_requests_sram_s1;

  //sram_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sram_s1_any_continuerequest = nios2_instruction_master_continuerequest |
    nios2_data_master_continuerequest;

  assign nios2_data_master_qualified_request_sram_s1 = nios2_data_master_requests_sram_s1 & ~((nios2_data_master_read & ((|nios2_data_master_read_data_valid_sram_s1_shift_register))) | ((~nios2_data_master_waitrequest) & nios2_data_master_write) | nios2_instruction_master_arbiterlock);
  //nios2_data_master_read_data_valid_sram_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign nios2_data_master_read_data_valid_sram_s1_shift_register_in = nios2_data_master_granted_sram_s1 & nios2_data_master_read & ~sram_s1_waits_for_read & ~(|nios2_data_master_read_data_valid_sram_s1_shift_register);

  //shift register p1 nios2_data_master_read_data_valid_sram_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_nios2_data_master_read_data_valid_sram_s1_shift_register = {nios2_data_master_read_data_valid_sram_s1_shift_register, nios2_data_master_read_data_valid_sram_s1_shift_register_in};

  //nios2_data_master_read_data_valid_sram_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_data_master_read_data_valid_sram_s1_shift_register <= 0;
      else 
        nios2_data_master_read_data_valid_sram_s1_shift_register <= p1_nios2_data_master_read_data_valid_sram_s1_shift_register;
    end


  //local readdatavalid nios2_data_master_read_data_valid_sram_s1, which is an e_mux
  assign nios2_data_master_read_data_valid_sram_s1 = nios2_data_master_read_data_valid_sram_s1_shift_register;

  //sram_s1_writedata mux, which is an e_mux
  assign sram_s1_writedata = nios2_data_master_writedata;

  //mux sram_s1_clken, which is an e_mux
  assign sram_s1_clken = 1'b1;

  assign nios2_instruction_master_requests_sram_s1 = (({nios2_instruction_master_address_to_slave[13] , 13'b0} == 14'h2000) & (nios2_instruction_master_read)) & nios2_instruction_master_read;
  //nios2/data_master granted sram/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_data_master_granted_slave_sram_s1 <= 0;
      else 
        last_cycle_nios2_data_master_granted_slave_sram_s1 <= nios2_data_master_saved_grant_sram_s1 ? 1 : (sram_s1_arbitration_holdoff_internal | ~nios2_data_master_requests_sram_s1) ? 0 : last_cycle_nios2_data_master_granted_slave_sram_s1;
    end


  //nios2_data_master_continuerequest continued request, which is an e_mux
  assign nios2_data_master_continuerequest = last_cycle_nios2_data_master_granted_slave_sram_s1 & nios2_data_master_requests_sram_s1;

  assign nios2_instruction_master_qualified_request_sram_s1 = nios2_instruction_master_requests_sram_s1 & ~((nios2_instruction_master_read & ((|nios2_instruction_master_read_data_valid_sram_s1_shift_register))) | nios2_data_master_arbiterlock);
  //nios2_instruction_master_read_data_valid_sram_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign nios2_instruction_master_read_data_valid_sram_s1_shift_register_in = nios2_instruction_master_granted_sram_s1 & nios2_instruction_master_read & ~sram_s1_waits_for_read & ~(|nios2_instruction_master_read_data_valid_sram_s1_shift_register);

  //shift register p1 nios2_instruction_master_read_data_valid_sram_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_nios2_instruction_master_read_data_valid_sram_s1_shift_register = {nios2_instruction_master_read_data_valid_sram_s1_shift_register, nios2_instruction_master_read_data_valid_sram_s1_shift_register_in};

  //nios2_instruction_master_read_data_valid_sram_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_instruction_master_read_data_valid_sram_s1_shift_register <= 0;
      else 
        nios2_instruction_master_read_data_valid_sram_s1_shift_register <= p1_nios2_instruction_master_read_data_valid_sram_s1_shift_register;
    end


  //local readdatavalid nios2_instruction_master_read_data_valid_sram_s1, which is an e_mux
  assign nios2_instruction_master_read_data_valid_sram_s1 = nios2_instruction_master_read_data_valid_sram_s1_shift_register;

  //allow new arb cycle for sram/s1, which is an e_assign
  assign sram_s1_allow_new_arb_cycle = ~nios2_data_master_arbiterlock & ~nios2_instruction_master_arbiterlock;

  //nios2/instruction_master assignment into master qualified-requests vector for sram/s1, which is an e_assign
  assign sram_s1_master_qreq_vector[0] = nios2_instruction_master_qualified_request_sram_s1;

  //nios2/instruction_master grant sram/s1, which is an e_assign
  assign nios2_instruction_master_granted_sram_s1 = sram_s1_grant_vector[0];

  //nios2/instruction_master saved-grant sram/s1, which is an e_assign
  assign nios2_instruction_master_saved_grant_sram_s1 = sram_s1_arb_winner[0] && nios2_instruction_master_requests_sram_s1;

  //nios2/data_master assignment into master qualified-requests vector for sram/s1, which is an e_assign
  assign sram_s1_master_qreq_vector[1] = nios2_data_master_qualified_request_sram_s1;

  //nios2/data_master grant sram/s1, which is an e_assign
  assign nios2_data_master_granted_sram_s1 = sram_s1_grant_vector[1];

  //nios2/data_master saved-grant sram/s1, which is an e_assign
  assign nios2_data_master_saved_grant_sram_s1 = sram_s1_arb_winner[1] && nios2_data_master_requests_sram_s1;

  //sram/s1 chosen-master double-vector, which is an e_assign
  assign sram_s1_chosen_master_double_vector = {sram_s1_master_qreq_vector, sram_s1_master_qreq_vector} & ({~sram_s1_master_qreq_vector, ~sram_s1_master_qreq_vector} + sram_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign sram_s1_arb_winner = (sram_s1_allow_new_arb_cycle & | sram_s1_grant_vector) ? sram_s1_grant_vector : sram_s1_saved_chosen_master_vector;

  //saved sram_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_s1_saved_chosen_master_vector <= 0;
      else if (sram_s1_allow_new_arb_cycle)
          sram_s1_saved_chosen_master_vector <= |sram_s1_grant_vector ? sram_s1_grant_vector : sram_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sram_s1_grant_vector = {(sram_s1_chosen_master_double_vector[1] | sram_s1_chosen_master_double_vector[3]),
    (sram_s1_chosen_master_double_vector[0] | sram_s1_chosen_master_double_vector[2])};

  //sram/s1 chosen master rotated left, which is an e_assign
  assign sram_s1_chosen_master_rot_left = (sram_s1_arb_winner << 1) ? (sram_s1_arb_winner << 1) : 1;

  //sram/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_s1_arb_addend <= 1;
      else if (|sram_s1_grant_vector)
          sram_s1_arb_addend <= sram_s1_end_xfer? sram_s1_chosen_master_rot_left : sram_s1_grant_vector;
    end


  //~sram_s1_reset assignment, which is an e_assign
  assign sram_s1_reset = ~reset_n;

  assign sram_s1_chipselect = nios2_data_master_granted_sram_s1 | nios2_instruction_master_granted_sram_s1;
  //sram_s1_firsttransfer first transaction, which is an e_assign
  assign sram_s1_firsttransfer = sram_s1_begins_xfer ? sram_s1_unreg_firsttransfer : sram_s1_reg_firsttransfer;

  //sram_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sram_s1_unreg_firsttransfer = ~(sram_s1_slavearbiterlockenable & sram_s1_any_continuerequest);

  //sram_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_s1_reg_firsttransfer <= 1'b1;
      else if (sram_s1_begins_xfer)
          sram_s1_reg_firsttransfer <= sram_s1_unreg_firsttransfer;
    end


  //sram_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sram_s1_beginbursttransfer_internal = sram_s1_begins_xfer;

  //sram_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sram_s1_arbitration_holdoff_internal = sram_s1_begins_xfer & sram_s1_firsttransfer;

  //sram_s1_write assignment, which is an e_mux
  assign sram_s1_write = nios2_data_master_granted_sram_s1 & nios2_data_master_write;

  assign shifted_address_to_sram_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //sram_s1_address mux, which is an e_mux
  assign sram_s1_address = (nios2_data_master_granted_sram_s1)? (shifted_address_to_sram_s1_from_nios2_data_master >> 2) :
    (shifted_address_to_sram_s1_from_nios2_instruction_master >> 2);

  assign shifted_address_to_sram_s1_from_nios2_instruction_master = nios2_instruction_master_address_to_slave;
  //d1_sram_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sram_s1_end_xfer <= 1;
      else 
        d1_sram_s1_end_xfer <= sram_s1_end_xfer;
    end


  //sram_s1_waits_for_read in a cycle, which is an e_mux
  assign sram_s1_waits_for_read = sram_s1_in_a_read_cycle & 0;

  //sram_s1_in_a_read_cycle assignment, which is an e_assign
  assign sram_s1_in_a_read_cycle = (nios2_data_master_granted_sram_s1 & nios2_data_master_read) | (nios2_instruction_master_granted_sram_s1 & nios2_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sram_s1_in_a_read_cycle;

  //sram_s1_waits_for_write in a cycle, which is an e_mux
  assign sram_s1_waits_for_write = sram_s1_in_a_write_cycle & 0;

  //sram_s1_in_a_write_cycle assignment, which is an e_assign
  assign sram_s1_in_a_write_cycle = nios2_data_master_granted_sram_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sram_s1_in_a_write_cycle;

  assign wait_for_sram_s1_counter = 0;
  //sram_s1_byteenable byte enable port mux, which is an e_mux
  assign sram_s1_byteenable = (nios2_data_master_granted_sram_s1)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sram/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_data_master_granted_sram_s1 + nios2_instruction_master_granted_sram_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_data_master_saved_grant_sram_s1 + nios2_instruction_master_saved_grant_sram_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sysid_control_slave_arbitrator (
                                        // inputs:
                                         clk,
                                         nios2_data_master_address_to_slave,
                                         nios2_data_master_read,
                                         nios2_data_master_write,
                                         reset_n,
                                         sysid_control_slave_readdata,

                                        // outputs:
                                         d1_sysid_control_slave_end_xfer,
                                         nios2_data_master_granted_sysid_control_slave,
                                         nios2_data_master_qualified_request_sysid_control_slave,
                                         nios2_data_master_read_data_valid_sysid_control_slave,
                                         nios2_data_master_requests_sysid_control_slave,
                                         sysid_control_slave_address,
                                         sysid_control_slave_readdata_from_sa,
                                         sysid_control_slave_reset_n
                                      )
;

  output           d1_sysid_control_slave_end_xfer;
  output           nios2_data_master_granted_sysid_control_slave;
  output           nios2_data_master_qualified_request_sysid_control_slave;
  output           nios2_data_master_read_data_valid_sysid_control_slave;
  output           nios2_data_master_requests_sysid_control_slave;
  output           sysid_control_slave_address;
  output  [ 31: 0] sysid_control_slave_readdata_from_sa;
  output           sysid_control_slave_reset_n;
  input            clk;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_write;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sysid_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sysid_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_sysid_control_slave;
  wire             nios2_data_master_qualified_request_sysid_control_slave;
  wire             nios2_data_master_read_data_valid_sysid_control_slave;
  wire             nios2_data_master_requests_sysid_control_slave;
  wire             nios2_data_master_saved_grant_sysid_control_slave;
  wire    [ 13: 0] shifted_address_to_sysid_control_slave_from_nios2_data_master;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg              sysid_control_slave_arb_share_counter;
  wire             sysid_control_slave_arb_share_counter_next_value;
  wire             sysid_control_slave_arb_share_set_values;
  wire             sysid_control_slave_beginbursttransfer_internal;
  wire             sysid_control_slave_begins_xfer;
  wire             sysid_control_slave_end_xfer;
  wire             sysid_control_slave_firsttransfer;
  wire             sysid_control_slave_grant_vector;
  wire             sysid_control_slave_in_a_read_cycle;
  wire             sysid_control_slave_in_a_write_cycle;
  wire             sysid_control_slave_master_qreq_vector;
  wire             sysid_control_slave_non_bursting_master_requests;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  reg              sysid_control_slave_reg_firsttransfer;
  wire             sysid_control_slave_reset_n;
  reg              sysid_control_slave_slavearbiterlockenable;
  wire             sysid_control_slave_slavearbiterlockenable2;
  wire             sysid_control_slave_unreg_firsttransfer;
  wire             sysid_control_slave_waits_for_read;
  wire             sysid_control_slave_waits_for_write;
  wire             wait_for_sysid_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sysid_control_slave_end_xfer;
    end


  assign sysid_control_slave_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_sysid_control_slave));
  //assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata;

  assign nios2_data_master_requests_sysid_control_slave = (({nios2_data_master_address_to_slave[13 : 3] , 3'b0} == 14'h28) & (nios2_data_master_read | nios2_data_master_write)) & nios2_data_master_read;
  //sysid_control_slave_arb_share_counter set values, which is an e_mux
  assign sysid_control_slave_arb_share_set_values = 1;

  //sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign sysid_control_slave_non_bursting_master_requests = nios2_data_master_requests_sysid_control_slave;

  //sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sysid_control_slave_any_bursting_master_saved_grant = 0;

  //sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sysid_control_slave_arb_share_counter_next_value = sysid_control_slave_firsttransfer ? (sysid_control_slave_arb_share_set_values - 1) : |sysid_control_slave_arb_share_counter ? (sysid_control_slave_arb_share_counter - 1) : 0;

  //sysid_control_slave_allgrants all slave grants, which is an e_mux
  assign sysid_control_slave_allgrants = |sysid_control_slave_grant_vector;

  //sysid_control_slave_end_xfer assignment, which is an e_assign
  assign sysid_control_slave_end_xfer = ~(sysid_control_slave_waits_for_read | sysid_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sysid_control_slave = sysid_control_slave_end_xfer & (~sysid_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sysid_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sysid_control_slave & sysid_control_slave_allgrants) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests);

  //sysid_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_arb_share_counter <= 0;
      else if (sysid_control_slave_arb_counter_enable)
          sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
    end


  //sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_slavearbiterlockenable <= 0;
      else if ((|sysid_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sysid_control_slave) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests))
          sysid_control_slave_slavearbiterlockenable <= |sysid_control_slave_arb_share_counter_next_value;
    end


  //nios2/data_master sysid/control_slave arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = sysid_control_slave_slavearbiterlockenable & nios2_data_master_continuerequest;

  //sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sysid_control_slave_slavearbiterlockenable2 = |sysid_control_slave_arb_share_counter_next_value;

  //nios2/data_master sysid/control_slave arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = sysid_control_slave_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sysid_control_slave_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_sysid_control_slave = nios2_data_master_requests_sysid_control_slave;
  //master is always granted when requested
  assign nios2_data_master_granted_sysid_control_slave = nios2_data_master_qualified_request_sysid_control_slave;

  //nios2/data_master saved-grant sysid/control_slave, which is an e_assign
  assign nios2_data_master_saved_grant_sysid_control_slave = nios2_data_master_requests_sysid_control_slave;

  //allow new arb cycle for sysid/control_slave, which is an e_assign
  assign sysid_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sysid_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sysid_control_slave_master_qreq_vector = 1;

  //sysid_control_slave_reset_n assignment, which is an e_assign
  assign sysid_control_slave_reset_n = reset_n;

  //sysid_control_slave_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_firsttransfer = sysid_control_slave_begins_xfer ? sysid_control_slave_unreg_firsttransfer : sysid_control_slave_reg_firsttransfer;

  //sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_unreg_firsttransfer = ~(sysid_control_slave_slavearbiterlockenable & sysid_control_slave_any_continuerequest);

  //sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_reg_firsttransfer <= 1'b1;
      else if (sysid_control_slave_begins_xfer)
          sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
    end


  //sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sysid_control_slave_beginbursttransfer_internal = sysid_control_slave_begins_xfer;

  assign shifted_address_to_sysid_control_slave_from_nios2_data_master = nios2_data_master_address_to_slave;
  //sysid_control_slave_address mux, which is an e_mux
  assign sysid_control_slave_address = shifted_address_to_sysid_control_slave_from_nios2_data_master >> 2;

  //d1_sysid_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sysid_control_slave_end_xfer <= 1;
      else 
        d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end


  //sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_read = sysid_control_slave_in_a_read_cycle & sysid_control_slave_begins_xfer;

  //sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_read_cycle = nios2_data_master_granted_sysid_control_slave & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sysid_control_slave_in_a_read_cycle;

  //sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_write = sysid_control_slave_in_a_write_cycle & 0;

  //sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_write_cycle = nios2_data_master_granted_sysid_control_slave & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sysid_control_slave_in_a_write_cycle;

  assign wait_for_sysid_control_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sysid/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module timer_0_s1_arbitrator (
                               // inputs:
                                clk,
                                nios2_data_master_address_to_slave,
                                nios2_data_master_read,
                                nios2_data_master_waitrequest,
                                nios2_data_master_write,
                                nios2_data_master_writedata,
                                reset_n,
                                timer_0_s1_irq,
                                timer_0_s1_readdata,

                               // outputs:
                                d1_timer_0_s1_end_xfer,
                                nios2_data_master_granted_timer_0_s1,
                                nios2_data_master_qualified_request_timer_0_s1,
                                nios2_data_master_read_data_valid_timer_0_s1,
                                nios2_data_master_requests_timer_0_s1,
                                timer_0_s1_address,
                                timer_0_s1_chipselect,
                                timer_0_s1_irq_from_sa,
                                timer_0_s1_readdata_from_sa,
                                timer_0_s1_reset_n,
                                timer_0_s1_write_n,
                                timer_0_s1_writedata
                             )
;

  output           d1_timer_0_s1_end_xfer;
  output           nios2_data_master_granted_timer_0_s1;
  output           nios2_data_master_qualified_request_timer_0_s1;
  output           nios2_data_master_read_data_valid_timer_0_s1;
  output           nios2_data_master_requests_timer_0_s1;
  output  [  2: 0] timer_0_s1_address;
  output           timer_0_s1_chipselect;
  output           timer_0_s1_irq_from_sa;
  output  [ 15: 0] timer_0_s1_readdata_from_sa;
  output           timer_0_s1_reset_n;
  output           timer_0_s1_write_n;
  output  [ 15: 0] timer_0_s1_writedata;
  input            clk;
  input   [ 13: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            reset_n;
  input            timer_0_s1_irq;
  input   [ 15: 0] timer_0_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_timer_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_timer_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_timer_0_s1;
  wire             nios2_data_master_qualified_request_timer_0_s1;
  wire             nios2_data_master_read_data_valid_timer_0_s1;
  wire             nios2_data_master_requests_timer_0_s1;
  wire             nios2_data_master_saved_grant_timer_0_s1;
  wire    [ 13: 0] shifted_address_to_timer_0_s1_from_nios2_data_master;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_allgrants;
  wire             timer_0_s1_allow_new_arb_cycle;
  wire             timer_0_s1_any_bursting_master_saved_grant;
  wire             timer_0_s1_any_continuerequest;
  wire             timer_0_s1_arb_counter_enable;
  reg              timer_0_s1_arb_share_counter;
  wire             timer_0_s1_arb_share_counter_next_value;
  wire             timer_0_s1_arb_share_set_values;
  wire             timer_0_s1_beginbursttransfer_internal;
  wire             timer_0_s1_begins_xfer;
  wire             timer_0_s1_chipselect;
  wire             timer_0_s1_end_xfer;
  wire             timer_0_s1_firsttransfer;
  wire             timer_0_s1_grant_vector;
  wire             timer_0_s1_in_a_read_cycle;
  wire             timer_0_s1_in_a_write_cycle;
  wire             timer_0_s1_irq_from_sa;
  wire             timer_0_s1_master_qreq_vector;
  wire             timer_0_s1_non_bursting_master_requests;
  wire    [ 15: 0] timer_0_s1_readdata_from_sa;
  reg              timer_0_s1_reg_firsttransfer;
  wire             timer_0_s1_reset_n;
  reg              timer_0_s1_slavearbiterlockenable;
  wire             timer_0_s1_slavearbiterlockenable2;
  wire             timer_0_s1_unreg_firsttransfer;
  wire             timer_0_s1_waits_for_read;
  wire             timer_0_s1_waits_for_write;
  wire             timer_0_s1_write_n;
  wire    [ 15: 0] timer_0_s1_writedata;
  wire             wait_for_timer_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~timer_0_s1_end_xfer;
    end


  assign timer_0_s1_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_timer_0_s1));
  //assign timer_0_s1_readdata_from_sa = timer_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_0_s1_readdata_from_sa = timer_0_s1_readdata;

  assign nios2_data_master_requests_timer_0_s1 = ({nios2_data_master_address_to_slave[13 : 5] , 5'b0} == 14'h80) & (nios2_data_master_read | nios2_data_master_write);
  //timer_0_s1_arb_share_counter set values, which is an e_mux
  assign timer_0_s1_arb_share_set_values = 1;

  //timer_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign timer_0_s1_non_bursting_master_requests = nios2_data_master_requests_timer_0_s1;

  //timer_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign timer_0_s1_any_bursting_master_saved_grant = 0;

  //timer_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign timer_0_s1_arb_share_counter_next_value = timer_0_s1_firsttransfer ? (timer_0_s1_arb_share_set_values - 1) : |timer_0_s1_arb_share_counter ? (timer_0_s1_arb_share_counter - 1) : 0;

  //timer_0_s1_allgrants all slave grants, which is an e_mux
  assign timer_0_s1_allgrants = |timer_0_s1_grant_vector;

  //timer_0_s1_end_xfer assignment, which is an e_assign
  assign timer_0_s1_end_xfer = ~(timer_0_s1_waits_for_read | timer_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_timer_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_timer_0_s1 = timer_0_s1_end_xfer & (~timer_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //timer_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign timer_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_timer_0_s1 & timer_0_s1_allgrants) | (end_xfer_arb_share_counter_term_timer_0_s1 & ~timer_0_s1_non_bursting_master_requests);

  //timer_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_arb_share_counter <= 0;
      else if (timer_0_s1_arb_counter_enable)
          timer_0_s1_arb_share_counter <= timer_0_s1_arb_share_counter_next_value;
    end


  //timer_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_slavearbiterlockenable <= 0;
      else if ((|timer_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_timer_0_s1) | (end_xfer_arb_share_counter_term_timer_0_s1 & ~timer_0_s1_non_bursting_master_requests))
          timer_0_s1_slavearbiterlockenable <= |timer_0_s1_arb_share_counter_next_value;
    end


  //nios2/data_master timer_0/s1 arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = timer_0_s1_slavearbiterlockenable & nios2_data_master_continuerequest;

  //timer_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign timer_0_s1_slavearbiterlockenable2 = |timer_0_s1_arb_share_counter_next_value;

  //nios2/data_master timer_0/s1 arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = timer_0_s1_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //timer_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign timer_0_s1_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_timer_0_s1 = nios2_data_master_requests_timer_0_s1 & ~(((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //timer_0_s1_writedata mux, which is an e_mux
  assign timer_0_s1_writedata = nios2_data_master_writedata;

  //master is always granted when requested
  assign nios2_data_master_granted_timer_0_s1 = nios2_data_master_qualified_request_timer_0_s1;

  //nios2/data_master saved-grant timer_0/s1, which is an e_assign
  assign nios2_data_master_saved_grant_timer_0_s1 = nios2_data_master_requests_timer_0_s1;

  //allow new arb cycle for timer_0/s1, which is an e_assign
  assign timer_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign timer_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign timer_0_s1_master_qreq_vector = 1;

  //timer_0_s1_reset_n assignment, which is an e_assign
  assign timer_0_s1_reset_n = reset_n;

  assign timer_0_s1_chipselect = nios2_data_master_granted_timer_0_s1;
  //timer_0_s1_firsttransfer first transaction, which is an e_assign
  assign timer_0_s1_firsttransfer = timer_0_s1_begins_xfer ? timer_0_s1_unreg_firsttransfer : timer_0_s1_reg_firsttransfer;

  //timer_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign timer_0_s1_unreg_firsttransfer = ~(timer_0_s1_slavearbiterlockenable & timer_0_s1_any_continuerequest);

  //timer_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          timer_0_s1_reg_firsttransfer <= 1'b1;
      else if (timer_0_s1_begins_xfer)
          timer_0_s1_reg_firsttransfer <= timer_0_s1_unreg_firsttransfer;
    end


  //timer_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign timer_0_s1_beginbursttransfer_internal = timer_0_s1_begins_xfer;

  //~timer_0_s1_write_n assignment, which is an e_mux
  assign timer_0_s1_write_n = ~(nios2_data_master_granted_timer_0_s1 & nios2_data_master_write);

  assign shifted_address_to_timer_0_s1_from_nios2_data_master = nios2_data_master_address_to_slave;
  //timer_0_s1_address mux, which is an e_mux
  assign timer_0_s1_address = shifted_address_to_timer_0_s1_from_nios2_data_master >> 2;

  //d1_timer_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_timer_0_s1_end_xfer <= 1;
      else 
        d1_timer_0_s1_end_xfer <= timer_0_s1_end_xfer;
    end


  //timer_0_s1_waits_for_read in a cycle, which is an e_mux
  assign timer_0_s1_waits_for_read = timer_0_s1_in_a_read_cycle & timer_0_s1_begins_xfer;

  //timer_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign timer_0_s1_in_a_read_cycle = nios2_data_master_granted_timer_0_s1 & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = timer_0_s1_in_a_read_cycle;

  //timer_0_s1_waits_for_write in a cycle, which is an e_mux
  assign timer_0_s1_waits_for_write = timer_0_s1_in_a_write_cycle & 0;

  //timer_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign timer_0_s1_in_a_write_cycle = nios2_data_master_granted_timer_0_s1 & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = timer_0_s1_in_a_write_cycle;

  assign wait_for_timer_0_s1_counter = 0;
  //assign timer_0_s1_irq_from_sa = timer_0_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign timer_0_s1_irq_from_sa = timer_0_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //timer_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pc8001_sub_system_reset_clk_1_domain_synch_module (
                                                           // inputs:
                                                            clk,
                                                            data_in,
                                                            reset_n,

                                                           // outputs:
                                                            data_out
                                                         )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pc8001_sub_system (
                           // 1) global signals:
                            clk_1,
                            reset_n,

                           // the_cmt_din
                            in_port_to_the_cmt_din,

                           // the_cmt_dout
                            out_port_from_the_cmt_dout,

                           // the_cmt_gpio_in
                            in_port_to_the_cmt_gpio_in,

                           // the_cmt_gpio_out
                            out_port_from_the_cmt_gpio_out,

                           // the_gpio0
                            out_port_from_the_gpio0,

                           // the_gpio1
                            in_port_to_the_gpio1
                         )
;

  output  [  7: 0] out_port_from_the_cmt_dout;
  output  [  7: 0] out_port_from_the_cmt_gpio_out;
  output  [  7: 0] out_port_from_the_gpio0;
  input            clk_1;
  input   [  7: 0] in_port_to_the_cmt_din;
  input   [  7: 0] in_port_to_the_cmt_gpio_in;
  input   [  7: 0] in_port_to_the_gpio1;
  input            reset_n;

  wire             clk_1_reset_n;
  wire    [  1: 0] cmt_din_s1_address;
  wire    [ 31: 0] cmt_din_s1_readdata;
  wire    [ 31: 0] cmt_din_s1_readdata_from_sa;
  wire             cmt_din_s1_reset_n;
  wire    [  1: 0] cmt_dout_s1_address;
  wire             cmt_dout_s1_chipselect;
  wire    [ 31: 0] cmt_dout_s1_readdata;
  wire    [ 31: 0] cmt_dout_s1_readdata_from_sa;
  wire             cmt_dout_s1_reset_n;
  wire             cmt_dout_s1_write_n;
  wire    [ 31: 0] cmt_dout_s1_writedata;
  wire    [  1: 0] cmt_gpio_in_s1_address;
  wire    [ 31: 0] cmt_gpio_in_s1_readdata;
  wire    [ 31: 0] cmt_gpio_in_s1_readdata_from_sa;
  wire             cmt_gpio_in_s1_reset_n;
  wire    [  1: 0] cmt_gpio_out_s1_address;
  wire             cmt_gpio_out_s1_chipselect;
  wire    [ 31: 0] cmt_gpio_out_s1_readdata;
  wire    [ 31: 0] cmt_gpio_out_s1_readdata_from_sa;
  wire             cmt_gpio_out_s1_reset_n;
  wire             cmt_gpio_out_s1_write_n;
  wire    [ 31: 0] cmt_gpio_out_s1_writedata;
  wire             d1_cmt_din_s1_end_xfer;
  wire             d1_cmt_dout_s1_end_xfer;
  wire             d1_cmt_gpio_in_s1_end_xfer;
  wire             d1_cmt_gpio_out_s1_end_xfer;
  wire             d1_gpio0_s1_end_xfer;
  wire             d1_gpio1_s1_end_xfer;
  wire             d1_jtag_uart_avalon_jtag_slave_end_xfer;
  wire             d1_nios2_jtag_debug_module_end_xfer;
  wire             d1_sram_s1_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_timer_0_s1_end_xfer;
  wire    [  1: 0] gpio0_s1_address;
  wire             gpio0_s1_chipselect;
  wire    [ 31: 0] gpio0_s1_readdata;
  wire    [ 31: 0] gpio0_s1_readdata_from_sa;
  wire             gpio0_s1_reset_n;
  wire             gpio0_s1_write_n;
  wire    [ 31: 0] gpio0_s1_writedata;
  wire    [  1: 0] gpio1_s1_address;
  wire    [ 31: 0] gpio1_s1_readdata;
  wire    [ 31: 0] gpio1_s1_readdata_from_sa;
  wire             gpio1_s1_reset_n;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_irq;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  wire             jtag_uart_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire    [ 13: 0] nios2_data_master_address;
  wire    [ 13: 0] nios2_data_master_address_to_slave;
  wire    [  3: 0] nios2_data_master_byteenable;
  wire             nios2_data_master_debugaccess;
  wire             nios2_data_master_granted_cmt_din_s1;
  wire             nios2_data_master_granted_cmt_dout_s1;
  wire             nios2_data_master_granted_cmt_gpio_in_s1;
  wire             nios2_data_master_granted_cmt_gpio_out_s1;
  wire             nios2_data_master_granted_gpio0_s1;
  wire             nios2_data_master_granted_gpio1_s1;
  wire             nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_granted_nios2_jtag_debug_module;
  wire             nios2_data_master_granted_sram_s1;
  wire             nios2_data_master_granted_sysid_control_slave;
  wire             nios2_data_master_granted_timer_0_s1;
  wire    [ 31: 0] nios2_data_master_irq;
  wire             nios2_data_master_qualified_request_cmt_din_s1;
  wire             nios2_data_master_qualified_request_cmt_dout_s1;
  wire             nios2_data_master_qualified_request_cmt_gpio_in_s1;
  wire             nios2_data_master_qualified_request_cmt_gpio_out_s1;
  wire             nios2_data_master_qualified_request_gpio0_s1;
  wire             nios2_data_master_qualified_request_gpio1_s1;
  wire             nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_qualified_request_nios2_jtag_debug_module;
  wire             nios2_data_master_qualified_request_sram_s1;
  wire             nios2_data_master_qualified_request_sysid_control_slave;
  wire             nios2_data_master_qualified_request_timer_0_s1;
  wire             nios2_data_master_read;
  wire             nios2_data_master_read_data_valid_cmt_din_s1;
  wire             nios2_data_master_read_data_valid_cmt_dout_s1;
  wire             nios2_data_master_read_data_valid_cmt_gpio_in_s1;
  wire             nios2_data_master_read_data_valid_cmt_gpio_out_s1;
  wire             nios2_data_master_read_data_valid_gpio0_s1;
  wire             nios2_data_master_read_data_valid_gpio1_s1;
  wire             nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_read_data_valid_nios2_jtag_debug_module;
  wire             nios2_data_master_read_data_valid_sram_s1;
  wire             nios2_data_master_read_data_valid_sysid_control_slave;
  wire             nios2_data_master_read_data_valid_timer_0_s1;
  wire    [ 31: 0] nios2_data_master_readdata;
  wire             nios2_data_master_requests_cmt_din_s1;
  wire             nios2_data_master_requests_cmt_dout_s1;
  wire             nios2_data_master_requests_cmt_gpio_in_s1;
  wire             nios2_data_master_requests_cmt_gpio_out_s1;
  wire             nios2_data_master_requests_gpio0_s1;
  wire             nios2_data_master_requests_gpio1_s1;
  wire             nios2_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_requests_nios2_jtag_debug_module;
  wire             nios2_data_master_requests_sram_s1;
  wire             nios2_data_master_requests_sysid_control_slave;
  wire             nios2_data_master_requests_timer_0_s1;
  wire             nios2_data_master_waitrequest;
  wire             nios2_data_master_write;
  wire    [ 31: 0] nios2_data_master_writedata;
  wire    [ 13: 0] nios2_instruction_master_address;
  wire    [ 13: 0] nios2_instruction_master_address_to_slave;
  wire             nios2_instruction_master_granted_nios2_jtag_debug_module;
  wire             nios2_instruction_master_granted_sram_s1;
  wire             nios2_instruction_master_qualified_request_nios2_jtag_debug_module;
  wire             nios2_instruction_master_qualified_request_sram_s1;
  wire             nios2_instruction_master_read;
  wire             nios2_instruction_master_read_data_valid_nios2_jtag_debug_module;
  wire             nios2_instruction_master_read_data_valid_sram_s1;
  wire    [ 31: 0] nios2_instruction_master_readdata;
  wire             nios2_instruction_master_requests_nios2_jtag_debug_module;
  wire             nios2_instruction_master_requests_sram_s1;
  wire             nios2_instruction_master_waitrequest;
  wire    [  8: 0] nios2_jtag_debug_module_address;
  wire             nios2_jtag_debug_module_begintransfer;
  wire    [  3: 0] nios2_jtag_debug_module_byteenable;
  wire             nios2_jtag_debug_module_chipselect;
  wire             nios2_jtag_debug_module_debugaccess;
  wire    [ 31: 0] nios2_jtag_debug_module_readdata;
  wire    [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  wire             nios2_jtag_debug_module_reset_n;
  wire             nios2_jtag_debug_module_resetrequest;
  wire             nios2_jtag_debug_module_resetrequest_from_sa;
  wire             nios2_jtag_debug_module_write;
  wire    [ 31: 0] nios2_jtag_debug_module_writedata;
  wire    [  7: 0] out_port_from_the_cmt_dout;
  wire    [  7: 0] out_port_from_the_cmt_gpio_out;
  wire    [  7: 0] out_port_from_the_gpio0;
  wire             registered_nios2_data_master_read_data_valid_sram_s1;
  wire             reset_n_sources;
  wire    [ 10: 0] sram_s1_address;
  wire    [  3: 0] sram_s1_byteenable;
  wire             sram_s1_chipselect;
  wire             sram_s1_clken;
  wire    [ 31: 0] sram_s1_readdata;
  wire    [ 31: 0] sram_s1_readdata_from_sa;
  wire             sram_s1_reset;
  wire             sram_s1_write;
  wire    [ 31: 0] sram_s1_writedata;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_clock;
  wire    [ 31: 0] sysid_control_slave_readdata;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  wire             sysid_control_slave_reset_n;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_chipselect;
  wire             timer_0_s1_irq;
  wire             timer_0_s1_irq_from_sa;
  wire    [ 15: 0] timer_0_s1_readdata;
  wire    [ 15: 0] timer_0_s1_readdata_from_sa;
  wire             timer_0_s1_reset_n;
  wire             timer_0_s1_write_n;
  wire    [ 15: 0] timer_0_s1_writedata;
  cmt_din_s1_arbitrator the_cmt_din_s1
    (
      .clk                                            (clk_1),
      .cmt_din_s1_address                             (cmt_din_s1_address),
      .cmt_din_s1_readdata                            (cmt_din_s1_readdata),
      .cmt_din_s1_readdata_from_sa                    (cmt_din_s1_readdata_from_sa),
      .cmt_din_s1_reset_n                             (cmt_din_s1_reset_n),
      .d1_cmt_din_s1_end_xfer                         (d1_cmt_din_s1_end_xfer),
      .nios2_data_master_address_to_slave             (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_cmt_din_s1           (nios2_data_master_granted_cmt_din_s1),
      .nios2_data_master_qualified_request_cmt_din_s1 (nios2_data_master_qualified_request_cmt_din_s1),
      .nios2_data_master_read                         (nios2_data_master_read),
      .nios2_data_master_read_data_valid_cmt_din_s1   (nios2_data_master_read_data_valid_cmt_din_s1),
      .nios2_data_master_requests_cmt_din_s1          (nios2_data_master_requests_cmt_din_s1),
      .nios2_data_master_write                        (nios2_data_master_write),
      .reset_n                                        (clk_1_reset_n)
    );

  cmt_din the_cmt_din
    (
      .address  (cmt_din_s1_address),
      .clk      (clk_1),
      .in_port  (in_port_to_the_cmt_din),
      .readdata (cmt_din_s1_readdata),
      .reset_n  (cmt_din_s1_reset_n)
    );

  cmt_dout_s1_arbitrator the_cmt_dout_s1
    (
      .clk                                             (clk_1),
      .cmt_dout_s1_address                             (cmt_dout_s1_address),
      .cmt_dout_s1_chipselect                          (cmt_dout_s1_chipselect),
      .cmt_dout_s1_readdata                            (cmt_dout_s1_readdata),
      .cmt_dout_s1_readdata_from_sa                    (cmt_dout_s1_readdata_from_sa),
      .cmt_dout_s1_reset_n                             (cmt_dout_s1_reset_n),
      .cmt_dout_s1_write_n                             (cmt_dout_s1_write_n),
      .cmt_dout_s1_writedata                           (cmt_dout_s1_writedata),
      .d1_cmt_dout_s1_end_xfer                         (d1_cmt_dout_s1_end_xfer),
      .nios2_data_master_address_to_slave              (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_cmt_dout_s1           (nios2_data_master_granted_cmt_dout_s1),
      .nios2_data_master_qualified_request_cmt_dout_s1 (nios2_data_master_qualified_request_cmt_dout_s1),
      .nios2_data_master_read                          (nios2_data_master_read),
      .nios2_data_master_read_data_valid_cmt_dout_s1   (nios2_data_master_read_data_valid_cmt_dout_s1),
      .nios2_data_master_requests_cmt_dout_s1          (nios2_data_master_requests_cmt_dout_s1),
      .nios2_data_master_waitrequest                   (nios2_data_master_waitrequest),
      .nios2_data_master_write                         (nios2_data_master_write),
      .nios2_data_master_writedata                     (nios2_data_master_writedata),
      .reset_n                                         (clk_1_reset_n)
    );

  cmt_dout the_cmt_dout
    (
      .address    (cmt_dout_s1_address),
      .chipselect (cmt_dout_s1_chipselect),
      .clk        (clk_1),
      .out_port   (out_port_from_the_cmt_dout),
      .readdata   (cmt_dout_s1_readdata),
      .reset_n    (cmt_dout_s1_reset_n),
      .write_n    (cmt_dout_s1_write_n),
      .writedata  (cmt_dout_s1_writedata)
    );

  cmt_gpio_in_s1_arbitrator the_cmt_gpio_in_s1
    (
      .clk                                                (clk_1),
      .cmt_gpio_in_s1_address                             (cmt_gpio_in_s1_address),
      .cmt_gpio_in_s1_readdata                            (cmt_gpio_in_s1_readdata),
      .cmt_gpio_in_s1_readdata_from_sa                    (cmt_gpio_in_s1_readdata_from_sa),
      .cmt_gpio_in_s1_reset_n                             (cmt_gpio_in_s1_reset_n),
      .d1_cmt_gpio_in_s1_end_xfer                         (d1_cmt_gpio_in_s1_end_xfer),
      .nios2_data_master_address_to_slave                 (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_cmt_gpio_in_s1           (nios2_data_master_granted_cmt_gpio_in_s1),
      .nios2_data_master_qualified_request_cmt_gpio_in_s1 (nios2_data_master_qualified_request_cmt_gpio_in_s1),
      .nios2_data_master_read                             (nios2_data_master_read),
      .nios2_data_master_read_data_valid_cmt_gpio_in_s1   (nios2_data_master_read_data_valid_cmt_gpio_in_s1),
      .nios2_data_master_requests_cmt_gpio_in_s1          (nios2_data_master_requests_cmt_gpio_in_s1),
      .nios2_data_master_write                            (nios2_data_master_write),
      .reset_n                                            (clk_1_reset_n)
    );

  cmt_gpio_in the_cmt_gpio_in
    (
      .address  (cmt_gpio_in_s1_address),
      .clk      (clk_1),
      .in_port  (in_port_to_the_cmt_gpio_in),
      .readdata (cmt_gpio_in_s1_readdata),
      .reset_n  (cmt_gpio_in_s1_reset_n)
    );

  cmt_gpio_out_s1_arbitrator the_cmt_gpio_out_s1
    (
      .clk                                                 (clk_1),
      .cmt_gpio_out_s1_address                             (cmt_gpio_out_s1_address),
      .cmt_gpio_out_s1_chipselect                          (cmt_gpio_out_s1_chipselect),
      .cmt_gpio_out_s1_readdata                            (cmt_gpio_out_s1_readdata),
      .cmt_gpio_out_s1_readdata_from_sa                    (cmt_gpio_out_s1_readdata_from_sa),
      .cmt_gpio_out_s1_reset_n                             (cmt_gpio_out_s1_reset_n),
      .cmt_gpio_out_s1_write_n                             (cmt_gpio_out_s1_write_n),
      .cmt_gpio_out_s1_writedata                           (cmt_gpio_out_s1_writedata),
      .d1_cmt_gpio_out_s1_end_xfer                         (d1_cmt_gpio_out_s1_end_xfer),
      .nios2_data_master_address_to_slave                  (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_cmt_gpio_out_s1           (nios2_data_master_granted_cmt_gpio_out_s1),
      .nios2_data_master_qualified_request_cmt_gpio_out_s1 (nios2_data_master_qualified_request_cmt_gpio_out_s1),
      .nios2_data_master_read                              (nios2_data_master_read),
      .nios2_data_master_read_data_valid_cmt_gpio_out_s1   (nios2_data_master_read_data_valid_cmt_gpio_out_s1),
      .nios2_data_master_requests_cmt_gpio_out_s1          (nios2_data_master_requests_cmt_gpio_out_s1),
      .nios2_data_master_waitrequest                       (nios2_data_master_waitrequest),
      .nios2_data_master_write                             (nios2_data_master_write),
      .nios2_data_master_writedata                         (nios2_data_master_writedata),
      .reset_n                                             (clk_1_reset_n)
    );

  cmt_gpio_out the_cmt_gpio_out
    (
      .address    (cmt_gpio_out_s1_address),
      .chipselect (cmt_gpio_out_s1_chipselect),
      .clk        (clk_1),
      .out_port   (out_port_from_the_cmt_gpio_out),
      .readdata   (cmt_gpio_out_s1_readdata),
      .reset_n    (cmt_gpio_out_s1_reset_n),
      .write_n    (cmt_gpio_out_s1_write_n),
      .writedata  (cmt_gpio_out_s1_writedata)
    );

  gpio0_s1_arbitrator the_gpio0_s1
    (
      .clk                                          (clk_1),
      .d1_gpio0_s1_end_xfer                         (d1_gpio0_s1_end_xfer),
      .gpio0_s1_address                             (gpio0_s1_address),
      .gpio0_s1_chipselect                          (gpio0_s1_chipselect),
      .gpio0_s1_readdata                            (gpio0_s1_readdata),
      .gpio0_s1_readdata_from_sa                    (gpio0_s1_readdata_from_sa),
      .gpio0_s1_reset_n                             (gpio0_s1_reset_n),
      .gpio0_s1_write_n                             (gpio0_s1_write_n),
      .gpio0_s1_writedata                           (gpio0_s1_writedata),
      .nios2_data_master_address_to_slave           (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_gpio0_s1           (nios2_data_master_granted_gpio0_s1),
      .nios2_data_master_qualified_request_gpio0_s1 (nios2_data_master_qualified_request_gpio0_s1),
      .nios2_data_master_read                       (nios2_data_master_read),
      .nios2_data_master_read_data_valid_gpio0_s1   (nios2_data_master_read_data_valid_gpio0_s1),
      .nios2_data_master_requests_gpio0_s1          (nios2_data_master_requests_gpio0_s1),
      .nios2_data_master_waitrequest                (nios2_data_master_waitrequest),
      .nios2_data_master_write                      (nios2_data_master_write),
      .nios2_data_master_writedata                  (nios2_data_master_writedata),
      .reset_n                                      (clk_1_reset_n)
    );

  gpio0 the_gpio0
    (
      .address    (gpio0_s1_address),
      .chipselect (gpio0_s1_chipselect),
      .clk        (clk_1),
      .out_port   (out_port_from_the_gpio0),
      .readdata   (gpio0_s1_readdata),
      .reset_n    (gpio0_s1_reset_n),
      .write_n    (gpio0_s1_write_n),
      .writedata  (gpio0_s1_writedata)
    );

  gpio1_s1_arbitrator the_gpio1_s1
    (
      .clk                                          (clk_1),
      .d1_gpio1_s1_end_xfer                         (d1_gpio1_s1_end_xfer),
      .gpio1_s1_address                             (gpio1_s1_address),
      .gpio1_s1_readdata                            (gpio1_s1_readdata),
      .gpio1_s1_readdata_from_sa                    (gpio1_s1_readdata_from_sa),
      .gpio1_s1_reset_n                             (gpio1_s1_reset_n),
      .nios2_data_master_address_to_slave           (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_gpio1_s1           (nios2_data_master_granted_gpio1_s1),
      .nios2_data_master_qualified_request_gpio1_s1 (nios2_data_master_qualified_request_gpio1_s1),
      .nios2_data_master_read                       (nios2_data_master_read),
      .nios2_data_master_read_data_valid_gpio1_s1   (nios2_data_master_read_data_valid_gpio1_s1),
      .nios2_data_master_requests_gpio1_s1          (nios2_data_master_requests_gpio1_s1),
      .nios2_data_master_write                      (nios2_data_master_write),
      .reset_n                                      (clk_1_reset_n)
    );

  gpio1 the_gpio1
    (
      .address  (gpio1_s1_address),
      .clk      (clk_1),
      .in_port  (in_port_to_the_gpio1),
      .readdata (gpio1_s1_readdata),
      .reset_n  (gpio1_s1_reset_n)
    );

  jtag_uart_avalon_jtag_slave_arbitrator the_jtag_uart_avalon_jtag_slave
    (
      .clk                                                             (clk_1),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .jtag_uart_avalon_jtag_slave_address                             (jtag_uart_avalon_jtag_slave_address),
      .jtag_uart_avalon_jtag_slave_chipselect                          (jtag_uart_avalon_jtag_slave_chipselect),
      .jtag_uart_avalon_jtag_slave_dataavailable                       (jtag_uart_avalon_jtag_slave_dataavailable),
      .jtag_uart_avalon_jtag_slave_dataavailable_from_sa               (jtag_uart_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_avalon_jtag_slave_irq                                 (jtag_uart_avalon_jtag_slave_irq),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                         (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_read_n                              (jtag_uart_avalon_jtag_slave_read_n),
      .jtag_uart_avalon_jtag_slave_readdata                            (jtag_uart_avalon_jtag_slave_readdata),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_readyfordata                        (jtag_uart_avalon_jtag_slave_readyfordata),
      .jtag_uart_avalon_jtag_slave_readyfordata_from_sa                (jtag_uart_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_avalon_jtag_slave_reset_n                             (jtag_uart_avalon_jtag_slave_reset_n),
      .jtag_uart_avalon_jtag_slave_waitrequest                         (jtag_uart_avalon_jtag_slave_waitrequest),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_avalon_jtag_slave_write_n                             (jtag_uart_avalon_jtag_slave_write_n),
      .jtag_uart_avalon_jtag_slave_writedata                           (jtag_uart_avalon_jtag_slave_writedata),
      .nios2_data_master_address_to_slave                              (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_jtag_uart_avalon_jtag_slave           (nios2_data_master_granted_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave (nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_read                                          (nios2_data_master_read),
      .nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave   (nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_requests_jtag_uart_avalon_jtag_slave          (nios2_data_master_requests_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_waitrequest                                   (nios2_data_master_waitrequest),
      .nios2_data_master_write                                         (nios2_data_master_write),
      .nios2_data_master_writedata                                     (nios2_data_master_writedata),
      .reset_n                                                         (clk_1_reset_n)
    );

  jtag_uart the_jtag_uart
    (
      .av_address     (jtag_uart_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_avalon_jtag_slave_writedata),
      .clk            (clk_1),
      .dataavailable  (jtag_uart_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_avalon_jtag_slave_reset_n)
    );

  nios2_jtag_debug_module_arbitrator the_nios2_jtag_debug_module
    (
      .clk                                                                (clk_1),
      .d1_nios2_jtag_debug_module_end_xfer                                (d1_nios2_jtag_debug_module_end_xfer),
      .nios2_data_master_address_to_slave                                 (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                       (nios2_data_master_byteenable),
      .nios2_data_master_debugaccess                                      (nios2_data_master_debugaccess),
      .nios2_data_master_granted_nios2_jtag_debug_module                  (nios2_data_master_granted_nios2_jtag_debug_module),
      .nios2_data_master_qualified_request_nios2_jtag_debug_module        (nios2_data_master_qualified_request_nios2_jtag_debug_module),
      .nios2_data_master_read                                             (nios2_data_master_read),
      .nios2_data_master_read_data_valid_nios2_jtag_debug_module          (nios2_data_master_read_data_valid_nios2_jtag_debug_module),
      .nios2_data_master_requests_nios2_jtag_debug_module                 (nios2_data_master_requests_nios2_jtag_debug_module),
      .nios2_data_master_waitrequest                                      (nios2_data_master_waitrequest),
      .nios2_data_master_write                                            (nios2_data_master_write),
      .nios2_data_master_writedata                                        (nios2_data_master_writedata),
      .nios2_instruction_master_address_to_slave                          (nios2_instruction_master_address_to_slave),
      .nios2_instruction_master_granted_nios2_jtag_debug_module           (nios2_instruction_master_granted_nios2_jtag_debug_module),
      .nios2_instruction_master_qualified_request_nios2_jtag_debug_module (nios2_instruction_master_qualified_request_nios2_jtag_debug_module),
      .nios2_instruction_master_read                                      (nios2_instruction_master_read),
      .nios2_instruction_master_read_data_valid_nios2_jtag_debug_module   (nios2_instruction_master_read_data_valid_nios2_jtag_debug_module),
      .nios2_instruction_master_requests_nios2_jtag_debug_module          (nios2_instruction_master_requests_nios2_jtag_debug_module),
      .nios2_jtag_debug_module_address                                    (nios2_jtag_debug_module_address),
      .nios2_jtag_debug_module_begintransfer                              (nios2_jtag_debug_module_begintransfer),
      .nios2_jtag_debug_module_byteenable                                 (nios2_jtag_debug_module_byteenable),
      .nios2_jtag_debug_module_chipselect                                 (nios2_jtag_debug_module_chipselect),
      .nios2_jtag_debug_module_debugaccess                                (nios2_jtag_debug_module_debugaccess),
      .nios2_jtag_debug_module_readdata                                   (nios2_jtag_debug_module_readdata),
      .nios2_jtag_debug_module_readdata_from_sa                           (nios2_jtag_debug_module_readdata_from_sa),
      .nios2_jtag_debug_module_reset_n                                    (nios2_jtag_debug_module_reset_n),
      .nios2_jtag_debug_module_resetrequest                               (nios2_jtag_debug_module_resetrequest),
      .nios2_jtag_debug_module_resetrequest_from_sa                       (nios2_jtag_debug_module_resetrequest_from_sa),
      .nios2_jtag_debug_module_write                                      (nios2_jtag_debug_module_write),
      .nios2_jtag_debug_module_writedata                                  (nios2_jtag_debug_module_writedata),
      .reset_n                                                            (clk_1_reset_n)
    );

  nios2_data_master_arbitrator the_nios2_data_master
    (
      .clk                                                             (clk_1),
      .cmt_din_s1_readdata_from_sa                                     (cmt_din_s1_readdata_from_sa),
      .cmt_dout_s1_readdata_from_sa                                    (cmt_dout_s1_readdata_from_sa),
      .cmt_gpio_in_s1_readdata_from_sa                                 (cmt_gpio_in_s1_readdata_from_sa),
      .cmt_gpio_out_s1_readdata_from_sa                                (cmt_gpio_out_s1_readdata_from_sa),
      .d1_cmt_din_s1_end_xfer                                          (d1_cmt_din_s1_end_xfer),
      .d1_cmt_dout_s1_end_xfer                                         (d1_cmt_dout_s1_end_xfer),
      .d1_cmt_gpio_in_s1_end_xfer                                      (d1_cmt_gpio_in_s1_end_xfer),
      .d1_cmt_gpio_out_s1_end_xfer                                     (d1_cmt_gpio_out_s1_end_xfer),
      .d1_gpio0_s1_end_xfer                                            (d1_gpio0_s1_end_xfer),
      .d1_gpio1_s1_end_xfer                                            (d1_gpio1_s1_end_xfer),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .d1_nios2_jtag_debug_module_end_xfer                             (d1_nios2_jtag_debug_module_end_xfer),
      .d1_sram_s1_end_xfer                                             (d1_sram_s1_end_xfer),
      .d1_sysid_control_slave_end_xfer                                 (d1_sysid_control_slave_end_xfer),
      .d1_timer_0_s1_end_xfer                                          (d1_timer_0_s1_end_xfer),
      .gpio0_s1_readdata_from_sa                                       (gpio0_s1_readdata_from_sa),
      .gpio1_s1_readdata_from_sa                                       (gpio1_s1_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                         (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .nios2_data_master_address                                       (nios2_data_master_address),
      .nios2_data_master_address_to_slave                              (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_cmt_din_s1                            (nios2_data_master_granted_cmt_din_s1),
      .nios2_data_master_granted_cmt_dout_s1                           (nios2_data_master_granted_cmt_dout_s1),
      .nios2_data_master_granted_cmt_gpio_in_s1                        (nios2_data_master_granted_cmt_gpio_in_s1),
      .nios2_data_master_granted_cmt_gpio_out_s1                       (nios2_data_master_granted_cmt_gpio_out_s1),
      .nios2_data_master_granted_gpio0_s1                              (nios2_data_master_granted_gpio0_s1),
      .nios2_data_master_granted_gpio1_s1                              (nios2_data_master_granted_gpio1_s1),
      .nios2_data_master_granted_jtag_uart_avalon_jtag_slave           (nios2_data_master_granted_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_granted_nios2_jtag_debug_module               (nios2_data_master_granted_nios2_jtag_debug_module),
      .nios2_data_master_granted_sram_s1                               (nios2_data_master_granted_sram_s1),
      .nios2_data_master_granted_sysid_control_slave                   (nios2_data_master_granted_sysid_control_slave),
      .nios2_data_master_granted_timer_0_s1                            (nios2_data_master_granted_timer_0_s1),
      .nios2_data_master_irq                                           (nios2_data_master_irq),
      .nios2_data_master_qualified_request_cmt_din_s1                  (nios2_data_master_qualified_request_cmt_din_s1),
      .nios2_data_master_qualified_request_cmt_dout_s1                 (nios2_data_master_qualified_request_cmt_dout_s1),
      .nios2_data_master_qualified_request_cmt_gpio_in_s1              (nios2_data_master_qualified_request_cmt_gpio_in_s1),
      .nios2_data_master_qualified_request_cmt_gpio_out_s1             (nios2_data_master_qualified_request_cmt_gpio_out_s1),
      .nios2_data_master_qualified_request_gpio0_s1                    (nios2_data_master_qualified_request_gpio0_s1),
      .nios2_data_master_qualified_request_gpio1_s1                    (nios2_data_master_qualified_request_gpio1_s1),
      .nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave (nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_qualified_request_nios2_jtag_debug_module     (nios2_data_master_qualified_request_nios2_jtag_debug_module),
      .nios2_data_master_qualified_request_sram_s1                     (nios2_data_master_qualified_request_sram_s1),
      .nios2_data_master_qualified_request_sysid_control_slave         (nios2_data_master_qualified_request_sysid_control_slave),
      .nios2_data_master_qualified_request_timer_0_s1                  (nios2_data_master_qualified_request_timer_0_s1),
      .nios2_data_master_read                                          (nios2_data_master_read),
      .nios2_data_master_read_data_valid_cmt_din_s1                    (nios2_data_master_read_data_valid_cmt_din_s1),
      .nios2_data_master_read_data_valid_cmt_dout_s1                   (nios2_data_master_read_data_valid_cmt_dout_s1),
      .nios2_data_master_read_data_valid_cmt_gpio_in_s1                (nios2_data_master_read_data_valid_cmt_gpio_in_s1),
      .nios2_data_master_read_data_valid_cmt_gpio_out_s1               (nios2_data_master_read_data_valid_cmt_gpio_out_s1),
      .nios2_data_master_read_data_valid_gpio0_s1                      (nios2_data_master_read_data_valid_gpio0_s1),
      .nios2_data_master_read_data_valid_gpio1_s1                      (nios2_data_master_read_data_valid_gpio1_s1),
      .nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave   (nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_read_data_valid_nios2_jtag_debug_module       (nios2_data_master_read_data_valid_nios2_jtag_debug_module),
      .nios2_data_master_read_data_valid_sram_s1                       (nios2_data_master_read_data_valid_sram_s1),
      .nios2_data_master_read_data_valid_sysid_control_slave           (nios2_data_master_read_data_valid_sysid_control_slave),
      .nios2_data_master_read_data_valid_timer_0_s1                    (nios2_data_master_read_data_valid_timer_0_s1),
      .nios2_data_master_readdata                                      (nios2_data_master_readdata),
      .nios2_data_master_requests_cmt_din_s1                           (nios2_data_master_requests_cmt_din_s1),
      .nios2_data_master_requests_cmt_dout_s1                          (nios2_data_master_requests_cmt_dout_s1),
      .nios2_data_master_requests_cmt_gpio_in_s1                       (nios2_data_master_requests_cmt_gpio_in_s1),
      .nios2_data_master_requests_cmt_gpio_out_s1                      (nios2_data_master_requests_cmt_gpio_out_s1),
      .nios2_data_master_requests_gpio0_s1                             (nios2_data_master_requests_gpio0_s1),
      .nios2_data_master_requests_gpio1_s1                             (nios2_data_master_requests_gpio1_s1),
      .nios2_data_master_requests_jtag_uart_avalon_jtag_slave          (nios2_data_master_requests_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_requests_nios2_jtag_debug_module              (nios2_data_master_requests_nios2_jtag_debug_module),
      .nios2_data_master_requests_sram_s1                              (nios2_data_master_requests_sram_s1),
      .nios2_data_master_requests_sysid_control_slave                  (nios2_data_master_requests_sysid_control_slave),
      .nios2_data_master_requests_timer_0_s1                           (nios2_data_master_requests_timer_0_s1),
      .nios2_data_master_waitrequest                                   (nios2_data_master_waitrequest),
      .nios2_data_master_write                                         (nios2_data_master_write),
      .nios2_jtag_debug_module_readdata_from_sa                        (nios2_jtag_debug_module_readdata_from_sa),
      .registered_nios2_data_master_read_data_valid_sram_s1            (registered_nios2_data_master_read_data_valid_sram_s1),
      .reset_n                                                         (clk_1_reset_n),
      .sram_s1_readdata_from_sa                                        (sram_s1_readdata_from_sa),
      .sysid_control_slave_readdata_from_sa                            (sysid_control_slave_readdata_from_sa),
      .timer_0_s1_irq_from_sa                                          (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata_from_sa                                     (timer_0_s1_readdata_from_sa)
    );

  nios2_instruction_master_arbitrator the_nios2_instruction_master
    (
      .clk                                                                (clk_1),
      .d1_nios2_jtag_debug_module_end_xfer                                (d1_nios2_jtag_debug_module_end_xfer),
      .d1_sram_s1_end_xfer                                                (d1_sram_s1_end_xfer),
      .nios2_instruction_master_address                                   (nios2_instruction_master_address),
      .nios2_instruction_master_address_to_slave                          (nios2_instruction_master_address_to_slave),
      .nios2_instruction_master_granted_nios2_jtag_debug_module           (nios2_instruction_master_granted_nios2_jtag_debug_module),
      .nios2_instruction_master_granted_sram_s1                           (nios2_instruction_master_granted_sram_s1),
      .nios2_instruction_master_qualified_request_nios2_jtag_debug_module (nios2_instruction_master_qualified_request_nios2_jtag_debug_module),
      .nios2_instruction_master_qualified_request_sram_s1                 (nios2_instruction_master_qualified_request_sram_s1),
      .nios2_instruction_master_read                                      (nios2_instruction_master_read),
      .nios2_instruction_master_read_data_valid_nios2_jtag_debug_module   (nios2_instruction_master_read_data_valid_nios2_jtag_debug_module),
      .nios2_instruction_master_read_data_valid_sram_s1                   (nios2_instruction_master_read_data_valid_sram_s1),
      .nios2_instruction_master_readdata                                  (nios2_instruction_master_readdata),
      .nios2_instruction_master_requests_nios2_jtag_debug_module          (nios2_instruction_master_requests_nios2_jtag_debug_module),
      .nios2_instruction_master_requests_sram_s1                          (nios2_instruction_master_requests_sram_s1),
      .nios2_instruction_master_waitrequest                               (nios2_instruction_master_waitrequest),
      .nios2_jtag_debug_module_readdata_from_sa                           (nios2_jtag_debug_module_readdata_from_sa),
      .reset_n                                                            (clk_1_reset_n),
      .sram_s1_readdata_from_sa                                           (sram_s1_readdata_from_sa)
    );

  nios2 the_nios2
    (
      .clk                                   (clk_1),
      .d_address                             (nios2_data_master_address),
      .d_byteenable                          (nios2_data_master_byteenable),
      .d_irq                                 (nios2_data_master_irq),
      .d_read                                (nios2_data_master_read),
      .d_readdata                            (nios2_data_master_readdata),
      .d_waitrequest                         (nios2_data_master_waitrequest),
      .d_write                               (nios2_data_master_write),
      .d_writedata                           (nios2_data_master_writedata),
      .i_address                             (nios2_instruction_master_address),
      .i_read                                (nios2_instruction_master_read),
      .i_readdata                            (nios2_instruction_master_readdata),
      .i_waitrequest                         (nios2_instruction_master_waitrequest),
      .jtag_debug_module_address             (nios2_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (nios2_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (nios2_jtag_debug_module_byteenable),
      .jtag_debug_module_debugaccess         (nios2_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (nios2_data_master_debugaccess),
      .jtag_debug_module_readdata            (nios2_jtag_debug_module_readdata),
      .jtag_debug_module_resetrequest        (nios2_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (nios2_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (nios2_jtag_debug_module_write),
      .jtag_debug_module_writedata           (nios2_jtag_debug_module_writedata),
      .reset_n                               (nios2_jtag_debug_module_reset_n)
    );

  sram_s1_arbitrator the_sram_s1
    (
      .clk                                                  (clk_1),
      .d1_sram_s1_end_xfer                                  (d1_sram_s1_end_xfer),
      .nios2_data_master_address_to_slave                   (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                         (nios2_data_master_byteenable),
      .nios2_data_master_granted_sram_s1                    (nios2_data_master_granted_sram_s1),
      .nios2_data_master_qualified_request_sram_s1          (nios2_data_master_qualified_request_sram_s1),
      .nios2_data_master_read                               (nios2_data_master_read),
      .nios2_data_master_read_data_valid_sram_s1            (nios2_data_master_read_data_valid_sram_s1),
      .nios2_data_master_requests_sram_s1                   (nios2_data_master_requests_sram_s1),
      .nios2_data_master_waitrequest                        (nios2_data_master_waitrequest),
      .nios2_data_master_write                              (nios2_data_master_write),
      .nios2_data_master_writedata                          (nios2_data_master_writedata),
      .nios2_instruction_master_address_to_slave            (nios2_instruction_master_address_to_slave),
      .nios2_instruction_master_granted_sram_s1             (nios2_instruction_master_granted_sram_s1),
      .nios2_instruction_master_qualified_request_sram_s1   (nios2_instruction_master_qualified_request_sram_s1),
      .nios2_instruction_master_read                        (nios2_instruction_master_read),
      .nios2_instruction_master_read_data_valid_sram_s1     (nios2_instruction_master_read_data_valid_sram_s1),
      .nios2_instruction_master_requests_sram_s1            (nios2_instruction_master_requests_sram_s1),
      .registered_nios2_data_master_read_data_valid_sram_s1 (registered_nios2_data_master_read_data_valid_sram_s1),
      .reset_n                                              (clk_1_reset_n),
      .sram_s1_address                                      (sram_s1_address),
      .sram_s1_byteenable                                   (sram_s1_byteenable),
      .sram_s1_chipselect                                   (sram_s1_chipselect),
      .sram_s1_clken                                        (sram_s1_clken),
      .sram_s1_readdata                                     (sram_s1_readdata),
      .sram_s1_readdata_from_sa                             (sram_s1_readdata_from_sa),
      .sram_s1_reset                                        (sram_s1_reset),
      .sram_s1_write                                        (sram_s1_write),
      .sram_s1_writedata                                    (sram_s1_writedata)
    );

  sram the_sram
    (
      .address    (sram_s1_address),
      .byteenable (sram_s1_byteenable),
      .chipselect (sram_s1_chipselect),
      .clk        (clk_1),
      .clken      (sram_s1_clken),
      .readdata   (sram_s1_readdata),
      .reset      (sram_s1_reset),
      .write      (sram_s1_write),
      .writedata  (sram_s1_writedata)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                     (clk_1),
      .d1_sysid_control_slave_end_xfer                         (d1_sysid_control_slave_end_xfer),
      .nios2_data_master_address_to_slave                      (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_sysid_control_slave           (nios2_data_master_granted_sysid_control_slave),
      .nios2_data_master_qualified_request_sysid_control_slave (nios2_data_master_qualified_request_sysid_control_slave),
      .nios2_data_master_read                                  (nios2_data_master_read),
      .nios2_data_master_read_data_valid_sysid_control_slave   (nios2_data_master_read_data_valid_sysid_control_slave),
      .nios2_data_master_requests_sysid_control_slave          (nios2_data_master_requests_sysid_control_slave),
      .nios2_data_master_write                                 (nios2_data_master_write),
      .reset_n                                                 (clk_1_reset_n),
      .sysid_control_slave_address                             (sysid_control_slave_address),
      .sysid_control_slave_readdata                            (sysid_control_slave_readdata),
      .sysid_control_slave_readdata_from_sa                    (sysid_control_slave_readdata_from_sa),
      .sysid_control_slave_reset_n                             (sysid_control_slave_reset_n)
    );

  sysid the_sysid
    (
      .address  (sysid_control_slave_address),
      .clock    (sysid_control_slave_clock),
      .readdata (sysid_control_slave_readdata),
      .reset_n  (sysid_control_slave_reset_n)
    );

  timer_0_s1_arbitrator the_timer_0_s1
    (
      .clk                                            (clk_1),
      .d1_timer_0_s1_end_xfer                         (d1_timer_0_s1_end_xfer),
      .nios2_data_master_address_to_slave             (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_timer_0_s1           (nios2_data_master_granted_timer_0_s1),
      .nios2_data_master_qualified_request_timer_0_s1 (nios2_data_master_qualified_request_timer_0_s1),
      .nios2_data_master_read                         (nios2_data_master_read),
      .nios2_data_master_read_data_valid_timer_0_s1   (nios2_data_master_read_data_valid_timer_0_s1),
      .nios2_data_master_requests_timer_0_s1          (nios2_data_master_requests_timer_0_s1),
      .nios2_data_master_waitrequest                  (nios2_data_master_waitrequest),
      .nios2_data_master_write                        (nios2_data_master_write),
      .nios2_data_master_writedata                    (nios2_data_master_writedata),
      .reset_n                                        (clk_1_reset_n),
      .timer_0_s1_address                             (timer_0_s1_address),
      .timer_0_s1_chipselect                          (timer_0_s1_chipselect),
      .timer_0_s1_irq                                 (timer_0_s1_irq),
      .timer_0_s1_irq_from_sa                         (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata                            (timer_0_s1_readdata),
      .timer_0_s1_readdata_from_sa                    (timer_0_s1_readdata_from_sa),
      .timer_0_s1_reset_n                             (timer_0_s1_reset_n),
      .timer_0_s1_write_n                             (timer_0_s1_write_n),
      .timer_0_s1_writedata                           (timer_0_s1_writedata)
    );

  timer_0 the_timer_0
    (
      .address    (timer_0_s1_address),
      .chipselect (timer_0_s1_chipselect),
      .clk        (clk_1),
      .irq        (timer_0_s1_irq),
      .readdata   (timer_0_s1_readdata),
      .reset_n    (timer_0_s1_reset_n),
      .write_n    (timer_0_s1_write_n),
      .writedata  (timer_0_s1_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  pc8001_sub_system_reset_clk_1_domain_synch_module pc8001_sub_system_reset_clk_1_domain_synch
    (
      .clk      (clk_1),
      .data_in  (1'b1),
      .data_out (clk_1_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    nios2_jtag_debug_module_resetrequest_from_sa |
    nios2_jtag_debug_module_resetrequest_from_sa);

  //sysid_control_slave_clock of type clock does not connect to anything so wire it to default (0)
  assign sysid_control_slave_clock = 0;


endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/11.1sp1/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/11.1sp1/quartus/eda/sim_lib/220model.v"
`include "c:/altera/11.1sp1/quartus/eda/sim_lib/sgate.v"
`include "cmt_gpio_out.v"
`include "sram.v"
`include "timer_0.v"
`include "cmt_dout.v"
`include "sysid.v"
`include "gpio1.v"
`include "cmt_din.v"
`include "nios2_test_bench.v"
`include "nios2_oci_test_bench.v"
`include "nios2_jtag_debug_module_tck.v"
`include "nios2_jtag_debug_module_sysclk.v"
`include "nios2_jtag_debug_module_wrapper.v"
`include "nios2.v"
`include "gpio0.v"
`include "jtag_uart.v"
`include "cmt_gpio_in.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             clk;
  reg              clk_1;
  wire    [  7: 0] in_port_to_the_cmt_din;
  wire    [  7: 0] in_port_to_the_cmt_gpio_in;
  wire    [  7: 0] in_port_to_the_gpio1;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire    [  7: 0] out_port_from_the_cmt_dout;
  wire    [  7: 0] out_port_from_the_cmt_gpio_out;
  wire    [  7: 0] out_port_from_the_gpio0;
  reg              reset_n;
  wire             sysid_control_slave_clock;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  pc8001_sub_system DUT
    (
      .clk_1                          (clk_1),
      .in_port_to_the_cmt_din         (in_port_to_the_cmt_din),
      .in_port_to_the_cmt_gpio_in     (in_port_to_the_cmt_gpio_in),
      .in_port_to_the_gpio1           (in_port_to_the_gpio1),
      .out_port_from_the_cmt_dout     (out_port_from_the_cmt_dout),
      .out_port_from_the_cmt_gpio_out (out_port_from_the_cmt_gpio_out),
      .out_port_from_the_gpio0        (out_port_from_the_gpio0),
      .reset_n                        (reset_n)
    );

  initial
    clk_1 = 1'b0;
  always
    #20 clk_1 <= ~clk_1;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on