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
                                pc8001_sub_system_clock_3_out_address_to_slave,
                                pc8001_sub_system_clock_3_out_nativeaddress,
                                pc8001_sub_system_clock_3_out_read,
                                pc8001_sub_system_clock_3_out_write,
                                reset_n,

                               // outputs:
                                cmt_din_s1_address,
                                cmt_din_s1_readdata_from_sa,
                                cmt_din_s1_reset_n,
                                d1_cmt_din_s1_end_xfer,
                                pc8001_sub_system_clock_3_out_granted_cmt_din_s1,
                                pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1,
                                pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1,
                                pc8001_sub_system_clock_3_out_requests_cmt_din_s1
                             )
;

  output  [  1: 0] cmt_din_s1_address;
  output  [ 31: 0] cmt_din_s1_readdata_from_sa;
  output           cmt_din_s1_reset_n;
  output           d1_cmt_din_s1_end_xfer;
  output           pc8001_sub_system_clock_3_out_granted_cmt_din_s1;
  output           pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1;
  output           pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1;
  output           pc8001_sub_system_clock_3_out_requests_cmt_din_s1;
  input            clk;
  input   [ 31: 0] cmt_din_s1_readdata;
  input   [  3: 0] pc8001_sub_system_clock_3_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_3_out_nativeaddress;
  input            pc8001_sub_system_clock_3_out_read;
  input            pc8001_sub_system_clock_3_out_write;
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
  wire             pc8001_sub_system_clock_3_out_arbiterlock;
  wire             pc8001_sub_system_clock_3_out_arbiterlock2;
  wire             pc8001_sub_system_clock_3_out_continuerequest;
  wire             pc8001_sub_system_clock_3_out_granted_cmt_din_s1;
  wire             pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1;
  wire             pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1;
  wire             pc8001_sub_system_clock_3_out_requests_cmt_din_s1;
  wire             pc8001_sub_system_clock_3_out_saved_grant_cmt_din_s1;
  wire             wait_for_cmt_din_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_din_s1_end_xfer;
    end


  assign cmt_din_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1));
  //assign cmt_din_s1_readdata_from_sa = cmt_din_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_din_s1_readdata_from_sa = cmt_din_s1_readdata;

  assign pc8001_sub_system_clock_3_out_requests_cmt_din_s1 = ((1) & (pc8001_sub_system_clock_3_out_read | pc8001_sub_system_clock_3_out_write)) & pc8001_sub_system_clock_3_out_read;
  //cmt_din_s1_arb_share_counter set values, which is an e_mux
  assign cmt_din_s1_arb_share_set_values = 1;

  //cmt_din_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_din_s1_non_bursting_master_requests = pc8001_sub_system_clock_3_out_requests_cmt_din_s1;

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


  //pc8001_sub_system_clock_3/out cmt_din/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_3_out_arbiterlock = cmt_din_s1_slavearbiterlockenable & pc8001_sub_system_clock_3_out_continuerequest;

  //cmt_din_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_din_s1_slavearbiterlockenable2 = |cmt_din_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_3/out cmt_din/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_3_out_arbiterlock2 = cmt_din_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_3_out_continuerequest;

  //cmt_din_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_din_s1_any_continuerequest = 1;

  //pc8001_sub_system_clock_3_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_3_out_continuerequest = 1;

  assign pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1 = pc8001_sub_system_clock_3_out_requests_cmt_din_s1;
  //master is always granted when requested
  assign pc8001_sub_system_clock_3_out_granted_cmt_din_s1 = pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1;

  //pc8001_sub_system_clock_3/out saved-grant cmt_din/s1, which is an e_assign
  assign pc8001_sub_system_clock_3_out_saved_grant_cmt_din_s1 = pc8001_sub_system_clock_3_out_requests_cmt_din_s1;

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

  //cmt_din_s1_address mux, which is an e_mux
  assign cmt_din_s1_address = pc8001_sub_system_clock_3_out_nativeaddress;

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
  assign cmt_din_s1_in_a_read_cycle = pc8001_sub_system_clock_3_out_granted_cmt_din_s1 & pc8001_sub_system_clock_3_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_din_s1_in_a_read_cycle;

  //cmt_din_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_din_s1_waits_for_write = cmt_din_s1_in_a_write_cycle & 0;

  //cmt_din_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_din_s1_in_a_write_cycle = pc8001_sub_system_clock_3_out_granted_cmt_din_s1 & pc8001_sub_system_clock_3_out_write;

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
                                 pc8001_sub_system_clock_2_out_address_to_slave,
                                 pc8001_sub_system_clock_2_out_nativeaddress,
                                 pc8001_sub_system_clock_2_out_read,
                                 pc8001_sub_system_clock_2_out_write,
                                 pc8001_sub_system_clock_2_out_writedata,
                                 reset_n,

                                // outputs:
                                 cmt_dout_s1_address,
                                 cmt_dout_s1_chipselect,
                                 cmt_dout_s1_readdata_from_sa,
                                 cmt_dout_s1_reset_n,
                                 cmt_dout_s1_write_n,
                                 cmt_dout_s1_writedata,
                                 d1_cmt_dout_s1_end_xfer,
                                 pc8001_sub_system_clock_2_out_granted_cmt_dout_s1,
                                 pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1,
                                 pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1,
                                 pc8001_sub_system_clock_2_out_requests_cmt_dout_s1
                              )
;

  output  [  1: 0] cmt_dout_s1_address;
  output           cmt_dout_s1_chipselect;
  output  [ 31: 0] cmt_dout_s1_readdata_from_sa;
  output           cmt_dout_s1_reset_n;
  output           cmt_dout_s1_write_n;
  output  [ 31: 0] cmt_dout_s1_writedata;
  output           d1_cmt_dout_s1_end_xfer;
  output           pc8001_sub_system_clock_2_out_granted_cmt_dout_s1;
  output           pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1;
  output           pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1;
  output           pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;
  input            clk;
  input   [ 31: 0] cmt_dout_s1_readdata;
  input   [  3: 0] pc8001_sub_system_clock_2_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_2_out_nativeaddress;
  input            pc8001_sub_system_clock_2_out_read;
  input            pc8001_sub_system_clock_2_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_2_out_writedata;
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
  wire             pc8001_sub_system_clock_2_out_arbiterlock;
  wire             pc8001_sub_system_clock_2_out_arbiterlock2;
  wire             pc8001_sub_system_clock_2_out_continuerequest;
  wire             pc8001_sub_system_clock_2_out_granted_cmt_dout_s1;
  wire             pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1;
  wire             pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1;
  wire             pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;
  wire             pc8001_sub_system_clock_2_out_saved_grant_cmt_dout_s1;
  wire             wait_for_cmt_dout_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_dout_s1_end_xfer;
    end


  assign cmt_dout_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1));
  //assign cmt_dout_s1_readdata_from_sa = cmt_dout_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_dout_s1_readdata_from_sa = cmt_dout_s1_readdata;

  assign pc8001_sub_system_clock_2_out_requests_cmt_dout_s1 = (1) & (pc8001_sub_system_clock_2_out_read | pc8001_sub_system_clock_2_out_write);
  //cmt_dout_s1_arb_share_counter set values, which is an e_mux
  assign cmt_dout_s1_arb_share_set_values = 1;

  //cmt_dout_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_dout_s1_non_bursting_master_requests = pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;

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


  //pc8001_sub_system_clock_2/out cmt_dout/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_2_out_arbiterlock = cmt_dout_s1_slavearbiterlockenable & pc8001_sub_system_clock_2_out_continuerequest;

  //cmt_dout_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_dout_s1_slavearbiterlockenable2 = |cmt_dout_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_2/out cmt_dout/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_2_out_arbiterlock2 = cmt_dout_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_2_out_continuerequest;

  //cmt_dout_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_dout_s1_any_continuerequest = 1;

  //pc8001_sub_system_clock_2_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_2_out_continuerequest = 1;

  assign pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1 = pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;
  //cmt_dout_s1_writedata mux, which is an e_mux
  assign cmt_dout_s1_writedata = pc8001_sub_system_clock_2_out_writedata;

  //master is always granted when requested
  assign pc8001_sub_system_clock_2_out_granted_cmt_dout_s1 = pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1;

  //pc8001_sub_system_clock_2/out saved-grant cmt_dout/s1, which is an e_assign
  assign pc8001_sub_system_clock_2_out_saved_grant_cmt_dout_s1 = pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;

  //allow new arb cycle for cmt_dout/s1, which is an e_assign
  assign cmt_dout_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign cmt_dout_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign cmt_dout_s1_master_qreq_vector = 1;

  //cmt_dout_s1_reset_n assignment, which is an e_assign
  assign cmt_dout_s1_reset_n = reset_n;

  assign cmt_dout_s1_chipselect = pc8001_sub_system_clock_2_out_granted_cmt_dout_s1;
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
  assign cmt_dout_s1_write_n = ~(pc8001_sub_system_clock_2_out_granted_cmt_dout_s1 & pc8001_sub_system_clock_2_out_write);

  //cmt_dout_s1_address mux, which is an e_mux
  assign cmt_dout_s1_address = pc8001_sub_system_clock_2_out_nativeaddress;

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
  assign cmt_dout_s1_in_a_read_cycle = pc8001_sub_system_clock_2_out_granted_cmt_dout_s1 & pc8001_sub_system_clock_2_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_dout_s1_in_a_read_cycle;

  //cmt_dout_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_dout_s1_waits_for_write = cmt_dout_s1_in_a_write_cycle & 0;

  //cmt_dout_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_dout_s1_in_a_write_cycle = pc8001_sub_system_clock_2_out_granted_cmt_dout_s1 & pc8001_sub_system_clock_2_out_write;

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
                                    pc8001_sub_system_clock_5_out_address_to_slave,
                                    pc8001_sub_system_clock_5_out_nativeaddress,
                                    pc8001_sub_system_clock_5_out_read,
                                    pc8001_sub_system_clock_5_out_write,
                                    reset_n,

                                   // outputs:
                                    cmt_gpio_in_s1_address,
                                    cmt_gpio_in_s1_readdata_from_sa,
                                    cmt_gpio_in_s1_reset_n,
                                    d1_cmt_gpio_in_s1_end_xfer,
                                    pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1,
                                    pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1,
                                    pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1,
                                    pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1
                                 )
;

  output  [  1: 0] cmt_gpio_in_s1_address;
  output  [ 31: 0] cmt_gpio_in_s1_readdata_from_sa;
  output           cmt_gpio_in_s1_reset_n;
  output           d1_cmt_gpio_in_s1_end_xfer;
  output           pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1;
  output           pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1;
  output           pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1;
  output           pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;
  input            clk;
  input   [ 31: 0] cmt_gpio_in_s1_readdata;
  input   [  3: 0] pc8001_sub_system_clock_5_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_5_out_nativeaddress;
  input            pc8001_sub_system_clock_5_out_read;
  input            pc8001_sub_system_clock_5_out_write;
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
  wire             pc8001_sub_system_clock_5_out_arbiterlock;
  wire             pc8001_sub_system_clock_5_out_arbiterlock2;
  wire             pc8001_sub_system_clock_5_out_continuerequest;
  wire             pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1;
  wire             pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1;
  wire             pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1;
  wire             pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;
  wire             pc8001_sub_system_clock_5_out_saved_grant_cmt_gpio_in_s1;
  wire             wait_for_cmt_gpio_in_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_gpio_in_s1_end_xfer;
    end


  assign cmt_gpio_in_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1));
  //assign cmt_gpio_in_s1_readdata_from_sa = cmt_gpio_in_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_gpio_in_s1_readdata_from_sa = cmt_gpio_in_s1_readdata;

  assign pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1 = ((1) & (pc8001_sub_system_clock_5_out_read | pc8001_sub_system_clock_5_out_write)) & pc8001_sub_system_clock_5_out_read;
  //cmt_gpio_in_s1_arb_share_counter set values, which is an e_mux
  assign cmt_gpio_in_s1_arb_share_set_values = 1;

  //cmt_gpio_in_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_gpio_in_s1_non_bursting_master_requests = pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;

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


  //pc8001_sub_system_clock_5/out cmt_gpio_in/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_5_out_arbiterlock = cmt_gpio_in_s1_slavearbiterlockenable & pc8001_sub_system_clock_5_out_continuerequest;

  //cmt_gpio_in_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_gpio_in_s1_slavearbiterlockenable2 = |cmt_gpio_in_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_5/out cmt_gpio_in/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_5_out_arbiterlock2 = cmt_gpio_in_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_5_out_continuerequest;

  //cmt_gpio_in_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_gpio_in_s1_any_continuerequest = 1;

  //pc8001_sub_system_clock_5_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_5_out_continuerequest = 1;

  assign pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1 = pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;
  //master is always granted when requested
  assign pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1 = pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1;

  //pc8001_sub_system_clock_5/out saved-grant cmt_gpio_in/s1, which is an e_assign
  assign pc8001_sub_system_clock_5_out_saved_grant_cmt_gpio_in_s1 = pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;

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

  //cmt_gpio_in_s1_address mux, which is an e_mux
  assign cmt_gpio_in_s1_address = pc8001_sub_system_clock_5_out_nativeaddress;

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
  assign cmt_gpio_in_s1_in_a_read_cycle = pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1 & pc8001_sub_system_clock_5_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_gpio_in_s1_in_a_read_cycle;

  //cmt_gpio_in_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_gpio_in_s1_waits_for_write = cmt_gpio_in_s1_in_a_write_cycle & 0;

  //cmt_gpio_in_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_gpio_in_s1_in_a_write_cycle = pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1 & pc8001_sub_system_clock_5_out_write;

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
                                     pc8001_sub_system_clock_4_out_address_to_slave,
                                     pc8001_sub_system_clock_4_out_nativeaddress,
                                     pc8001_sub_system_clock_4_out_read,
                                     pc8001_sub_system_clock_4_out_write,
                                     pc8001_sub_system_clock_4_out_writedata,
                                     reset_n,

                                    // outputs:
                                     cmt_gpio_out_s1_address,
                                     cmt_gpio_out_s1_chipselect,
                                     cmt_gpio_out_s1_readdata_from_sa,
                                     cmt_gpio_out_s1_reset_n,
                                     cmt_gpio_out_s1_write_n,
                                     cmt_gpio_out_s1_writedata,
                                     d1_cmt_gpio_out_s1_end_xfer,
                                     pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1,
                                     pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1,
                                     pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1,
                                     pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1
                                  )
;

  output  [  1: 0] cmt_gpio_out_s1_address;
  output           cmt_gpio_out_s1_chipselect;
  output  [ 31: 0] cmt_gpio_out_s1_readdata_from_sa;
  output           cmt_gpio_out_s1_reset_n;
  output           cmt_gpio_out_s1_write_n;
  output  [ 31: 0] cmt_gpio_out_s1_writedata;
  output           d1_cmt_gpio_out_s1_end_xfer;
  output           pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1;
  output           pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1;
  output           pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1;
  output           pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;
  input            clk;
  input   [ 31: 0] cmt_gpio_out_s1_readdata;
  input   [  3: 0] pc8001_sub_system_clock_4_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_4_out_nativeaddress;
  input            pc8001_sub_system_clock_4_out_read;
  input            pc8001_sub_system_clock_4_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_4_out_writedata;
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
  wire             pc8001_sub_system_clock_4_out_arbiterlock;
  wire             pc8001_sub_system_clock_4_out_arbiterlock2;
  wire             pc8001_sub_system_clock_4_out_continuerequest;
  wire             pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1;
  wire             pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1;
  wire             pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1;
  wire             pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;
  wire             pc8001_sub_system_clock_4_out_saved_grant_cmt_gpio_out_s1;
  wire             wait_for_cmt_gpio_out_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~cmt_gpio_out_s1_end_xfer;
    end


  assign cmt_gpio_out_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1));
  //assign cmt_gpio_out_s1_readdata_from_sa = cmt_gpio_out_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cmt_gpio_out_s1_readdata_from_sa = cmt_gpio_out_s1_readdata;

  assign pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1 = (1) & (pc8001_sub_system_clock_4_out_read | pc8001_sub_system_clock_4_out_write);
  //cmt_gpio_out_s1_arb_share_counter set values, which is an e_mux
  assign cmt_gpio_out_s1_arb_share_set_values = 1;

  //cmt_gpio_out_s1_non_bursting_master_requests mux, which is an e_mux
  assign cmt_gpio_out_s1_non_bursting_master_requests = pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;

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


  //pc8001_sub_system_clock_4/out cmt_gpio_out/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_4_out_arbiterlock = cmt_gpio_out_s1_slavearbiterlockenable & pc8001_sub_system_clock_4_out_continuerequest;

  //cmt_gpio_out_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cmt_gpio_out_s1_slavearbiterlockenable2 = |cmt_gpio_out_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_4/out cmt_gpio_out/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_4_out_arbiterlock2 = cmt_gpio_out_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_4_out_continuerequest;

  //cmt_gpio_out_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign cmt_gpio_out_s1_any_continuerequest = 1;

  //pc8001_sub_system_clock_4_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_4_out_continuerequest = 1;

  assign pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1 = pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;
  //cmt_gpio_out_s1_writedata mux, which is an e_mux
  assign cmt_gpio_out_s1_writedata = pc8001_sub_system_clock_4_out_writedata;

  //master is always granted when requested
  assign pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1 = pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1;

  //pc8001_sub_system_clock_4/out saved-grant cmt_gpio_out/s1, which is an e_assign
  assign pc8001_sub_system_clock_4_out_saved_grant_cmt_gpio_out_s1 = pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;

  //allow new arb cycle for cmt_gpio_out/s1, which is an e_assign
  assign cmt_gpio_out_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign cmt_gpio_out_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign cmt_gpio_out_s1_master_qreq_vector = 1;

  //cmt_gpio_out_s1_reset_n assignment, which is an e_assign
  assign cmt_gpio_out_s1_reset_n = reset_n;

  assign cmt_gpio_out_s1_chipselect = pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1;
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
  assign cmt_gpio_out_s1_write_n = ~(pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1 & pc8001_sub_system_clock_4_out_write);

  //cmt_gpio_out_s1_address mux, which is an e_mux
  assign cmt_gpio_out_s1_address = pc8001_sub_system_clock_4_out_nativeaddress;

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
  assign cmt_gpio_out_s1_in_a_read_cycle = pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1 & pc8001_sub_system_clock_4_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cmt_gpio_out_s1_in_a_read_cycle;

  //cmt_gpio_out_s1_waits_for_write in a cycle, which is an e_mux
  assign cmt_gpio_out_s1_waits_for_write = cmt_gpio_out_s1_in_a_write_cycle & 0;

  //cmt_gpio_out_s1_in_a_write_cycle assignment, which is an e_assign
  assign cmt_gpio_out_s1_in_a_write_cycle = pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1 & pc8001_sub_system_clock_4_out_write;

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

module epcs_flash_controller_epcs_control_port_arbitrator (
                                                            // inputs:
                                                             clk,
                                                             epcs_flash_controller_epcs_control_port_dataavailable,
                                                             epcs_flash_controller_epcs_control_port_endofpacket,
                                                             epcs_flash_controller_epcs_control_port_irq,
                                                             epcs_flash_controller_epcs_control_port_readdata,
                                                             epcs_flash_controller_epcs_control_port_readyfordata,
                                                             nios2_data_master_address_to_slave,
                                                             nios2_data_master_read,
                                                             nios2_data_master_write,
                                                             nios2_data_master_writedata,
                                                             nios2_instruction_master_address_to_slave,
                                                             nios2_instruction_master_read,
                                                             reset_n,

                                                            // outputs:
                                                             d1_epcs_flash_controller_epcs_control_port_end_xfer,
                                                             epcs_flash_controller_epcs_control_port_address,
                                                             epcs_flash_controller_epcs_control_port_chipselect,
                                                             epcs_flash_controller_epcs_control_port_dataavailable_from_sa,
                                                             epcs_flash_controller_epcs_control_port_endofpacket_from_sa,
                                                             epcs_flash_controller_epcs_control_port_irq_from_sa,
                                                             epcs_flash_controller_epcs_control_port_read_n,
                                                             epcs_flash_controller_epcs_control_port_readdata_from_sa,
                                                             epcs_flash_controller_epcs_control_port_readyfordata_from_sa,
                                                             epcs_flash_controller_epcs_control_port_reset_n,
                                                             epcs_flash_controller_epcs_control_port_write_n,
                                                             epcs_flash_controller_epcs_control_port_writedata,
                                                             nios2_data_master_granted_epcs_flash_controller_epcs_control_port,
                                                             nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port,
                                                             nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port,
                                                             nios2_data_master_requests_epcs_flash_controller_epcs_control_port,
                                                             nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port,
                                                             nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port,
                                                             nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port,
                                                             nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port
                                                          )
;

  output           d1_epcs_flash_controller_epcs_control_port_end_xfer;
  output  [  8: 0] epcs_flash_controller_epcs_control_port_address;
  output           epcs_flash_controller_epcs_control_port_chipselect;
  output           epcs_flash_controller_epcs_control_port_dataavailable_from_sa;
  output           epcs_flash_controller_epcs_control_port_endofpacket_from_sa;
  output           epcs_flash_controller_epcs_control_port_irq_from_sa;
  output           epcs_flash_controller_epcs_control_port_read_n;
  output  [ 31: 0] epcs_flash_controller_epcs_control_port_readdata_from_sa;
  output           epcs_flash_controller_epcs_control_port_readyfordata_from_sa;
  output           epcs_flash_controller_epcs_control_port_reset_n;
  output           epcs_flash_controller_epcs_control_port_write_n;
  output  [ 31: 0] epcs_flash_controller_epcs_control_port_writedata;
  output           nios2_data_master_granted_epcs_flash_controller_epcs_control_port;
  output           nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port;
  output           nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  output           nios2_data_master_requests_epcs_flash_controller_epcs_control_port;
  output           nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  output           nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;
  output           nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  output           nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  input            clk;
  input            epcs_flash_controller_epcs_control_port_dataavailable;
  input            epcs_flash_controller_epcs_control_port_endofpacket;
  input            epcs_flash_controller_epcs_control_port_irq;
  input   [ 31: 0] epcs_flash_controller_epcs_control_port_readdata;
  input            epcs_flash_controller_epcs_control_port_readyfordata;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input            nios2_data_master_read;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input   [ 25: 0] nios2_instruction_master_address_to_slave;
  input            nios2_instruction_master_read;
  input            reset_n;

  reg              d1_epcs_flash_controller_epcs_control_port_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port;
  wire    [  8: 0] epcs_flash_controller_epcs_control_port_address;
  wire             epcs_flash_controller_epcs_control_port_allgrants;
  wire             epcs_flash_controller_epcs_control_port_allow_new_arb_cycle;
  wire             epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant;
  wire             epcs_flash_controller_epcs_control_port_any_continuerequest;
  reg     [  1: 0] epcs_flash_controller_epcs_control_port_arb_addend;
  wire             epcs_flash_controller_epcs_control_port_arb_counter_enable;
  reg     [  1: 0] epcs_flash_controller_epcs_control_port_arb_share_counter;
  wire    [  1: 0] epcs_flash_controller_epcs_control_port_arb_share_counter_next_value;
  wire    [  1: 0] epcs_flash_controller_epcs_control_port_arb_share_set_values;
  wire    [  1: 0] epcs_flash_controller_epcs_control_port_arb_winner;
  wire             epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal;
  wire             epcs_flash_controller_epcs_control_port_beginbursttransfer_internal;
  wire             epcs_flash_controller_epcs_control_port_begins_xfer;
  wire             epcs_flash_controller_epcs_control_port_chipselect;
  wire    [  3: 0] epcs_flash_controller_epcs_control_port_chosen_master_double_vector;
  wire    [  1: 0] epcs_flash_controller_epcs_control_port_chosen_master_rot_left;
  wire             epcs_flash_controller_epcs_control_port_dataavailable_from_sa;
  wire             epcs_flash_controller_epcs_control_port_end_xfer;
  wire             epcs_flash_controller_epcs_control_port_endofpacket_from_sa;
  wire             epcs_flash_controller_epcs_control_port_firsttransfer;
  wire    [  1: 0] epcs_flash_controller_epcs_control_port_grant_vector;
  wire             epcs_flash_controller_epcs_control_port_in_a_read_cycle;
  wire             epcs_flash_controller_epcs_control_port_in_a_write_cycle;
  wire             epcs_flash_controller_epcs_control_port_irq_from_sa;
  wire    [  1: 0] epcs_flash_controller_epcs_control_port_master_qreq_vector;
  wire             epcs_flash_controller_epcs_control_port_non_bursting_master_requests;
  wire             epcs_flash_controller_epcs_control_port_read_n;
  wire    [ 31: 0] epcs_flash_controller_epcs_control_port_readdata_from_sa;
  wire             epcs_flash_controller_epcs_control_port_readyfordata_from_sa;
  reg              epcs_flash_controller_epcs_control_port_reg_firsttransfer;
  wire             epcs_flash_controller_epcs_control_port_reset_n;
  reg     [  1: 0] epcs_flash_controller_epcs_control_port_saved_chosen_master_vector;
  reg              epcs_flash_controller_epcs_control_port_slavearbiterlockenable;
  wire             epcs_flash_controller_epcs_control_port_slavearbiterlockenable2;
  wire             epcs_flash_controller_epcs_control_port_unreg_firsttransfer;
  wire             epcs_flash_controller_epcs_control_port_waits_for_read;
  wire             epcs_flash_controller_epcs_control_port_waits_for_write;
  wire             epcs_flash_controller_epcs_control_port_write_n;
  wire    [ 31: 0] epcs_flash_controller_epcs_control_port_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios2_data_master_granted_slave_epcs_flash_controller_epcs_control_port;
  reg              last_cycle_nios2_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_requests_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_saved_grant_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_arbiterlock;
  wire             nios2_instruction_master_arbiterlock2;
  wire             nios2_instruction_master_continuerequest;
  wire             nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port;
  wire    [ 25: 0] shifted_address_to_epcs_flash_controller_epcs_control_port_from_nios2_data_master;
  wire    [ 25: 0] shifted_address_to_epcs_flash_controller_epcs_control_port_from_nios2_instruction_master;
  wire             wait_for_epcs_flash_controller_epcs_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~epcs_flash_controller_epcs_control_port_end_xfer;
    end


  assign epcs_flash_controller_epcs_control_port_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port | nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port));
  //assign epcs_flash_controller_epcs_control_port_readdata_from_sa = epcs_flash_controller_epcs_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_readdata_from_sa = epcs_flash_controller_epcs_control_port_readdata;

  assign nios2_data_master_requests_epcs_flash_controller_epcs_control_port = ({nios2_data_master_address_to_slave[25 : 11] , 11'b0} == 26'h1800) & (nios2_data_master_read | nios2_data_master_write);
  //assign epcs_flash_controller_epcs_control_port_dataavailable_from_sa = epcs_flash_controller_epcs_control_port_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_dataavailable_from_sa = epcs_flash_controller_epcs_control_port_dataavailable;

  //assign epcs_flash_controller_epcs_control_port_readyfordata_from_sa = epcs_flash_controller_epcs_control_port_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_readyfordata_from_sa = epcs_flash_controller_epcs_control_port_readyfordata;

  //epcs_flash_controller_epcs_control_port_arb_share_counter set values, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_arb_share_set_values = 1;

  //epcs_flash_controller_epcs_control_port_non_bursting_master_requests mux, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_non_bursting_master_requests = nios2_data_master_requests_epcs_flash_controller_epcs_control_port |
    nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port |
    nios2_data_master_requests_epcs_flash_controller_epcs_control_port |
    nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;

  //epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant = 0;

  //epcs_flash_controller_epcs_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_arb_share_counter_next_value = epcs_flash_controller_epcs_control_port_firsttransfer ? (epcs_flash_controller_epcs_control_port_arb_share_set_values - 1) : |epcs_flash_controller_epcs_control_port_arb_share_counter ? (epcs_flash_controller_epcs_control_port_arb_share_counter - 1) : 0;

  //epcs_flash_controller_epcs_control_port_allgrants all slave grants, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_allgrants = (|epcs_flash_controller_epcs_control_port_grant_vector) |
    (|epcs_flash_controller_epcs_control_port_grant_vector) |
    (|epcs_flash_controller_epcs_control_port_grant_vector) |
    (|epcs_flash_controller_epcs_control_port_grant_vector);

  //epcs_flash_controller_epcs_control_port_end_xfer assignment, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_end_xfer = ~(epcs_flash_controller_epcs_control_port_waits_for_read | epcs_flash_controller_epcs_control_port_waits_for_write);

  //end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port = epcs_flash_controller_epcs_control_port_end_xfer & (~epcs_flash_controller_epcs_control_port_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //epcs_flash_controller_epcs_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_arb_counter_enable = (end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port & epcs_flash_controller_epcs_control_port_allgrants) | (end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port & ~epcs_flash_controller_epcs_control_port_non_bursting_master_requests);

  //epcs_flash_controller_epcs_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_flash_controller_epcs_control_port_arb_share_counter <= 0;
      else if (epcs_flash_controller_epcs_control_port_arb_counter_enable)
          epcs_flash_controller_epcs_control_port_arb_share_counter <= epcs_flash_controller_epcs_control_port_arb_share_counter_next_value;
    end


  //epcs_flash_controller_epcs_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_flash_controller_epcs_control_port_slavearbiterlockenable <= 0;
      else if ((|epcs_flash_controller_epcs_control_port_master_qreq_vector & end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port) | (end_xfer_arb_share_counter_term_epcs_flash_controller_epcs_control_port & ~epcs_flash_controller_epcs_control_port_non_bursting_master_requests))
          epcs_flash_controller_epcs_control_port_slavearbiterlockenable <= |epcs_flash_controller_epcs_control_port_arb_share_counter_next_value;
    end


  //nios2/data_master epcs_flash_controller/epcs_control_port arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = epcs_flash_controller_epcs_control_port_slavearbiterlockenable & nios2_data_master_continuerequest;

  //epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 = |epcs_flash_controller_epcs_control_port_arb_share_counter_next_value;

  //nios2/data_master epcs_flash_controller/epcs_control_port arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //nios2/instruction_master epcs_flash_controller/epcs_control_port arbiterlock, which is an e_assign
  assign nios2_instruction_master_arbiterlock = epcs_flash_controller_epcs_control_port_slavearbiterlockenable & nios2_instruction_master_continuerequest;

  //nios2/instruction_master epcs_flash_controller/epcs_control_port arbiterlock2, which is an e_assign
  assign nios2_instruction_master_arbiterlock2 = epcs_flash_controller_epcs_control_port_slavearbiterlockenable2 & nios2_instruction_master_continuerequest;

  //nios2/instruction_master granted epcs_flash_controller/epcs_control_port last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port <= 0;
      else 
        last_cycle_nios2_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port <= nios2_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port ? 1 : (epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal | ~nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port) ? 0 : last_cycle_nios2_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port;
    end


  //nios2_instruction_master_continuerequest continued request, which is an e_mux
  assign nios2_instruction_master_continuerequest = last_cycle_nios2_instruction_master_granted_slave_epcs_flash_controller_epcs_control_port & nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;

  //epcs_flash_controller_epcs_control_port_any_continuerequest at least one master continues requesting, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_any_continuerequest = nios2_instruction_master_continuerequest |
    nios2_data_master_continuerequest;

  assign nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port = nios2_data_master_requests_epcs_flash_controller_epcs_control_port & ~(nios2_instruction_master_arbiterlock);
  //epcs_flash_controller_epcs_control_port_writedata mux, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_writedata = nios2_data_master_writedata;

  //assign epcs_flash_controller_epcs_control_port_endofpacket_from_sa = epcs_flash_controller_epcs_control_port_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_endofpacket_from_sa = epcs_flash_controller_epcs_control_port_endofpacket;

  assign nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port = (({nios2_instruction_master_address_to_slave[25 : 11] , 11'b0} == 26'h1800) & (nios2_instruction_master_read)) & nios2_instruction_master_read;
  //nios2/data_master granted epcs_flash_controller/epcs_control_port last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios2_data_master_granted_slave_epcs_flash_controller_epcs_control_port <= 0;
      else 
        last_cycle_nios2_data_master_granted_slave_epcs_flash_controller_epcs_control_port <= nios2_data_master_saved_grant_epcs_flash_controller_epcs_control_port ? 1 : (epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal | ~nios2_data_master_requests_epcs_flash_controller_epcs_control_port) ? 0 : last_cycle_nios2_data_master_granted_slave_epcs_flash_controller_epcs_control_port;
    end


  //nios2_data_master_continuerequest continued request, which is an e_mux
  assign nios2_data_master_continuerequest = last_cycle_nios2_data_master_granted_slave_epcs_flash_controller_epcs_control_port & nios2_data_master_requests_epcs_flash_controller_epcs_control_port;

  assign nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port = nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port & ~(nios2_data_master_arbiterlock);
  //allow new arb cycle for epcs_flash_controller/epcs_control_port, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_allow_new_arb_cycle = ~nios2_data_master_arbiterlock & ~nios2_instruction_master_arbiterlock;

  //nios2/instruction_master assignment into master qualified-requests vector for epcs_flash_controller/epcs_control_port, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_master_qreq_vector[0] = nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;

  //nios2/instruction_master grant epcs_flash_controller/epcs_control_port, which is an e_assign
  assign nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port = epcs_flash_controller_epcs_control_port_grant_vector[0];

  //nios2/instruction_master saved-grant epcs_flash_controller/epcs_control_port, which is an e_assign
  assign nios2_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port = epcs_flash_controller_epcs_control_port_arb_winner[0] && nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;

  //nios2/data_master assignment into master qualified-requests vector for epcs_flash_controller/epcs_control_port, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_master_qreq_vector[1] = nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port;

  //nios2/data_master grant epcs_flash_controller/epcs_control_port, which is an e_assign
  assign nios2_data_master_granted_epcs_flash_controller_epcs_control_port = epcs_flash_controller_epcs_control_port_grant_vector[1];

  //nios2/data_master saved-grant epcs_flash_controller/epcs_control_port, which is an e_assign
  assign nios2_data_master_saved_grant_epcs_flash_controller_epcs_control_port = epcs_flash_controller_epcs_control_port_arb_winner[1] && nios2_data_master_requests_epcs_flash_controller_epcs_control_port;

  //epcs_flash_controller/epcs_control_port chosen-master double-vector, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_chosen_master_double_vector = {epcs_flash_controller_epcs_control_port_master_qreq_vector, epcs_flash_controller_epcs_control_port_master_qreq_vector} & ({~epcs_flash_controller_epcs_control_port_master_qreq_vector, ~epcs_flash_controller_epcs_control_port_master_qreq_vector} + epcs_flash_controller_epcs_control_port_arb_addend);

  //stable onehot encoding of arb winner
  assign epcs_flash_controller_epcs_control_port_arb_winner = (epcs_flash_controller_epcs_control_port_allow_new_arb_cycle & | epcs_flash_controller_epcs_control_port_grant_vector) ? epcs_flash_controller_epcs_control_port_grant_vector : epcs_flash_controller_epcs_control_port_saved_chosen_master_vector;

  //saved epcs_flash_controller_epcs_control_port_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_flash_controller_epcs_control_port_saved_chosen_master_vector <= 0;
      else if (epcs_flash_controller_epcs_control_port_allow_new_arb_cycle)
          epcs_flash_controller_epcs_control_port_saved_chosen_master_vector <= |epcs_flash_controller_epcs_control_port_grant_vector ? epcs_flash_controller_epcs_control_port_grant_vector : epcs_flash_controller_epcs_control_port_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign epcs_flash_controller_epcs_control_port_grant_vector = {(epcs_flash_controller_epcs_control_port_chosen_master_double_vector[1] | epcs_flash_controller_epcs_control_port_chosen_master_double_vector[3]),
    (epcs_flash_controller_epcs_control_port_chosen_master_double_vector[0] | epcs_flash_controller_epcs_control_port_chosen_master_double_vector[2])};

  //epcs_flash_controller/epcs_control_port chosen master rotated left, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_chosen_master_rot_left = (epcs_flash_controller_epcs_control_port_arb_winner << 1) ? (epcs_flash_controller_epcs_control_port_arb_winner << 1) : 1;

  //epcs_flash_controller/epcs_control_port's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_flash_controller_epcs_control_port_arb_addend <= 1;
      else if (|epcs_flash_controller_epcs_control_port_grant_vector)
          epcs_flash_controller_epcs_control_port_arb_addend <= epcs_flash_controller_epcs_control_port_end_xfer? epcs_flash_controller_epcs_control_port_chosen_master_rot_left : epcs_flash_controller_epcs_control_port_grant_vector;
    end


  //epcs_flash_controller_epcs_control_port_reset_n assignment, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_reset_n = reset_n;

  assign epcs_flash_controller_epcs_control_port_chipselect = nios2_data_master_granted_epcs_flash_controller_epcs_control_port | nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  //epcs_flash_controller_epcs_control_port_firsttransfer first transaction, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_firsttransfer = epcs_flash_controller_epcs_control_port_begins_xfer ? epcs_flash_controller_epcs_control_port_unreg_firsttransfer : epcs_flash_controller_epcs_control_port_reg_firsttransfer;

  //epcs_flash_controller_epcs_control_port_unreg_firsttransfer first transaction, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_unreg_firsttransfer = ~(epcs_flash_controller_epcs_control_port_slavearbiterlockenable & epcs_flash_controller_epcs_control_port_any_continuerequest);

  //epcs_flash_controller_epcs_control_port_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_flash_controller_epcs_control_port_reg_firsttransfer <= 1'b1;
      else if (epcs_flash_controller_epcs_control_port_begins_xfer)
          epcs_flash_controller_epcs_control_port_reg_firsttransfer <= epcs_flash_controller_epcs_control_port_unreg_firsttransfer;
    end


  //epcs_flash_controller_epcs_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_beginbursttransfer_internal = epcs_flash_controller_epcs_control_port_begins_xfer;

  //epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_arbitration_holdoff_internal = epcs_flash_controller_epcs_control_port_begins_xfer & epcs_flash_controller_epcs_control_port_firsttransfer;

  //~epcs_flash_controller_epcs_control_port_read_n assignment, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_read_n = ~((nios2_data_master_granted_epcs_flash_controller_epcs_control_port & nios2_data_master_read) | (nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port & nios2_instruction_master_read));

  //~epcs_flash_controller_epcs_control_port_write_n assignment, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_write_n = ~(nios2_data_master_granted_epcs_flash_controller_epcs_control_port & nios2_data_master_write);

  assign shifted_address_to_epcs_flash_controller_epcs_control_port_from_nios2_data_master = nios2_data_master_address_to_slave;
  //epcs_flash_controller_epcs_control_port_address mux, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_address = (nios2_data_master_granted_epcs_flash_controller_epcs_control_port)? (shifted_address_to_epcs_flash_controller_epcs_control_port_from_nios2_data_master >> 2) :
    (shifted_address_to_epcs_flash_controller_epcs_control_port_from_nios2_instruction_master >> 2);

  assign shifted_address_to_epcs_flash_controller_epcs_control_port_from_nios2_instruction_master = nios2_instruction_master_address_to_slave;
  //d1_epcs_flash_controller_epcs_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_epcs_flash_controller_epcs_control_port_end_xfer <= 1;
      else 
        d1_epcs_flash_controller_epcs_control_port_end_xfer <= epcs_flash_controller_epcs_control_port_end_xfer;
    end


  //epcs_flash_controller_epcs_control_port_waits_for_read in a cycle, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_waits_for_read = epcs_flash_controller_epcs_control_port_in_a_read_cycle & epcs_flash_controller_epcs_control_port_begins_xfer;

  //epcs_flash_controller_epcs_control_port_in_a_read_cycle assignment, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_in_a_read_cycle = (nios2_data_master_granted_epcs_flash_controller_epcs_control_port & nios2_data_master_read) | (nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port & nios2_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = epcs_flash_controller_epcs_control_port_in_a_read_cycle;

  //epcs_flash_controller_epcs_control_port_waits_for_write in a cycle, which is an e_mux
  assign epcs_flash_controller_epcs_control_port_waits_for_write = epcs_flash_controller_epcs_control_port_in_a_write_cycle & epcs_flash_controller_epcs_control_port_begins_xfer;

  //epcs_flash_controller_epcs_control_port_in_a_write_cycle assignment, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_in_a_write_cycle = nios2_data_master_granted_epcs_flash_controller_epcs_control_port & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = epcs_flash_controller_epcs_control_port_in_a_write_cycle;

  assign wait_for_epcs_flash_controller_epcs_control_port_counter = 0;
  //assign epcs_flash_controller_epcs_control_port_irq_from_sa = epcs_flash_controller_epcs_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_flash_controller_epcs_control_port_irq_from_sa = epcs_flash_controller_epcs_control_port_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //epcs_flash_controller/epcs_control_port enable non-zero assertions, which is an e_register
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
      if (nios2_data_master_granted_epcs_flash_controller_epcs_control_port + nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios2_data_master_saved_grant_epcs_flash_controller_epcs_control_port + nios2_instruction_master_saved_grant_epcs_flash_controller_epcs_control_port > 1)
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

module gpio0_s1_arbitrator (
                             // inputs:
                              clk,
                              gpio0_s1_readdata,
                              pc8001_sub_system_clock_0_out_address_to_slave,
                              pc8001_sub_system_clock_0_out_nativeaddress,
                              pc8001_sub_system_clock_0_out_read,
                              pc8001_sub_system_clock_0_out_write,
                              pc8001_sub_system_clock_0_out_writedata,
                              reset_n,

                             // outputs:
                              d1_gpio0_s1_end_xfer,
                              gpio0_s1_address,
                              gpio0_s1_chipselect,
                              gpio0_s1_readdata_from_sa,
                              gpio0_s1_reset_n,
                              gpio0_s1_write_n,
                              gpio0_s1_writedata,
                              pc8001_sub_system_clock_0_out_granted_gpio0_s1,
                              pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1,
                              pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1,
                              pc8001_sub_system_clock_0_out_requests_gpio0_s1
                           )
;

  output           d1_gpio0_s1_end_xfer;
  output  [  1: 0] gpio0_s1_address;
  output           gpio0_s1_chipselect;
  output  [ 31: 0] gpio0_s1_readdata_from_sa;
  output           gpio0_s1_reset_n;
  output           gpio0_s1_write_n;
  output  [ 31: 0] gpio0_s1_writedata;
  output           pc8001_sub_system_clock_0_out_granted_gpio0_s1;
  output           pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1;
  output           pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1;
  output           pc8001_sub_system_clock_0_out_requests_gpio0_s1;
  input            clk;
  input   [ 31: 0] gpio0_s1_readdata;
  input   [  3: 0] pc8001_sub_system_clock_0_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_0_out_nativeaddress;
  input            pc8001_sub_system_clock_0_out_read;
  input            pc8001_sub_system_clock_0_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_0_out_writedata;
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
  wire             pc8001_sub_system_clock_0_out_arbiterlock;
  wire             pc8001_sub_system_clock_0_out_arbiterlock2;
  wire             pc8001_sub_system_clock_0_out_continuerequest;
  wire             pc8001_sub_system_clock_0_out_granted_gpio0_s1;
  wire             pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1;
  wire             pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1;
  wire             pc8001_sub_system_clock_0_out_requests_gpio0_s1;
  wire             pc8001_sub_system_clock_0_out_saved_grant_gpio0_s1;
  wire             wait_for_gpio0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~gpio0_s1_end_xfer;
    end


  assign gpio0_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1));
  //assign gpio0_s1_readdata_from_sa = gpio0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign gpio0_s1_readdata_from_sa = gpio0_s1_readdata;

  assign pc8001_sub_system_clock_0_out_requests_gpio0_s1 = (1) & (pc8001_sub_system_clock_0_out_read | pc8001_sub_system_clock_0_out_write);
  //gpio0_s1_arb_share_counter set values, which is an e_mux
  assign gpio0_s1_arb_share_set_values = 1;

  //gpio0_s1_non_bursting_master_requests mux, which is an e_mux
  assign gpio0_s1_non_bursting_master_requests = pc8001_sub_system_clock_0_out_requests_gpio0_s1;

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


  //pc8001_sub_system_clock_0/out gpio0/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_0_out_arbiterlock = gpio0_s1_slavearbiterlockenable & pc8001_sub_system_clock_0_out_continuerequest;

  //gpio0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign gpio0_s1_slavearbiterlockenable2 = |gpio0_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_0/out gpio0/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_0_out_arbiterlock2 = gpio0_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_0_out_continuerequest;

  //gpio0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign gpio0_s1_any_continuerequest = 1;

  //pc8001_sub_system_clock_0_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_0_out_continuerequest = 1;

  assign pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1 = pc8001_sub_system_clock_0_out_requests_gpio0_s1;
  //gpio0_s1_writedata mux, which is an e_mux
  assign gpio0_s1_writedata = pc8001_sub_system_clock_0_out_writedata;

  //master is always granted when requested
  assign pc8001_sub_system_clock_0_out_granted_gpio0_s1 = pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1;

  //pc8001_sub_system_clock_0/out saved-grant gpio0/s1, which is an e_assign
  assign pc8001_sub_system_clock_0_out_saved_grant_gpio0_s1 = pc8001_sub_system_clock_0_out_requests_gpio0_s1;

  //allow new arb cycle for gpio0/s1, which is an e_assign
  assign gpio0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign gpio0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign gpio0_s1_master_qreq_vector = 1;

  //gpio0_s1_reset_n assignment, which is an e_assign
  assign gpio0_s1_reset_n = reset_n;

  assign gpio0_s1_chipselect = pc8001_sub_system_clock_0_out_granted_gpio0_s1;
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
  assign gpio0_s1_write_n = ~(pc8001_sub_system_clock_0_out_granted_gpio0_s1 & pc8001_sub_system_clock_0_out_write);

  //gpio0_s1_address mux, which is an e_mux
  assign gpio0_s1_address = pc8001_sub_system_clock_0_out_nativeaddress;

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
  assign gpio0_s1_in_a_read_cycle = pc8001_sub_system_clock_0_out_granted_gpio0_s1 & pc8001_sub_system_clock_0_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = gpio0_s1_in_a_read_cycle;

  //gpio0_s1_waits_for_write in a cycle, which is an e_mux
  assign gpio0_s1_waits_for_write = gpio0_s1_in_a_write_cycle & 0;

  //gpio0_s1_in_a_write_cycle assignment, which is an e_assign
  assign gpio0_s1_in_a_write_cycle = pc8001_sub_system_clock_0_out_granted_gpio0_s1 & pc8001_sub_system_clock_0_out_write;

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
                              pc8001_sub_system_clock_1_out_address_to_slave,
                              pc8001_sub_system_clock_1_out_nativeaddress,
                              pc8001_sub_system_clock_1_out_read,
                              pc8001_sub_system_clock_1_out_write,
                              reset_n,

                             // outputs:
                              d1_gpio1_s1_end_xfer,
                              gpio1_s1_address,
                              gpio1_s1_readdata_from_sa,
                              gpio1_s1_reset_n,
                              pc8001_sub_system_clock_1_out_granted_gpio1_s1,
                              pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1,
                              pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1,
                              pc8001_sub_system_clock_1_out_requests_gpio1_s1
                           )
;

  output           d1_gpio1_s1_end_xfer;
  output  [  1: 0] gpio1_s1_address;
  output  [ 31: 0] gpio1_s1_readdata_from_sa;
  output           gpio1_s1_reset_n;
  output           pc8001_sub_system_clock_1_out_granted_gpio1_s1;
  output           pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1;
  output           pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1;
  output           pc8001_sub_system_clock_1_out_requests_gpio1_s1;
  input            clk;
  input   [ 31: 0] gpio1_s1_readdata;
  input   [  3: 0] pc8001_sub_system_clock_1_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_1_out_nativeaddress;
  input            pc8001_sub_system_clock_1_out_read;
  input            pc8001_sub_system_clock_1_out_write;
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
  wire             pc8001_sub_system_clock_1_out_arbiterlock;
  wire             pc8001_sub_system_clock_1_out_arbiterlock2;
  wire             pc8001_sub_system_clock_1_out_continuerequest;
  wire             pc8001_sub_system_clock_1_out_granted_gpio1_s1;
  wire             pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1;
  wire             pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1;
  wire             pc8001_sub_system_clock_1_out_requests_gpio1_s1;
  wire             pc8001_sub_system_clock_1_out_saved_grant_gpio1_s1;
  wire             wait_for_gpio1_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~gpio1_s1_end_xfer;
    end


  assign gpio1_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1));
  //assign gpio1_s1_readdata_from_sa = gpio1_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign gpio1_s1_readdata_from_sa = gpio1_s1_readdata;

  assign pc8001_sub_system_clock_1_out_requests_gpio1_s1 = ((1) & (pc8001_sub_system_clock_1_out_read | pc8001_sub_system_clock_1_out_write)) & pc8001_sub_system_clock_1_out_read;
  //gpio1_s1_arb_share_counter set values, which is an e_mux
  assign gpio1_s1_arb_share_set_values = 1;

  //gpio1_s1_non_bursting_master_requests mux, which is an e_mux
  assign gpio1_s1_non_bursting_master_requests = pc8001_sub_system_clock_1_out_requests_gpio1_s1;

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


  //pc8001_sub_system_clock_1/out gpio1/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_1_out_arbiterlock = gpio1_s1_slavearbiterlockenable & pc8001_sub_system_clock_1_out_continuerequest;

  //gpio1_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign gpio1_s1_slavearbiterlockenable2 = |gpio1_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_1/out gpio1/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_1_out_arbiterlock2 = gpio1_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_1_out_continuerequest;

  //gpio1_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign gpio1_s1_any_continuerequest = 1;

  //pc8001_sub_system_clock_1_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_1_out_continuerequest = 1;

  assign pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1 = pc8001_sub_system_clock_1_out_requests_gpio1_s1;
  //master is always granted when requested
  assign pc8001_sub_system_clock_1_out_granted_gpio1_s1 = pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1;

  //pc8001_sub_system_clock_1/out saved-grant gpio1/s1, which is an e_assign
  assign pc8001_sub_system_clock_1_out_saved_grant_gpio1_s1 = pc8001_sub_system_clock_1_out_requests_gpio1_s1;

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

  //gpio1_s1_address mux, which is an e_mux
  assign gpio1_s1_address = pc8001_sub_system_clock_1_out_nativeaddress;

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
  assign gpio1_s1_in_a_read_cycle = pc8001_sub_system_clock_1_out_granted_gpio1_s1 & pc8001_sub_system_clock_1_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = gpio1_s1_in_a_read_cycle;

  //gpio1_s1_waits_for_write in a cycle, which is an e_mux
  assign gpio1_s1_waits_for_write = gpio1_s1_in_a_write_cycle & 0;

  //gpio1_s1_in_a_write_cycle assignment, which is an e_assign
  assign gpio1_s1_in_a_write_cycle = pc8001_sub_system_clock_1_out_granted_gpio1_s1 & pc8001_sub_system_clock_1_out_write;

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
  input   [ 25: 0] nios2_data_master_address_to_slave;
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
  reg     [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_counter;
  wire    [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_set_values;
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
  wire    [ 25: 0] shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios2_data_master;
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

  assign nios2_data_master_requests_jtag_uart_avalon_jtag_slave = ({nios2_data_master_address_to_slave[25 : 3] , 3'b0} == 26'h20) & (nios2_data_master_read | nios2_data_master_write);
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

module mmc_spi_avalon_slave_0_arbitrator (
                                           // inputs:
                                            clk,
                                            mmc_spi_avalon_slave_0_irq,
                                            mmc_spi_avalon_slave_0_readdata,
                                            pc8001_sub_system_clock_6_out_address_to_slave,
                                            pc8001_sub_system_clock_6_out_read,
                                            pc8001_sub_system_clock_6_out_write,
                                            pc8001_sub_system_clock_6_out_writedata,
                                            reset_n,

                                           // outputs:
                                            d1_mmc_spi_avalon_slave_0_end_xfer,
                                            mmc_spi_avalon_slave_0_address,
                                            mmc_spi_avalon_slave_0_chipselect,
                                            mmc_spi_avalon_slave_0_irq_from_sa,
                                            mmc_spi_avalon_slave_0_read,
                                            mmc_spi_avalon_slave_0_readdata_from_sa,
                                            mmc_spi_avalon_slave_0_reset,
                                            mmc_spi_avalon_slave_0_write,
                                            mmc_spi_avalon_slave_0_writedata,
                                            pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0,
                                            pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0,
                                            pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0,
                                            pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0
                                         )
;

  output           d1_mmc_spi_avalon_slave_0_end_xfer;
  output  [  1: 0] mmc_spi_avalon_slave_0_address;
  output           mmc_spi_avalon_slave_0_chipselect;
  output           mmc_spi_avalon_slave_0_irq_from_sa;
  output           mmc_spi_avalon_slave_0_read;
  output  [ 31: 0] mmc_spi_avalon_slave_0_readdata_from_sa;
  output           mmc_spi_avalon_slave_0_reset;
  output           mmc_spi_avalon_slave_0_write;
  output  [ 31: 0] mmc_spi_avalon_slave_0_writedata;
  output           pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0;
  output           pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0;
  output           pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0;
  output           pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;
  input            clk;
  input            mmc_spi_avalon_slave_0_irq;
  input   [ 31: 0] mmc_spi_avalon_slave_0_readdata;
  input   [  3: 0] pc8001_sub_system_clock_6_out_address_to_slave;
  input            pc8001_sub_system_clock_6_out_read;
  input            pc8001_sub_system_clock_6_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_6_out_writedata;
  input            reset_n;

  reg              d1_mmc_spi_avalon_slave_0_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] mmc_spi_avalon_slave_0_address;
  wire             mmc_spi_avalon_slave_0_allgrants;
  wire             mmc_spi_avalon_slave_0_allow_new_arb_cycle;
  wire             mmc_spi_avalon_slave_0_any_bursting_master_saved_grant;
  wire             mmc_spi_avalon_slave_0_any_continuerequest;
  wire             mmc_spi_avalon_slave_0_arb_counter_enable;
  reg              mmc_spi_avalon_slave_0_arb_share_counter;
  wire             mmc_spi_avalon_slave_0_arb_share_counter_next_value;
  wire             mmc_spi_avalon_slave_0_arb_share_set_values;
  wire             mmc_spi_avalon_slave_0_beginbursttransfer_internal;
  wire             mmc_spi_avalon_slave_0_begins_xfer;
  wire             mmc_spi_avalon_slave_0_chipselect;
  wire             mmc_spi_avalon_slave_0_end_xfer;
  wire             mmc_spi_avalon_slave_0_firsttransfer;
  wire             mmc_spi_avalon_slave_0_grant_vector;
  wire             mmc_spi_avalon_slave_0_in_a_read_cycle;
  wire             mmc_spi_avalon_slave_0_in_a_write_cycle;
  wire             mmc_spi_avalon_slave_0_irq_from_sa;
  wire             mmc_spi_avalon_slave_0_master_qreq_vector;
  wire             mmc_spi_avalon_slave_0_non_bursting_master_requests;
  wire             mmc_spi_avalon_slave_0_read;
  wire    [ 31: 0] mmc_spi_avalon_slave_0_readdata_from_sa;
  reg              mmc_spi_avalon_slave_0_reg_firsttransfer;
  wire             mmc_spi_avalon_slave_0_reset;
  reg              mmc_spi_avalon_slave_0_slavearbiterlockenable;
  wire             mmc_spi_avalon_slave_0_slavearbiterlockenable2;
  wire             mmc_spi_avalon_slave_0_unreg_firsttransfer;
  wire             mmc_spi_avalon_slave_0_waits_for_read;
  wire             mmc_spi_avalon_slave_0_waits_for_write;
  wire             mmc_spi_avalon_slave_0_write;
  wire    [ 31: 0] mmc_spi_avalon_slave_0_writedata;
  wire             pc8001_sub_system_clock_6_out_arbiterlock;
  wire             pc8001_sub_system_clock_6_out_arbiterlock2;
  wire             pc8001_sub_system_clock_6_out_continuerequest;
  wire             pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0;
  wire             pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0;
  wire             pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0;
  wire             pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;
  wire             pc8001_sub_system_clock_6_out_saved_grant_mmc_spi_avalon_slave_0;
  wire    [  3: 0] shifted_address_to_mmc_spi_avalon_slave_0_from_pc8001_sub_system_clock_6_out;
  wire             wait_for_mmc_spi_avalon_slave_0_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~mmc_spi_avalon_slave_0_end_xfer;
    end


  assign mmc_spi_avalon_slave_0_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0));
  //assign mmc_spi_avalon_slave_0_readdata_from_sa = mmc_spi_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign mmc_spi_avalon_slave_0_readdata_from_sa = mmc_spi_avalon_slave_0_readdata;

  assign pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0 = (1) & (pc8001_sub_system_clock_6_out_read | pc8001_sub_system_clock_6_out_write);
  //mmc_spi_avalon_slave_0_arb_share_counter set values, which is an e_mux
  assign mmc_spi_avalon_slave_0_arb_share_set_values = 1;

  //mmc_spi_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  assign mmc_spi_avalon_slave_0_non_bursting_master_requests = pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;

  //mmc_spi_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  assign mmc_spi_avalon_slave_0_any_bursting_master_saved_grant = 0;

  //mmc_spi_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  assign mmc_spi_avalon_slave_0_arb_share_counter_next_value = mmc_spi_avalon_slave_0_firsttransfer ? (mmc_spi_avalon_slave_0_arb_share_set_values - 1) : |mmc_spi_avalon_slave_0_arb_share_counter ? (mmc_spi_avalon_slave_0_arb_share_counter - 1) : 0;

  //mmc_spi_avalon_slave_0_allgrants all slave grants, which is an e_mux
  assign mmc_spi_avalon_slave_0_allgrants = |mmc_spi_avalon_slave_0_grant_vector;

  //mmc_spi_avalon_slave_0_end_xfer assignment, which is an e_assign
  assign mmc_spi_avalon_slave_0_end_xfer = ~(mmc_spi_avalon_slave_0_waits_for_read | mmc_spi_avalon_slave_0_waits_for_write);

  //end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0 = mmc_spi_avalon_slave_0_end_xfer & (~mmc_spi_avalon_slave_0_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //mmc_spi_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  assign mmc_spi_avalon_slave_0_arb_counter_enable = (end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0 & mmc_spi_avalon_slave_0_allgrants) | (end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0 & ~mmc_spi_avalon_slave_0_non_bursting_master_requests);

  //mmc_spi_avalon_slave_0_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          mmc_spi_avalon_slave_0_arb_share_counter <= 0;
      else if (mmc_spi_avalon_slave_0_arb_counter_enable)
          mmc_spi_avalon_slave_0_arb_share_counter <= mmc_spi_avalon_slave_0_arb_share_counter_next_value;
    end


  //mmc_spi_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          mmc_spi_avalon_slave_0_slavearbiterlockenable <= 0;
      else if ((|mmc_spi_avalon_slave_0_master_qreq_vector & end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0) | (end_xfer_arb_share_counter_term_mmc_spi_avalon_slave_0 & ~mmc_spi_avalon_slave_0_non_bursting_master_requests))
          mmc_spi_avalon_slave_0_slavearbiterlockenable <= |mmc_spi_avalon_slave_0_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_6/out mmc_spi/avalon_slave_0 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_6_out_arbiterlock = mmc_spi_avalon_slave_0_slavearbiterlockenable & pc8001_sub_system_clock_6_out_continuerequest;

  //mmc_spi_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign mmc_spi_avalon_slave_0_slavearbiterlockenable2 = |mmc_spi_avalon_slave_0_arb_share_counter_next_value;

  //pc8001_sub_system_clock_6/out mmc_spi/avalon_slave_0 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_6_out_arbiterlock2 = mmc_spi_avalon_slave_0_slavearbiterlockenable2 & pc8001_sub_system_clock_6_out_continuerequest;

  //mmc_spi_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  assign mmc_spi_avalon_slave_0_any_continuerequest = 1;

  //pc8001_sub_system_clock_6_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_6_out_continuerequest = 1;

  assign pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0 = pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;
  //mmc_spi_avalon_slave_0_writedata mux, which is an e_mux
  assign mmc_spi_avalon_slave_0_writedata = pc8001_sub_system_clock_6_out_writedata;

  //master is always granted when requested
  assign pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0 = pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0;

  //pc8001_sub_system_clock_6/out saved-grant mmc_spi/avalon_slave_0, which is an e_assign
  assign pc8001_sub_system_clock_6_out_saved_grant_mmc_spi_avalon_slave_0 = pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;

  //allow new arb cycle for mmc_spi/avalon_slave_0, which is an e_assign
  assign mmc_spi_avalon_slave_0_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign mmc_spi_avalon_slave_0_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign mmc_spi_avalon_slave_0_master_qreq_vector = 1;

  //~mmc_spi_avalon_slave_0_reset assignment, which is an e_assign
  assign mmc_spi_avalon_slave_0_reset = ~reset_n;

  assign mmc_spi_avalon_slave_0_chipselect = pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0;
  //mmc_spi_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  assign mmc_spi_avalon_slave_0_firsttransfer = mmc_spi_avalon_slave_0_begins_xfer ? mmc_spi_avalon_slave_0_unreg_firsttransfer : mmc_spi_avalon_slave_0_reg_firsttransfer;

  //mmc_spi_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  assign mmc_spi_avalon_slave_0_unreg_firsttransfer = ~(mmc_spi_avalon_slave_0_slavearbiterlockenable & mmc_spi_avalon_slave_0_any_continuerequest);

  //mmc_spi_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          mmc_spi_avalon_slave_0_reg_firsttransfer <= 1'b1;
      else if (mmc_spi_avalon_slave_0_begins_xfer)
          mmc_spi_avalon_slave_0_reg_firsttransfer <= mmc_spi_avalon_slave_0_unreg_firsttransfer;
    end


  //mmc_spi_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign mmc_spi_avalon_slave_0_beginbursttransfer_internal = mmc_spi_avalon_slave_0_begins_xfer;

  //mmc_spi_avalon_slave_0_read assignment, which is an e_mux
  assign mmc_spi_avalon_slave_0_read = pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0 & pc8001_sub_system_clock_6_out_read;

  //mmc_spi_avalon_slave_0_write assignment, which is an e_mux
  assign mmc_spi_avalon_slave_0_write = pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0 & pc8001_sub_system_clock_6_out_write;

  assign shifted_address_to_mmc_spi_avalon_slave_0_from_pc8001_sub_system_clock_6_out = pc8001_sub_system_clock_6_out_address_to_slave;
  //mmc_spi_avalon_slave_0_address mux, which is an e_mux
  assign mmc_spi_avalon_slave_0_address = shifted_address_to_mmc_spi_avalon_slave_0_from_pc8001_sub_system_clock_6_out >> 2;

  //d1_mmc_spi_avalon_slave_0_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_mmc_spi_avalon_slave_0_end_xfer <= 1;
      else 
        d1_mmc_spi_avalon_slave_0_end_xfer <= mmc_spi_avalon_slave_0_end_xfer;
    end


  //mmc_spi_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  assign mmc_spi_avalon_slave_0_waits_for_read = mmc_spi_avalon_slave_0_in_a_read_cycle & mmc_spi_avalon_slave_0_begins_xfer;

  //mmc_spi_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  assign mmc_spi_avalon_slave_0_in_a_read_cycle = pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0 & pc8001_sub_system_clock_6_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = mmc_spi_avalon_slave_0_in_a_read_cycle;

  //mmc_spi_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  assign mmc_spi_avalon_slave_0_waits_for_write = mmc_spi_avalon_slave_0_in_a_write_cycle & 0;

  //mmc_spi_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  assign mmc_spi_avalon_slave_0_in_a_write_cycle = pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0 & pc8001_sub_system_clock_6_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = mmc_spi_avalon_slave_0_in_a_write_cycle;

  assign wait_for_mmc_spi_avalon_slave_0_counter = 0;
  //assign mmc_spi_avalon_slave_0_irq_from_sa = mmc_spi_avalon_slave_0_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign mmc_spi_avalon_slave_0_irq_from_sa = mmc_spi_avalon_slave_0_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //mmc_spi/avalon_slave_0 enable non-zero assertions, which is an e_register
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
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_debugaccess;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input   [ 25: 0] nios2_instruction_master_address_to_slave;
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
  reg     [  1: 0] nios2_jtag_debug_module_arb_share_counter;
  wire    [  1: 0] nios2_jtag_debug_module_arb_share_counter_next_value;
  wire    [  1: 0] nios2_jtag_debug_module_arb_share_set_values;
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
  wire    [ 25: 0] shifted_address_to_nios2_jtag_debug_module_from_nios2_data_master;
  wire    [ 25: 0] shifted_address_to_nios2_jtag_debug_module_from_nios2_instruction_master;
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

  assign nios2_data_master_requests_nios2_jtag_debug_module = ({nios2_data_master_address_to_slave[25 : 11] , 11'b0} == 26'h800) & (nios2_data_master_read | nios2_data_master_write);
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

  assign nios2_instruction_master_requests_nios2_jtag_debug_module = (({nios2_instruction_master_address_to_slave[25 : 11] , 11'b0} == 26'h800) & (nios2_instruction_master_read)) & nios2_instruction_master_read;
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

module mmc_spi_avalon_slave_0_irq_from_sa_clock_crossing_nios2_data_master_module (
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

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON"  */;
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

module nios2_data_master_arbitrator (
                                      // inputs:
                                       clk,
                                       d1_epcs_flash_controller_epcs_control_port_end_xfer,
                                       d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                       d1_nios2_jtag_debug_module_end_xfer,
                                       d1_pc8001_sub_system_clock_0_in_end_xfer,
                                       d1_pc8001_sub_system_clock_1_in_end_xfer,
                                       d1_pc8001_sub_system_clock_2_in_end_xfer,
                                       d1_pc8001_sub_system_clock_3_in_end_xfer,
                                       d1_pc8001_sub_system_clock_4_in_end_xfer,
                                       d1_pc8001_sub_system_clock_5_in_end_xfer,
                                       d1_pc8001_sub_system_clock_6_in_end_xfer,
                                       d1_pc8001_sub_system_clock_7_in_end_xfer,
                                       d1_pc8001_sub_system_clock_9_in_end_xfer,
                                       d1_sysid_control_slave_end_xfer,
                                       d1_timer_0_s1_end_xfer,
                                       epcs_flash_controller_epcs_control_port_irq_from_sa,
                                       epcs_flash_controller_epcs_control_port_readdata_from_sa,
                                       jtag_uart_avalon_jtag_slave_irq_from_sa,
                                       jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                       jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                       mmc_spi_avalon_slave_0_irq_from_sa,
                                       nios2_data_master_address,
                                       nios2_data_master_byteenable_pc8001_sub_system_clock_9_in,
                                       nios2_data_master_granted_epcs_flash_controller_epcs_control_port,
                                       nios2_data_master_granted_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_granted_nios2_jtag_debug_module,
                                       nios2_data_master_granted_pc8001_sub_system_clock_0_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_1_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_2_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_3_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_4_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_5_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_6_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_7_in,
                                       nios2_data_master_granted_pc8001_sub_system_clock_9_in,
                                       nios2_data_master_granted_sysid_control_slave,
                                       nios2_data_master_granted_timer_0_s1,
                                       nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port,
                                       nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_qualified_request_nios2_jtag_debug_module,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in,
                                       nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in,
                                       nios2_data_master_qualified_request_sysid_control_slave,
                                       nios2_data_master_qualified_request_timer_0_s1,
                                       nios2_data_master_read,
                                       nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port,
                                       nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_read_data_valid_nios2_jtag_debug_module,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in,
                                       nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in,
                                       nios2_data_master_read_data_valid_sysid_control_slave,
                                       nios2_data_master_read_data_valid_timer_0_s1,
                                       nios2_data_master_requests_epcs_flash_controller_epcs_control_port,
                                       nios2_data_master_requests_jtag_uart_avalon_jtag_slave,
                                       nios2_data_master_requests_nios2_jtag_debug_module,
                                       nios2_data_master_requests_pc8001_sub_system_clock_0_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_1_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_2_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_3_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_4_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_5_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_6_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_7_in,
                                       nios2_data_master_requests_pc8001_sub_system_clock_9_in,
                                       nios2_data_master_requests_sysid_control_slave,
                                       nios2_data_master_requests_timer_0_s1,
                                       nios2_data_master_write,
                                       nios2_data_master_writedata,
                                       nios2_jtag_debug_module_readdata_from_sa,
                                       pc8001_sub_system_clock_0_in_readdata_from_sa,
                                       pc8001_sub_system_clock_0_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_1_in_readdata_from_sa,
                                       pc8001_sub_system_clock_1_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_2_in_readdata_from_sa,
                                       pc8001_sub_system_clock_2_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_3_in_readdata_from_sa,
                                       pc8001_sub_system_clock_3_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_4_in_readdata_from_sa,
                                       pc8001_sub_system_clock_4_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_5_in_readdata_from_sa,
                                       pc8001_sub_system_clock_5_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_6_in_readdata_from_sa,
                                       pc8001_sub_system_clock_6_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_7_in_readdata_from_sa,
                                       pc8001_sub_system_clock_7_in_waitrequest_from_sa,
                                       pc8001_sub_system_clock_9_in_readdata_from_sa,
                                       pc8001_sub_system_clock_9_in_waitrequest_from_sa,
                                       pll_cpu,
                                       pll_cpu_reset_n,
                                       reset_n,
                                       sysid_control_slave_readdata_from_sa,
                                       timer_0_s1_irq_from_sa,
                                       timer_0_s1_readdata_from_sa,

                                      // outputs:
                                       nios2_data_master_address_to_slave,
                                       nios2_data_master_dbs_address,
                                       nios2_data_master_dbs_write_16,
                                       nios2_data_master_irq,
                                       nios2_data_master_no_byte_enables_and_last_term,
                                       nios2_data_master_readdata,
                                       nios2_data_master_waitrequest
                                    )
;

  output  [ 25: 0] nios2_data_master_address_to_slave;
  output  [  1: 0] nios2_data_master_dbs_address;
  output  [ 15: 0] nios2_data_master_dbs_write_16;
  output  [ 31: 0] nios2_data_master_irq;
  output           nios2_data_master_no_byte_enables_and_last_term;
  output  [ 31: 0] nios2_data_master_readdata;
  output           nios2_data_master_waitrequest;
  input            clk;
  input            d1_epcs_flash_controller_epcs_control_port_end_xfer;
  input            d1_jtag_uart_avalon_jtag_slave_end_xfer;
  input            d1_nios2_jtag_debug_module_end_xfer;
  input            d1_pc8001_sub_system_clock_0_in_end_xfer;
  input            d1_pc8001_sub_system_clock_1_in_end_xfer;
  input            d1_pc8001_sub_system_clock_2_in_end_xfer;
  input            d1_pc8001_sub_system_clock_3_in_end_xfer;
  input            d1_pc8001_sub_system_clock_4_in_end_xfer;
  input            d1_pc8001_sub_system_clock_5_in_end_xfer;
  input            d1_pc8001_sub_system_clock_6_in_end_xfer;
  input            d1_pc8001_sub_system_clock_7_in_end_xfer;
  input            d1_pc8001_sub_system_clock_9_in_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_timer_0_s1_end_xfer;
  input            epcs_flash_controller_epcs_control_port_irq_from_sa;
  input   [ 31: 0] epcs_flash_controller_epcs_control_port_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  input            mmc_spi_avalon_slave_0_irq_from_sa;
  input   [ 25: 0] nios2_data_master_address;
  input   [  1: 0] nios2_data_master_byteenable_pc8001_sub_system_clock_9_in;
  input            nios2_data_master_granted_epcs_flash_controller_epcs_control_port;
  input            nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_granted_nios2_jtag_debug_module;
  input            nios2_data_master_granted_pc8001_sub_system_clock_0_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_1_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_2_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_3_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_4_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_5_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_6_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_7_in;
  input            nios2_data_master_granted_pc8001_sub_system_clock_9_in;
  input            nios2_data_master_granted_sysid_control_slave;
  input            nios2_data_master_granted_timer_0_s1;
  input            nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port;
  input            nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_qualified_request_nios2_jtag_debug_module;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in;
  input            nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in;
  input            nios2_data_master_qualified_request_sysid_control_slave;
  input            nios2_data_master_qualified_request_timer_0_s1;
  input            nios2_data_master_read;
  input            nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  input            nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_read_data_valid_nios2_jtag_debug_module;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in;
  input            nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in;
  input            nios2_data_master_read_data_valid_sysid_control_slave;
  input            nios2_data_master_read_data_valid_timer_0_s1;
  input            nios2_data_master_requests_epcs_flash_controller_epcs_control_port;
  input            nios2_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            nios2_data_master_requests_nios2_jtag_debug_module;
  input            nios2_data_master_requests_pc8001_sub_system_clock_0_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_1_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_2_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_3_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_4_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_5_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_6_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_7_in;
  input            nios2_data_master_requests_pc8001_sub_system_clock_9_in;
  input            nios2_data_master_requests_sysid_control_slave;
  input            nios2_data_master_requests_timer_0_s1;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input   [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_0_in_readdata_from_sa;
  input            pc8001_sub_system_clock_0_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_1_in_readdata_from_sa;
  input            pc8001_sub_system_clock_1_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_2_in_readdata_from_sa;
  input            pc8001_sub_system_clock_2_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_3_in_readdata_from_sa;
  input            pc8001_sub_system_clock_3_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_4_in_readdata_from_sa;
  input            pc8001_sub_system_clock_4_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_5_in_readdata_from_sa;
  input            pc8001_sub_system_clock_5_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_6_in_readdata_from_sa;
  input            pc8001_sub_system_clock_6_in_waitrequest_from_sa;
  input   [ 31: 0] pc8001_sub_system_clock_7_in_readdata_from_sa;
  input            pc8001_sub_system_clock_7_in_waitrequest_from_sa;
  input   [ 15: 0] pc8001_sub_system_clock_9_in_readdata_from_sa;
  input            pc8001_sub_system_clock_9_in_waitrequest_from_sa;
  input            pll_cpu;
  input            pll_cpu_reset_n;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input            timer_0_s1_irq_from_sa;
  input   [ 15: 0] timer_0_s1_readdata_from_sa;

  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire             last_dbs_term_and_run;
  wire    [  1: 0] next_dbs_address;
  wire    [ 25: 0] nios2_data_master_address_to_slave;
  reg     [  1: 0] nios2_data_master_dbs_address;
  wire    [  1: 0] nios2_data_master_dbs_increment;
  wire    [ 15: 0] nios2_data_master_dbs_write_16;
  wire    [ 31: 0] nios2_data_master_irq;
  reg              nios2_data_master_no_byte_enables_and_last_term;
  wire    [ 31: 0] nios2_data_master_readdata;
  wire             nios2_data_master_run;
  reg              nios2_data_master_waitrequest;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [ 31: 0] p1_registered_nios2_data_master_readdata;
  wire             pll_cpu_mmc_spi_avalon_slave_0_irq_from_sa;
  wire             pre_dbs_count_enable;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  reg     [ 31: 0] registered_nios2_data_master_readdata;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port | ~nios2_data_master_requests_epcs_flash_controller_epcs_control_port) & (nios2_data_master_granted_epcs_flash_controller_epcs_control_port | ~nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port) & ((~nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port | ~(nios2_data_master_read | nios2_data_master_write) | (1 & 1 & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port | ~(nios2_data_master_read | nios2_data_master_write) | (1 & 1 & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~nios2_data_master_requests_jtag_uart_avalon_jtag_slave) & ((~nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_nios2_jtag_debug_module | ~nios2_data_master_requests_nios2_jtag_debug_module) & (nios2_data_master_granted_nios2_jtag_debug_module | ~nios2_data_master_qualified_request_nios2_jtag_debug_module) & ((~nios2_data_master_qualified_request_nios2_jtag_debug_module | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_nios2_jtag_debug_module | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in | ~nios2_data_master_requests_pc8001_sub_system_clock_0_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_0_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_0_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in | ~nios2_data_master_requests_pc8001_sub_system_clock_1_in);

  //cascaded wait assignment, which is an e_assign
  assign nios2_data_master_run = r_0 & r_1 & r_2;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_1_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_1_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in | ~nios2_data_master_requests_pc8001_sub_system_clock_2_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_2_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_2_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in | ~nios2_data_master_requests_pc8001_sub_system_clock_3_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_3_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_3_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in | ~nios2_data_master_requests_pc8001_sub_system_clock_4_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_4_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_4_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in | ~nios2_data_master_requests_pc8001_sub_system_clock_5_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_5_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_5_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in | ~nios2_data_master_requests_pc8001_sub_system_clock_6_in);

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_6_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_6_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in | ~nios2_data_master_requests_pc8001_sub_system_clock_7_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_7_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in | ~(nios2_data_master_read | nios2_data_master_write) | (1 & ~pc8001_sub_system_clock_7_in_waitrequest_from_sa & (nios2_data_master_read | nios2_data_master_write)))) & 1 & (nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in | (nios2_data_master_write & !nios2_data_master_byteenable_pc8001_sub_system_clock_9_in & nios2_data_master_dbs_address[1]) | ~nios2_data_master_requests_pc8001_sub_system_clock_9_in) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in | ~nios2_data_master_read | (1 & ~pc8001_sub_system_clock_9_in_waitrequest_from_sa & (nios2_data_master_dbs_address[1]) & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in | ~nios2_data_master_write | (1 & ~pc8001_sub_system_clock_9_in_waitrequest_from_sa & (nios2_data_master_dbs_address[1]) & nios2_data_master_write))) & 1 & ((~nios2_data_master_qualified_request_sysid_control_slave | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_sysid_control_slave | ~nios2_data_master_write | (1 & nios2_data_master_write))) & 1 & (nios2_data_master_qualified_request_timer_0_s1 | ~nios2_data_master_requests_timer_0_s1) & ((~nios2_data_master_qualified_request_timer_0_s1 | ~nios2_data_master_read | (1 & 1 & nios2_data_master_read))) & ((~nios2_data_master_qualified_request_timer_0_s1 | ~nios2_data_master_write | (1 & nios2_data_master_write)));

  //optimize select-logic by passing only those address bits which matter.
  assign nios2_data_master_address_to_slave = {nios2_data_master_address[25],
    2'b0,
    nios2_data_master_address[22 : 0]};

  //nios2/data_master readdata mux, which is an e_mux
  assign nios2_data_master_readdata = ({32 {~nios2_data_master_requests_epcs_flash_controller_epcs_control_port}} | epcs_flash_controller_epcs_control_port_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_jtag_uart_avalon_jtag_slave}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_nios2_jtag_debug_module}} | nios2_jtag_debug_module_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_0_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_1_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_2_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_3_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_4_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_5_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_6_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_7_in}} | registered_nios2_data_master_readdata) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_9_in}} | registered_nios2_data_master_readdata) &
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
    epcs_flash_controller_epcs_control_port_irq_from_sa,
    pll_cpu_mmc_spi_avalon_slave_0_irq_from_sa,
    timer_0_s1_irq_from_sa,
    jtag_uart_avalon_jtag_slave_irq_from_sa};

  //unpredictable registered wait state incoming data, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          registered_nios2_data_master_readdata <= 0;
      else 
        registered_nios2_data_master_readdata <= p1_registered_nios2_data_master_readdata;
    end


  //registered readdata mux, which is an e_mux
  assign p1_registered_nios2_data_master_readdata = ({32 {~nios2_data_master_requests_jtag_uart_avalon_jtag_slave}} | jtag_uart_avalon_jtag_slave_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_0_in}} | pc8001_sub_system_clock_0_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_1_in}} | pc8001_sub_system_clock_1_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_2_in}} | pc8001_sub_system_clock_2_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_3_in}} | pc8001_sub_system_clock_3_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_4_in}} | pc8001_sub_system_clock_4_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_5_in}} | pc8001_sub_system_clock_5_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_6_in}} | pc8001_sub_system_clock_6_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_7_in}} | pc8001_sub_system_clock_7_in_readdata_from_sa) &
    ({32 {~nios2_data_master_requests_pc8001_sub_system_clock_9_in}} | {pc8001_sub_system_clock_9_in_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0});

  //mmc_spi_avalon_slave_0_irq_from_sa from pll_peripheral to pll_cpu
  mmc_spi_avalon_slave_0_irq_from_sa_clock_crossing_nios2_data_master_module mmc_spi_avalon_slave_0_irq_from_sa_clock_crossing_nios2_data_master
    (
      .clk      (pll_cpu),
      .data_in  (mmc_spi_avalon_slave_0_irq_from_sa),
      .data_out (pll_cpu_mmc_spi_avalon_slave_0_irq_from_sa),
      .reset_n  (pll_cpu_reset_n)
    );

  //no_byte_enables_and_last_term, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_data_master_no_byte_enables_and_last_term <= 0;
      else 
        nios2_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end


  //compute the last dbs term, which is an e_mux
  assign last_dbs_term_and_run = (nios2_data_master_dbs_address == 2'b10) & nios2_data_master_write & !nios2_data_master_byteenable_pc8001_sub_system_clock_9_in;

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~nios2_data_master_no_byte_enables_and_last_term) & nios2_data_master_requests_pc8001_sub_system_clock_9_in & nios2_data_master_write & !nios2_data_master_byteenable_pc8001_sub_system_clock_9_in)) |
    (nios2_data_master_granted_pc8001_sub_system_clock_9_in & nios2_data_master_read & 1 & 1 & ~pc8001_sub_system_clock_9_in_waitrequest_from_sa) |
    (nios2_data_master_granted_pc8001_sub_system_clock_9_in & nios2_data_master_write & 1 & 1 & ~pc8001_sub_system_clock_9_in_waitrequest_from_sa);

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = pc8001_sub_system_clock_9_in_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((nios2_data_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign nios2_data_master_dbs_write_16 = (nios2_data_master_dbs_address[1])? nios2_data_master_writedata[31 : 16] :
    nios2_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign nios2_data_master_dbs_increment = (nios2_data_master_requests_pc8001_sub_system_clock_9_in)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = nios2_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = nios2_data_master_dbs_address + nios2_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable &
    (~(nios2_data_master_requests_pc8001_sub_system_clock_9_in & ~nios2_data_master_waitrequest));

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          nios2_data_master_dbs_address <= next_dbs_address;
    end



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
                                              d1_epcs_flash_controller_epcs_control_port_end_xfer,
                                              d1_nios2_jtag_debug_module_end_xfer,
                                              d1_pc8001_sub_system_clock_8_in_end_xfer,
                                              epcs_flash_controller_epcs_control_port_readdata_from_sa,
                                              nios2_instruction_master_address,
                                              nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port,
                                              nios2_instruction_master_granted_nios2_jtag_debug_module,
                                              nios2_instruction_master_granted_pc8001_sub_system_clock_8_in,
                                              nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port,
                                              nios2_instruction_master_qualified_request_nios2_jtag_debug_module,
                                              nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in,
                                              nios2_instruction_master_read,
                                              nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port,
                                              nios2_instruction_master_read_data_valid_nios2_jtag_debug_module,
                                              nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in,
                                              nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port,
                                              nios2_instruction_master_requests_nios2_jtag_debug_module,
                                              nios2_instruction_master_requests_pc8001_sub_system_clock_8_in,
                                              nios2_jtag_debug_module_readdata_from_sa,
                                              pc8001_sub_system_clock_8_in_readdata_from_sa,
                                              pc8001_sub_system_clock_8_in_waitrequest_from_sa,
                                              reset_n,

                                             // outputs:
                                              nios2_instruction_master_address_to_slave,
                                              nios2_instruction_master_dbs_address,
                                              nios2_instruction_master_readdata,
                                              nios2_instruction_master_waitrequest
                                           )
;

  output  [ 25: 0] nios2_instruction_master_address_to_slave;
  output  [  1: 0] nios2_instruction_master_dbs_address;
  output  [ 31: 0] nios2_instruction_master_readdata;
  output           nios2_instruction_master_waitrequest;
  input            clk;
  input            d1_epcs_flash_controller_epcs_control_port_end_xfer;
  input            d1_nios2_jtag_debug_module_end_xfer;
  input            d1_pc8001_sub_system_clock_8_in_end_xfer;
  input   [ 31: 0] epcs_flash_controller_epcs_control_port_readdata_from_sa;
  input   [ 25: 0] nios2_instruction_master_address;
  input            nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  input            nios2_instruction_master_granted_nios2_jtag_debug_module;
  input            nios2_instruction_master_granted_pc8001_sub_system_clock_8_in;
  input            nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;
  input            nios2_instruction_master_qualified_request_nios2_jtag_debug_module;
  input            nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in;
  input            nios2_instruction_master_read;
  input            nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  input            nios2_instruction_master_read_data_valid_nios2_jtag_debug_module;
  input            nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in;
  input            nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  input            nios2_instruction_master_requests_nios2_jtag_debug_module;
  input            nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;
  input   [ 31: 0] nios2_jtag_debug_module_readdata_from_sa;
  input   [ 15: 0] pc8001_sub_system_clock_8_in_readdata_from_sa;
  input            pc8001_sub_system_clock_8_in_waitrequest_from_sa;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire    [  1: 0] next_dbs_address;
  reg     [ 25: 0] nios2_instruction_master_address_last_time;
  wire    [ 25: 0] nios2_instruction_master_address_to_slave;
  reg     [  1: 0] nios2_instruction_master_dbs_address;
  wire    [  1: 0] nios2_instruction_master_dbs_increment;
  reg              nios2_instruction_master_read_last_time;
  wire    [ 31: 0] nios2_instruction_master_readdata;
  wire             nios2_instruction_master_run;
  wire             nios2_instruction_master_waitrequest;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire             pre_dbs_count_enable;
  wire             r_0;
  wire             r_2;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port | ~nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port) & (nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port | ~nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port) & ((~nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port | ~(nios2_instruction_master_read) | (1 & ~d1_epcs_flash_controller_epcs_control_port_end_xfer & (nios2_instruction_master_read)))) & 1 & (nios2_instruction_master_qualified_request_nios2_jtag_debug_module | ~nios2_instruction_master_requests_nios2_jtag_debug_module) & (nios2_instruction_master_granted_nios2_jtag_debug_module | ~nios2_instruction_master_qualified_request_nios2_jtag_debug_module) & ((~nios2_instruction_master_qualified_request_nios2_jtag_debug_module | ~nios2_instruction_master_read | (1 & ~d1_nios2_jtag_debug_module_end_xfer & nios2_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign nios2_instruction_master_run = r_0 & r_2;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & ((~nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in | ~nios2_instruction_master_read | (1 & ~pc8001_sub_system_clock_8_in_waitrequest_from_sa & (nios2_instruction_master_dbs_address[1]) & nios2_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign nios2_instruction_master_address_to_slave = {nios2_instruction_master_address[25],
    2'b0,
    nios2_instruction_master_address[22 : 0]};

  //nios2/instruction_master readdata mux, which is an e_mux
  assign nios2_instruction_master_readdata = ({32 {~nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port}} | epcs_flash_controller_epcs_control_port_readdata_from_sa) &
    ({32 {~nios2_instruction_master_requests_nios2_jtag_debug_module}} | nios2_jtag_debug_module_readdata_from_sa) &
    ({32 {~nios2_instruction_master_requests_pc8001_sub_system_clock_8_in}} | {pc8001_sub_system_clock_8_in_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign nios2_instruction_master_waitrequest = ~nios2_instruction_master_run;

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = pc8001_sub_system_clock_8_in_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((nios2_instruction_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign nios2_instruction_master_dbs_increment = (nios2_instruction_master_requests_pc8001_sub_system_clock_8_in)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = nios2_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = nios2_instruction_master_dbs_address + nios2_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios2_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          nios2_instruction_master_dbs_address <= next_dbs_address;
    end


  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = nios2_instruction_master_granted_pc8001_sub_system_clock_8_in & nios2_instruction_master_read & 1 & 1 & ~pc8001_sub_system_clock_8_in_waitrequest_from_sa;


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

module pc8001_sub_system_clock_0_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_0_in_endofpacket,
                                                  pc8001_sub_system_clock_0_in_readdata,
                                                  pc8001_sub_system_clock_0_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_0_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_0_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_0_in,
                                                  pc8001_sub_system_clock_0_in_address,
                                                  pc8001_sub_system_clock_0_in_byteenable,
                                                  pc8001_sub_system_clock_0_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_0_in_nativeaddress,
                                                  pc8001_sub_system_clock_0_in_read,
                                                  pc8001_sub_system_clock_0_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_0_in_reset_n,
                                                  pc8001_sub_system_clock_0_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_0_in_write,
                                                  pc8001_sub_system_clock_0_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_0_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_0_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_0_in;
  output  [  3: 0] pc8001_sub_system_clock_0_in_address;
  output  [  3: 0] pc8001_sub_system_clock_0_in_byteenable;
  output           pc8001_sub_system_clock_0_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_0_in_nativeaddress;
  output           pc8001_sub_system_clock_0_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_0_in_readdata_from_sa;
  output           pc8001_sub_system_clock_0_in_reset_n;
  output           pc8001_sub_system_clock_0_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_0_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_0_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_0_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_0_in_readdata;
  input            pc8001_sub_system_clock_0_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_0_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_0_in;
  wire    [  3: 0] pc8001_sub_system_clock_0_in_address;
  wire             pc8001_sub_system_clock_0_in_allgrants;
  wire             pc8001_sub_system_clock_0_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_0_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_0_in_any_continuerequest;
  wire             pc8001_sub_system_clock_0_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_0_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_0_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_0_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_0_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_0_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_0_in_byteenable;
  wire             pc8001_sub_system_clock_0_in_end_xfer;
  wire             pc8001_sub_system_clock_0_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_0_in_firsttransfer;
  wire             pc8001_sub_system_clock_0_in_grant_vector;
  wire             pc8001_sub_system_clock_0_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_0_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_0_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_0_in_nativeaddress;
  wire             pc8001_sub_system_clock_0_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_0_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_0_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_0_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_0_in_reset_n;
  reg              pc8001_sub_system_clock_0_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_0_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_0_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_0_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_0_in_waits_for_read;
  wire             pc8001_sub_system_clock_0_in_waits_for_write;
  wire             pc8001_sub_system_clock_0_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_0_in_writedata;
  wire    [ 25: 0] shifted_address_to_pc8001_sub_system_clock_0_in_from_nios2_data_master;
  wire             wait_for_pc8001_sub_system_clock_0_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_0_in_end_xfer;
    end


  assign pc8001_sub_system_clock_0_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in));
  //assign pc8001_sub_system_clock_0_in_readdata_from_sa = pc8001_sub_system_clock_0_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_0_in_readdata_from_sa = pc8001_sub_system_clock_0_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_0_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h0) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_0_in_waitrequest_from_sa = pc8001_sub_system_clock_0_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_0_in_waitrequest_from_sa = pc8001_sub_system_clock_0_in_waitrequest;

  //pc8001_sub_system_clock_0_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_0_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_0_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_0_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_0_in;

  //pc8001_sub_system_clock_0_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_0_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_0_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_in_arb_share_counter_next_value = pc8001_sub_system_clock_0_in_firsttransfer ? (pc8001_sub_system_clock_0_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_0_in_arb_share_counter ? (pc8001_sub_system_clock_0_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_0_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_0_in_allgrants = |pc8001_sub_system_clock_0_in_grant_vector;

  //pc8001_sub_system_clock_0_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_in_end_xfer = ~(pc8001_sub_system_clock_0_in_waits_for_read | pc8001_sub_system_clock_0_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in = pc8001_sub_system_clock_0_in_end_xfer & (~pc8001_sub_system_clock_0_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_0_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_0_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in & pc8001_sub_system_clock_0_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in & ~pc8001_sub_system_clock_0_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_0_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_0_in_arb_counter_enable)
          pc8001_sub_system_clock_0_in_arb_share_counter <= pc8001_sub_system_clock_0_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_0_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_0_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_0_in & ~pc8001_sub_system_clock_0_in_non_bursting_master_requests))
          pc8001_sub_system_clock_0_in_slavearbiterlockenable <= |pc8001_sub_system_clock_0_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_0/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_0_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_0_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_0_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_0_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_0/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_0_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_0_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_0_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in = nios2_data_master_requests_pc8001_sub_system_clock_0_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_0_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_0_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_0_in_endofpacket_from_sa = pc8001_sub_system_clock_0_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_0_in_endofpacket_from_sa = pc8001_sub_system_clock_0_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_0_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_0/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_0_in = nios2_data_master_requests_pc8001_sub_system_clock_0_in;

  //allow new arb cycle for pc8001_sub_system_clock_0/in, which is an e_assign
  assign pc8001_sub_system_clock_0_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_0_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_0_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_0_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_in_reset_n = reset_n;

  //pc8001_sub_system_clock_0_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_0_in_firsttransfer = pc8001_sub_system_clock_0_in_begins_xfer ? pc8001_sub_system_clock_0_in_unreg_firsttransfer : pc8001_sub_system_clock_0_in_reg_firsttransfer;

  //pc8001_sub_system_clock_0_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_0_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_0_in_slavearbiterlockenable & pc8001_sub_system_clock_0_in_any_continuerequest);

  //pc8001_sub_system_clock_0_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_0_in_begins_xfer)
          pc8001_sub_system_clock_0_in_reg_firsttransfer <= pc8001_sub_system_clock_0_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_0_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_0_in_beginbursttransfer_internal = pc8001_sub_system_clock_0_in_begins_xfer;

  //pc8001_sub_system_clock_0_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_0_in_read = nios2_data_master_granted_pc8001_sub_system_clock_0_in & nios2_data_master_read;

  //pc8001_sub_system_clock_0_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_0_in_write = nios2_data_master_granted_pc8001_sub_system_clock_0_in & nios2_data_master_write;

  assign shifted_address_to_pc8001_sub_system_clock_0_in_from_nios2_data_master = nios2_data_master_address_to_slave;
  //pc8001_sub_system_clock_0_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_0_in_address = shifted_address_to_pc8001_sub_system_clock_0_in_from_nios2_data_master >> 2;

  //slaveid pc8001_sub_system_clock_0_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_0_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_0_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_0_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_0_in_end_xfer <= pc8001_sub_system_clock_0_in_end_xfer;
    end


  //pc8001_sub_system_clock_0_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_0_in_waits_for_read = pc8001_sub_system_clock_0_in_in_a_read_cycle & pc8001_sub_system_clock_0_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_0_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_0_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_0_in_in_a_read_cycle;

  //pc8001_sub_system_clock_0_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_0_in_waits_for_write = pc8001_sub_system_clock_0_in_in_a_write_cycle & pc8001_sub_system_clock_0_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_0_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_0_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_0_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_0_in_counter = 0;
  //pc8001_sub_system_clock_0_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_0_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_0_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_0/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_0_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   d1_gpio0_s1_end_xfer,
                                                   gpio0_s1_readdata_from_sa,
                                                   pc8001_sub_system_clock_0_out_address,
                                                   pc8001_sub_system_clock_0_out_byteenable,
                                                   pc8001_sub_system_clock_0_out_granted_gpio0_s1,
                                                   pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1,
                                                   pc8001_sub_system_clock_0_out_read,
                                                   pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1,
                                                   pc8001_sub_system_clock_0_out_requests_gpio0_s1,
                                                   pc8001_sub_system_clock_0_out_write,
                                                   pc8001_sub_system_clock_0_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_0_out_address_to_slave,
                                                   pc8001_sub_system_clock_0_out_readdata,
                                                   pc8001_sub_system_clock_0_out_reset_n,
                                                   pc8001_sub_system_clock_0_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_0_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_0_out_readdata;
  output           pc8001_sub_system_clock_0_out_reset_n;
  output           pc8001_sub_system_clock_0_out_waitrequest;
  input            clk;
  input            d1_gpio0_s1_end_xfer;
  input   [ 31: 0] gpio0_s1_readdata_from_sa;
  input   [  3: 0] pc8001_sub_system_clock_0_out_address;
  input   [  3: 0] pc8001_sub_system_clock_0_out_byteenable;
  input            pc8001_sub_system_clock_0_out_granted_gpio0_s1;
  input            pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1;
  input            pc8001_sub_system_clock_0_out_read;
  input            pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1;
  input            pc8001_sub_system_clock_0_out_requests_gpio0_s1;
  input            pc8001_sub_system_clock_0_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_0_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_0_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_0_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_0_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_0_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_0_out_readdata;
  wire             pc8001_sub_system_clock_0_out_reset_n;
  wire             pc8001_sub_system_clock_0_out_run;
  wire             pc8001_sub_system_clock_0_out_waitrequest;
  reg              pc8001_sub_system_clock_0_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_0_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1 | ~pc8001_sub_system_clock_0_out_read | (1 & ~d1_gpio0_s1_end_xfer & pc8001_sub_system_clock_0_out_read))) & ((~pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1 | ~pc8001_sub_system_clock_0_out_write | (1 & pc8001_sub_system_clock_0_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_0_out_address_to_slave = pc8001_sub_system_clock_0_out_address;

  //pc8001_sub_system_clock_0/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_0_out_readdata = gpio0_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_0_out_waitrequest = ~pc8001_sub_system_clock_0_out_run;

  //pc8001_sub_system_clock_0_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_0_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_0_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_0_out_address_last_time <= pc8001_sub_system_clock_0_out_address;
    end


  //pc8001_sub_system_clock_0/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_0_out_waitrequest & (pc8001_sub_system_clock_0_out_read | pc8001_sub_system_clock_0_out_write);
    end


  //pc8001_sub_system_clock_0_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_0_out_address != pc8001_sub_system_clock_0_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_0_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_0_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_0_out_byteenable_last_time <= pc8001_sub_system_clock_0_out_byteenable;
    end


  //pc8001_sub_system_clock_0_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_0_out_byteenable != pc8001_sub_system_clock_0_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_0_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_0_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_0_out_read_last_time <= pc8001_sub_system_clock_0_out_read;
    end


  //pc8001_sub_system_clock_0_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_0_out_read != pc8001_sub_system_clock_0_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_0_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_0_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_0_out_write_last_time <= pc8001_sub_system_clock_0_out_write;
    end


  //pc8001_sub_system_clock_0_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_0_out_write != pc8001_sub_system_clock_0_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_0_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_0_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_0_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_0_out_writedata_last_time <= pc8001_sub_system_clock_0_out_writedata;
    end


  //pc8001_sub_system_clock_0_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_0_out_writedata != pc8001_sub_system_clock_0_out_writedata_last_time) & pc8001_sub_system_clock_0_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_0_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_1_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_1_in_endofpacket,
                                                  pc8001_sub_system_clock_1_in_readdata,
                                                  pc8001_sub_system_clock_1_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_1_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_1_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_1_in,
                                                  pc8001_sub_system_clock_1_in_address,
                                                  pc8001_sub_system_clock_1_in_byteenable,
                                                  pc8001_sub_system_clock_1_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_1_in_nativeaddress,
                                                  pc8001_sub_system_clock_1_in_read,
                                                  pc8001_sub_system_clock_1_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_1_in_reset_n,
                                                  pc8001_sub_system_clock_1_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_1_in_write,
                                                  pc8001_sub_system_clock_1_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_1_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_1_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_1_in;
  output  [  3: 0] pc8001_sub_system_clock_1_in_address;
  output  [  3: 0] pc8001_sub_system_clock_1_in_byteenable;
  output           pc8001_sub_system_clock_1_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_1_in_nativeaddress;
  output           pc8001_sub_system_clock_1_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_1_in_readdata_from_sa;
  output           pc8001_sub_system_clock_1_in_reset_n;
  output           pc8001_sub_system_clock_1_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_1_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_1_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_1_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_1_in_readdata;
  input            pc8001_sub_system_clock_1_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_1_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_1_in;
  wire    [  3: 0] pc8001_sub_system_clock_1_in_address;
  wire             pc8001_sub_system_clock_1_in_allgrants;
  wire             pc8001_sub_system_clock_1_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_1_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_1_in_any_continuerequest;
  wire             pc8001_sub_system_clock_1_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_1_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_1_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_1_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_1_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_1_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_1_in_byteenable;
  wire             pc8001_sub_system_clock_1_in_end_xfer;
  wire             pc8001_sub_system_clock_1_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_1_in_firsttransfer;
  wire             pc8001_sub_system_clock_1_in_grant_vector;
  wire             pc8001_sub_system_clock_1_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_1_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_1_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_1_in_nativeaddress;
  wire             pc8001_sub_system_clock_1_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_1_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_1_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_1_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_1_in_reset_n;
  reg              pc8001_sub_system_clock_1_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_1_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_1_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_1_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_1_in_waits_for_read;
  wire             pc8001_sub_system_clock_1_in_waits_for_write;
  wire             pc8001_sub_system_clock_1_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_1_in_writedata;
  wire    [ 25: 0] shifted_address_to_pc8001_sub_system_clock_1_in_from_nios2_data_master;
  wire             wait_for_pc8001_sub_system_clock_1_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_1_in_end_xfer;
    end


  assign pc8001_sub_system_clock_1_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in));
  //assign pc8001_sub_system_clock_1_in_readdata_from_sa = pc8001_sub_system_clock_1_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_1_in_readdata_from_sa = pc8001_sub_system_clock_1_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_1_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h10) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_1_in_waitrequest_from_sa = pc8001_sub_system_clock_1_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_1_in_waitrequest_from_sa = pc8001_sub_system_clock_1_in_waitrequest;

  //pc8001_sub_system_clock_1_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_1_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_1_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_1_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_1_in;

  //pc8001_sub_system_clock_1_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_1_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_1_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_in_arb_share_counter_next_value = pc8001_sub_system_clock_1_in_firsttransfer ? (pc8001_sub_system_clock_1_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_1_in_arb_share_counter ? (pc8001_sub_system_clock_1_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_1_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_1_in_allgrants = |pc8001_sub_system_clock_1_in_grant_vector;

  //pc8001_sub_system_clock_1_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_in_end_xfer = ~(pc8001_sub_system_clock_1_in_waits_for_read | pc8001_sub_system_clock_1_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in = pc8001_sub_system_clock_1_in_end_xfer & (~pc8001_sub_system_clock_1_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_1_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_1_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in & pc8001_sub_system_clock_1_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in & ~pc8001_sub_system_clock_1_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_1_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_1_in_arb_counter_enable)
          pc8001_sub_system_clock_1_in_arb_share_counter <= pc8001_sub_system_clock_1_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_1_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_1_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_1_in & ~pc8001_sub_system_clock_1_in_non_bursting_master_requests))
          pc8001_sub_system_clock_1_in_slavearbiterlockenable <= |pc8001_sub_system_clock_1_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_1/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_1_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_1_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_1_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_1_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_1/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_1_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_1_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_1_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in = nios2_data_master_requests_pc8001_sub_system_clock_1_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_1_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_1_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_1_in_endofpacket_from_sa = pc8001_sub_system_clock_1_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_1_in_endofpacket_from_sa = pc8001_sub_system_clock_1_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_1_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_1/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_1_in = nios2_data_master_requests_pc8001_sub_system_clock_1_in;

  //allow new arb cycle for pc8001_sub_system_clock_1/in, which is an e_assign
  assign pc8001_sub_system_clock_1_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_1_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_1_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_1_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_in_reset_n = reset_n;

  //pc8001_sub_system_clock_1_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_1_in_firsttransfer = pc8001_sub_system_clock_1_in_begins_xfer ? pc8001_sub_system_clock_1_in_unreg_firsttransfer : pc8001_sub_system_clock_1_in_reg_firsttransfer;

  //pc8001_sub_system_clock_1_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_1_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_1_in_slavearbiterlockenable & pc8001_sub_system_clock_1_in_any_continuerequest);

  //pc8001_sub_system_clock_1_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_1_in_begins_xfer)
          pc8001_sub_system_clock_1_in_reg_firsttransfer <= pc8001_sub_system_clock_1_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_1_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_1_in_beginbursttransfer_internal = pc8001_sub_system_clock_1_in_begins_xfer;

  //pc8001_sub_system_clock_1_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_1_in_read = nios2_data_master_granted_pc8001_sub_system_clock_1_in & nios2_data_master_read;

  //pc8001_sub_system_clock_1_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_1_in_write = nios2_data_master_granted_pc8001_sub_system_clock_1_in & nios2_data_master_write;

  assign shifted_address_to_pc8001_sub_system_clock_1_in_from_nios2_data_master = nios2_data_master_address_to_slave;
  //pc8001_sub_system_clock_1_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_1_in_address = shifted_address_to_pc8001_sub_system_clock_1_in_from_nios2_data_master >> 2;

  //slaveid pc8001_sub_system_clock_1_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_1_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_1_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_1_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_1_in_end_xfer <= pc8001_sub_system_clock_1_in_end_xfer;
    end


  //pc8001_sub_system_clock_1_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_1_in_waits_for_read = pc8001_sub_system_clock_1_in_in_a_read_cycle & pc8001_sub_system_clock_1_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_1_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_1_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_1_in_in_a_read_cycle;

  //pc8001_sub_system_clock_1_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_1_in_waits_for_write = pc8001_sub_system_clock_1_in_in_a_write_cycle & pc8001_sub_system_clock_1_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_1_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_1_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_1_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_1_in_counter = 0;
  //pc8001_sub_system_clock_1_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_1_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_1_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_1/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_1_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   d1_gpio1_s1_end_xfer,
                                                   gpio1_s1_readdata_from_sa,
                                                   pc8001_sub_system_clock_1_out_address,
                                                   pc8001_sub_system_clock_1_out_byteenable,
                                                   pc8001_sub_system_clock_1_out_granted_gpio1_s1,
                                                   pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1,
                                                   pc8001_sub_system_clock_1_out_read,
                                                   pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1,
                                                   pc8001_sub_system_clock_1_out_requests_gpio1_s1,
                                                   pc8001_sub_system_clock_1_out_write,
                                                   pc8001_sub_system_clock_1_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_1_out_address_to_slave,
                                                   pc8001_sub_system_clock_1_out_readdata,
                                                   pc8001_sub_system_clock_1_out_reset_n,
                                                   pc8001_sub_system_clock_1_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_1_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_1_out_readdata;
  output           pc8001_sub_system_clock_1_out_reset_n;
  output           pc8001_sub_system_clock_1_out_waitrequest;
  input            clk;
  input            d1_gpio1_s1_end_xfer;
  input   [ 31: 0] gpio1_s1_readdata_from_sa;
  input   [  3: 0] pc8001_sub_system_clock_1_out_address;
  input   [  3: 0] pc8001_sub_system_clock_1_out_byteenable;
  input            pc8001_sub_system_clock_1_out_granted_gpio1_s1;
  input            pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1;
  input            pc8001_sub_system_clock_1_out_read;
  input            pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1;
  input            pc8001_sub_system_clock_1_out_requests_gpio1_s1;
  input            pc8001_sub_system_clock_1_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_1_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_1_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_1_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_1_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_1_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_1_out_readdata;
  wire             pc8001_sub_system_clock_1_out_reset_n;
  wire             pc8001_sub_system_clock_1_out_run;
  wire             pc8001_sub_system_clock_1_out_waitrequest;
  reg              pc8001_sub_system_clock_1_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_1_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1 | ~pc8001_sub_system_clock_1_out_read | (1 & ~d1_gpio1_s1_end_xfer & pc8001_sub_system_clock_1_out_read))) & ((~pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1 | ~pc8001_sub_system_clock_1_out_write | (1 & pc8001_sub_system_clock_1_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_1_out_address_to_slave = pc8001_sub_system_clock_1_out_address;

  //pc8001_sub_system_clock_1/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_1_out_readdata = gpio1_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_1_out_waitrequest = ~pc8001_sub_system_clock_1_out_run;

  //pc8001_sub_system_clock_1_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_1_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_1_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_1_out_address_last_time <= pc8001_sub_system_clock_1_out_address;
    end


  //pc8001_sub_system_clock_1/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_1_out_waitrequest & (pc8001_sub_system_clock_1_out_read | pc8001_sub_system_clock_1_out_write);
    end


  //pc8001_sub_system_clock_1_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_1_out_address != pc8001_sub_system_clock_1_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_1_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_1_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_1_out_byteenable_last_time <= pc8001_sub_system_clock_1_out_byteenable;
    end


  //pc8001_sub_system_clock_1_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_1_out_byteenable != pc8001_sub_system_clock_1_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_1_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_1_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_1_out_read_last_time <= pc8001_sub_system_clock_1_out_read;
    end


  //pc8001_sub_system_clock_1_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_1_out_read != pc8001_sub_system_clock_1_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_1_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_1_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_1_out_write_last_time <= pc8001_sub_system_clock_1_out_write;
    end


  //pc8001_sub_system_clock_1_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_1_out_write != pc8001_sub_system_clock_1_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_1_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_1_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_1_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_1_out_writedata_last_time <= pc8001_sub_system_clock_1_out_writedata;
    end


  //pc8001_sub_system_clock_1_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_1_out_writedata != pc8001_sub_system_clock_1_out_writedata_last_time) & pc8001_sub_system_clock_1_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_1_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_2_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_2_in_endofpacket,
                                                  pc8001_sub_system_clock_2_in_readdata,
                                                  pc8001_sub_system_clock_2_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_2_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_2_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_2_in,
                                                  pc8001_sub_system_clock_2_in_address,
                                                  pc8001_sub_system_clock_2_in_byteenable,
                                                  pc8001_sub_system_clock_2_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_2_in_nativeaddress,
                                                  pc8001_sub_system_clock_2_in_read,
                                                  pc8001_sub_system_clock_2_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_2_in_reset_n,
                                                  pc8001_sub_system_clock_2_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_2_in_write,
                                                  pc8001_sub_system_clock_2_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_2_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_2_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_2_in;
  output  [  3: 0] pc8001_sub_system_clock_2_in_address;
  output  [  3: 0] pc8001_sub_system_clock_2_in_byteenable;
  output           pc8001_sub_system_clock_2_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_2_in_nativeaddress;
  output           pc8001_sub_system_clock_2_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_2_in_readdata_from_sa;
  output           pc8001_sub_system_clock_2_in_reset_n;
  output           pc8001_sub_system_clock_2_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_2_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_2_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_2_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_2_in_readdata;
  input            pc8001_sub_system_clock_2_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_2_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_2_in;
  wire    [  3: 0] pc8001_sub_system_clock_2_in_address;
  wire             pc8001_sub_system_clock_2_in_allgrants;
  wire             pc8001_sub_system_clock_2_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_2_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_2_in_any_continuerequest;
  wire             pc8001_sub_system_clock_2_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_2_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_2_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_2_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_2_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_2_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_2_in_byteenable;
  wire             pc8001_sub_system_clock_2_in_end_xfer;
  wire             pc8001_sub_system_clock_2_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_2_in_firsttransfer;
  wire             pc8001_sub_system_clock_2_in_grant_vector;
  wire             pc8001_sub_system_clock_2_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_2_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_2_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_2_in_nativeaddress;
  wire             pc8001_sub_system_clock_2_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_2_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_2_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_2_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_2_in_reset_n;
  reg              pc8001_sub_system_clock_2_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_2_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_2_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_2_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_2_in_waits_for_read;
  wire             pc8001_sub_system_clock_2_in_waits_for_write;
  wire             pc8001_sub_system_clock_2_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_2_in_writedata;
  wire    [ 25: 0] shifted_address_to_pc8001_sub_system_clock_2_in_from_nios2_data_master;
  wire             wait_for_pc8001_sub_system_clock_2_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_2_in_end_xfer;
    end


  assign pc8001_sub_system_clock_2_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in));
  //assign pc8001_sub_system_clock_2_in_readdata_from_sa = pc8001_sub_system_clock_2_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_2_in_readdata_from_sa = pc8001_sub_system_clock_2_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_2_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h30) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_2_in_waitrequest_from_sa = pc8001_sub_system_clock_2_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_2_in_waitrequest_from_sa = pc8001_sub_system_clock_2_in_waitrequest;

  //pc8001_sub_system_clock_2_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_2_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_2_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_2_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_2_in;

  //pc8001_sub_system_clock_2_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_2_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_2_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_in_arb_share_counter_next_value = pc8001_sub_system_clock_2_in_firsttransfer ? (pc8001_sub_system_clock_2_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_2_in_arb_share_counter ? (pc8001_sub_system_clock_2_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_2_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_2_in_allgrants = |pc8001_sub_system_clock_2_in_grant_vector;

  //pc8001_sub_system_clock_2_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_in_end_xfer = ~(pc8001_sub_system_clock_2_in_waits_for_read | pc8001_sub_system_clock_2_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in = pc8001_sub_system_clock_2_in_end_xfer & (~pc8001_sub_system_clock_2_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_2_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_2_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in & pc8001_sub_system_clock_2_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in & ~pc8001_sub_system_clock_2_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_2_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_2_in_arb_counter_enable)
          pc8001_sub_system_clock_2_in_arb_share_counter <= pc8001_sub_system_clock_2_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_2_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_2_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_2_in & ~pc8001_sub_system_clock_2_in_non_bursting_master_requests))
          pc8001_sub_system_clock_2_in_slavearbiterlockenable <= |pc8001_sub_system_clock_2_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_2/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_2_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_2_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_2_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_2_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_2/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_2_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_2_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_2_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in = nios2_data_master_requests_pc8001_sub_system_clock_2_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_2_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_2_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_2_in_endofpacket_from_sa = pc8001_sub_system_clock_2_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_2_in_endofpacket_from_sa = pc8001_sub_system_clock_2_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_2_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_2/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_2_in = nios2_data_master_requests_pc8001_sub_system_clock_2_in;

  //allow new arb cycle for pc8001_sub_system_clock_2/in, which is an e_assign
  assign pc8001_sub_system_clock_2_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_2_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_2_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_2_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_in_reset_n = reset_n;

  //pc8001_sub_system_clock_2_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_2_in_firsttransfer = pc8001_sub_system_clock_2_in_begins_xfer ? pc8001_sub_system_clock_2_in_unreg_firsttransfer : pc8001_sub_system_clock_2_in_reg_firsttransfer;

  //pc8001_sub_system_clock_2_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_2_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_2_in_slavearbiterlockenable & pc8001_sub_system_clock_2_in_any_continuerequest);

  //pc8001_sub_system_clock_2_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_2_in_begins_xfer)
          pc8001_sub_system_clock_2_in_reg_firsttransfer <= pc8001_sub_system_clock_2_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_2_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_2_in_beginbursttransfer_internal = pc8001_sub_system_clock_2_in_begins_xfer;

  //pc8001_sub_system_clock_2_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_2_in_read = nios2_data_master_granted_pc8001_sub_system_clock_2_in & nios2_data_master_read;

  //pc8001_sub_system_clock_2_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_2_in_write = nios2_data_master_granted_pc8001_sub_system_clock_2_in & nios2_data_master_write;

  assign shifted_address_to_pc8001_sub_system_clock_2_in_from_nios2_data_master = nios2_data_master_address_to_slave;
  //pc8001_sub_system_clock_2_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_2_in_address = shifted_address_to_pc8001_sub_system_clock_2_in_from_nios2_data_master >> 2;

  //slaveid pc8001_sub_system_clock_2_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_2_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_2_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_2_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_2_in_end_xfer <= pc8001_sub_system_clock_2_in_end_xfer;
    end


  //pc8001_sub_system_clock_2_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_2_in_waits_for_read = pc8001_sub_system_clock_2_in_in_a_read_cycle & pc8001_sub_system_clock_2_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_2_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_2_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_2_in_in_a_read_cycle;

  //pc8001_sub_system_clock_2_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_2_in_waits_for_write = pc8001_sub_system_clock_2_in_in_a_write_cycle & pc8001_sub_system_clock_2_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_2_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_2_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_2_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_2_in_counter = 0;
  //pc8001_sub_system_clock_2_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_2_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_2_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_2/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_2_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cmt_dout_s1_readdata_from_sa,
                                                   d1_cmt_dout_s1_end_xfer,
                                                   pc8001_sub_system_clock_2_out_address,
                                                   pc8001_sub_system_clock_2_out_byteenable,
                                                   pc8001_sub_system_clock_2_out_granted_cmt_dout_s1,
                                                   pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1,
                                                   pc8001_sub_system_clock_2_out_read,
                                                   pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1,
                                                   pc8001_sub_system_clock_2_out_requests_cmt_dout_s1,
                                                   pc8001_sub_system_clock_2_out_write,
                                                   pc8001_sub_system_clock_2_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_2_out_address_to_slave,
                                                   pc8001_sub_system_clock_2_out_readdata,
                                                   pc8001_sub_system_clock_2_out_reset_n,
                                                   pc8001_sub_system_clock_2_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_2_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_2_out_readdata;
  output           pc8001_sub_system_clock_2_out_reset_n;
  output           pc8001_sub_system_clock_2_out_waitrequest;
  input            clk;
  input   [ 31: 0] cmt_dout_s1_readdata_from_sa;
  input            d1_cmt_dout_s1_end_xfer;
  input   [  3: 0] pc8001_sub_system_clock_2_out_address;
  input   [  3: 0] pc8001_sub_system_clock_2_out_byteenable;
  input            pc8001_sub_system_clock_2_out_granted_cmt_dout_s1;
  input            pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1;
  input            pc8001_sub_system_clock_2_out_read;
  input            pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1;
  input            pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;
  input            pc8001_sub_system_clock_2_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_2_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_2_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_2_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_2_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_2_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_2_out_readdata;
  wire             pc8001_sub_system_clock_2_out_reset_n;
  wire             pc8001_sub_system_clock_2_out_run;
  wire             pc8001_sub_system_clock_2_out_waitrequest;
  reg              pc8001_sub_system_clock_2_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_2_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1 | ~pc8001_sub_system_clock_2_out_read | (1 & ~d1_cmt_dout_s1_end_xfer & pc8001_sub_system_clock_2_out_read))) & ((~pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1 | ~pc8001_sub_system_clock_2_out_write | (1 & pc8001_sub_system_clock_2_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_2_out_address_to_slave = pc8001_sub_system_clock_2_out_address;

  //pc8001_sub_system_clock_2/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_2_out_readdata = cmt_dout_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_2_out_waitrequest = ~pc8001_sub_system_clock_2_out_run;

  //pc8001_sub_system_clock_2_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_2_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_2_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_2_out_address_last_time <= pc8001_sub_system_clock_2_out_address;
    end


  //pc8001_sub_system_clock_2/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_2_out_waitrequest & (pc8001_sub_system_clock_2_out_read | pc8001_sub_system_clock_2_out_write);
    end


  //pc8001_sub_system_clock_2_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_2_out_address != pc8001_sub_system_clock_2_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_2_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_2_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_2_out_byteenable_last_time <= pc8001_sub_system_clock_2_out_byteenable;
    end


  //pc8001_sub_system_clock_2_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_2_out_byteenable != pc8001_sub_system_clock_2_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_2_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_2_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_2_out_read_last_time <= pc8001_sub_system_clock_2_out_read;
    end


  //pc8001_sub_system_clock_2_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_2_out_read != pc8001_sub_system_clock_2_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_2_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_2_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_2_out_write_last_time <= pc8001_sub_system_clock_2_out_write;
    end


  //pc8001_sub_system_clock_2_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_2_out_write != pc8001_sub_system_clock_2_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_2_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_2_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_2_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_2_out_writedata_last_time <= pc8001_sub_system_clock_2_out_writedata;
    end


  //pc8001_sub_system_clock_2_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_2_out_writedata != pc8001_sub_system_clock_2_out_writedata_last_time) & pc8001_sub_system_clock_2_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_2_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_3_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_3_in_endofpacket,
                                                  pc8001_sub_system_clock_3_in_readdata,
                                                  pc8001_sub_system_clock_3_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_3_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_3_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_3_in,
                                                  pc8001_sub_system_clock_3_in_address,
                                                  pc8001_sub_system_clock_3_in_byteenable,
                                                  pc8001_sub_system_clock_3_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_3_in_nativeaddress,
                                                  pc8001_sub_system_clock_3_in_read,
                                                  pc8001_sub_system_clock_3_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_3_in_reset_n,
                                                  pc8001_sub_system_clock_3_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_3_in_write,
                                                  pc8001_sub_system_clock_3_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_3_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_3_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_3_in;
  output  [  3: 0] pc8001_sub_system_clock_3_in_address;
  output  [  3: 0] pc8001_sub_system_clock_3_in_byteenable;
  output           pc8001_sub_system_clock_3_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_3_in_nativeaddress;
  output           pc8001_sub_system_clock_3_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_3_in_readdata_from_sa;
  output           pc8001_sub_system_clock_3_in_reset_n;
  output           pc8001_sub_system_clock_3_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_3_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_3_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_3_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_3_in_readdata;
  input            pc8001_sub_system_clock_3_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_3_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_3_in;
  wire    [  3: 0] pc8001_sub_system_clock_3_in_address;
  wire             pc8001_sub_system_clock_3_in_allgrants;
  wire             pc8001_sub_system_clock_3_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_3_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_3_in_any_continuerequest;
  wire             pc8001_sub_system_clock_3_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_3_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_3_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_3_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_3_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_3_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_3_in_byteenable;
  wire             pc8001_sub_system_clock_3_in_end_xfer;
  wire             pc8001_sub_system_clock_3_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_3_in_firsttransfer;
  wire             pc8001_sub_system_clock_3_in_grant_vector;
  wire             pc8001_sub_system_clock_3_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_3_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_3_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_3_in_nativeaddress;
  wire             pc8001_sub_system_clock_3_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_3_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_3_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_3_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_3_in_reset_n;
  reg              pc8001_sub_system_clock_3_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_3_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_3_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_3_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_3_in_waits_for_read;
  wire             pc8001_sub_system_clock_3_in_waits_for_write;
  wire             pc8001_sub_system_clock_3_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_3_in_writedata;
  wire    [ 25: 0] shifted_address_to_pc8001_sub_system_clock_3_in_from_nios2_data_master;
  wire             wait_for_pc8001_sub_system_clock_3_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_3_in_end_xfer;
    end


  assign pc8001_sub_system_clock_3_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in));
  //assign pc8001_sub_system_clock_3_in_readdata_from_sa = pc8001_sub_system_clock_3_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_3_in_readdata_from_sa = pc8001_sub_system_clock_3_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_3_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h40) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_3_in_waitrequest_from_sa = pc8001_sub_system_clock_3_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_3_in_waitrequest_from_sa = pc8001_sub_system_clock_3_in_waitrequest;

  //pc8001_sub_system_clock_3_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_3_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_3_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_3_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_3_in;

  //pc8001_sub_system_clock_3_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_3_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_3_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_in_arb_share_counter_next_value = pc8001_sub_system_clock_3_in_firsttransfer ? (pc8001_sub_system_clock_3_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_3_in_arb_share_counter ? (pc8001_sub_system_clock_3_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_3_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_3_in_allgrants = |pc8001_sub_system_clock_3_in_grant_vector;

  //pc8001_sub_system_clock_3_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_in_end_xfer = ~(pc8001_sub_system_clock_3_in_waits_for_read | pc8001_sub_system_clock_3_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in = pc8001_sub_system_clock_3_in_end_xfer & (~pc8001_sub_system_clock_3_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_3_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_3_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in & pc8001_sub_system_clock_3_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in & ~pc8001_sub_system_clock_3_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_3_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_3_in_arb_counter_enable)
          pc8001_sub_system_clock_3_in_arb_share_counter <= pc8001_sub_system_clock_3_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_3_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_3_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_3_in & ~pc8001_sub_system_clock_3_in_non_bursting_master_requests))
          pc8001_sub_system_clock_3_in_slavearbiterlockenable <= |pc8001_sub_system_clock_3_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_3/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_3_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_3_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_3_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_3_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_3/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_3_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_3_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_3_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in = nios2_data_master_requests_pc8001_sub_system_clock_3_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_3_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_3_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_3_in_endofpacket_from_sa = pc8001_sub_system_clock_3_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_3_in_endofpacket_from_sa = pc8001_sub_system_clock_3_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_3_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_3/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_3_in = nios2_data_master_requests_pc8001_sub_system_clock_3_in;

  //allow new arb cycle for pc8001_sub_system_clock_3/in, which is an e_assign
  assign pc8001_sub_system_clock_3_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_3_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_3_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_3_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_in_reset_n = reset_n;

  //pc8001_sub_system_clock_3_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_3_in_firsttransfer = pc8001_sub_system_clock_3_in_begins_xfer ? pc8001_sub_system_clock_3_in_unreg_firsttransfer : pc8001_sub_system_clock_3_in_reg_firsttransfer;

  //pc8001_sub_system_clock_3_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_3_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_3_in_slavearbiterlockenable & pc8001_sub_system_clock_3_in_any_continuerequest);

  //pc8001_sub_system_clock_3_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_3_in_begins_xfer)
          pc8001_sub_system_clock_3_in_reg_firsttransfer <= pc8001_sub_system_clock_3_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_3_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_3_in_beginbursttransfer_internal = pc8001_sub_system_clock_3_in_begins_xfer;

  //pc8001_sub_system_clock_3_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_3_in_read = nios2_data_master_granted_pc8001_sub_system_clock_3_in & nios2_data_master_read;

  //pc8001_sub_system_clock_3_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_3_in_write = nios2_data_master_granted_pc8001_sub_system_clock_3_in & nios2_data_master_write;

  assign shifted_address_to_pc8001_sub_system_clock_3_in_from_nios2_data_master = nios2_data_master_address_to_slave;
  //pc8001_sub_system_clock_3_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_3_in_address = shifted_address_to_pc8001_sub_system_clock_3_in_from_nios2_data_master >> 2;

  //slaveid pc8001_sub_system_clock_3_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_3_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_3_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_3_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_3_in_end_xfer <= pc8001_sub_system_clock_3_in_end_xfer;
    end


  //pc8001_sub_system_clock_3_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_3_in_waits_for_read = pc8001_sub_system_clock_3_in_in_a_read_cycle & pc8001_sub_system_clock_3_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_3_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_3_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_3_in_in_a_read_cycle;

  //pc8001_sub_system_clock_3_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_3_in_waits_for_write = pc8001_sub_system_clock_3_in_in_a_write_cycle & pc8001_sub_system_clock_3_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_3_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_3_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_3_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_3_in_counter = 0;
  //pc8001_sub_system_clock_3_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_3_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_3_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_3/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_3_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cmt_din_s1_readdata_from_sa,
                                                   d1_cmt_din_s1_end_xfer,
                                                   pc8001_sub_system_clock_3_out_address,
                                                   pc8001_sub_system_clock_3_out_byteenable,
                                                   pc8001_sub_system_clock_3_out_granted_cmt_din_s1,
                                                   pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1,
                                                   pc8001_sub_system_clock_3_out_read,
                                                   pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1,
                                                   pc8001_sub_system_clock_3_out_requests_cmt_din_s1,
                                                   pc8001_sub_system_clock_3_out_write,
                                                   pc8001_sub_system_clock_3_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_3_out_address_to_slave,
                                                   pc8001_sub_system_clock_3_out_readdata,
                                                   pc8001_sub_system_clock_3_out_reset_n,
                                                   pc8001_sub_system_clock_3_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_3_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_3_out_readdata;
  output           pc8001_sub_system_clock_3_out_reset_n;
  output           pc8001_sub_system_clock_3_out_waitrequest;
  input            clk;
  input   [ 31: 0] cmt_din_s1_readdata_from_sa;
  input            d1_cmt_din_s1_end_xfer;
  input   [  3: 0] pc8001_sub_system_clock_3_out_address;
  input   [  3: 0] pc8001_sub_system_clock_3_out_byteenable;
  input            pc8001_sub_system_clock_3_out_granted_cmt_din_s1;
  input            pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1;
  input            pc8001_sub_system_clock_3_out_read;
  input            pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1;
  input            pc8001_sub_system_clock_3_out_requests_cmt_din_s1;
  input            pc8001_sub_system_clock_3_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_3_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_3_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_3_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_3_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_3_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_3_out_readdata;
  wire             pc8001_sub_system_clock_3_out_reset_n;
  wire             pc8001_sub_system_clock_3_out_run;
  wire             pc8001_sub_system_clock_3_out_waitrequest;
  reg              pc8001_sub_system_clock_3_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_3_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1 | ~pc8001_sub_system_clock_3_out_read | (1 & ~d1_cmt_din_s1_end_xfer & pc8001_sub_system_clock_3_out_read))) & ((~pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1 | ~pc8001_sub_system_clock_3_out_write | (1 & pc8001_sub_system_clock_3_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_3_out_address_to_slave = pc8001_sub_system_clock_3_out_address;

  //pc8001_sub_system_clock_3/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_3_out_readdata = cmt_din_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_3_out_waitrequest = ~pc8001_sub_system_clock_3_out_run;

  //pc8001_sub_system_clock_3_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_3_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_3_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_3_out_address_last_time <= pc8001_sub_system_clock_3_out_address;
    end


  //pc8001_sub_system_clock_3/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_3_out_waitrequest & (pc8001_sub_system_clock_3_out_read | pc8001_sub_system_clock_3_out_write);
    end


  //pc8001_sub_system_clock_3_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_3_out_address != pc8001_sub_system_clock_3_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_3_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_3_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_3_out_byteenable_last_time <= pc8001_sub_system_clock_3_out_byteenable;
    end


  //pc8001_sub_system_clock_3_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_3_out_byteenable != pc8001_sub_system_clock_3_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_3_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_3_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_3_out_read_last_time <= pc8001_sub_system_clock_3_out_read;
    end


  //pc8001_sub_system_clock_3_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_3_out_read != pc8001_sub_system_clock_3_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_3_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_3_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_3_out_write_last_time <= pc8001_sub_system_clock_3_out_write;
    end


  //pc8001_sub_system_clock_3_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_3_out_write != pc8001_sub_system_clock_3_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_3_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_3_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_3_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_3_out_writedata_last_time <= pc8001_sub_system_clock_3_out_writedata;
    end


  //pc8001_sub_system_clock_3_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_3_out_writedata != pc8001_sub_system_clock_3_out_writedata_last_time) & pc8001_sub_system_clock_3_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_3_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_4_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_4_in_endofpacket,
                                                  pc8001_sub_system_clock_4_in_readdata,
                                                  pc8001_sub_system_clock_4_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_4_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_4_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_4_in,
                                                  pc8001_sub_system_clock_4_in_address,
                                                  pc8001_sub_system_clock_4_in_byteenable,
                                                  pc8001_sub_system_clock_4_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_4_in_nativeaddress,
                                                  pc8001_sub_system_clock_4_in_read,
                                                  pc8001_sub_system_clock_4_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_4_in_reset_n,
                                                  pc8001_sub_system_clock_4_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_4_in_write,
                                                  pc8001_sub_system_clock_4_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_4_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_4_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_4_in;
  output  [  3: 0] pc8001_sub_system_clock_4_in_address;
  output  [  3: 0] pc8001_sub_system_clock_4_in_byteenable;
  output           pc8001_sub_system_clock_4_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_4_in_nativeaddress;
  output           pc8001_sub_system_clock_4_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_4_in_readdata_from_sa;
  output           pc8001_sub_system_clock_4_in_reset_n;
  output           pc8001_sub_system_clock_4_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_4_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_4_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_4_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_4_in_readdata;
  input            pc8001_sub_system_clock_4_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_4_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_4_in;
  wire    [  3: 0] pc8001_sub_system_clock_4_in_address;
  wire             pc8001_sub_system_clock_4_in_allgrants;
  wire             pc8001_sub_system_clock_4_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_4_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_4_in_any_continuerequest;
  wire             pc8001_sub_system_clock_4_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_4_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_4_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_4_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_4_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_4_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_4_in_byteenable;
  wire             pc8001_sub_system_clock_4_in_end_xfer;
  wire             pc8001_sub_system_clock_4_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_4_in_firsttransfer;
  wire             pc8001_sub_system_clock_4_in_grant_vector;
  wire             pc8001_sub_system_clock_4_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_4_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_4_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_4_in_nativeaddress;
  wire             pc8001_sub_system_clock_4_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_4_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_4_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_4_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_4_in_reset_n;
  reg              pc8001_sub_system_clock_4_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_4_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_4_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_4_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_4_in_waits_for_read;
  wire             pc8001_sub_system_clock_4_in_waits_for_write;
  wire             pc8001_sub_system_clock_4_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_4_in_writedata;
  wire    [ 25: 0] shifted_address_to_pc8001_sub_system_clock_4_in_from_nios2_data_master;
  wire             wait_for_pc8001_sub_system_clock_4_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_4_in_end_xfer;
    end


  assign pc8001_sub_system_clock_4_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in));
  //assign pc8001_sub_system_clock_4_in_readdata_from_sa = pc8001_sub_system_clock_4_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_4_in_readdata_from_sa = pc8001_sub_system_clock_4_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_4_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h50) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_4_in_waitrequest_from_sa = pc8001_sub_system_clock_4_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_4_in_waitrequest_from_sa = pc8001_sub_system_clock_4_in_waitrequest;

  //pc8001_sub_system_clock_4_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_4_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_4_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_4_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_4_in;

  //pc8001_sub_system_clock_4_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_4_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_4_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_in_arb_share_counter_next_value = pc8001_sub_system_clock_4_in_firsttransfer ? (pc8001_sub_system_clock_4_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_4_in_arb_share_counter ? (pc8001_sub_system_clock_4_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_4_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_4_in_allgrants = |pc8001_sub_system_clock_4_in_grant_vector;

  //pc8001_sub_system_clock_4_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_in_end_xfer = ~(pc8001_sub_system_clock_4_in_waits_for_read | pc8001_sub_system_clock_4_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in = pc8001_sub_system_clock_4_in_end_xfer & (~pc8001_sub_system_clock_4_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_4_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_4_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in & pc8001_sub_system_clock_4_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in & ~pc8001_sub_system_clock_4_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_4_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_4_in_arb_counter_enable)
          pc8001_sub_system_clock_4_in_arb_share_counter <= pc8001_sub_system_clock_4_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_4_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_4_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_4_in & ~pc8001_sub_system_clock_4_in_non_bursting_master_requests))
          pc8001_sub_system_clock_4_in_slavearbiterlockenable <= |pc8001_sub_system_clock_4_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_4/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_4_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_4_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_4_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_4_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_4/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_4_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_4_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_4_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in = nios2_data_master_requests_pc8001_sub_system_clock_4_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_4_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_4_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_4_in_endofpacket_from_sa = pc8001_sub_system_clock_4_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_4_in_endofpacket_from_sa = pc8001_sub_system_clock_4_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_4_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_4/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_4_in = nios2_data_master_requests_pc8001_sub_system_clock_4_in;

  //allow new arb cycle for pc8001_sub_system_clock_4/in, which is an e_assign
  assign pc8001_sub_system_clock_4_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_4_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_4_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_4_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_in_reset_n = reset_n;

  //pc8001_sub_system_clock_4_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_4_in_firsttransfer = pc8001_sub_system_clock_4_in_begins_xfer ? pc8001_sub_system_clock_4_in_unreg_firsttransfer : pc8001_sub_system_clock_4_in_reg_firsttransfer;

  //pc8001_sub_system_clock_4_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_4_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_4_in_slavearbiterlockenable & pc8001_sub_system_clock_4_in_any_continuerequest);

  //pc8001_sub_system_clock_4_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_4_in_begins_xfer)
          pc8001_sub_system_clock_4_in_reg_firsttransfer <= pc8001_sub_system_clock_4_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_4_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_4_in_beginbursttransfer_internal = pc8001_sub_system_clock_4_in_begins_xfer;

  //pc8001_sub_system_clock_4_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_4_in_read = nios2_data_master_granted_pc8001_sub_system_clock_4_in & nios2_data_master_read;

  //pc8001_sub_system_clock_4_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_4_in_write = nios2_data_master_granted_pc8001_sub_system_clock_4_in & nios2_data_master_write;

  assign shifted_address_to_pc8001_sub_system_clock_4_in_from_nios2_data_master = nios2_data_master_address_to_slave;
  //pc8001_sub_system_clock_4_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_4_in_address = shifted_address_to_pc8001_sub_system_clock_4_in_from_nios2_data_master >> 2;

  //slaveid pc8001_sub_system_clock_4_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_4_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_4_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_4_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_4_in_end_xfer <= pc8001_sub_system_clock_4_in_end_xfer;
    end


  //pc8001_sub_system_clock_4_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_4_in_waits_for_read = pc8001_sub_system_clock_4_in_in_a_read_cycle & pc8001_sub_system_clock_4_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_4_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_4_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_4_in_in_a_read_cycle;

  //pc8001_sub_system_clock_4_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_4_in_waits_for_write = pc8001_sub_system_clock_4_in_in_a_write_cycle & pc8001_sub_system_clock_4_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_4_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_4_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_4_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_4_in_counter = 0;
  //pc8001_sub_system_clock_4_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_4_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_4_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_4/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_4_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cmt_gpio_out_s1_readdata_from_sa,
                                                   d1_cmt_gpio_out_s1_end_xfer,
                                                   pc8001_sub_system_clock_4_out_address,
                                                   pc8001_sub_system_clock_4_out_byteenable,
                                                   pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1,
                                                   pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1,
                                                   pc8001_sub_system_clock_4_out_read,
                                                   pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1,
                                                   pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1,
                                                   pc8001_sub_system_clock_4_out_write,
                                                   pc8001_sub_system_clock_4_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_4_out_address_to_slave,
                                                   pc8001_sub_system_clock_4_out_readdata,
                                                   pc8001_sub_system_clock_4_out_reset_n,
                                                   pc8001_sub_system_clock_4_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_4_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_4_out_readdata;
  output           pc8001_sub_system_clock_4_out_reset_n;
  output           pc8001_sub_system_clock_4_out_waitrequest;
  input            clk;
  input   [ 31: 0] cmt_gpio_out_s1_readdata_from_sa;
  input            d1_cmt_gpio_out_s1_end_xfer;
  input   [  3: 0] pc8001_sub_system_clock_4_out_address;
  input   [  3: 0] pc8001_sub_system_clock_4_out_byteenable;
  input            pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1;
  input            pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1;
  input            pc8001_sub_system_clock_4_out_read;
  input            pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1;
  input            pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;
  input            pc8001_sub_system_clock_4_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_4_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_4_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_4_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_4_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_4_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_4_out_readdata;
  wire             pc8001_sub_system_clock_4_out_reset_n;
  wire             pc8001_sub_system_clock_4_out_run;
  wire             pc8001_sub_system_clock_4_out_waitrequest;
  reg              pc8001_sub_system_clock_4_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_4_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1 | ~pc8001_sub_system_clock_4_out_read | (1 & ~d1_cmt_gpio_out_s1_end_xfer & pc8001_sub_system_clock_4_out_read))) & ((~pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1 | ~pc8001_sub_system_clock_4_out_write | (1 & pc8001_sub_system_clock_4_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_4_out_address_to_slave = pc8001_sub_system_clock_4_out_address;

  //pc8001_sub_system_clock_4/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_4_out_readdata = cmt_gpio_out_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_4_out_waitrequest = ~pc8001_sub_system_clock_4_out_run;

  //pc8001_sub_system_clock_4_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_4_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_4_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_4_out_address_last_time <= pc8001_sub_system_clock_4_out_address;
    end


  //pc8001_sub_system_clock_4/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_4_out_waitrequest & (pc8001_sub_system_clock_4_out_read | pc8001_sub_system_clock_4_out_write);
    end


  //pc8001_sub_system_clock_4_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_4_out_address != pc8001_sub_system_clock_4_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_4_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_4_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_4_out_byteenable_last_time <= pc8001_sub_system_clock_4_out_byteenable;
    end


  //pc8001_sub_system_clock_4_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_4_out_byteenable != pc8001_sub_system_clock_4_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_4_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_4_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_4_out_read_last_time <= pc8001_sub_system_clock_4_out_read;
    end


  //pc8001_sub_system_clock_4_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_4_out_read != pc8001_sub_system_clock_4_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_4_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_4_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_4_out_write_last_time <= pc8001_sub_system_clock_4_out_write;
    end


  //pc8001_sub_system_clock_4_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_4_out_write != pc8001_sub_system_clock_4_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_4_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_4_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_4_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_4_out_writedata_last_time <= pc8001_sub_system_clock_4_out_writedata;
    end


  //pc8001_sub_system_clock_4_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_4_out_writedata != pc8001_sub_system_clock_4_out_writedata_last_time) & pc8001_sub_system_clock_4_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_4_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_5_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_5_in_endofpacket,
                                                  pc8001_sub_system_clock_5_in_readdata,
                                                  pc8001_sub_system_clock_5_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_5_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_5_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_5_in,
                                                  pc8001_sub_system_clock_5_in_address,
                                                  pc8001_sub_system_clock_5_in_byteenable,
                                                  pc8001_sub_system_clock_5_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_5_in_nativeaddress,
                                                  pc8001_sub_system_clock_5_in_read,
                                                  pc8001_sub_system_clock_5_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_5_in_reset_n,
                                                  pc8001_sub_system_clock_5_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_5_in_write,
                                                  pc8001_sub_system_clock_5_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_5_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_5_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_5_in;
  output  [  3: 0] pc8001_sub_system_clock_5_in_address;
  output  [  3: 0] pc8001_sub_system_clock_5_in_byteenable;
  output           pc8001_sub_system_clock_5_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_5_in_nativeaddress;
  output           pc8001_sub_system_clock_5_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_5_in_readdata_from_sa;
  output           pc8001_sub_system_clock_5_in_reset_n;
  output           pc8001_sub_system_clock_5_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_5_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_5_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_5_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_5_in_readdata;
  input            pc8001_sub_system_clock_5_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_5_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_5_in;
  wire    [  3: 0] pc8001_sub_system_clock_5_in_address;
  wire             pc8001_sub_system_clock_5_in_allgrants;
  wire             pc8001_sub_system_clock_5_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_5_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_5_in_any_continuerequest;
  wire             pc8001_sub_system_clock_5_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_5_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_5_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_5_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_5_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_5_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_5_in_byteenable;
  wire             pc8001_sub_system_clock_5_in_end_xfer;
  wire             pc8001_sub_system_clock_5_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_5_in_firsttransfer;
  wire             pc8001_sub_system_clock_5_in_grant_vector;
  wire             pc8001_sub_system_clock_5_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_5_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_5_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_5_in_nativeaddress;
  wire             pc8001_sub_system_clock_5_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_5_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_5_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_5_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_5_in_reset_n;
  reg              pc8001_sub_system_clock_5_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_5_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_5_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_5_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_5_in_waits_for_read;
  wire             pc8001_sub_system_clock_5_in_waits_for_write;
  wire             pc8001_sub_system_clock_5_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_5_in_writedata;
  wire    [ 25: 0] shifted_address_to_pc8001_sub_system_clock_5_in_from_nios2_data_master;
  wire             wait_for_pc8001_sub_system_clock_5_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_5_in_end_xfer;
    end


  assign pc8001_sub_system_clock_5_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in));
  //assign pc8001_sub_system_clock_5_in_readdata_from_sa = pc8001_sub_system_clock_5_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_5_in_readdata_from_sa = pc8001_sub_system_clock_5_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_5_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h60) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_5_in_waitrequest_from_sa = pc8001_sub_system_clock_5_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_5_in_waitrequest_from_sa = pc8001_sub_system_clock_5_in_waitrequest;

  //pc8001_sub_system_clock_5_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_5_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_5_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_5_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_5_in;

  //pc8001_sub_system_clock_5_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_5_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_5_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_in_arb_share_counter_next_value = pc8001_sub_system_clock_5_in_firsttransfer ? (pc8001_sub_system_clock_5_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_5_in_arb_share_counter ? (pc8001_sub_system_clock_5_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_5_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_5_in_allgrants = |pc8001_sub_system_clock_5_in_grant_vector;

  //pc8001_sub_system_clock_5_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_in_end_xfer = ~(pc8001_sub_system_clock_5_in_waits_for_read | pc8001_sub_system_clock_5_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in = pc8001_sub_system_clock_5_in_end_xfer & (~pc8001_sub_system_clock_5_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_5_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_5_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in & pc8001_sub_system_clock_5_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in & ~pc8001_sub_system_clock_5_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_5_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_5_in_arb_counter_enable)
          pc8001_sub_system_clock_5_in_arb_share_counter <= pc8001_sub_system_clock_5_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_5_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_5_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_5_in & ~pc8001_sub_system_clock_5_in_non_bursting_master_requests))
          pc8001_sub_system_clock_5_in_slavearbiterlockenable <= |pc8001_sub_system_clock_5_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_5/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_5_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_5_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_5_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_5_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_5/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_5_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_5_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_5_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in = nios2_data_master_requests_pc8001_sub_system_clock_5_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_5_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_5_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_5_in_endofpacket_from_sa = pc8001_sub_system_clock_5_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_5_in_endofpacket_from_sa = pc8001_sub_system_clock_5_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_5_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_5/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_5_in = nios2_data_master_requests_pc8001_sub_system_clock_5_in;

  //allow new arb cycle for pc8001_sub_system_clock_5/in, which is an e_assign
  assign pc8001_sub_system_clock_5_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_5_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_5_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_5_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_in_reset_n = reset_n;

  //pc8001_sub_system_clock_5_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_5_in_firsttransfer = pc8001_sub_system_clock_5_in_begins_xfer ? pc8001_sub_system_clock_5_in_unreg_firsttransfer : pc8001_sub_system_clock_5_in_reg_firsttransfer;

  //pc8001_sub_system_clock_5_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_5_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_5_in_slavearbiterlockenable & pc8001_sub_system_clock_5_in_any_continuerequest);

  //pc8001_sub_system_clock_5_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_5_in_begins_xfer)
          pc8001_sub_system_clock_5_in_reg_firsttransfer <= pc8001_sub_system_clock_5_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_5_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_5_in_beginbursttransfer_internal = pc8001_sub_system_clock_5_in_begins_xfer;

  //pc8001_sub_system_clock_5_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_5_in_read = nios2_data_master_granted_pc8001_sub_system_clock_5_in & nios2_data_master_read;

  //pc8001_sub_system_clock_5_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_5_in_write = nios2_data_master_granted_pc8001_sub_system_clock_5_in & nios2_data_master_write;

  assign shifted_address_to_pc8001_sub_system_clock_5_in_from_nios2_data_master = nios2_data_master_address_to_slave;
  //pc8001_sub_system_clock_5_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_5_in_address = shifted_address_to_pc8001_sub_system_clock_5_in_from_nios2_data_master >> 2;

  //slaveid pc8001_sub_system_clock_5_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_5_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_5_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_5_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_5_in_end_xfer <= pc8001_sub_system_clock_5_in_end_xfer;
    end


  //pc8001_sub_system_clock_5_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_5_in_waits_for_read = pc8001_sub_system_clock_5_in_in_a_read_cycle & pc8001_sub_system_clock_5_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_5_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_5_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_5_in_in_a_read_cycle;

  //pc8001_sub_system_clock_5_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_5_in_waits_for_write = pc8001_sub_system_clock_5_in_in_a_write_cycle & pc8001_sub_system_clock_5_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_5_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_5_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_5_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_5_in_counter = 0;
  //pc8001_sub_system_clock_5_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_5_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_5_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_5/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_5_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cmt_gpio_in_s1_readdata_from_sa,
                                                   d1_cmt_gpio_in_s1_end_xfer,
                                                   pc8001_sub_system_clock_5_out_address,
                                                   pc8001_sub_system_clock_5_out_byteenable,
                                                   pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1,
                                                   pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1,
                                                   pc8001_sub_system_clock_5_out_read,
                                                   pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1,
                                                   pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1,
                                                   pc8001_sub_system_clock_5_out_write,
                                                   pc8001_sub_system_clock_5_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_5_out_address_to_slave,
                                                   pc8001_sub_system_clock_5_out_readdata,
                                                   pc8001_sub_system_clock_5_out_reset_n,
                                                   pc8001_sub_system_clock_5_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_5_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_5_out_readdata;
  output           pc8001_sub_system_clock_5_out_reset_n;
  output           pc8001_sub_system_clock_5_out_waitrequest;
  input            clk;
  input   [ 31: 0] cmt_gpio_in_s1_readdata_from_sa;
  input            d1_cmt_gpio_in_s1_end_xfer;
  input   [  3: 0] pc8001_sub_system_clock_5_out_address;
  input   [  3: 0] pc8001_sub_system_clock_5_out_byteenable;
  input            pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1;
  input            pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1;
  input            pc8001_sub_system_clock_5_out_read;
  input            pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1;
  input            pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;
  input            pc8001_sub_system_clock_5_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_5_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_5_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_5_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_5_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_5_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_5_out_readdata;
  wire             pc8001_sub_system_clock_5_out_reset_n;
  wire             pc8001_sub_system_clock_5_out_run;
  wire             pc8001_sub_system_clock_5_out_waitrequest;
  reg              pc8001_sub_system_clock_5_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_5_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1 | ~pc8001_sub_system_clock_5_out_read | (1 & ~d1_cmt_gpio_in_s1_end_xfer & pc8001_sub_system_clock_5_out_read))) & ((~pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1 | ~pc8001_sub_system_clock_5_out_write | (1 & pc8001_sub_system_clock_5_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_5_out_address_to_slave = pc8001_sub_system_clock_5_out_address;

  //pc8001_sub_system_clock_5/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_5_out_readdata = cmt_gpio_in_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_5_out_waitrequest = ~pc8001_sub_system_clock_5_out_run;

  //pc8001_sub_system_clock_5_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_5_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_5_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_5_out_address_last_time <= pc8001_sub_system_clock_5_out_address;
    end


  //pc8001_sub_system_clock_5/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_5_out_waitrequest & (pc8001_sub_system_clock_5_out_read | pc8001_sub_system_clock_5_out_write);
    end


  //pc8001_sub_system_clock_5_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_5_out_address != pc8001_sub_system_clock_5_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_5_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_5_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_5_out_byteenable_last_time <= pc8001_sub_system_clock_5_out_byteenable;
    end


  //pc8001_sub_system_clock_5_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_5_out_byteenable != pc8001_sub_system_clock_5_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_5_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_5_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_5_out_read_last_time <= pc8001_sub_system_clock_5_out_read;
    end


  //pc8001_sub_system_clock_5_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_5_out_read != pc8001_sub_system_clock_5_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_5_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_5_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_5_out_write_last_time <= pc8001_sub_system_clock_5_out_write;
    end


  //pc8001_sub_system_clock_5_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_5_out_write != pc8001_sub_system_clock_5_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_5_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_5_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_5_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_5_out_writedata_last_time <= pc8001_sub_system_clock_5_out_writedata;
    end


  //pc8001_sub_system_clock_5_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_5_out_writedata != pc8001_sub_system_clock_5_out_writedata_last_time) & pc8001_sub_system_clock_5_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_5_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_6_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_6_in_endofpacket,
                                                  pc8001_sub_system_clock_6_in_readdata,
                                                  pc8001_sub_system_clock_6_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_6_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_6_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_6_in,
                                                  pc8001_sub_system_clock_6_in_address,
                                                  pc8001_sub_system_clock_6_in_byteenable,
                                                  pc8001_sub_system_clock_6_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_6_in_nativeaddress,
                                                  pc8001_sub_system_clock_6_in_read,
                                                  pc8001_sub_system_clock_6_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_6_in_reset_n,
                                                  pc8001_sub_system_clock_6_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_6_in_write,
                                                  pc8001_sub_system_clock_6_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_6_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_6_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_6_in;
  output  [  3: 0] pc8001_sub_system_clock_6_in_address;
  output  [  3: 0] pc8001_sub_system_clock_6_in_byteenable;
  output           pc8001_sub_system_clock_6_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_6_in_nativeaddress;
  output           pc8001_sub_system_clock_6_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_6_in_readdata_from_sa;
  output           pc8001_sub_system_clock_6_in_reset_n;
  output           pc8001_sub_system_clock_6_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_6_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_6_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_6_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_6_in_readdata;
  input            pc8001_sub_system_clock_6_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_6_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_6_in;
  wire    [  3: 0] pc8001_sub_system_clock_6_in_address;
  wire             pc8001_sub_system_clock_6_in_allgrants;
  wire             pc8001_sub_system_clock_6_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_6_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_6_in_any_continuerequest;
  wire             pc8001_sub_system_clock_6_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_6_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_6_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_6_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_6_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_6_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_6_in_byteenable;
  wire             pc8001_sub_system_clock_6_in_end_xfer;
  wire             pc8001_sub_system_clock_6_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_6_in_firsttransfer;
  wire             pc8001_sub_system_clock_6_in_grant_vector;
  wire             pc8001_sub_system_clock_6_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_6_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_6_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_6_in_nativeaddress;
  wire             pc8001_sub_system_clock_6_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_6_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_6_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_6_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_6_in_reset_n;
  reg              pc8001_sub_system_clock_6_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_6_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_6_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_6_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_6_in_waits_for_read;
  wire             pc8001_sub_system_clock_6_in_waits_for_write;
  wire             pc8001_sub_system_clock_6_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_6_in_writedata;
  wire             wait_for_pc8001_sub_system_clock_6_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_6_in_end_xfer;
    end


  assign pc8001_sub_system_clock_6_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in));
  //assign pc8001_sub_system_clock_6_in_readdata_from_sa = pc8001_sub_system_clock_6_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_6_in_readdata_from_sa = pc8001_sub_system_clock_6_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_6_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'h70) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_6_in_waitrequest_from_sa = pc8001_sub_system_clock_6_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_6_in_waitrequest_from_sa = pc8001_sub_system_clock_6_in_waitrequest;

  //pc8001_sub_system_clock_6_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_6_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_6_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_6_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_6_in;

  //pc8001_sub_system_clock_6_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_6_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_6_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_in_arb_share_counter_next_value = pc8001_sub_system_clock_6_in_firsttransfer ? (pc8001_sub_system_clock_6_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_6_in_arb_share_counter ? (pc8001_sub_system_clock_6_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_6_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_6_in_allgrants = |pc8001_sub_system_clock_6_in_grant_vector;

  //pc8001_sub_system_clock_6_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_in_end_xfer = ~(pc8001_sub_system_clock_6_in_waits_for_read | pc8001_sub_system_clock_6_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in = pc8001_sub_system_clock_6_in_end_xfer & (~pc8001_sub_system_clock_6_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_6_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_6_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in & pc8001_sub_system_clock_6_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in & ~pc8001_sub_system_clock_6_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_6_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_6_in_arb_counter_enable)
          pc8001_sub_system_clock_6_in_arb_share_counter <= pc8001_sub_system_clock_6_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_6_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_6_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_6_in & ~pc8001_sub_system_clock_6_in_non_bursting_master_requests))
          pc8001_sub_system_clock_6_in_slavearbiterlockenable <= |pc8001_sub_system_clock_6_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_6/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_6_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_6_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_6_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_6_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_6/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_6_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_6_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_6_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in = nios2_data_master_requests_pc8001_sub_system_clock_6_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_6_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_6_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_6_in_endofpacket_from_sa = pc8001_sub_system_clock_6_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_6_in_endofpacket_from_sa = pc8001_sub_system_clock_6_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_6_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_6/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_6_in = nios2_data_master_requests_pc8001_sub_system_clock_6_in;

  //allow new arb cycle for pc8001_sub_system_clock_6/in, which is an e_assign
  assign pc8001_sub_system_clock_6_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_6_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_6_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_6_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_in_reset_n = reset_n;

  //pc8001_sub_system_clock_6_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_6_in_firsttransfer = pc8001_sub_system_clock_6_in_begins_xfer ? pc8001_sub_system_clock_6_in_unreg_firsttransfer : pc8001_sub_system_clock_6_in_reg_firsttransfer;

  //pc8001_sub_system_clock_6_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_6_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_6_in_slavearbiterlockenable & pc8001_sub_system_clock_6_in_any_continuerequest);

  //pc8001_sub_system_clock_6_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_6_in_begins_xfer)
          pc8001_sub_system_clock_6_in_reg_firsttransfer <= pc8001_sub_system_clock_6_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_6_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_6_in_beginbursttransfer_internal = pc8001_sub_system_clock_6_in_begins_xfer;

  //pc8001_sub_system_clock_6_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_6_in_read = nios2_data_master_granted_pc8001_sub_system_clock_6_in & nios2_data_master_read;

  //pc8001_sub_system_clock_6_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_6_in_write = nios2_data_master_granted_pc8001_sub_system_clock_6_in & nios2_data_master_write;

  //pc8001_sub_system_clock_6_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_6_in_address = nios2_data_master_address_to_slave;

  //slaveid pc8001_sub_system_clock_6_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_6_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_6_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_6_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_6_in_end_xfer <= pc8001_sub_system_clock_6_in_end_xfer;
    end


  //pc8001_sub_system_clock_6_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_6_in_waits_for_read = pc8001_sub_system_clock_6_in_in_a_read_cycle & pc8001_sub_system_clock_6_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_6_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_6_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_6_in_in_a_read_cycle;

  //pc8001_sub_system_clock_6_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_6_in_waits_for_write = pc8001_sub_system_clock_6_in_in_a_write_cycle & pc8001_sub_system_clock_6_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_6_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_6_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_6_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_6_in_counter = 0;
  //pc8001_sub_system_clock_6_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_6_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_6_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_6/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_6_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   d1_mmc_spi_avalon_slave_0_end_xfer,
                                                   mmc_spi_avalon_slave_0_readdata_from_sa,
                                                   pc8001_sub_system_clock_6_out_address,
                                                   pc8001_sub_system_clock_6_out_byteenable,
                                                   pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0,
                                                   pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0,
                                                   pc8001_sub_system_clock_6_out_read,
                                                   pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0,
                                                   pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0,
                                                   pc8001_sub_system_clock_6_out_write,
                                                   pc8001_sub_system_clock_6_out_writedata,
                                                   reset_n,

                                                  // outputs:
                                                   pc8001_sub_system_clock_6_out_address_to_slave,
                                                   pc8001_sub_system_clock_6_out_readdata,
                                                   pc8001_sub_system_clock_6_out_reset_n,
                                                   pc8001_sub_system_clock_6_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_6_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_6_out_readdata;
  output           pc8001_sub_system_clock_6_out_reset_n;
  output           pc8001_sub_system_clock_6_out_waitrequest;
  input            clk;
  input            d1_mmc_spi_avalon_slave_0_end_xfer;
  input   [ 31: 0] mmc_spi_avalon_slave_0_readdata_from_sa;
  input   [  3: 0] pc8001_sub_system_clock_6_out_address;
  input   [  3: 0] pc8001_sub_system_clock_6_out_byteenable;
  input            pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0;
  input            pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0;
  input            pc8001_sub_system_clock_6_out_read;
  input            pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0;
  input            pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;
  input            pc8001_sub_system_clock_6_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_6_out_writedata;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_6_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_6_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_6_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_6_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_6_out_readdata;
  wire             pc8001_sub_system_clock_6_out_reset_n;
  wire             pc8001_sub_system_clock_6_out_run;
  wire             pc8001_sub_system_clock_6_out_waitrequest;
  reg              pc8001_sub_system_clock_6_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_6_out_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0 | ~pc8001_sub_system_clock_6_out_read | (1 & ~d1_mmc_spi_avalon_slave_0_end_xfer & pc8001_sub_system_clock_6_out_read))) & ((~pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0 | ~pc8001_sub_system_clock_6_out_write | (1 & pc8001_sub_system_clock_6_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_6_out_address_to_slave = pc8001_sub_system_clock_6_out_address;

  //pc8001_sub_system_clock_6/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_6_out_readdata = mmc_spi_avalon_slave_0_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_6_out_waitrequest = ~pc8001_sub_system_clock_6_out_run;

  //pc8001_sub_system_clock_6_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_6_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_6_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_6_out_address_last_time <= pc8001_sub_system_clock_6_out_address;
    end


  //pc8001_sub_system_clock_6/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_6_out_waitrequest & (pc8001_sub_system_clock_6_out_read | pc8001_sub_system_clock_6_out_write);
    end


  //pc8001_sub_system_clock_6_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_6_out_address != pc8001_sub_system_clock_6_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_6_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_6_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_6_out_byteenable_last_time <= pc8001_sub_system_clock_6_out_byteenable;
    end


  //pc8001_sub_system_clock_6_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_6_out_byteenable != pc8001_sub_system_clock_6_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_6_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_6_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_6_out_read_last_time <= pc8001_sub_system_clock_6_out_read;
    end


  //pc8001_sub_system_clock_6_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_6_out_read != pc8001_sub_system_clock_6_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_6_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_6_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_6_out_write_last_time <= pc8001_sub_system_clock_6_out_write;
    end


  //pc8001_sub_system_clock_6_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_6_out_write != pc8001_sub_system_clock_6_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_6_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_6_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_6_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_6_out_writedata_last_time <= pc8001_sub_system_clock_6_out_writedata;
    end


  //pc8001_sub_system_clock_6_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_6_out_writedata != pc8001_sub_system_clock_6_out_writedata_last_time) & pc8001_sub_system_clock_6_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_6_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_7_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  nios2_data_master_writedata,
                                                  pc8001_sub_system_clock_7_in_endofpacket,
                                                  pc8001_sub_system_clock_7_in_readdata,
                                                  pc8001_sub_system_clock_7_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_7_in_end_xfer,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_7_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_7_in,
                                                  pc8001_sub_system_clock_7_in_address,
                                                  pc8001_sub_system_clock_7_in_byteenable,
                                                  pc8001_sub_system_clock_7_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_7_in_nativeaddress,
                                                  pc8001_sub_system_clock_7_in_read,
                                                  pc8001_sub_system_clock_7_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_7_in_reset_n,
                                                  pc8001_sub_system_clock_7_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_7_in_write,
                                                  pc8001_sub_system_clock_7_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_7_in_end_xfer;
  output           nios2_data_master_granted_pc8001_sub_system_clock_7_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_7_in;
  output  [  3: 0] pc8001_sub_system_clock_7_in_address;
  output  [  3: 0] pc8001_sub_system_clock_7_in_byteenable;
  output           pc8001_sub_system_clock_7_in_endofpacket_from_sa;
  output  [  1: 0] pc8001_sub_system_clock_7_in_nativeaddress;
  output           pc8001_sub_system_clock_7_in_read;
  output  [ 31: 0] pc8001_sub_system_clock_7_in_readdata_from_sa;
  output           pc8001_sub_system_clock_7_in_reset_n;
  output           pc8001_sub_system_clock_7_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_7_in_write;
  output  [ 31: 0] pc8001_sub_system_clock_7_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input   [ 31: 0] nios2_data_master_writedata;
  input            pc8001_sub_system_clock_7_in_endofpacket;
  input   [ 31: 0] pc8001_sub_system_clock_7_in_readdata;
  input            pc8001_sub_system_clock_7_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_7_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_7_in;
  wire    [  3: 0] pc8001_sub_system_clock_7_in_address;
  wire             pc8001_sub_system_clock_7_in_allgrants;
  wire             pc8001_sub_system_clock_7_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_7_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_7_in_any_continuerequest;
  wire             pc8001_sub_system_clock_7_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_7_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_7_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_7_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_7_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_7_in_begins_xfer;
  wire    [  3: 0] pc8001_sub_system_clock_7_in_byteenable;
  wire             pc8001_sub_system_clock_7_in_end_xfer;
  wire             pc8001_sub_system_clock_7_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_7_in_firsttransfer;
  wire             pc8001_sub_system_clock_7_in_grant_vector;
  wire             pc8001_sub_system_clock_7_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_7_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_7_in_master_qreq_vector;
  wire    [  1: 0] pc8001_sub_system_clock_7_in_nativeaddress;
  wire             pc8001_sub_system_clock_7_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_7_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_7_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_7_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_7_in_reset_n;
  reg              pc8001_sub_system_clock_7_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_7_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_7_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_7_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_7_in_waits_for_read;
  wire             pc8001_sub_system_clock_7_in_waits_for_write;
  wire             pc8001_sub_system_clock_7_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_7_in_writedata;
  wire             wait_for_pc8001_sub_system_clock_7_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_7_in_end_xfer;
    end


  assign pc8001_sub_system_clock_7_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in));
  //assign pc8001_sub_system_clock_7_in_readdata_from_sa = pc8001_sub_system_clock_7_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_7_in_readdata_from_sa = pc8001_sub_system_clock_7_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_7_in = ({nios2_data_master_address_to_slave[25 : 4] , 4'b0} == 26'ha0) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_7_in_waitrequest_from_sa = pc8001_sub_system_clock_7_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_7_in_waitrequest_from_sa = pc8001_sub_system_clock_7_in_waitrequest;

  //pc8001_sub_system_clock_7_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_7_in_arb_share_set_values = 1;

  //pc8001_sub_system_clock_7_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_7_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_7_in;

  //pc8001_sub_system_clock_7_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_7_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_7_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_in_arb_share_counter_next_value = pc8001_sub_system_clock_7_in_firsttransfer ? (pc8001_sub_system_clock_7_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_7_in_arb_share_counter ? (pc8001_sub_system_clock_7_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_7_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_7_in_allgrants = |pc8001_sub_system_clock_7_in_grant_vector;

  //pc8001_sub_system_clock_7_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_in_end_xfer = ~(pc8001_sub_system_clock_7_in_waits_for_read | pc8001_sub_system_clock_7_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in = pc8001_sub_system_clock_7_in_end_xfer & (~pc8001_sub_system_clock_7_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_7_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_7_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in & pc8001_sub_system_clock_7_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in & ~pc8001_sub_system_clock_7_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_7_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_7_in_arb_counter_enable)
          pc8001_sub_system_clock_7_in_arb_share_counter <= pc8001_sub_system_clock_7_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_7_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_7_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_7_in & ~pc8001_sub_system_clock_7_in_non_bursting_master_requests))
          pc8001_sub_system_clock_7_in_slavearbiterlockenable <= |pc8001_sub_system_clock_7_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_7/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_7_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_7_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_7_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_7_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_7/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_7_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_7_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_7_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in = nios2_data_master_requests_pc8001_sub_system_clock_7_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest) & nios2_data_master_write));
  //pc8001_sub_system_clock_7_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_7_in_writedata = nios2_data_master_writedata;

  //assign pc8001_sub_system_clock_7_in_endofpacket_from_sa = pc8001_sub_system_clock_7_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_7_in_endofpacket_from_sa = pc8001_sub_system_clock_7_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_7_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_7/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_7_in = nios2_data_master_requests_pc8001_sub_system_clock_7_in;

  //allow new arb cycle for pc8001_sub_system_clock_7/in, which is an e_assign
  assign pc8001_sub_system_clock_7_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_7_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_7_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_7_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_in_reset_n = reset_n;

  //pc8001_sub_system_clock_7_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_7_in_firsttransfer = pc8001_sub_system_clock_7_in_begins_xfer ? pc8001_sub_system_clock_7_in_unreg_firsttransfer : pc8001_sub_system_clock_7_in_reg_firsttransfer;

  //pc8001_sub_system_clock_7_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_7_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_7_in_slavearbiterlockenable & pc8001_sub_system_clock_7_in_any_continuerequest);

  //pc8001_sub_system_clock_7_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_7_in_begins_xfer)
          pc8001_sub_system_clock_7_in_reg_firsttransfer <= pc8001_sub_system_clock_7_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_7_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_7_in_beginbursttransfer_internal = pc8001_sub_system_clock_7_in_begins_xfer;

  //pc8001_sub_system_clock_7_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_7_in_read = nios2_data_master_granted_pc8001_sub_system_clock_7_in & nios2_data_master_read;

  //pc8001_sub_system_clock_7_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_7_in_write = nios2_data_master_granted_pc8001_sub_system_clock_7_in & nios2_data_master_write;

  //pc8001_sub_system_clock_7_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_7_in_address = nios2_data_master_address_to_slave;

  //slaveid pc8001_sub_system_clock_7_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_7_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_7_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_7_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_7_in_end_xfer <= pc8001_sub_system_clock_7_in_end_xfer;
    end


  //pc8001_sub_system_clock_7_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_7_in_waits_for_read = pc8001_sub_system_clock_7_in_in_a_read_cycle & pc8001_sub_system_clock_7_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_7_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_7_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_7_in_in_a_read_cycle;

  //pc8001_sub_system_clock_7_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_7_in_waits_for_write = pc8001_sub_system_clock_7_in_in_a_write_cycle & pc8001_sub_system_clock_7_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_7_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_7_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_7_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_7_in_counter = 0;
  //pc8001_sub_system_clock_7_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_7_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_7_in)? nios2_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_7/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_7_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   d1_sub_system_pll_pll_slave_end_xfer,
                                                   pc8001_sub_system_clock_7_out_address,
                                                   pc8001_sub_system_clock_7_out_byteenable,
                                                   pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave,
                                                   pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave,
                                                   pc8001_sub_system_clock_7_out_read,
                                                   pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave,
                                                   pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave,
                                                   pc8001_sub_system_clock_7_out_write,
                                                   pc8001_sub_system_clock_7_out_writedata,
                                                   reset_n,
                                                   sub_system_pll_pll_slave_readdata_from_sa,

                                                  // outputs:
                                                   pc8001_sub_system_clock_7_out_address_to_slave,
                                                   pc8001_sub_system_clock_7_out_readdata,
                                                   pc8001_sub_system_clock_7_out_reset_n,
                                                   pc8001_sub_system_clock_7_out_waitrequest
                                                )
;

  output  [  3: 0] pc8001_sub_system_clock_7_out_address_to_slave;
  output  [ 31: 0] pc8001_sub_system_clock_7_out_readdata;
  output           pc8001_sub_system_clock_7_out_reset_n;
  output           pc8001_sub_system_clock_7_out_waitrequest;
  input            clk;
  input            d1_sub_system_pll_pll_slave_end_xfer;
  input   [  3: 0] pc8001_sub_system_clock_7_out_address;
  input   [  3: 0] pc8001_sub_system_clock_7_out_byteenable;
  input            pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave;
  input            pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave;
  input            pc8001_sub_system_clock_7_out_read;
  input            pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave;
  input            pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;
  input            pc8001_sub_system_clock_7_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_7_out_writedata;
  input            reset_n;
  input   [ 31: 0] sub_system_pll_pll_slave_readdata_from_sa;

  reg              active_and_waiting_last_time;
  reg     [  3: 0] pc8001_sub_system_clock_7_out_address_last_time;
  wire    [  3: 0] pc8001_sub_system_clock_7_out_address_to_slave;
  reg     [  3: 0] pc8001_sub_system_clock_7_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_7_out_read_last_time;
  wire    [ 31: 0] pc8001_sub_system_clock_7_out_readdata;
  wire             pc8001_sub_system_clock_7_out_reset_n;
  wire             pc8001_sub_system_clock_7_out_run;
  wire             pc8001_sub_system_clock_7_out_waitrequest;
  reg              pc8001_sub_system_clock_7_out_write_last_time;
  reg     [ 31: 0] pc8001_sub_system_clock_7_out_writedata_last_time;
  wire             r_2;
  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & ((~pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave | ~(pc8001_sub_system_clock_7_out_read | pc8001_sub_system_clock_7_out_write) | (1 & (pc8001_sub_system_clock_7_out_read | pc8001_sub_system_clock_7_out_write)))) & ((~pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave | ~(pc8001_sub_system_clock_7_out_read | pc8001_sub_system_clock_7_out_write) | (1 & (pc8001_sub_system_clock_7_out_read | pc8001_sub_system_clock_7_out_write))));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_out_run = r_2;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_7_out_address_to_slave = pc8001_sub_system_clock_7_out_address;

  //pc8001_sub_system_clock_7/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_7_out_readdata = sub_system_pll_pll_slave_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_7_out_waitrequest = ~pc8001_sub_system_clock_7_out_run;

  //pc8001_sub_system_clock_7_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_7_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_7_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_7_out_address_last_time <= pc8001_sub_system_clock_7_out_address;
    end


  //pc8001_sub_system_clock_7/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_7_out_waitrequest & (pc8001_sub_system_clock_7_out_read | pc8001_sub_system_clock_7_out_write);
    end


  //pc8001_sub_system_clock_7_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_7_out_address != pc8001_sub_system_clock_7_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_7_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_7_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_7_out_byteenable_last_time <= pc8001_sub_system_clock_7_out_byteenable;
    end


  //pc8001_sub_system_clock_7_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_7_out_byteenable != pc8001_sub_system_clock_7_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_7_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_7_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_7_out_read_last_time <= pc8001_sub_system_clock_7_out_read;
    end


  //pc8001_sub_system_clock_7_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_7_out_read != pc8001_sub_system_clock_7_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_7_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_7_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_7_out_write_last_time <= pc8001_sub_system_clock_7_out_write;
    end


  //pc8001_sub_system_clock_7_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_7_out_write != pc8001_sub_system_clock_7_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_7_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_7_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_7_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_7_out_writedata_last_time <= pc8001_sub_system_clock_7_out_writedata;
    end


  //pc8001_sub_system_clock_7_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_7_out_writedata != pc8001_sub_system_clock_7_out_writedata_last_time) & pc8001_sub_system_clock_7_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_7_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_8_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_instruction_master_address_to_slave,
                                                  nios2_instruction_master_dbs_address,
                                                  nios2_instruction_master_read,
                                                  pc8001_sub_system_clock_8_in_endofpacket,
                                                  pc8001_sub_system_clock_8_in_readdata,
                                                  pc8001_sub_system_clock_8_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_8_in_end_xfer,
                                                  nios2_instruction_master_granted_pc8001_sub_system_clock_8_in,
                                                  nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in,
                                                  nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in,
                                                  nios2_instruction_master_requests_pc8001_sub_system_clock_8_in,
                                                  pc8001_sub_system_clock_8_in_address,
                                                  pc8001_sub_system_clock_8_in_byteenable,
                                                  pc8001_sub_system_clock_8_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_8_in_nativeaddress,
                                                  pc8001_sub_system_clock_8_in_read,
                                                  pc8001_sub_system_clock_8_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_8_in_reset_n,
                                                  pc8001_sub_system_clock_8_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_8_in_write
                                               )
;

  output           d1_pc8001_sub_system_clock_8_in_end_xfer;
  output           nios2_instruction_master_granted_pc8001_sub_system_clock_8_in;
  output           nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in;
  output           nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in;
  output           nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;
  output  [ 22: 0] pc8001_sub_system_clock_8_in_address;
  output  [  1: 0] pc8001_sub_system_clock_8_in_byteenable;
  output           pc8001_sub_system_clock_8_in_endofpacket_from_sa;
  output  [ 21: 0] pc8001_sub_system_clock_8_in_nativeaddress;
  output           pc8001_sub_system_clock_8_in_read;
  output  [ 15: 0] pc8001_sub_system_clock_8_in_readdata_from_sa;
  output           pc8001_sub_system_clock_8_in_reset_n;
  output           pc8001_sub_system_clock_8_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_8_in_write;
  input            clk;
  input   [ 25: 0] nios2_instruction_master_address_to_slave;
  input   [  1: 0] nios2_instruction_master_dbs_address;
  input            nios2_instruction_master_read;
  input            pc8001_sub_system_clock_8_in_endofpacket;
  input   [ 15: 0] pc8001_sub_system_clock_8_in_readdata;
  input            pc8001_sub_system_clock_8_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_8_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_instruction_master_arbiterlock;
  wire             nios2_instruction_master_arbiterlock2;
  wire             nios2_instruction_master_continuerequest;
  wire             nios2_instruction_master_granted_pc8001_sub_system_clock_8_in;
  wire             nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in;
  wire             nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in;
  wire             nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;
  wire             nios2_instruction_master_saved_grant_pc8001_sub_system_clock_8_in;
  wire    [ 22: 0] pc8001_sub_system_clock_8_in_address;
  wire             pc8001_sub_system_clock_8_in_allgrants;
  wire             pc8001_sub_system_clock_8_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_8_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_8_in_any_continuerequest;
  wire             pc8001_sub_system_clock_8_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_8_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_8_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_8_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_8_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_8_in_begins_xfer;
  wire    [  1: 0] pc8001_sub_system_clock_8_in_byteenable;
  wire             pc8001_sub_system_clock_8_in_end_xfer;
  wire             pc8001_sub_system_clock_8_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_8_in_firsttransfer;
  wire             pc8001_sub_system_clock_8_in_grant_vector;
  wire             pc8001_sub_system_clock_8_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_8_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_8_in_master_qreq_vector;
  wire    [ 21: 0] pc8001_sub_system_clock_8_in_nativeaddress;
  wire             pc8001_sub_system_clock_8_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_8_in_read;
  wire    [ 15: 0] pc8001_sub_system_clock_8_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_8_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_8_in_reset_n;
  reg              pc8001_sub_system_clock_8_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_8_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_8_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_8_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_8_in_waits_for_read;
  wire             pc8001_sub_system_clock_8_in_waits_for_write;
  wire             pc8001_sub_system_clock_8_in_write;
  wire             wait_for_pc8001_sub_system_clock_8_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_8_in_end_xfer;
    end


  assign pc8001_sub_system_clock_8_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in));
  //assign pc8001_sub_system_clock_8_in_readdata_from_sa = pc8001_sub_system_clock_8_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_8_in_readdata_from_sa = pc8001_sub_system_clock_8_in_readdata;

  assign nios2_instruction_master_requests_pc8001_sub_system_clock_8_in = (({nios2_instruction_master_address_to_slave[25 : 23] , 23'b0} == 26'h2000000) & (nios2_instruction_master_read)) & nios2_instruction_master_read;
  //assign pc8001_sub_system_clock_8_in_waitrequest_from_sa = pc8001_sub_system_clock_8_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_8_in_waitrequest_from_sa = pc8001_sub_system_clock_8_in_waitrequest;

  //pc8001_sub_system_clock_8_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_8_in_arb_share_set_values = (nios2_instruction_master_granted_pc8001_sub_system_clock_8_in)? 2 :
    1;

  //pc8001_sub_system_clock_8_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_8_in_non_bursting_master_requests = nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;

  //pc8001_sub_system_clock_8_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_8_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_8_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_in_arb_share_counter_next_value = pc8001_sub_system_clock_8_in_firsttransfer ? (pc8001_sub_system_clock_8_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_8_in_arb_share_counter ? (pc8001_sub_system_clock_8_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_8_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_8_in_allgrants = |pc8001_sub_system_clock_8_in_grant_vector;

  //pc8001_sub_system_clock_8_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_in_end_xfer = ~(pc8001_sub_system_clock_8_in_waits_for_read | pc8001_sub_system_clock_8_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in = pc8001_sub_system_clock_8_in_end_xfer & (~pc8001_sub_system_clock_8_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_8_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_8_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in & pc8001_sub_system_clock_8_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in & ~pc8001_sub_system_clock_8_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_8_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_8_in_arb_counter_enable)
          pc8001_sub_system_clock_8_in_arb_share_counter <= pc8001_sub_system_clock_8_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_8_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_8_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_8_in & ~pc8001_sub_system_clock_8_in_non_bursting_master_requests))
          pc8001_sub_system_clock_8_in_slavearbiterlockenable <= |pc8001_sub_system_clock_8_in_arb_share_counter_next_value;
    end


  //nios2/instruction_master pc8001_sub_system_clock_8/in arbiterlock, which is an e_assign
  assign nios2_instruction_master_arbiterlock = pc8001_sub_system_clock_8_in_slavearbiterlockenable & nios2_instruction_master_continuerequest;

  //pc8001_sub_system_clock_8_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_8_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_8_in_arb_share_counter_next_value;

  //nios2/instruction_master pc8001_sub_system_clock_8/in arbiterlock2, which is an e_assign
  assign nios2_instruction_master_arbiterlock2 = pc8001_sub_system_clock_8_in_slavearbiterlockenable2 & nios2_instruction_master_continuerequest;

  //pc8001_sub_system_clock_8_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_8_in_any_continuerequest = 1;

  //nios2_instruction_master_continuerequest continued request, which is an e_assign
  assign nios2_instruction_master_continuerequest = 1;

  assign nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in = nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;
  //assign pc8001_sub_system_clock_8_in_endofpacket_from_sa = pc8001_sub_system_clock_8_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_8_in_endofpacket_from_sa = pc8001_sub_system_clock_8_in_endofpacket;

  //master is always granted when requested
  assign nios2_instruction_master_granted_pc8001_sub_system_clock_8_in = nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in;

  //nios2/instruction_master saved-grant pc8001_sub_system_clock_8/in, which is an e_assign
  assign nios2_instruction_master_saved_grant_pc8001_sub_system_clock_8_in = nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;

  //allow new arb cycle for pc8001_sub_system_clock_8/in, which is an e_assign
  assign pc8001_sub_system_clock_8_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_8_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_8_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_8_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_in_reset_n = reset_n;

  //pc8001_sub_system_clock_8_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_8_in_firsttransfer = pc8001_sub_system_clock_8_in_begins_xfer ? pc8001_sub_system_clock_8_in_unreg_firsttransfer : pc8001_sub_system_clock_8_in_reg_firsttransfer;

  //pc8001_sub_system_clock_8_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_8_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_8_in_slavearbiterlockenable & pc8001_sub_system_clock_8_in_any_continuerequest);

  //pc8001_sub_system_clock_8_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_8_in_begins_xfer)
          pc8001_sub_system_clock_8_in_reg_firsttransfer <= pc8001_sub_system_clock_8_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_8_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_8_in_beginbursttransfer_internal = pc8001_sub_system_clock_8_in_begins_xfer;

  //pc8001_sub_system_clock_8_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_8_in_read = nios2_instruction_master_granted_pc8001_sub_system_clock_8_in & nios2_instruction_master_read;

  //pc8001_sub_system_clock_8_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_8_in_write = 0;

  //pc8001_sub_system_clock_8_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_8_in_address = {nios2_instruction_master_address_to_slave >> 2,
    nios2_instruction_master_dbs_address[1],
    {1 {1'b0}}};

  //slaveid pc8001_sub_system_clock_8_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_8_in_nativeaddress = nios2_instruction_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_8_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_8_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_8_in_end_xfer <= pc8001_sub_system_clock_8_in_end_xfer;
    end


  //pc8001_sub_system_clock_8_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_8_in_waits_for_read = pc8001_sub_system_clock_8_in_in_a_read_cycle & pc8001_sub_system_clock_8_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_8_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_in_in_a_read_cycle = nios2_instruction_master_granted_pc8001_sub_system_clock_8_in & nios2_instruction_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_8_in_in_a_read_cycle;

  //pc8001_sub_system_clock_8_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_8_in_waits_for_write = pc8001_sub_system_clock_8_in_in_a_write_cycle & pc8001_sub_system_clock_8_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_8_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_in_in_a_write_cycle = 0;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_8_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_8_in_counter = 0;
  //pc8001_sub_system_clock_8_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_8_in_byteenable = -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_8/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_8_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   d1_sdram_s1_end_xfer,
                                                   pc8001_sub_system_clock_8_out_address,
                                                   pc8001_sub_system_clock_8_out_byteenable,
                                                   pc8001_sub_system_clock_8_out_granted_sdram_s1,
                                                   pc8001_sub_system_clock_8_out_qualified_request_sdram_s1,
                                                   pc8001_sub_system_clock_8_out_read,
                                                   pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1,
                                                   pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register,
                                                   pc8001_sub_system_clock_8_out_requests_sdram_s1,
                                                   pc8001_sub_system_clock_8_out_write,
                                                   pc8001_sub_system_clock_8_out_writedata,
                                                   reset_n,
                                                   sdram_s1_readdata_from_sa,
                                                   sdram_s1_waitrequest_from_sa,

                                                  // outputs:
                                                   pc8001_sub_system_clock_8_out_address_to_slave,
                                                   pc8001_sub_system_clock_8_out_readdata,
                                                   pc8001_sub_system_clock_8_out_reset_n,
                                                   pc8001_sub_system_clock_8_out_waitrequest
                                                )
;

  output  [ 22: 0] pc8001_sub_system_clock_8_out_address_to_slave;
  output  [ 15: 0] pc8001_sub_system_clock_8_out_readdata;
  output           pc8001_sub_system_clock_8_out_reset_n;
  output           pc8001_sub_system_clock_8_out_waitrequest;
  input            clk;
  input            d1_sdram_s1_end_xfer;
  input   [ 22: 0] pc8001_sub_system_clock_8_out_address;
  input   [  1: 0] pc8001_sub_system_clock_8_out_byteenable;
  input            pc8001_sub_system_clock_8_out_granted_sdram_s1;
  input            pc8001_sub_system_clock_8_out_qualified_request_sdram_s1;
  input            pc8001_sub_system_clock_8_out_read;
  input            pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1;
  input            pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register;
  input            pc8001_sub_system_clock_8_out_requests_sdram_s1;
  input            pc8001_sub_system_clock_8_out_write;
  input   [ 15: 0] pc8001_sub_system_clock_8_out_writedata;
  input            reset_n;
  input   [ 15: 0] sdram_s1_readdata_from_sa;
  input            sdram_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 22: 0] pc8001_sub_system_clock_8_out_address_last_time;
  wire    [ 22: 0] pc8001_sub_system_clock_8_out_address_to_slave;
  reg     [  1: 0] pc8001_sub_system_clock_8_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_8_out_read_last_time;
  wire    [ 15: 0] pc8001_sub_system_clock_8_out_readdata;
  wire             pc8001_sub_system_clock_8_out_reset_n;
  wire             pc8001_sub_system_clock_8_out_run;
  wire             pc8001_sub_system_clock_8_out_waitrequest;
  reg              pc8001_sub_system_clock_8_out_write_last_time;
  reg     [ 15: 0] pc8001_sub_system_clock_8_out_writedata_last_time;
  wire             r_2;
  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (pc8001_sub_system_clock_8_out_qualified_request_sdram_s1 | pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1 | ~pc8001_sub_system_clock_8_out_requests_sdram_s1) & (pc8001_sub_system_clock_8_out_granted_sdram_s1 | ~pc8001_sub_system_clock_8_out_qualified_request_sdram_s1) & ((~pc8001_sub_system_clock_8_out_qualified_request_sdram_s1 | ~pc8001_sub_system_clock_8_out_read | (pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1 & pc8001_sub_system_clock_8_out_read))) & ((~pc8001_sub_system_clock_8_out_qualified_request_sdram_s1 | ~(pc8001_sub_system_clock_8_out_read | pc8001_sub_system_clock_8_out_write) | (1 & ~sdram_s1_waitrequest_from_sa & (pc8001_sub_system_clock_8_out_read | pc8001_sub_system_clock_8_out_write))));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_out_run = r_2;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_8_out_address_to_slave = pc8001_sub_system_clock_8_out_address;

  //pc8001_sub_system_clock_8/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_8_out_readdata = sdram_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_8_out_waitrequest = ~pc8001_sub_system_clock_8_out_run;

  //pc8001_sub_system_clock_8_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_8_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_8_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_8_out_address_last_time <= pc8001_sub_system_clock_8_out_address;
    end


  //pc8001_sub_system_clock_8/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_8_out_waitrequest & (pc8001_sub_system_clock_8_out_read | pc8001_sub_system_clock_8_out_write);
    end


  //pc8001_sub_system_clock_8_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_8_out_address != pc8001_sub_system_clock_8_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_8_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_8_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_8_out_byteenable_last_time <= pc8001_sub_system_clock_8_out_byteenable;
    end


  //pc8001_sub_system_clock_8_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_8_out_byteenable != pc8001_sub_system_clock_8_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_8_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_8_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_8_out_read_last_time <= pc8001_sub_system_clock_8_out_read;
    end


  //pc8001_sub_system_clock_8_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_8_out_read != pc8001_sub_system_clock_8_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_8_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_8_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_8_out_write_last_time <= pc8001_sub_system_clock_8_out_write;
    end


  //pc8001_sub_system_clock_8_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_8_out_write != pc8001_sub_system_clock_8_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_8_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_8_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_8_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_8_out_writedata_last_time <= pc8001_sub_system_clock_8_out_writedata;
    end


  //pc8001_sub_system_clock_8_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_8_out_writedata != pc8001_sub_system_clock_8_out_writedata_last_time) & pc8001_sub_system_clock_8_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_8_out_writedata did not heed wait!!!", $time);
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

module pc8001_sub_system_clock_9_in_arbitrator (
                                                 // inputs:
                                                  clk,
                                                  nios2_data_master_address_to_slave,
                                                  nios2_data_master_byteenable,
                                                  nios2_data_master_dbs_address,
                                                  nios2_data_master_dbs_write_16,
                                                  nios2_data_master_no_byte_enables_and_last_term,
                                                  nios2_data_master_read,
                                                  nios2_data_master_waitrequest,
                                                  nios2_data_master_write,
                                                  pc8001_sub_system_clock_9_in_endofpacket,
                                                  pc8001_sub_system_clock_9_in_readdata,
                                                  pc8001_sub_system_clock_9_in_waitrequest,
                                                  reset_n,

                                                 // outputs:
                                                  d1_pc8001_sub_system_clock_9_in_end_xfer,
                                                  nios2_data_master_byteenable_pc8001_sub_system_clock_9_in,
                                                  nios2_data_master_granted_pc8001_sub_system_clock_9_in,
                                                  nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in,
                                                  nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in,
                                                  nios2_data_master_requests_pc8001_sub_system_clock_9_in,
                                                  pc8001_sub_system_clock_9_in_address,
                                                  pc8001_sub_system_clock_9_in_byteenable,
                                                  pc8001_sub_system_clock_9_in_endofpacket_from_sa,
                                                  pc8001_sub_system_clock_9_in_nativeaddress,
                                                  pc8001_sub_system_clock_9_in_read,
                                                  pc8001_sub_system_clock_9_in_readdata_from_sa,
                                                  pc8001_sub_system_clock_9_in_reset_n,
                                                  pc8001_sub_system_clock_9_in_waitrequest_from_sa,
                                                  pc8001_sub_system_clock_9_in_write,
                                                  pc8001_sub_system_clock_9_in_writedata
                                               )
;

  output           d1_pc8001_sub_system_clock_9_in_end_xfer;
  output  [  1: 0] nios2_data_master_byteenable_pc8001_sub_system_clock_9_in;
  output           nios2_data_master_granted_pc8001_sub_system_clock_9_in;
  output           nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in;
  output           nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in;
  output           nios2_data_master_requests_pc8001_sub_system_clock_9_in;
  output  [ 22: 0] pc8001_sub_system_clock_9_in_address;
  output  [  1: 0] pc8001_sub_system_clock_9_in_byteenable;
  output           pc8001_sub_system_clock_9_in_endofpacket_from_sa;
  output  [ 21: 0] pc8001_sub_system_clock_9_in_nativeaddress;
  output           pc8001_sub_system_clock_9_in_read;
  output  [ 15: 0] pc8001_sub_system_clock_9_in_readdata_from_sa;
  output           pc8001_sub_system_clock_9_in_reset_n;
  output           pc8001_sub_system_clock_9_in_waitrequest_from_sa;
  output           pc8001_sub_system_clock_9_in_write;
  output  [ 15: 0] pc8001_sub_system_clock_9_in_writedata;
  input            clk;
  input   [ 25: 0] nios2_data_master_address_to_slave;
  input   [  3: 0] nios2_data_master_byteenable;
  input   [  1: 0] nios2_data_master_dbs_address;
  input   [ 15: 0] nios2_data_master_dbs_write_16;
  input            nios2_data_master_no_byte_enables_and_last_term;
  input            nios2_data_master_read;
  input            nios2_data_master_waitrequest;
  input            nios2_data_master_write;
  input            pc8001_sub_system_clock_9_in_endofpacket;
  input   [ 15: 0] pc8001_sub_system_clock_9_in_readdata;
  input            pc8001_sub_system_clock_9_in_waitrequest;
  input            reset_n;

  reg              d1_pc8001_sub_system_clock_9_in_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios2_data_master_arbiterlock;
  wire             nios2_data_master_arbiterlock2;
  wire    [  1: 0] nios2_data_master_byteenable_pc8001_sub_system_clock_9_in;
  wire    [  1: 0] nios2_data_master_byteenable_pc8001_sub_system_clock_9_in_segment_0;
  wire    [  1: 0] nios2_data_master_byteenable_pc8001_sub_system_clock_9_in_segment_1;
  wire             nios2_data_master_continuerequest;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_saved_grant_pc8001_sub_system_clock_9_in;
  wire    [ 22: 0] pc8001_sub_system_clock_9_in_address;
  wire             pc8001_sub_system_clock_9_in_allgrants;
  wire             pc8001_sub_system_clock_9_in_allow_new_arb_cycle;
  wire             pc8001_sub_system_clock_9_in_any_bursting_master_saved_grant;
  wire             pc8001_sub_system_clock_9_in_any_continuerequest;
  wire             pc8001_sub_system_clock_9_in_arb_counter_enable;
  reg     [  1: 0] pc8001_sub_system_clock_9_in_arb_share_counter;
  wire    [  1: 0] pc8001_sub_system_clock_9_in_arb_share_counter_next_value;
  wire    [  1: 0] pc8001_sub_system_clock_9_in_arb_share_set_values;
  wire             pc8001_sub_system_clock_9_in_beginbursttransfer_internal;
  wire             pc8001_sub_system_clock_9_in_begins_xfer;
  wire    [  1: 0] pc8001_sub_system_clock_9_in_byteenable;
  wire             pc8001_sub_system_clock_9_in_end_xfer;
  wire             pc8001_sub_system_clock_9_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_9_in_firsttransfer;
  wire             pc8001_sub_system_clock_9_in_grant_vector;
  wire             pc8001_sub_system_clock_9_in_in_a_read_cycle;
  wire             pc8001_sub_system_clock_9_in_in_a_write_cycle;
  wire             pc8001_sub_system_clock_9_in_master_qreq_vector;
  wire    [ 21: 0] pc8001_sub_system_clock_9_in_nativeaddress;
  wire             pc8001_sub_system_clock_9_in_non_bursting_master_requests;
  wire             pc8001_sub_system_clock_9_in_read;
  wire    [ 15: 0] pc8001_sub_system_clock_9_in_readdata_from_sa;
  reg              pc8001_sub_system_clock_9_in_reg_firsttransfer;
  wire             pc8001_sub_system_clock_9_in_reset_n;
  reg              pc8001_sub_system_clock_9_in_slavearbiterlockenable;
  wire             pc8001_sub_system_clock_9_in_slavearbiterlockenable2;
  wire             pc8001_sub_system_clock_9_in_unreg_firsttransfer;
  wire             pc8001_sub_system_clock_9_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_9_in_waits_for_read;
  wire             pc8001_sub_system_clock_9_in_waits_for_write;
  wire             pc8001_sub_system_clock_9_in_write;
  wire    [ 15: 0] pc8001_sub_system_clock_9_in_writedata;
  wire             wait_for_pc8001_sub_system_clock_9_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pc8001_sub_system_clock_9_in_end_xfer;
    end


  assign pc8001_sub_system_clock_9_in_begins_xfer = ~d1_reasons_to_wait & ((nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in));
  //assign pc8001_sub_system_clock_9_in_readdata_from_sa = pc8001_sub_system_clock_9_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_9_in_readdata_from_sa = pc8001_sub_system_clock_9_in_readdata;

  assign nios2_data_master_requests_pc8001_sub_system_clock_9_in = ({nios2_data_master_address_to_slave[25 : 23] , 23'b0} == 26'h2000000) & (nios2_data_master_read | nios2_data_master_write);
  //assign pc8001_sub_system_clock_9_in_waitrequest_from_sa = pc8001_sub_system_clock_9_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_9_in_waitrequest_from_sa = pc8001_sub_system_clock_9_in_waitrequest;

  //pc8001_sub_system_clock_9_in_arb_share_counter set values, which is an e_mux
  assign pc8001_sub_system_clock_9_in_arb_share_set_values = (nios2_data_master_granted_pc8001_sub_system_clock_9_in)? 2 :
    1;

  //pc8001_sub_system_clock_9_in_non_bursting_master_requests mux, which is an e_mux
  assign pc8001_sub_system_clock_9_in_non_bursting_master_requests = nios2_data_master_requests_pc8001_sub_system_clock_9_in;

  //pc8001_sub_system_clock_9_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign pc8001_sub_system_clock_9_in_any_bursting_master_saved_grant = 0;

  //pc8001_sub_system_clock_9_in_arb_share_counter_next_value assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_in_arb_share_counter_next_value = pc8001_sub_system_clock_9_in_firsttransfer ? (pc8001_sub_system_clock_9_in_arb_share_set_values - 1) : |pc8001_sub_system_clock_9_in_arb_share_counter ? (pc8001_sub_system_clock_9_in_arb_share_counter - 1) : 0;

  //pc8001_sub_system_clock_9_in_allgrants all slave grants, which is an e_mux
  assign pc8001_sub_system_clock_9_in_allgrants = |pc8001_sub_system_clock_9_in_grant_vector;

  //pc8001_sub_system_clock_9_in_end_xfer assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_in_end_xfer = ~(pc8001_sub_system_clock_9_in_waits_for_read | pc8001_sub_system_clock_9_in_waits_for_write);

  //end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in = pc8001_sub_system_clock_9_in_end_xfer & (~pc8001_sub_system_clock_9_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pc8001_sub_system_clock_9_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign pc8001_sub_system_clock_9_in_arb_counter_enable = (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in & pc8001_sub_system_clock_9_in_allgrants) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in & ~pc8001_sub_system_clock_9_in_non_bursting_master_requests);

  //pc8001_sub_system_clock_9_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_in_arb_share_counter <= 0;
      else if (pc8001_sub_system_clock_9_in_arb_counter_enable)
          pc8001_sub_system_clock_9_in_arb_share_counter <= pc8001_sub_system_clock_9_in_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_9_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_in_slavearbiterlockenable <= 0;
      else if ((|pc8001_sub_system_clock_9_in_master_qreq_vector & end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in) | (end_xfer_arb_share_counter_term_pc8001_sub_system_clock_9_in & ~pc8001_sub_system_clock_9_in_non_bursting_master_requests))
          pc8001_sub_system_clock_9_in_slavearbiterlockenable <= |pc8001_sub_system_clock_9_in_arb_share_counter_next_value;
    end


  //nios2/data_master pc8001_sub_system_clock_9/in arbiterlock, which is an e_assign
  assign nios2_data_master_arbiterlock = pc8001_sub_system_clock_9_in_slavearbiterlockenable & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_9_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_9_in_slavearbiterlockenable2 = |pc8001_sub_system_clock_9_in_arb_share_counter_next_value;

  //nios2/data_master pc8001_sub_system_clock_9/in arbiterlock2, which is an e_assign
  assign nios2_data_master_arbiterlock2 = pc8001_sub_system_clock_9_in_slavearbiterlockenable2 & nios2_data_master_continuerequest;

  //pc8001_sub_system_clock_9_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pc8001_sub_system_clock_9_in_any_continuerequest = 1;

  //nios2_data_master_continuerequest continued request, which is an e_assign
  assign nios2_data_master_continuerequest = 1;

  assign nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in = nios2_data_master_requests_pc8001_sub_system_clock_9_in & ~((nios2_data_master_read & (~nios2_data_master_waitrequest)) | ((~nios2_data_master_waitrequest | nios2_data_master_no_byte_enables_and_last_term | !nios2_data_master_byteenable_pc8001_sub_system_clock_9_in) & nios2_data_master_write));
  //pc8001_sub_system_clock_9_in_writedata mux, which is an e_mux
  assign pc8001_sub_system_clock_9_in_writedata = nios2_data_master_dbs_write_16;

  //assign pc8001_sub_system_clock_9_in_endofpacket_from_sa = pc8001_sub_system_clock_9_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pc8001_sub_system_clock_9_in_endofpacket_from_sa = pc8001_sub_system_clock_9_in_endofpacket;

  //master is always granted when requested
  assign nios2_data_master_granted_pc8001_sub_system_clock_9_in = nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in;

  //nios2/data_master saved-grant pc8001_sub_system_clock_9/in, which is an e_assign
  assign nios2_data_master_saved_grant_pc8001_sub_system_clock_9_in = nios2_data_master_requests_pc8001_sub_system_clock_9_in;

  //allow new arb cycle for pc8001_sub_system_clock_9/in, which is an e_assign
  assign pc8001_sub_system_clock_9_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pc8001_sub_system_clock_9_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pc8001_sub_system_clock_9_in_master_qreq_vector = 1;

  //pc8001_sub_system_clock_9_in_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_in_reset_n = reset_n;

  //pc8001_sub_system_clock_9_in_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_9_in_firsttransfer = pc8001_sub_system_clock_9_in_begins_xfer ? pc8001_sub_system_clock_9_in_unreg_firsttransfer : pc8001_sub_system_clock_9_in_reg_firsttransfer;

  //pc8001_sub_system_clock_9_in_unreg_firsttransfer first transaction, which is an e_assign
  assign pc8001_sub_system_clock_9_in_unreg_firsttransfer = ~(pc8001_sub_system_clock_9_in_slavearbiterlockenable & pc8001_sub_system_clock_9_in_any_continuerequest);

  //pc8001_sub_system_clock_9_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_in_reg_firsttransfer <= 1'b1;
      else if (pc8001_sub_system_clock_9_in_begins_xfer)
          pc8001_sub_system_clock_9_in_reg_firsttransfer <= pc8001_sub_system_clock_9_in_unreg_firsttransfer;
    end


  //pc8001_sub_system_clock_9_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pc8001_sub_system_clock_9_in_beginbursttransfer_internal = pc8001_sub_system_clock_9_in_begins_xfer;

  //pc8001_sub_system_clock_9_in_read assignment, which is an e_mux
  assign pc8001_sub_system_clock_9_in_read = nios2_data_master_granted_pc8001_sub_system_clock_9_in & nios2_data_master_read;

  //pc8001_sub_system_clock_9_in_write assignment, which is an e_mux
  assign pc8001_sub_system_clock_9_in_write = nios2_data_master_granted_pc8001_sub_system_clock_9_in & nios2_data_master_write;

  //pc8001_sub_system_clock_9_in_address mux, which is an e_mux
  assign pc8001_sub_system_clock_9_in_address = {nios2_data_master_address_to_slave >> 2,
    nios2_data_master_dbs_address[1],
    {1 {1'b0}}};

  //slaveid pc8001_sub_system_clock_9_in_nativeaddress nativeaddress mux, which is an e_mux
  assign pc8001_sub_system_clock_9_in_nativeaddress = nios2_data_master_address_to_slave >> 2;

  //d1_pc8001_sub_system_clock_9_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pc8001_sub_system_clock_9_in_end_xfer <= 1;
      else 
        d1_pc8001_sub_system_clock_9_in_end_xfer <= pc8001_sub_system_clock_9_in_end_xfer;
    end


  //pc8001_sub_system_clock_9_in_waits_for_read in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_9_in_waits_for_read = pc8001_sub_system_clock_9_in_in_a_read_cycle & pc8001_sub_system_clock_9_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_9_in_in_a_read_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_in_in_a_read_cycle = nios2_data_master_granted_pc8001_sub_system_clock_9_in & nios2_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pc8001_sub_system_clock_9_in_in_a_read_cycle;

  //pc8001_sub_system_clock_9_in_waits_for_write in a cycle, which is an e_mux
  assign pc8001_sub_system_clock_9_in_waits_for_write = pc8001_sub_system_clock_9_in_in_a_write_cycle & pc8001_sub_system_clock_9_in_waitrequest_from_sa;

  //pc8001_sub_system_clock_9_in_in_a_write_cycle assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_in_in_a_write_cycle = nios2_data_master_granted_pc8001_sub_system_clock_9_in & nios2_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pc8001_sub_system_clock_9_in_in_a_write_cycle;

  assign wait_for_pc8001_sub_system_clock_9_in_counter = 0;
  //pc8001_sub_system_clock_9_in_byteenable byte enable port mux, which is an e_mux
  assign pc8001_sub_system_clock_9_in_byteenable = (nios2_data_master_granted_pc8001_sub_system_clock_9_in)? nios2_data_master_byteenable_pc8001_sub_system_clock_9_in :
    -1;

  assign {nios2_data_master_byteenable_pc8001_sub_system_clock_9_in_segment_1,
nios2_data_master_byteenable_pc8001_sub_system_clock_9_in_segment_0} = nios2_data_master_byteenable;
  assign nios2_data_master_byteenable_pc8001_sub_system_clock_9_in = ((nios2_data_master_dbs_address[1] == 0))? nios2_data_master_byteenable_pc8001_sub_system_clock_9_in_segment_0 :
    nios2_data_master_byteenable_pc8001_sub_system_clock_9_in_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_9/in enable non-zero assertions, which is an e_register
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

module pc8001_sub_system_clock_9_out_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   d1_sdram_s1_end_xfer,
                                                   pc8001_sub_system_clock_9_out_address,
                                                   pc8001_sub_system_clock_9_out_byteenable,
                                                   pc8001_sub_system_clock_9_out_granted_sdram_s1,
                                                   pc8001_sub_system_clock_9_out_qualified_request_sdram_s1,
                                                   pc8001_sub_system_clock_9_out_read,
                                                   pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1,
                                                   pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register,
                                                   pc8001_sub_system_clock_9_out_requests_sdram_s1,
                                                   pc8001_sub_system_clock_9_out_write,
                                                   pc8001_sub_system_clock_9_out_writedata,
                                                   reset_n,
                                                   sdram_s1_readdata_from_sa,
                                                   sdram_s1_waitrequest_from_sa,

                                                  // outputs:
                                                   pc8001_sub_system_clock_9_out_address_to_slave,
                                                   pc8001_sub_system_clock_9_out_readdata,
                                                   pc8001_sub_system_clock_9_out_reset_n,
                                                   pc8001_sub_system_clock_9_out_waitrequest
                                                )
;

  output  [ 22: 0] pc8001_sub_system_clock_9_out_address_to_slave;
  output  [ 15: 0] pc8001_sub_system_clock_9_out_readdata;
  output           pc8001_sub_system_clock_9_out_reset_n;
  output           pc8001_sub_system_clock_9_out_waitrequest;
  input            clk;
  input            d1_sdram_s1_end_xfer;
  input   [ 22: 0] pc8001_sub_system_clock_9_out_address;
  input   [  1: 0] pc8001_sub_system_clock_9_out_byteenable;
  input            pc8001_sub_system_clock_9_out_granted_sdram_s1;
  input            pc8001_sub_system_clock_9_out_qualified_request_sdram_s1;
  input            pc8001_sub_system_clock_9_out_read;
  input            pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1;
  input            pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register;
  input            pc8001_sub_system_clock_9_out_requests_sdram_s1;
  input            pc8001_sub_system_clock_9_out_write;
  input   [ 15: 0] pc8001_sub_system_clock_9_out_writedata;
  input            reset_n;
  input   [ 15: 0] sdram_s1_readdata_from_sa;
  input            sdram_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 22: 0] pc8001_sub_system_clock_9_out_address_last_time;
  wire    [ 22: 0] pc8001_sub_system_clock_9_out_address_to_slave;
  reg     [  1: 0] pc8001_sub_system_clock_9_out_byteenable_last_time;
  reg              pc8001_sub_system_clock_9_out_read_last_time;
  wire    [ 15: 0] pc8001_sub_system_clock_9_out_readdata;
  wire             pc8001_sub_system_clock_9_out_reset_n;
  wire             pc8001_sub_system_clock_9_out_run;
  wire             pc8001_sub_system_clock_9_out_waitrequest;
  reg              pc8001_sub_system_clock_9_out_write_last_time;
  reg     [ 15: 0] pc8001_sub_system_clock_9_out_writedata_last_time;
  wire             r_2;
  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (pc8001_sub_system_clock_9_out_qualified_request_sdram_s1 | pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1 | ~pc8001_sub_system_clock_9_out_requests_sdram_s1) & (pc8001_sub_system_clock_9_out_granted_sdram_s1 | ~pc8001_sub_system_clock_9_out_qualified_request_sdram_s1) & ((~pc8001_sub_system_clock_9_out_qualified_request_sdram_s1 | ~pc8001_sub_system_clock_9_out_read | (pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1 & pc8001_sub_system_clock_9_out_read))) & ((~pc8001_sub_system_clock_9_out_qualified_request_sdram_s1 | ~(pc8001_sub_system_clock_9_out_read | pc8001_sub_system_clock_9_out_write) | (1 & ~sdram_s1_waitrequest_from_sa & (pc8001_sub_system_clock_9_out_read | pc8001_sub_system_clock_9_out_write))));

  //cascaded wait assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_out_run = r_2;

  //optimize select-logic by passing only those address bits which matter.
  assign pc8001_sub_system_clock_9_out_address_to_slave = pc8001_sub_system_clock_9_out_address;

  //pc8001_sub_system_clock_9/out readdata mux, which is an e_mux
  assign pc8001_sub_system_clock_9_out_readdata = sdram_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pc8001_sub_system_clock_9_out_waitrequest = ~pc8001_sub_system_clock_9_out_run;

  //pc8001_sub_system_clock_9_out_reset_n assignment, which is an e_assign
  assign pc8001_sub_system_clock_9_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pc8001_sub_system_clock_9_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_out_address_last_time <= 0;
      else 
        pc8001_sub_system_clock_9_out_address_last_time <= pc8001_sub_system_clock_9_out_address;
    end


  //pc8001_sub_system_clock_9/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pc8001_sub_system_clock_9_out_waitrequest & (pc8001_sub_system_clock_9_out_read | pc8001_sub_system_clock_9_out_write);
    end


  //pc8001_sub_system_clock_9_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_9_out_address != pc8001_sub_system_clock_9_out_address_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_9_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_9_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_out_byteenable_last_time <= 0;
      else 
        pc8001_sub_system_clock_9_out_byteenable_last_time <= pc8001_sub_system_clock_9_out_byteenable;
    end


  //pc8001_sub_system_clock_9_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_9_out_byteenable != pc8001_sub_system_clock_9_out_byteenable_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_9_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_9_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_out_read_last_time <= 0;
      else 
        pc8001_sub_system_clock_9_out_read_last_time <= pc8001_sub_system_clock_9_out_read;
    end


  //pc8001_sub_system_clock_9_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_9_out_read != pc8001_sub_system_clock_9_out_read_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_9_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_9_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_out_write_last_time <= 0;
      else 
        pc8001_sub_system_clock_9_out_write_last_time <= pc8001_sub_system_clock_9_out_write;
    end


  //pc8001_sub_system_clock_9_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_9_out_write != pc8001_sub_system_clock_9_out_write_last_time))
        begin
          $write("%0d ns: pc8001_sub_system_clock_9_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pc8001_sub_system_clock_9_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pc8001_sub_system_clock_9_out_writedata_last_time <= 0;
      else 
        pc8001_sub_system_clock_9_out_writedata_last_time <= pc8001_sub_system_clock_9_out_writedata;
    end


  //pc8001_sub_system_clock_9_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pc8001_sub_system_clock_9_out_writedata != pc8001_sub_system_clock_9_out_writedata_last_time) & pc8001_sub_system_clock_9_out_write)
        begin
          $write("%0d ns: pc8001_sub_system_clock_9_out_writedata did not heed wait!!!", $time);
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

module rdv_fifo_for_pc8001_sub_system_clock_8_out_to_sdram_s1_module (
                                                                       // inputs:
                                                                        clear_fifo,
                                                                        clk,
                                                                        data_in,
                                                                        read,
                                                                        reset_n,
                                                                        sync_reset,
                                                                        write,

                                                                       // outputs:
                                                                        data_out,
                                                                        empty,
                                                                        fifo_contains_ones_n,
                                                                        full
                                                                     )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_pc8001_sub_system_clock_9_out_to_sdram_s1_module (
                                                                       // inputs:
                                                                        clear_fifo,
                                                                        clk,
                                                                        data_in,
                                                                        read,
                                                                        reset_n,
                                                                        sync_reset,
                                                                        write,

                                                                       // outputs:
                                                                        data_out,
                                                                        empty,
                                                                        fifo_contains_ones_n,
                                                                        full
                                                                     )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_s1_arbitrator (
                             // inputs:
                              clk,
                              pc8001_sub_system_clock_8_out_address_to_slave,
                              pc8001_sub_system_clock_8_out_byteenable,
                              pc8001_sub_system_clock_8_out_read,
                              pc8001_sub_system_clock_8_out_write,
                              pc8001_sub_system_clock_8_out_writedata,
                              pc8001_sub_system_clock_9_out_address_to_slave,
                              pc8001_sub_system_clock_9_out_byteenable,
                              pc8001_sub_system_clock_9_out_read,
                              pc8001_sub_system_clock_9_out_write,
                              pc8001_sub_system_clock_9_out_writedata,
                              reset_n,
                              sdram_s1_readdata,
                              sdram_s1_readdatavalid,
                              sdram_s1_waitrequest,

                             // outputs:
                              d1_sdram_s1_end_xfer,
                              pc8001_sub_system_clock_8_out_granted_sdram_s1,
                              pc8001_sub_system_clock_8_out_qualified_request_sdram_s1,
                              pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1,
                              pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register,
                              pc8001_sub_system_clock_8_out_requests_sdram_s1,
                              pc8001_sub_system_clock_9_out_granted_sdram_s1,
                              pc8001_sub_system_clock_9_out_qualified_request_sdram_s1,
                              pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1,
                              pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register,
                              pc8001_sub_system_clock_9_out_requests_sdram_s1,
                              sdram_s1_address,
                              sdram_s1_byteenable_n,
                              sdram_s1_chipselect,
                              sdram_s1_read_n,
                              sdram_s1_readdata_from_sa,
                              sdram_s1_reset_n,
                              sdram_s1_waitrequest_from_sa,
                              sdram_s1_write_n,
                              sdram_s1_writedata
                           )
;

  output           d1_sdram_s1_end_xfer;
  output           pc8001_sub_system_clock_8_out_granted_sdram_s1;
  output           pc8001_sub_system_clock_8_out_qualified_request_sdram_s1;
  output           pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1;
  output           pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register;
  output           pc8001_sub_system_clock_8_out_requests_sdram_s1;
  output           pc8001_sub_system_clock_9_out_granted_sdram_s1;
  output           pc8001_sub_system_clock_9_out_qualified_request_sdram_s1;
  output           pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1;
  output           pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register;
  output           pc8001_sub_system_clock_9_out_requests_sdram_s1;
  output  [ 21: 0] sdram_s1_address;
  output  [  1: 0] sdram_s1_byteenable_n;
  output           sdram_s1_chipselect;
  output           sdram_s1_read_n;
  output  [ 15: 0] sdram_s1_readdata_from_sa;
  output           sdram_s1_reset_n;
  output           sdram_s1_waitrequest_from_sa;
  output           sdram_s1_write_n;
  output  [ 15: 0] sdram_s1_writedata;
  input            clk;
  input   [ 22: 0] pc8001_sub_system_clock_8_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_8_out_byteenable;
  input            pc8001_sub_system_clock_8_out_read;
  input            pc8001_sub_system_clock_8_out_write;
  input   [ 15: 0] pc8001_sub_system_clock_8_out_writedata;
  input   [ 22: 0] pc8001_sub_system_clock_9_out_address_to_slave;
  input   [  1: 0] pc8001_sub_system_clock_9_out_byteenable;
  input            pc8001_sub_system_clock_9_out_read;
  input            pc8001_sub_system_clock_9_out_write;
  input   [ 15: 0] pc8001_sub_system_clock_9_out_writedata;
  input            reset_n;
  input   [ 15: 0] sdram_s1_readdata;
  input            sdram_s1_readdatavalid;
  input            sdram_s1_waitrequest;

  reg              d1_reasons_to_wait;
  reg              d1_sdram_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sdram_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_pc8001_sub_system_clock_8_out_granted_slave_sdram_s1;
  reg              last_cycle_pc8001_sub_system_clock_9_out_granted_slave_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_arbiterlock;
  wire             pc8001_sub_system_clock_8_out_arbiterlock2;
  wire             pc8001_sub_system_clock_8_out_continuerequest;
  wire             pc8001_sub_system_clock_8_out_granted_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_qualified_request_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_rdv_fifo_empty_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_rdv_fifo_output_from_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register;
  wire             pc8001_sub_system_clock_8_out_requests_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_saved_grant_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_arbiterlock;
  wire             pc8001_sub_system_clock_9_out_arbiterlock2;
  wire             pc8001_sub_system_clock_9_out_continuerequest;
  wire             pc8001_sub_system_clock_9_out_granted_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_qualified_request_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_rdv_fifo_empty_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_rdv_fifo_output_from_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register;
  wire             pc8001_sub_system_clock_9_out_requests_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_saved_grant_sdram_s1;
  wire    [ 21: 0] sdram_s1_address;
  wire             sdram_s1_allgrants;
  wire             sdram_s1_allow_new_arb_cycle;
  wire             sdram_s1_any_bursting_master_saved_grant;
  wire             sdram_s1_any_continuerequest;
  reg     [  1: 0] sdram_s1_arb_addend;
  wire             sdram_s1_arb_counter_enable;
  reg              sdram_s1_arb_share_counter;
  wire             sdram_s1_arb_share_counter_next_value;
  wire             sdram_s1_arb_share_set_values;
  wire    [  1: 0] sdram_s1_arb_winner;
  wire             sdram_s1_arbitration_holdoff_internal;
  wire             sdram_s1_beginbursttransfer_internal;
  wire             sdram_s1_begins_xfer;
  wire    [  1: 0] sdram_s1_byteenable_n;
  wire             sdram_s1_chipselect;
  wire    [  3: 0] sdram_s1_chosen_master_double_vector;
  wire    [  1: 0] sdram_s1_chosen_master_rot_left;
  wire             sdram_s1_end_xfer;
  wire             sdram_s1_firsttransfer;
  wire    [  1: 0] sdram_s1_grant_vector;
  wire             sdram_s1_in_a_read_cycle;
  wire             sdram_s1_in_a_write_cycle;
  wire    [  1: 0] sdram_s1_master_qreq_vector;
  wire             sdram_s1_move_on_to_next_transaction;
  wire             sdram_s1_non_bursting_master_requests;
  wire             sdram_s1_read_n;
  wire    [ 15: 0] sdram_s1_readdata_from_sa;
  wire             sdram_s1_readdatavalid_from_sa;
  reg              sdram_s1_reg_firsttransfer;
  wire             sdram_s1_reset_n;
  reg     [  1: 0] sdram_s1_saved_chosen_master_vector;
  reg              sdram_s1_slavearbiterlockenable;
  wire             sdram_s1_slavearbiterlockenable2;
  wire             sdram_s1_unreg_firsttransfer;
  wire             sdram_s1_waitrequest_from_sa;
  wire             sdram_s1_waits_for_read;
  wire             sdram_s1_waits_for_write;
  wire             sdram_s1_write_n;
  wire    [ 15: 0] sdram_s1_writedata;
  wire    [ 22: 0] shifted_address_to_sdram_s1_from_pc8001_sub_system_clock_8_out;
  wire    [ 22: 0] shifted_address_to_sdram_s1_from_pc8001_sub_system_clock_9_out;
  wire             wait_for_sdram_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sdram_s1_end_xfer;
    end


  assign sdram_s1_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_8_out_qualified_request_sdram_s1 | pc8001_sub_system_clock_9_out_qualified_request_sdram_s1));
  //assign sdram_s1_readdata_from_sa = sdram_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_s1_readdata_from_sa = sdram_s1_readdata;

  assign pc8001_sub_system_clock_8_out_requests_sdram_s1 = (1) & (pc8001_sub_system_clock_8_out_read | pc8001_sub_system_clock_8_out_write);
  //assign sdram_s1_waitrequest_from_sa = sdram_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_s1_waitrequest_from_sa = sdram_s1_waitrequest;

  //assign sdram_s1_readdatavalid_from_sa = sdram_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_s1_readdatavalid_from_sa = sdram_s1_readdatavalid;

  //sdram_s1_arb_share_counter set values, which is an e_mux
  assign sdram_s1_arb_share_set_values = 1;

  //sdram_s1_non_bursting_master_requests mux, which is an e_mux
  assign sdram_s1_non_bursting_master_requests = pc8001_sub_system_clock_8_out_requests_sdram_s1 |
    pc8001_sub_system_clock_9_out_requests_sdram_s1 |
    pc8001_sub_system_clock_8_out_requests_sdram_s1 |
    pc8001_sub_system_clock_9_out_requests_sdram_s1;

  //sdram_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sdram_s1_any_bursting_master_saved_grant = 0;

  //sdram_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sdram_s1_arb_share_counter_next_value = sdram_s1_firsttransfer ? (sdram_s1_arb_share_set_values - 1) : |sdram_s1_arb_share_counter ? (sdram_s1_arb_share_counter - 1) : 0;

  //sdram_s1_allgrants all slave grants, which is an e_mux
  assign sdram_s1_allgrants = (|sdram_s1_grant_vector) |
    (|sdram_s1_grant_vector) |
    (|sdram_s1_grant_vector) |
    (|sdram_s1_grant_vector);

  //sdram_s1_end_xfer assignment, which is an e_assign
  assign sdram_s1_end_xfer = ~(sdram_s1_waits_for_read | sdram_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sdram_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sdram_s1 = sdram_s1_end_xfer & (~sdram_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sdram_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sdram_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sdram_s1 & sdram_s1_allgrants) | (end_xfer_arb_share_counter_term_sdram_s1 & ~sdram_s1_non_bursting_master_requests);

  //sdram_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_arb_share_counter <= 0;
      else if (sdram_s1_arb_counter_enable)
          sdram_s1_arb_share_counter <= sdram_s1_arb_share_counter_next_value;
    end


  //sdram_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_slavearbiterlockenable <= 0;
      else if ((|sdram_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sdram_s1) | (end_xfer_arb_share_counter_term_sdram_s1 & ~sdram_s1_non_bursting_master_requests))
          sdram_s1_slavearbiterlockenable <= |sdram_s1_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_8/out sdram/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_8_out_arbiterlock = sdram_s1_slavearbiterlockenable & pc8001_sub_system_clock_8_out_continuerequest;

  //sdram_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sdram_s1_slavearbiterlockenable2 = |sdram_s1_arb_share_counter_next_value;

  //pc8001_sub_system_clock_8/out sdram/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_8_out_arbiterlock2 = sdram_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_8_out_continuerequest;

  //pc8001_sub_system_clock_9/out sdram/s1 arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_9_out_arbiterlock = sdram_s1_slavearbiterlockenable & pc8001_sub_system_clock_9_out_continuerequest;

  //pc8001_sub_system_clock_9/out sdram/s1 arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_9_out_arbiterlock2 = sdram_s1_slavearbiterlockenable2 & pc8001_sub_system_clock_9_out_continuerequest;

  //pc8001_sub_system_clock_9/out granted sdram/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_pc8001_sub_system_clock_9_out_granted_slave_sdram_s1 <= 0;
      else 
        last_cycle_pc8001_sub_system_clock_9_out_granted_slave_sdram_s1 <= pc8001_sub_system_clock_9_out_saved_grant_sdram_s1 ? 1 : (sdram_s1_arbitration_holdoff_internal | ~pc8001_sub_system_clock_9_out_requests_sdram_s1) ? 0 : last_cycle_pc8001_sub_system_clock_9_out_granted_slave_sdram_s1;
    end


  //pc8001_sub_system_clock_9_out_continuerequest continued request, which is an e_mux
  assign pc8001_sub_system_clock_9_out_continuerequest = last_cycle_pc8001_sub_system_clock_9_out_granted_slave_sdram_s1 & pc8001_sub_system_clock_9_out_requests_sdram_s1;

  //sdram_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sdram_s1_any_continuerequest = pc8001_sub_system_clock_9_out_continuerequest |
    pc8001_sub_system_clock_8_out_continuerequest;

  assign pc8001_sub_system_clock_8_out_qualified_request_sdram_s1 = pc8001_sub_system_clock_8_out_requests_sdram_s1 & ~((pc8001_sub_system_clock_8_out_read & ((|pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register))) | pc8001_sub_system_clock_9_out_arbiterlock);
  //unique name for sdram_s1_move_on_to_next_transaction, which is an e_assign
  assign sdram_s1_move_on_to_next_transaction = sdram_s1_readdatavalid_from_sa;

  //rdv_fifo_for_pc8001_sub_system_clock_8_out_to_sdram_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_pc8001_sub_system_clock_8_out_to_sdram_s1_module rdv_fifo_for_pc8001_sub_system_clock_8_out_to_sdram_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (pc8001_sub_system_clock_8_out_granted_sdram_s1),
      .data_out             (pc8001_sub_system_clock_8_out_rdv_fifo_output_from_sdram_s1),
      .empty                (),
      .fifo_contains_ones_n (pc8001_sub_system_clock_8_out_rdv_fifo_empty_sdram_s1),
      .full                 (),
      .read                 (sdram_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_s1_waits_for_read)
    );

  assign pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register = ~pc8001_sub_system_clock_8_out_rdv_fifo_empty_sdram_s1;
  //local readdatavalid pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1, which is an e_mux
  assign pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1 = (sdram_s1_readdatavalid_from_sa & pc8001_sub_system_clock_8_out_rdv_fifo_output_from_sdram_s1) & ~ pc8001_sub_system_clock_8_out_rdv_fifo_empty_sdram_s1;

  //sdram_s1_writedata mux, which is an e_mux
  assign sdram_s1_writedata = (pc8001_sub_system_clock_8_out_granted_sdram_s1)? pc8001_sub_system_clock_8_out_writedata :
    pc8001_sub_system_clock_9_out_writedata;

  assign pc8001_sub_system_clock_9_out_requests_sdram_s1 = (1) & (pc8001_sub_system_clock_9_out_read | pc8001_sub_system_clock_9_out_write);
  //pc8001_sub_system_clock_8/out granted sdram/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_pc8001_sub_system_clock_8_out_granted_slave_sdram_s1 <= 0;
      else 
        last_cycle_pc8001_sub_system_clock_8_out_granted_slave_sdram_s1 <= pc8001_sub_system_clock_8_out_saved_grant_sdram_s1 ? 1 : (sdram_s1_arbitration_holdoff_internal | ~pc8001_sub_system_clock_8_out_requests_sdram_s1) ? 0 : last_cycle_pc8001_sub_system_clock_8_out_granted_slave_sdram_s1;
    end


  //pc8001_sub_system_clock_8_out_continuerequest continued request, which is an e_mux
  assign pc8001_sub_system_clock_8_out_continuerequest = last_cycle_pc8001_sub_system_clock_8_out_granted_slave_sdram_s1 & pc8001_sub_system_clock_8_out_requests_sdram_s1;

  assign pc8001_sub_system_clock_9_out_qualified_request_sdram_s1 = pc8001_sub_system_clock_9_out_requests_sdram_s1 & ~((pc8001_sub_system_clock_9_out_read & ((|pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register))) | pc8001_sub_system_clock_8_out_arbiterlock);
  //rdv_fifo_for_pc8001_sub_system_clock_9_out_to_sdram_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_pc8001_sub_system_clock_9_out_to_sdram_s1_module rdv_fifo_for_pc8001_sub_system_clock_9_out_to_sdram_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (pc8001_sub_system_clock_9_out_granted_sdram_s1),
      .data_out             (pc8001_sub_system_clock_9_out_rdv_fifo_output_from_sdram_s1),
      .empty                (),
      .fifo_contains_ones_n (pc8001_sub_system_clock_9_out_rdv_fifo_empty_sdram_s1),
      .full                 (),
      .read                 (sdram_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_s1_waits_for_read)
    );

  assign pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register = ~pc8001_sub_system_clock_9_out_rdv_fifo_empty_sdram_s1;
  //local readdatavalid pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1, which is an e_mux
  assign pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1 = (sdram_s1_readdatavalid_from_sa & pc8001_sub_system_clock_9_out_rdv_fifo_output_from_sdram_s1) & ~ pc8001_sub_system_clock_9_out_rdv_fifo_empty_sdram_s1;

  //allow new arb cycle for sdram/s1, which is an e_assign
  assign sdram_s1_allow_new_arb_cycle = ~pc8001_sub_system_clock_8_out_arbiterlock & ~pc8001_sub_system_clock_9_out_arbiterlock;

  //pc8001_sub_system_clock_9/out assignment into master qualified-requests vector for sdram/s1, which is an e_assign
  assign sdram_s1_master_qreq_vector[0] = pc8001_sub_system_clock_9_out_qualified_request_sdram_s1;

  //pc8001_sub_system_clock_9/out grant sdram/s1, which is an e_assign
  assign pc8001_sub_system_clock_9_out_granted_sdram_s1 = sdram_s1_grant_vector[0];

  //pc8001_sub_system_clock_9/out saved-grant sdram/s1, which is an e_assign
  assign pc8001_sub_system_clock_9_out_saved_grant_sdram_s1 = sdram_s1_arb_winner[0] && pc8001_sub_system_clock_9_out_requests_sdram_s1;

  //pc8001_sub_system_clock_8/out assignment into master qualified-requests vector for sdram/s1, which is an e_assign
  assign sdram_s1_master_qreq_vector[1] = pc8001_sub_system_clock_8_out_qualified_request_sdram_s1;

  //pc8001_sub_system_clock_8/out grant sdram/s1, which is an e_assign
  assign pc8001_sub_system_clock_8_out_granted_sdram_s1 = sdram_s1_grant_vector[1];

  //pc8001_sub_system_clock_8/out saved-grant sdram/s1, which is an e_assign
  assign pc8001_sub_system_clock_8_out_saved_grant_sdram_s1 = sdram_s1_arb_winner[1] && pc8001_sub_system_clock_8_out_requests_sdram_s1;

  //sdram/s1 chosen-master double-vector, which is an e_assign
  assign sdram_s1_chosen_master_double_vector = {sdram_s1_master_qreq_vector, sdram_s1_master_qreq_vector} & ({~sdram_s1_master_qreq_vector, ~sdram_s1_master_qreq_vector} + sdram_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign sdram_s1_arb_winner = (sdram_s1_allow_new_arb_cycle & | sdram_s1_grant_vector) ? sdram_s1_grant_vector : sdram_s1_saved_chosen_master_vector;

  //saved sdram_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_saved_chosen_master_vector <= 0;
      else if (sdram_s1_allow_new_arb_cycle)
          sdram_s1_saved_chosen_master_vector <= |sdram_s1_grant_vector ? sdram_s1_grant_vector : sdram_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sdram_s1_grant_vector = {(sdram_s1_chosen_master_double_vector[1] | sdram_s1_chosen_master_double_vector[3]),
    (sdram_s1_chosen_master_double_vector[0] | sdram_s1_chosen_master_double_vector[2])};

  //sdram/s1 chosen master rotated left, which is an e_assign
  assign sdram_s1_chosen_master_rot_left = (sdram_s1_arb_winner << 1) ? (sdram_s1_arb_winner << 1) : 1;

  //sdram/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_arb_addend <= 1;
      else if (|sdram_s1_grant_vector)
          sdram_s1_arb_addend <= sdram_s1_end_xfer? sdram_s1_chosen_master_rot_left : sdram_s1_grant_vector;
    end


  //sdram_s1_reset_n assignment, which is an e_assign
  assign sdram_s1_reset_n = reset_n;

  assign sdram_s1_chipselect = pc8001_sub_system_clock_8_out_granted_sdram_s1 | pc8001_sub_system_clock_9_out_granted_sdram_s1;
  //sdram_s1_firsttransfer first transaction, which is an e_assign
  assign sdram_s1_firsttransfer = sdram_s1_begins_xfer ? sdram_s1_unreg_firsttransfer : sdram_s1_reg_firsttransfer;

  //sdram_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sdram_s1_unreg_firsttransfer = ~(sdram_s1_slavearbiterlockenable & sdram_s1_any_continuerequest);

  //sdram_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_reg_firsttransfer <= 1'b1;
      else if (sdram_s1_begins_xfer)
          sdram_s1_reg_firsttransfer <= sdram_s1_unreg_firsttransfer;
    end


  //sdram_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sdram_s1_beginbursttransfer_internal = sdram_s1_begins_xfer;

  //sdram_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sdram_s1_arbitration_holdoff_internal = sdram_s1_begins_xfer & sdram_s1_firsttransfer;

  //~sdram_s1_read_n assignment, which is an e_mux
  assign sdram_s1_read_n = ~((pc8001_sub_system_clock_8_out_granted_sdram_s1 & pc8001_sub_system_clock_8_out_read) | (pc8001_sub_system_clock_9_out_granted_sdram_s1 & pc8001_sub_system_clock_9_out_read));

  //~sdram_s1_write_n assignment, which is an e_mux
  assign sdram_s1_write_n = ~((pc8001_sub_system_clock_8_out_granted_sdram_s1 & pc8001_sub_system_clock_8_out_write) | (pc8001_sub_system_clock_9_out_granted_sdram_s1 & pc8001_sub_system_clock_9_out_write));

  assign shifted_address_to_sdram_s1_from_pc8001_sub_system_clock_8_out = pc8001_sub_system_clock_8_out_address_to_slave;
  //sdram_s1_address mux, which is an e_mux
  assign sdram_s1_address = (pc8001_sub_system_clock_8_out_granted_sdram_s1)? (shifted_address_to_sdram_s1_from_pc8001_sub_system_clock_8_out >> 1) :
    (shifted_address_to_sdram_s1_from_pc8001_sub_system_clock_9_out >> 1);

  assign shifted_address_to_sdram_s1_from_pc8001_sub_system_clock_9_out = pc8001_sub_system_clock_9_out_address_to_slave;
  //d1_sdram_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sdram_s1_end_xfer <= 1;
      else 
        d1_sdram_s1_end_xfer <= sdram_s1_end_xfer;
    end


  //sdram_s1_waits_for_read in a cycle, which is an e_mux
  assign sdram_s1_waits_for_read = sdram_s1_in_a_read_cycle & sdram_s1_waitrequest_from_sa;

  //sdram_s1_in_a_read_cycle assignment, which is an e_assign
  assign sdram_s1_in_a_read_cycle = (pc8001_sub_system_clock_8_out_granted_sdram_s1 & pc8001_sub_system_clock_8_out_read) | (pc8001_sub_system_clock_9_out_granted_sdram_s1 & pc8001_sub_system_clock_9_out_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sdram_s1_in_a_read_cycle;

  //sdram_s1_waits_for_write in a cycle, which is an e_mux
  assign sdram_s1_waits_for_write = sdram_s1_in_a_write_cycle & sdram_s1_waitrequest_from_sa;

  //sdram_s1_in_a_write_cycle assignment, which is an e_assign
  assign sdram_s1_in_a_write_cycle = (pc8001_sub_system_clock_8_out_granted_sdram_s1 & pc8001_sub_system_clock_8_out_write) | (pc8001_sub_system_clock_9_out_granted_sdram_s1 & pc8001_sub_system_clock_9_out_write);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sdram_s1_in_a_write_cycle;

  assign wait_for_sdram_s1_counter = 0;
  //~sdram_s1_byteenable_n byte enable port mux, which is an e_mux
  assign sdram_s1_byteenable_n = ~((pc8001_sub_system_clock_8_out_granted_sdram_s1)? pc8001_sub_system_clock_8_out_byteenable :
    (pc8001_sub_system_clock_9_out_granted_sdram_s1)? pc8001_sub_system_clock_9_out_byteenable :
    -1);


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sdram/s1 enable non-zero assertions, which is an e_register
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
      if (pc8001_sub_system_clock_8_out_granted_sdram_s1 + pc8001_sub_system_clock_9_out_granted_sdram_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (pc8001_sub_system_clock_8_out_saved_grant_sdram_s1 + pc8001_sub_system_clock_9_out_saved_grant_sdram_s1 > 1)
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

module sub_system_pll_pll_slave_arbitrator (
                                             // inputs:
                                              clk,
                                              pc8001_sub_system_clock_7_out_address_to_slave,
                                              pc8001_sub_system_clock_7_out_read,
                                              pc8001_sub_system_clock_7_out_write,
                                              pc8001_sub_system_clock_7_out_writedata,
                                              reset_n,
                                              sub_system_pll_pll_slave_readdata,

                                             // outputs:
                                              d1_sub_system_pll_pll_slave_end_xfer,
                                              pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave,
                                              pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave,
                                              pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave,
                                              pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave,
                                              sub_system_pll_pll_slave_address,
                                              sub_system_pll_pll_slave_read,
                                              sub_system_pll_pll_slave_readdata_from_sa,
                                              sub_system_pll_pll_slave_reset,
                                              sub_system_pll_pll_slave_write,
                                              sub_system_pll_pll_slave_writedata
                                           )
;

  output           d1_sub_system_pll_pll_slave_end_xfer;
  output           pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave;
  output           pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave;
  output           pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave;
  output           pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;
  output  [  1: 0] sub_system_pll_pll_slave_address;
  output           sub_system_pll_pll_slave_read;
  output  [ 31: 0] sub_system_pll_pll_slave_readdata_from_sa;
  output           sub_system_pll_pll_slave_reset;
  output           sub_system_pll_pll_slave_write;
  output  [ 31: 0] sub_system_pll_pll_slave_writedata;
  input            clk;
  input   [  3: 0] pc8001_sub_system_clock_7_out_address_to_slave;
  input            pc8001_sub_system_clock_7_out_read;
  input            pc8001_sub_system_clock_7_out_write;
  input   [ 31: 0] pc8001_sub_system_clock_7_out_writedata;
  input            reset_n;
  input   [ 31: 0] sub_system_pll_pll_slave_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sub_system_pll_pll_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sub_system_pll_pll_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pc8001_sub_system_clock_7_out_arbiterlock;
  wire             pc8001_sub_system_clock_7_out_arbiterlock2;
  wire             pc8001_sub_system_clock_7_out_continuerequest;
  wire             pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave;
  wire             pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave;
  wire             pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave;
  wire             pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;
  wire             pc8001_sub_system_clock_7_out_saved_grant_sub_system_pll_pll_slave;
  wire    [  3: 0] shifted_address_to_sub_system_pll_pll_slave_from_pc8001_sub_system_clock_7_out;
  wire    [  1: 0] sub_system_pll_pll_slave_address;
  wire             sub_system_pll_pll_slave_allgrants;
  wire             sub_system_pll_pll_slave_allow_new_arb_cycle;
  wire             sub_system_pll_pll_slave_any_bursting_master_saved_grant;
  wire             sub_system_pll_pll_slave_any_continuerequest;
  wire             sub_system_pll_pll_slave_arb_counter_enable;
  reg              sub_system_pll_pll_slave_arb_share_counter;
  wire             sub_system_pll_pll_slave_arb_share_counter_next_value;
  wire             sub_system_pll_pll_slave_arb_share_set_values;
  wire             sub_system_pll_pll_slave_beginbursttransfer_internal;
  wire             sub_system_pll_pll_slave_begins_xfer;
  wire             sub_system_pll_pll_slave_end_xfer;
  wire             sub_system_pll_pll_slave_firsttransfer;
  wire             sub_system_pll_pll_slave_grant_vector;
  wire             sub_system_pll_pll_slave_in_a_read_cycle;
  wire             sub_system_pll_pll_slave_in_a_write_cycle;
  wire             sub_system_pll_pll_slave_master_qreq_vector;
  wire             sub_system_pll_pll_slave_non_bursting_master_requests;
  wire             sub_system_pll_pll_slave_read;
  wire    [ 31: 0] sub_system_pll_pll_slave_readdata_from_sa;
  reg              sub_system_pll_pll_slave_reg_firsttransfer;
  wire             sub_system_pll_pll_slave_reset;
  reg              sub_system_pll_pll_slave_slavearbiterlockenable;
  wire             sub_system_pll_pll_slave_slavearbiterlockenable2;
  wire             sub_system_pll_pll_slave_unreg_firsttransfer;
  wire             sub_system_pll_pll_slave_waits_for_read;
  wire             sub_system_pll_pll_slave_waits_for_write;
  wire             sub_system_pll_pll_slave_write;
  wire    [ 31: 0] sub_system_pll_pll_slave_writedata;
  wire             wait_for_sub_system_pll_pll_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sub_system_pll_pll_slave_end_xfer;
    end


  assign sub_system_pll_pll_slave_begins_xfer = ~d1_reasons_to_wait & ((pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave));
  //assign sub_system_pll_pll_slave_readdata_from_sa = sub_system_pll_pll_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sub_system_pll_pll_slave_readdata_from_sa = sub_system_pll_pll_slave_readdata;

  assign pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave = (1) & (pc8001_sub_system_clock_7_out_read | pc8001_sub_system_clock_7_out_write);
  //sub_system_pll_pll_slave_arb_share_counter set values, which is an e_mux
  assign sub_system_pll_pll_slave_arb_share_set_values = 1;

  //sub_system_pll_pll_slave_non_bursting_master_requests mux, which is an e_mux
  assign sub_system_pll_pll_slave_non_bursting_master_requests = pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;

  //sub_system_pll_pll_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sub_system_pll_pll_slave_any_bursting_master_saved_grant = 0;

  //sub_system_pll_pll_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sub_system_pll_pll_slave_arb_share_counter_next_value = sub_system_pll_pll_slave_firsttransfer ? (sub_system_pll_pll_slave_arb_share_set_values - 1) : |sub_system_pll_pll_slave_arb_share_counter ? (sub_system_pll_pll_slave_arb_share_counter - 1) : 0;

  //sub_system_pll_pll_slave_allgrants all slave grants, which is an e_mux
  assign sub_system_pll_pll_slave_allgrants = |sub_system_pll_pll_slave_grant_vector;

  //sub_system_pll_pll_slave_end_xfer assignment, which is an e_assign
  assign sub_system_pll_pll_slave_end_xfer = ~(sub_system_pll_pll_slave_waits_for_read | sub_system_pll_pll_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sub_system_pll_pll_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sub_system_pll_pll_slave = sub_system_pll_pll_slave_end_xfer & (~sub_system_pll_pll_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sub_system_pll_pll_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sub_system_pll_pll_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sub_system_pll_pll_slave & sub_system_pll_pll_slave_allgrants) | (end_xfer_arb_share_counter_term_sub_system_pll_pll_slave & ~sub_system_pll_pll_slave_non_bursting_master_requests);

  //sub_system_pll_pll_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sub_system_pll_pll_slave_arb_share_counter <= 0;
      else if (sub_system_pll_pll_slave_arb_counter_enable)
          sub_system_pll_pll_slave_arb_share_counter <= sub_system_pll_pll_slave_arb_share_counter_next_value;
    end


  //sub_system_pll_pll_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sub_system_pll_pll_slave_slavearbiterlockenable <= 0;
      else if ((|sub_system_pll_pll_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sub_system_pll_pll_slave) | (end_xfer_arb_share_counter_term_sub_system_pll_pll_slave & ~sub_system_pll_pll_slave_non_bursting_master_requests))
          sub_system_pll_pll_slave_slavearbiterlockenable <= |sub_system_pll_pll_slave_arb_share_counter_next_value;
    end


  //pc8001_sub_system_clock_7/out sub_system_pll/pll_slave arbiterlock, which is an e_assign
  assign pc8001_sub_system_clock_7_out_arbiterlock = sub_system_pll_pll_slave_slavearbiterlockenable & pc8001_sub_system_clock_7_out_continuerequest;

  //sub_system_pll_pll_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sub_system_pll_pll_slave_slavearbiterlockenable2 = |sub_system_pll_pll_slave_arb_share_counter_next_value;

  //pc8001_sub_system_clock_7/out sub_system_pll/pll_slave arbiterlock2, which is an e_assign
  assign pc8001_sub_system_clock_7_out_arbiterlock2 = sub_system_pll_pll_slave_slavearbiterlockenable2 & pc8001_sub_system_clock_7_out_continuerequest;

  //sub_system_pll_pll_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sub_system_pll_pll_slave_any_continuerequest = 1;

  //pc8001_sub_system_clock_7_out_continuerequest continued request, which is an e_assign
  assign pc8001_sub_system_clock_7_out_continuerequest = 1;

  assign pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave = pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;
  //sub_system_pll_pll_slave_writedata mux, which is an e_mux
  assign sub_system_pll_pll_slave_writedata = pc8001_sub_system_clock_7_out_writedata;

  //master is always granted when requested
  assign pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave = pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave;

  //pc8001_sub_system_clock_7/out saved-grant sub_system_pll/pll_slave, which is an e_assign
  assign pc8001_sub_system_clock_7_out_saved_grant_sub_system_pll_pll_slave = pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;

  //allow new arb cycle for sub_system_pll/pll_slave, which is an e_assign
  assign sub_system_pll_pll_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sub_system_pll_pll_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sub_system_pll_pll_slave_master_qreq_vector = 1;

  //~sub_system_pll_pll_slave_reset assignment, which is an e_assign
  assign sub_system_pll_pll_slave_reset = ~reset_n;

  //sub_system_pll_pll_slave_firsttransfer first transaction, which is an e_assign
  assign sub_system_pll_pll_slave_firsttransfer = sub_system_pll_pll_slave_begins_xfer ? sub_system_pll_pll_slave_unreg_firsttransfer : sub_system_pll_pll_slave_reg_firsttransfer;

  //sub_system_pll_pll_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sub_system_pll_pll_slave_unreg_firsttransfer = ~(sub_system_pll_pll_slave_slavearbiterlockenable & sub_system_pll_pll_slave_any_continuerequest);

  //sub_system_pll_pll_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sub_system_pll_pll_slave_reg_firsttransfer <= 1'b1;
      else if (sub_system_pll_pll_slave_begins_xfer)
          sub_system_pll_pll_slave_reg_firsttransfer <= sub_system_pll_pll_slave_unreg_firsttransfer;
    end


  //sub_system_pll_pll_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sub_system_pll_pll_slave_beginbursttransfer_internal = sub_system_pll_pll_slave_begins_xfer;

  //sub_system_pll_pll_slave_read assignment, which is an e_mux
  assign sub_system_pll_pll_slave_read = pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave & pc8001_sub_system_clock_7_out_read;

  //sub_system_pll_pll_slave_write assignment, which is an e_mux
  assign sub_system_pll_pll_slave_write = pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave & pc8001_sub_system_clock_7_out_write;

  assign shifted_address_to_sub_system_pll_pll_slave_from_pc8001_sub_system_clock_7_out = pc8001_sub_system_clock_7_out_address_to_slave;
  //sub_system_pll_pll_slave_address mux, which is an e_mux
  assign sub_system_pll_pll_slave_address = shifted_address_to_sub_system_pll_pll_slave_from_pc8001_sub_system_clock_7_out >> 2;

  //d1_sub_system_pll_pll_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sub_system_pll_pll_slave_end_xfer <= 1;
      else 
        d1_sub_system_pll_pll_slave_end_xfer <= sub_system_pll_pll_slave_end_xfer;
    end


  //sub_system_pll_pll_slave_waits_for_read in a cycle, which is an e_mux
  assign sub_system_pll_pll_slave_waits_for_read = sub_system_pll_pll_slave_in_a_read_cycle & 0;

  //sub_system_pll_pll_slave_in_a_read_cycle assignment, which is an e_assign
  assign sub_system_pll_pll_slave_in_a_read_cycle = pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave & pc8001_sub_system_clock_7_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sub_system_pll_pll_slave_in_a_read_cycle;

  //sub_system_pll_pll_slave_waits_for_write in a cycle, which is an e_mux
  assign sub_system_pll_pll_slave_waits_for_write = sub_system_pll_pll_slave_in_a_write_cycle & 0;

  //sub_system_pll_pll_slave_in_a_write_cycle assignment, which is an e_assign
  assign sub_system_pll_pll_slave_in_a_write_cycle = pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave & pc8001_sub_system_clock_7_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sub_system_pll_pll_slave_in_a_write_cycle;

  assign wait_for_sub_system_pll_pll_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sub_system_pll/pll_slave enable non-zero assertions, which is an e_register
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
  input   [ 25: 0] nios2_data_master_address_to_slave;
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
  wire    [ 25: 0] shifted_address_to_sysid_control_slave_from_nios2_data_master;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg     [  1: 0] sysid_control_slave_arb_share_counter;
  wire    [  1: 0] sysid_control_slave_arb_share_counter_next_value;
  wire    [  1: 0] sysid_control_slave_arb_share_set_values;
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

  assign nios2_data_master_requests_sysid_control_slave = (({nios2_data_master_address_to_slave[25 : 3] , 3'b0} == 26'h28) & (nios2_data_master_read | nios2_data_master_write)) & nios2_data_master_read;
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
  input   [ 25: 0] nios2_data_master_address_to_slave;
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
  wire    [ 25: 0] shifted_address_to_timer_0_s1_from_nios2_data_master;
  wire    [  2: 0] timer_0_s1_address;
  wire             timer_0_s1_allgrants;
  wire             timer_0_s1_allow_new_arb_cycle;
  wire             timer_0_s1_any_bursting_master_saved_grant;
  wire             timer_0_s1_any_continuerequest;
  wire             timer_0_s1_arb_counter_enable;
  reg     [  1: 0] timer_0_s1_arb_share_counter;
  wire    [  1: 0] timer_0_s1_arb_share_counter_next_value;
  wire    [  1: 0] timer_0_s1_arb_share_set_values;
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

  assign nios2_data_master_requests_timer_0_s1 = ({nios2_data_master_address_to_slave[25 : 5] , 5'b0} == 26'h80) & (nios2_data_master_read | nios2_data_master_write);
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

module pc8001_sub_system_reset_pll_io_domain_synch_module (
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

module pc8001_sub_system_reset_pll_cpu_domain_synch_module (
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

module pc8001_sub_system_reset_pll_peripheral_domain_synch_module (
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

module pc8001_sub_system_reset_pll_sdram_domain_synch_module (
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

module pc8001_sub_system_reset_clk_0_domain_synch_module (
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
                            clk_0,
                            pll_cpu,
                            pll_io,
                            pll_peripheral,
                            pll_sdram,
                            reset_n,

                           // the_cmt_din
                            in_port_to_the_cmt_din,

                           // the_cmt_dout
                            out_port_from_the_cmt_dout,

                           // the_cmt_gpio_in
                            in_port_to_the_cmt_gpio_in,

                           // the_cmt_gpio_out
                            out_port_from_the_cmt_gpio_out,

                           // the_epcs_flash_controller
                            data0_to_the_epcs_flash_controller,
                            dclk_from_the_epcs_flash_controller,
                            sce_from_the_epcs_flash_controller,
                            sdo_from_the_epcs_flash_controller,

                           // the_gpio0
                            out_port_from_the_gpio0,

                           // the_gpio1
                            in_port_to_the_gpio1,

                           // the_mmc_spi
                            MMC_CD_to_the_mmc_spi,
                            MMC_SCK_from_the_mmc_spi,
                            MMC_SDI_to_the_mmc_spi,
                            MMC_SDO_from_the_mmc_spi,
                            MMC_WP_to_the_mmc_spi,
                            MMC_nCS_from_the_mmc_spi,

                           // the_sdram
                            zs_addr_from_the_sdram,
                            zs_ba_from_the_sdram,
                            zs_cas_n_from_the_sdram,
                            zs_cke_from_the_sdram,
                            zs_cs_n_from_the_sdram,
                            zs_dq_to_and_from_the_sdram,
                            zs_dqm_from_the_sdram,
                            zs_ras_n_from_the_sdram,
                            zs_we_n_from_the_sdram,

                           // the_sub_system_pll
                            areset_to_the_sub_system_pll,
                            locked_from_the_sub_system_pll,
                            phasedone_from_the_sub_system_pll
                         )
;

  output           MMC_SCK_from_the_mmc_spi;
  output           MMC_SDO_from_the_mmc_spi;
  output           MMC_nCS_from_the_mmc_spi;
  output           dclk_from_the_epcs_flash_controller;
  output           locked_from_the_sub_system_pll;
  output  [  7: 0] out_port_from_the_cmt_dout;
  output  [  7: 0] out_port_from_the_cmt_gpio_out;
  output  [  7: 0] out_port_from_the_gpio0;
  output           phasedone_from_the_sub_system_pll;
  output           pll_cpu;
  output           pll_io;
  output           pll_peripheral;
  output           pll_sdram;
  output           sce_from_the_epcs_flash_controller;
  output           sdo_from_the_epcs_flash_controller;
  output  [ 11: 0] zs_addr_from_the_sdram;
  output  [  1: 0] zs_ba_from_the_sdram;
  output           zs_cas_n_from_the_sdram;
  output           zs_cke_from_the_sdram;
  output           zs_cs_n_from_the_sdram;
  inout   [ 15: 0] zs_dq_to_and_from_the_sdram;
  output  [  1: 0] zs_dqm_from_the_sdram;
  output           zs_ras_n_from_the_sdram;
  output           zs_we_n_from_the_sdram;
  input            MMC_CD_to_the_mmc_spi;
  input            MMC_SDI_to_the_mmc_spi;
  input            MMC_WP_to_the_mmc_spi;
  input            areset_to_the_sub_system_pll;
  input            clk_0;
  input            data0_to_the_epcs_flash_controller;
  input   [  7: 0] in_port_to_the_cmt_din;
  input   [  7: 0] in_port_to_the_cmt_gpio_in;
  input   [  7: 0] in_port_to_the_gpio1;
  input            reset_n;

  wire             MMC_SCK_from_the_mmc_spi;
  wire             MMC_SDO_from_the_mmc_spi;
  wire             MMC_nCS_from_the_mmc_spi;
  wire             clk_0_reset_n;
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
  wire             d1_epcs_flash_controller_epcs_control_port_end_xfer;
  wire             d1_gpio0_s1_end_xfer;
  wire             d1_gpio1_s1_end_xfer;
  wire             d1_jtag_uart_avalon_jtag_slave_end_xfer;
  wire             d1_mmc_spi_avalon_slave_0_end_xfer;
  wire             d1_nios2_jtag_debug_module_end_xfer;
  wire             d1_pc8001_sub_system_clock_0_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_1_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_2_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_3_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_4_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_5_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_6_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_7_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_8_in_end_xfer;
  wire             d1_pc8001_sub_system_clock_9_in_end_xfer;
  wire             d1_sdram_s1_end_xfer;
  wire             d1_sub_system_pll_pll_slave_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_timer_0_s1_end_xfer;
  wire             dclk_from_the_epcs_flash_controller;
  wire    [  8: 0] epcs_flash_controller_epcs_control_port_address;
  wire             epcs_flash_controller_epcs_control_port_chipselect;
  wire             epcs_flash_controller_epcs_control_port_dataavailable;
  wire             epcs_flash_controller_epcs_control_port_dataavailable_from_sa;
  wire             epcs_flash_controller_epcs_control_port_endofpacket;
  wire             epcs_flash_controller_epcs_control_port_endofpacket_from_sa;
  wire             epcs_flash_controller_epcs_control_port_irq;
  wire             epcs_flash_controller_epcs_control_port_irq_from_sa;
  wire             epcs_flash_controller_epcs_control_port_read_n;
  wire    [ 31: 0] epcs_flash_controller_epcs_control_port_readdata;
  wire    [ 31: 0] epcs_flash_controller_epcs_control_port_readdata_from_sa;
  wire             epcs_flash_controller_epcs_control_port_readyfordata;
  wire             epcs_flash_controller_epcs_control_port_readyfordata_from_sa;
  wire             epcs_flash_controller_epcs_control_port_reset_n;
  wire             epcs_flash_controller_epcs_control_port_write_n;
  wire    [ 31: 0] epcs_flash_controller_epcs_control_port_writedata;
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
  wire             locked_from_the_sub_system_pll;
  wire    [  1: 0] mmc_spi_avalon_slave_0_address;
  wire             mmc_spi_avalon_slave_0_chipselect;
  wire             mmc_spi_avalon_slave_0_irq;
  wire             mmc_spi_avalon_slave_0_irq_from_sa;
  wire             mmc_spi_avalon_slave_0_read;
  wire    [ 31: 0] mmc_spi_avalon_slave_0_readdata;
  wire    [ 31: 0] mmc_spi_avalon_slave_0_readdata_from_sa;
  wire             mmc_spi_avalon_slave_0_reset;
  wire             mmc_spi_avalon_slave_0_write;
  wire    [ 31: 0] mmc_spi_avalon_slave_0_writedata;
  wire    [ 25: 0] nios2_data_master_address;
  wire    [ 25: 0] nios2_data_master_address_to_slave;
  wire    [  3: 0] nios2_data_master_byteenable;
  wire    [  1: 0] nios2_data_master_byteenable_pc8001_sub_system_clock_9_in;
  wire    [  1: 0] nios2_data_master_dbs_address;
  wire    [ 15: 0] nios2_data_master_dbs_write_16;
  wire             nios2_data_master_debugaccess;
  wire             nios2_data_master_granted_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_granted_nios2_jtag_debug_module;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_granted_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_granted_sysid_control_slave;
  wire             nios2_data_master_granted_timer_0_s1;
  wire    [ 31: 0] nios2_data_master_irq;
  wire             nios2_data_master_no_byte_enables_and_last_term;
  wire             nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_qualified_request_nios2_jtag_debug_module;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_qualified_request_sysid_control_slave;
  wire             nios2_data_master_qualified_request_timer_0_s1;
  wire             nios2_data_master_read;
  wire             nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_read_data_valid_nios2_jtag_debug_module;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_read_data_valid_sysid_control_slave;
  wire             nios2_data_master_read_data_valid_timer_0_s1;
  wire    [ 31: 0] nios2_data_master_readdata;
  wire             nios2_data_master_requests_epcs_flash_controller_epcs_control_port;
  wire             nios2_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             nios2_data_master_requests_nios2_jtag_debug_module;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_0_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_1_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_2_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_3_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_4_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_5_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_6_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_7_in;
  wire             nios2_data_master_requests_pc8001_sub_system_clock_9_in;
  wire             nios2_data_master_requests_sysid_control_slave;
  wire             nios2_data_master_requests_timer_0_s1;
  wire             nios2_data_master_waitrequest;
  wire             nios2_data_master_write;
  wire    [ 31: 0] nios2_data_master_writedata;
  wire    [ 25: 0] nios2_instruction_master_address;
  wire    [ 25: 0] nios2_instruction_master_address_to_slave;
  wire    [  1: 0] nios2_instruction_master_dbs_address;
  wire             nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_granted_nios2_jtag_debug_module;
  wire             nios2_instruction_master_granted_pc8001_sub_system_clock_8_in;
  wire             nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_qualified_request_nios2_jtag_debug_module;
  wire             nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in;
  wire             nios2_instruction_master_read;
  wire             nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_read_data_valid_nios2_jtag_debug_module;
  wire             nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in;
  wire    [ 31: 0] nios2_instruction_master_readdata;
  wire             nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port;
  wire             nios2_instruction_master_requests_nios2_jtag_debug_module;
  wire             nios2_instruction_master_requests_pc8001_sub_system_clock_8_in;
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
  wire             out_clk_sub_system_pll_c0;
  wire             out_clk_sub_system_pll_c1;
  wire             out_clk_sub_system_pll_c2;
  wire             out_clk_sub_system_pll_c3;
  wire    [  7: 0] out_port_from_the_cmt_dout;
  wire    [  7: 0] out_port_from_the_cmt_gpio_out;
  wire    [  7: 0] out_port_from_the_gpio0;
  wire    [  3: 0] pc8001_sub_system_clock_0_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_0_in_byteenable;
  wire             pc8001_sub_system_clock_0_in_endofpacket;
  wire             pc8001_sub_system_clock_0_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_0_in_nativeaddress;
  wire             pc8001_sub_system_clock_0_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_0_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_0_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_0_in_reset_n;
  wire             pc8001_sub_system_clock_0_in_waitrequest;
  wire             pc8001_sub_system_clock_0_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_0_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_0_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_0_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_0_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_0_out_byteenable;
  wire             pc8001_sub_system_clock_0_out_endofpacket;
  wire             pc8001_sub_system_clock_0_out_granted_gpio0_s1;
  wire    [  1: 0] pc8001_sub_system_clock_0_out_nativeaddress;
  wire             pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1;
  wire             pc8001_sub_system_clock_0_out_read;
  wire             pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1;
  wire    [ 31: 0] pc8001_sub_system_clock_0_out_readdata;
  wire             pc8001_sub_system_clock_0_out_requests_gpio0_s1;
  wire             pc8001_sub_system_clock_0_out_reset_n;
  wire             pc8001_sub_system_clock_0_out_waitrequest;
  wire             pc8001_sub_system_clock_0_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_0_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_1_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_1_in_byteenable;
  wire             pc8001_sub_system_clock_1_in_endofpacket;
  wire             pc8001_sub_system_clock_1_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_1_in_nativeaddress;
  wire             pc8001_sub_system_clock_1_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_1_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_1_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_1_in_reset_n;
  wire             pc8001_sub_system_clock_1_in_waitrequest;
  wire             pc8001_sub_system_clock_1_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_1_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_1_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_1_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_1_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_1_out_byteenable;
  wire             pc8001_sub_system_clock_1_out_endofpacket;
  wire             pc8001_sub_system_clock_1_out_granted_gpio1_s1;
  wire    [  1: 0] pc8001_sub_system_clock_1_out_nativeaddress;
  wire             pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1;
  wire             pc8001_sub_system_clock_1_out_read;
  wire             pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1;
  wire    [ 31: 0] pc8001_sub_system_clock_1_out_readdata;
  wire             pc8001_sub_system_clock_1_out_requests_gpio1_s1;
  wire             pc8001_sub_system_clock_1_out_reset_n;
  wire             pc8001_sub_system_clock_1_out_waitrequest;
  wire             pc8001_sub_system_clock_1_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_1_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_2_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_2_in_byteenable;
  wire             pc8001_sub_system_clock_2_in_endofpacket;
  wire             pc8001_sub_system_clock_2_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_2_in_nativeaddress;
  wire             pc8001_sub_system_clock_2_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_2_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_2_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_2_in_reset_n;
  wire             pc8001_sub_system_clock_2_in_waitrequest;
  wire             pc8001_sub_system_clock_2_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_2_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_2_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_2_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_2_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_2_out_byteenable;
  wire             pc8001_sub_system_clock_2_out_endofpacket;
  wire             pc8001_sub_system_clock_2_out_granted_cmt_dout_s1;
  wire    [  1: 0] pc8001_sub_system_clock_2_out_nativeaddress;
  wire             pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1;
  wire             pc8001_sub_system_clock_2_out_read;
  wire             pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1;
  wire    [ 31: 0] pc8001_sub_system_clock_2_out_readdata;
  wire             pc8001_sub_system_clock_2_out_requests_cmt_dout_s1;
  wire             pc8001_sub_system_clock_2_out_reset_n;
  wire             pc8001_sub_system_clock_2_out_waitrequest;
  wire             pc8001_sub_system_clock_2_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_2_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_3_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_3_in_byteenable;
  wire             pc8001_sub_system_clock_3_in_endofpacket;
  wire             pc8001_sub_system_clock_3_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_3_in_nativeaddress;
  wire             pc8001_sub_system_clock_3_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_3_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_3_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_3_in_reset_n;
  wire             pc8001_sub_system_clock_3_in_waitrequest;
  wire             pc8001_sub_system_clock_3_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_3_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_3_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_3_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_3_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_3_out_byteenable;
  wire             pc8001_sub_system_clock_3_out_endofpacket;
  wire             pc8001_sub_system_clock_3_out_granted_cmt_din_s1;
  wire    [  1: 0] pc8001_sub_system_clock_3_out_nativeaddress;
  wire             pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1;
  wire             pc8001_sub_system_clock_3_out_read;
  wire             pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1;
  wire    [ 31: 0] pc8001_sub_system_clock_3_out_readdata;
  wire             pc8001_sub_system_clock_3_out_requests_cmt_din_s1;
  wire             pc8001_sub_system_clock_3_out_reset_n;
  wire             pc8001_sub_system_clock_3_out_waitrequest;
  wire             pc8001_sub_system_clock_3_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_3_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_4_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_4_in_byteenable;
  wire             pc8001_sub_system_clock_4_in_endofpacket;
  wire             pc8001_sub_system_clock_4_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_4_in_nativeaddress;
  wire             pc8001_sub_system_clock_4_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_4_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_4_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_4_in_reset_n;
  wire             pc8001_sub_system_clock_4_in_waitrequest;
  wire             pc8001_sub_system_clock_4_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_4_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_4_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_4_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_4_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_4_out_byteenable;
  wire             pc8001_sub_system_clock_4_out_endofpacket;
  wire             pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1;
  wire    [  1: 0] pc8001_sub_system_clock_4_out_nativeaddress;
  wire             pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1;
  wire             pc8001_sub_system_clock_4_out_read;
  wire             pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1;
  wire    [ 31: 0] pc8001_sub_system_clock_4_out_readdata;
  wire             pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1;
  wire             pc8001_sub_system_clock_4_out_reset_n;
  wire             pc8001_sub_system_clock_4_out_waitrequest;
  wire             pc8001_sub_system_clock_4_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_4_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_5_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_5_in_byteenable;
  wire             pc8001_sub_system_clock_5_in_endofpacket;
  wire             pc8001_sub_system_clock_5_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_5_in_nativeaddress;
  wire             pc8001_sub_system_clock_5_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_5_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_5_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_5_in_reset_n;
  wire             pc8001_sub_system_clock_5_in_waitrequest;
  wire             pc8001_sub_system_clock_5_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_5_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_5_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_5_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_5_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_5_out_byteenable;
  wire             pc8001_sub_system_clock_5_out_endofpacket;
  wire             pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1;
  wire    [  1: 0] pc8001_sub_system_clock_5_out_nativeaddress;
  wire             pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1;
  wire             pc8001_sub_system_clock_5_out_read;
  wire             pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1;
  wire    [ 31: 0] pc8001_sub_system_clock_5_out_readdata;
  wire             pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1;
  wire             pc8001_sub_system_clock_5_out_reset_n;
  wire             pc8001_sub_system_clock_5_out_waitrequest;
  wire             pc8001_sub_system_clock_5_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_5_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_6_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_6_in_byteenable;
  wire             pc8001_sub_system_clock_6_in_endofpacket;
  wire             pc8001_sub_system_clock_6_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_6_in_nativeaddress;
  wire             pc8001_sub_system_clock_6_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_6_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_6_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_6_in_reset_n;
  wire             pc8001_sub_system_clock_6_in_waitrequest;
  wire             pc8001_sub_system_clock_6_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_6_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_6_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_6_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_6_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_6_out_byteenable;
  wire             pc8001_sub_system_clock_6_out_endofpacket;
  wire             pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0;
  wire    [  1: 0] pc8001_sub_system_clock_6_out_nativeaddress;
  wire             pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0;
  wire             pc8001_sub_system_clock_6_out_read;
  wire             pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0;
  wire    [ 31: 0] pc8001_sub_system_clock_6_out_readdata;
  wire             pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0;
  wire             pc8001_sub_system_clock_6_out_reset_n;
  wire             pc8001_sub_system_clock_6_out_waitrequest;
  wire             pc8001_sub_system_clock_6_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_6_out_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_7_in_address;
  wire    [  3: 0] pc8001_sub_system_clock_7_in_byteenable;
  wire             pc8001_sub_system_clock_7_in_endofpacket;
  wire             pc8001_sub_system_clock_7_in_endofpacket_from_sa;
  wire    [  1: 0] pc8001_sub_system_clock_7_in_nativeaddress;
  wire             pc8001_sub_system_clock_7_in_read;
  wire    [ 31: 0] pc8001_sub_system_clock_7_in_readdata;
  wire    [ 31: 0] pc8001_sub_system_clock_7_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_7_in_reset_n;
  wire             pc8001_sub_system_clock_7_in_waitrequest;
  wire             pc8001_sub_system_clock_7_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_7_in_write;
  wire    [ 31: 0] pc8001_sub_system_clock_7_in_writedata;
  wire    [  3: 0] pc8001_sub_system_clock_7_out_address;
  wire    [  3: 0] pc8001_sub_system_clock_7_out_address_to_slave;
  wire    [  3: 0] pc8001_sub_system_clock_7_out_byteenable;
  wire             pc8001_sub_system_clock_7_out_endofpacket;
  wire             pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave;
  wire    [  1: 0] pc8001_sub_system_clock_7_out_nativeaddress;
  wire             pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave;
  wire             pc8001_sub_system_clock_7_out_read;
  wire             pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave;
  wire    [ 31: 0] pc8001_sub_system_clock_7_out_readdata;
  wire             pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave;
  wire             pc8001_sub_system_clock_7_out_reset_n;
  wire             pc8001_sub_system_clock_7_out_waitrequest;
  wire             pc8001_sub_system_clock_7_out_write;
  wire    [ 31: 0] pc8001_sub_system_clock_7_out_writedata;
  wire    [ 22: 0] pc8001_sub_system_clock_8_in_address;
  wire    [  1: 0] pc8001_sub_system_clock_8_in_byteenable;
  wire             pc8001_sub_system_clock_8_in_endofpacket;
  wire             pc8001_sub_system_clock_8_in_endofpacket_from_sa;
  wire    [ 21: 0] pc8001_sub_system_clock_8_in_nativeaddress;
  wire             pc8001_sub_system_clock_8_in_read;
  wire    [ 15: 0] pc8001_sub_system_clock_8_in_readdata;
  wire    [ 15: 0] pc8001_sub_system_clock_8_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_8_in_reset_n;
  wire             pc8001_sub_system_clock_8_in_waitrequest;
  wire             pc8001_sub_system_clock_8_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_8_in_write;
  wire    [ 15: 0] pc8001_sub_system_clock_8_in_writedata;
  wire    [ 22: 0] pc8001_sub_system_clock_8_out_address;
  wire    [ 22: 0] pc8001_sub_system_clock_8_out_address_to_slave;
  wire    [  1: 0] pc8001_sub_system_clock_8_out_byteenable;
  wire             pc8001_sub_system_clock_8_out_endofpacket;
  wire             pc8001_sub_system_clock_8_out_granted_sdram_s1;
  wire    [ 21: 0] pc8001_sub_system_clock_8_out_nativeaddress;
  wire             pc8001_sub_system_clock_8_out_qualified_request_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_read;
  wire             pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register;
  wire    [ 15: 0] pc8001_sub_system_clock_8_out_readdata;
  wire             pc8001_sub_system_clock_8_out_requests_sdram_s1;
  wire             pc8001_sub_system_clock_8_out_reset_n;
  wire             pc8001_sub_system_clock_8_out_waitrequest;
  wire             pc8001_sub_system_clock_8_out_write;
  wire    [ 15: 0] pc8001_sub_system_clock_8_out_writedata;
  wire    [ 22: 0] pc8001_sub_system_clock_9_in_address;
  wire    [  1: 0] pc8001_sub_system_clock_9_in_byteenable;
  wire             pc8001_sub_system_clock_9_in_endofpacket;
  wire             pc8001_sub_system_clock_9_in_endofpacket_from_sa;
  wire    [ 21: 0] pc8001_sub_system_clock_9_in_nativeaddress;
  wire             pc8001_sub_system_clock_9_in_read;
  wire    [ 15: 0] pc8001_sub_system_clock_9_in_readdata;
  wire    [ 15: 0] pc8001_sub_system_clock_9_in_readdata_from_sa;
  wire             pc8001_sub_system_clock_9_in_reset_n;
  wire             pc8001_sub_system_clock_9_in_waitrequest;
  wire             pc8001_sub_system_clock_9_in_waitrequest_from_sa;
  wire             pc8001_sub_system_clock_9_in_write;
  wire    [ 15: 0] pc8001_sub_system_clock_9_in_writedata;
  wire    [ 22: 0] pc8001_sub_system_clock_9_out_address;
  wire    [ 22: 0] pc8001_sub_system_clock_9_out_address_to_slave;
  wire    [  1: 0] pc8001_sub_system_clock_9_out_byteenable;
  wire             pc8001_sub_system_clock_9_out_endofpacket;
  wire             pc8001_sub_system_clock_9_out_granted_sdram_s1;
  wire    [ 21: 0] pc8001_sub_system_clock_9_out_nativeaddress;
  wire             pc8001_sub_system_clock_9_out_qualified_request_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_read;
  wire             pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register;
  wire    [ 15: 0] pc8001_sub_system_clock_9_out_readdata;
  wire             pc8001_sub_system_clock_9_out_requests_sdram_s1;
  wire             pc8001_sub_system_clock_9_out_reset_n;
  wire             pc8001_sub_system_clock_9_out_waitrequest;
  wire             pc8001_sub_system_clock_9_out_write;
  wire    [ 15: 0] pc8001_sub_system_clock_9_out_writedata;
  wire             phasedone_from_the_sub_system_pll;
  wire             pll_cpu;
  wire             pll_cpu_reset_n;
  wire             pll_io;
  wire             pll_io_reset_n;
  wire             pll_peripheral;
  wire             pll_peripheral_reset_n;
  wire             pll_sdram;
  wire             pll_sdram_reset_n;
  wire             reset_n_sources;
  wire             sce_from_the_epcs_flash_controller;
  wire             sdo_from_the_epcs_flash_controller;
  wire    [ 21: 0] sdram_s1_address;
  wire    [  1: 0] sdram_s1_byteenable_n;
  wire             sdram_s1_chipselect;
  wire             sdram_s1_read_n;
  wire    [ 15: 0] sdram_s1_readdata;
  wire    [ 15: 0] sdram_s1_readdata_from_sa;
  wire             sdram_s1_readdatavalid;
  wire             sdram_s1_reset_n;
  wire             sdram_s1_waitrequest;
  wire             sdram_s1_waitrequest_from_sa;
  wire             sdram_s1_write_n;
  wire    [ 15: 0] sdram_s1_writedata;
  wire    [  1: 0] sub_system_pll_pll_slave_address;
  wire             sub_system_pll_pll_slave_read;
  wire    [ 31: 0] sub_system_pll_pll_slave_readdata;
  wire    [ 31: 0] sub_system_pll_pll_slave_readdata_from_sa;
  wire             sub_system_pll_pll_slave_reset;
  wire             sub_system_pll_pll_slave_write;
  wire    [ 31: 0] sub_system_pll_pll_slave_writedata;
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
  wire    [ 11: 0] zs_addr_from_the_sdram;
  wire    [  1: 0] zs_ba_from_the_sdram;
  wire             zs_cas_n_from_the_sdram;
  wire             zs_cke_from_the_sdram;
  wire             zs_cs_n_from_the_sdram;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram;
  wire    [  1: 0] zs_dqm_from_the_sdram;
  wire             zs_ras_n_from_the_sdram;
  wire             zs_we_n_from_the_sdram;
  cmt_din_s1_arbitrator the_cmt_din_s1
    (
      .clk                                                        (pll_io),
      .cmt_din_s1_address                                         (cmt_din_s1_address),
      .cmt_din_s1_readdata                                        (cmt_din_s1_readdata),
      .cmt_din_s1_readdata_from_sa                                (cmt_din_s1_readdata_from_sa),
      .cmt_din_s1_reset_n                                         (cmt_din_s1_reset_n),
      .d1_cmt_din_s1_end_xfer                                     (d1_cmt_din_s1_end_xfer),
      .pc8001_sub_system_clock_3_out_address_to_slave             (pc8001_sub_system_clock_3_out_address_to_slave),
      .pc8001_sub_system_clock_3_out_granted_cmt_din_s1           (pc8001_sub_system_clock_3_out_granted_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_nativeaddress                (pc8001_sub_system_clock_3_out_nativeaddress),
      .pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1 (pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_read                         (pc8001_sub_system_clock_3_out_read),
      .pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1   (pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_requests_cmt_din_s1          (pc8001_sub_system_clock_3_out_requests_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_write                        (pc8001_sub_system_clock_3_out_write),
      .reset_n                                                    (pll_io_reset_n)
    );

  cmt_din the_cmt_din
    (
      .address  (cmt_din_s1_address),
      .clk      (pll_io),
      .in_port  (in_port_to_the_cmt_din),
      .readdata (cmt_din_s1_readdata),
      .reset_n  (cmt_din_s1_reset_n)
    );

  cmt_dout_s1_arbitrator the_cmt_dout_s1
    (
      .clk                                                         (pll_io),
      .cmt_dout_s1_address                                         (cmt_dout_s1_address),
      .cmt_dout_s1_chipselect                                      (cmt_dout_s1_chipselect),
      .cmt_dout_s1_readdata                                        (cmt_dout_s1_readdata),
      .cmt_dout_s1_readdata_from_sa                                (cmt_dout_s1_readdata_from_sa),
      .cmt_dout_s1_reset_n                                         (cmt_dout_s1_reset_n),
      .cmt_dout_s1_write_n                                         (cmt_dout_s1_write_n),
      .cmt_dout_s1_writedata                                       (cmt_dout_s1_writedata),
      .d1_cmt_dout_s1_end_xfer                                     (d1_cmt_dout_s1_end_xfer),
      .pc8001_sub_system_clock_2_out_address_to_slave              (pc8001_sub_system_clock_2_out_address_to_slave),
      .pc8001_sub_system_clock_2_out_granted_cmt_dout_s1           (pc8001_sub_system_clock_2_out_granted_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_nativeaddress                 (pc8001_sub_system_clock_2_out_nativeaddress),
      .pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1 (pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_read                          (pc8001_sub_system_clock_2_out_read),
      .pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1   (pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_requests_cmt_dout_s1          (pc8001_sub_system_clock_2_out_requests_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_write                         (pc8001_sub_system_clock_2_out_write),
      .pc8001_sub_system_clock_2_out_writedata                     (pc8001_sub_system_clock_2_out_writedata),
      .reset_n                                                     (pll_io_reset_n)
    );

  cmt_dout the_cmt_dout
    (
      .address    (cmt_dout_s1_address),
      .chipselect (cmt_dout_s1_chipselect),
      .clk        (pll_io),
      .out_port   (out_port_from_the_cmt_dout),
      .readdata   (cmt_dout_s1_readdata),
      .reset_n    (cmt_dout_s1_reset_n),
      .write_n    (cmt_dout_s1_write_n),
      .writedata  (cmt_dout_s1_writedata)
    );

  cmt_gpio_in_s1_arbitrator the_cmt_gpio_in_s1
    (
      .clk                                                            (pll_io),
      .cmt_gpio_in_s1_address                                         (cmt_gpio_in_s1_address),
      .cmt_gpio_in_s1_readdata                                        (cmt_gpio_in_s1_readdata),
      .cmt_gpio_in_s1_readdata_from_sa                                (cmt_gpio_in_s1_readdata_from_sa),
      .cmt_gpio_in_s1_reset_n                                         (cmt_gpio_in_s1_reset_n),
      .d1_cmt_gpio_in_s1_end_xfer                                     (d1_cmt_gpio_in_s1_end_xfer),
      .pc8001_sub_system_clock_5_out_address_to_slave                 (pc8001_sub_system_clock_5_out_address_to_slave),
      .pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1           (pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_nativeaddress                    (pc8001_sub_system_clock_5_out_nativeaddress),
      .pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1 (pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_read                             (pc8001_sub_system_clock_5_out_read),
      .pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1   (pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1          (pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_write                            (pc8001_sub_system_clock_5_out_write),
      .reset_n                                                        (pll_io_reset_n)
    );

  cmt_gpio_in the_cmt_gpio_in
    (
      .address  (cmt_gpio_in_s1_address),
      .clk      (pll_io),
      .in_port  (in_port_to_the_cmt_gpio_in),
      .readdata (cmt_gpio_in_s1_readdata),
      .reset_n  (cmt_gpio_in_s1_reset_n)
    );

  cmt_gpio_out_s1_arbitrator the_cmt_gpio_out_s1
    (
      .clk                                                             (pll_io),
      .cmt_gpio_out_s1_address                                         (cmt_gpio_out_s1_address),
      .cmt_gpio_out_s1_chipselect                                      (cmt_gpio_out_s1_chipselect),
      .cmt_gpio_out_s1_readdata                                        (cmt_gpio_out_s1_readdata),
      .cmt_gpio_out_s1_readdata_from_sa                                (cmt_gpio_out_s1_readdata_from_sa),
      .cmt_gpio_out_s1_reset_n                                         (cmt_gpio_out_s1_reset_n),
      .cmt_gpio_out_s1_write_n                                         (cmt_gpio_out_s1_write_n),
      .cmt_gpio_out_s1_writedata                                       (cmt_gpio_out_s1_writedata),
      .d1_cmt_gpio_out_s1_end_xfer                                     (d1_cmt_gpio_out_s1_end_xfer),
      .pc8001_sub_system_clock_4_out_address_to_slave                  (pc8001_sub_system_clock_4_out_address_to_slave),
      .pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1           (pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_nativeaddress                     (pc8001_sub_system_clock_4_out_nativeaddress),
      .pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1 (pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_read                              (pc8001_sub_system_clock_4_out_read),
      .pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1   (pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1          (pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_write                             (pc8001_sub_system_clock_4_out_write),
      .pc8001_sub_system_clock_4_out_writedata                         (pc8001_sub_system_clock_4_out_writedata),
      .reset_n                                                         (pll_io_reset_n)
    );

  cmt_gpio_out the_cmt_gpio_out
    (
      .address    (cmt_gpio_out_s1_address),
      .chipselect (cmt_gpio_out_s1_chipselect),
      .clk        (pll_io),
      .out_port   (out_port_from_the_cmt_gpio_out),
      .readdata   (cmt_gpio_out_s1_readdata),
      .reset_n    (cmt_gpio_out_s1_reset_n),
      .write_n    (cmt_gpio_out_s1_write_n),
      .writedata  (cmt_gpio_out_s1_writedata)
    );

  epcs_flash_controller_epcs_control_port_arbitrator the_epcs_flash_controller_epcs_control_port
    (
      .clk                                                                                (pll_cpu),
      .d1_epcs_flash_controller_epcs_control_port_end_xfer                                (d1_epcs_flash_controller_epcs_control_port_end_xfer),
      .epcs_flash_controller_epcs_control_port_address                                    (epcs_flash_controller_epcs_control_port_address),
      .epcs_flash_controller_epcs_control_port_chipselect                                 (epcs_flash_controller_epcs_control_port_chipselect),
      .epcs_flash_controller_epcs_control_port_dataavailable                              (epcs_flash_controller_epcs_control_port_dataavailable),
      .epcs_flash_controller_epcs_control_port_dataavailable_from_sa                      (epcs_flash_controller_epcs_control_port_dataavailable_from_sa),
      .epcs_flash_controller_epcs_control_port_endofpacket                                (epcs_flash_controller_epcs_control_port_endofpacket),
      .epcs_flash_controller_epcs_control_port_endofpacket_from_sa                        (epcs_flash_controller_epcs_control_port_endofpacket_from_sa),
      .epcs_flash_controller_epcs_control_port_irq                                        (epcs_flash_controller_epcs_control_port_irq),
      .epcs_flash_controller_epcs_control_port_irq_from_sa                                (epcs_flash_controller_epcs_control_port_irq_from_sa),
      .epcs_flash_controller_epcs_control_port_read_n                                     (epcs_flash_controller_epcs_control_port_read_n),
      .epcs_flash_controller_epcs_control_port_readdata                                   (epcs_flash_controller_epcs_control_port_readdata),
      .epcs_flash_controller_epcs_control_port_readdata_from_sa                           (epcs_flash_controller_epcs_control_port_readdata_from_sa),
      .epcs_flash_controller_epcs_control_port_readyfordata                               (epcs_flash_controller_epcs_control_port_readyfordata),
      .epcs_flash_controller_epcs_control_port_readyfordata_from_sa                       (epcs_flash_controller_epcs_control_port_readyfordata_from_sa),
      .epcs_flash_controller_epcs_control_port_reset_n                                    (epcs_flash_controller_epcs_control_port_reset_n),
      .epcs_flash_controller_epcs_control_port_write_n                                    (epcs_flash_controller_epcs_control_port_write_n),
      .epcs_flash_controller_epcs_control_port_writedata                                  (epcs_flash_controller_epcs_control_port_writedata),
      .nios2_data_master_address_to_slave                                                 (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_epcs_flash_controller_epcs_control_port                  (nios2_data_master_granted_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port        (nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_read                                                             (nios2_data_master_read),
      .nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port          (nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_requests_epcs_flash_controller_epcs_control_port                 (nios2_data_master_requests_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_write                                                            (nios2_data_master_write),
      .nios2_data_master_writedata                                                        (nios2_data_master_writedata),
      .nios2_instruction_master_address_to_slave                                          (nios2_instruction_master_address_to_slave),
      .nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port           (nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port (nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_read                                                      (nios2_instruction_master_read),
      .nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port   (nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port          (nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port),
      .reset_n                                                                            (pll_cpu_reset_n)
    );

  epcs_flash_controller the_epcs_flash_controller
    (
      .address       (epcs_flash_controller_epcs_control_port_address),
      .chipselect    (epcs_flash_controller_epcs_control_port_chipselect),
      .clk           (pll_cpu),
      .data0         (data0_to_the_epcs_flash_controller),
      .dataavailable (epcs_flash_controller_epcs_control_port_dataavailable),
      .dclk          (dclk_from_the_epcs_flash_controller),
      .endofpacket   (epcs_flash_controller_epcs_control_port_endofpacket),
      .irq           (epcs_flash_controller_epcs_control_port_irq),
      .read_n        (epcs_flash_controller_epcs_control_port_read_n),
      .readdata      (epcs_flash_controller_epcs_control_port_readdata),
      .readyfordata  (epcs_flash_controller_epcs_control_port_readyfordata),
      .reset_n       (epcs_flash_controller_epcs_control_port_reset_n),
      .sce           (sce_from_the_epcs_flash_controller),
      .sdo           (sdo_from_the_epcs_flash_controller),
      .write_n       (epcs_flash_controller_epcs_control_port_write_n),
      .writedata     (epcs_flash_controller_epcs_control_port_writedata)
    );

  gpio0_s1_arbitrator the_gpio0_s1
    (
      .clk                                                      (pll_io),
      .d1_gpio0_s1_end_xfer                                     (d1_gpio0_s1_end_xfer),
      .gpio0_s1_address                                         (gpio0_s1_address),
      .gpio0_s1_chipselect                                      (gpio0_s1_chipselect),
      .gpio0_s1_readdata                                        (gpio0_s1_readdata),
      .gpio0_s1_readdata_from_sa                                (gpio0_s1_readdata_from_sa),
      .gpio0_s1_reset_n                                         (gpio0_s1_reset_n),
      .gpio0_s1_write_n                                         (gpio0_s1_write_n),
      .gpio0_s1_writedata                                       (gpio0_s1_writedata),
      .pc8001_sub_system_clock_0_out_address_to_slave           (pc8001_sub_system_clock_0_out_address_to_slave),
      .pc8001_sub_system_clock_0_out_granted_gpio0_s1           (pc8001_sub_system_clock_0_out_granted_gpio0_s1),
      .pc8001_sub_system_clock_0_out_nativeaddress              (pc8001_sub_system_clock_0_out_nativeaddress),
      .pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1 (pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1),
      .pc8001_sub_system_clock_0_out_read                       (pc8001_sub_system_clock_0_out_read),
      .pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1   (pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1),
      .pc8001_sub_system_clock_0_out_requests_gpio0_s1          (pc8001_sub_system_clock_0_out_requests_gpio0_s1),
      .pc8001_sub_system_clock_0_out_write                      (pc8001_sub_system_clock_0_out_write),
      .pc8001_sub_system_clock_0_out_writedata                  (pc8001_sub_system_clock_0_out_writedata),
      .reset_n                                                  (pll_io_reset_n)
    );

  gpio0 the_gpio0
    (
      .address    (gpio0_s1_address),
      .chipselect (gpio0_s1_chipselect),
      .clk        (pll_io),
      .out_port   (out_port_from_the_gpio0),
      .readdata   (gpio0_s1_readdata),
      .reset_n    (gpio0_s1_reset_n),
      .write_n    (gpio0_s1_write_n),
      .writedata  (gpio0_s1_writedata)
    );

  gpio1_s1_arbitrator the_gpio1_s1
    (
      .clk                                                      (pll_io),
      .d1_gpio1_s1_end_xfer                                     (d1_gpio1_s1_end_xfer),
      .gpio1_s1_address                                         (gpio1_s1_address),
      .gpio1_s1_readdata                                        (gpio1_s1_readdata),
      .gpio1_s1_readdata_from_sa                                (gpio1_s1_readdata_from_sa),
      .gpio1_s1_reset_n                                         (gpio1_s1_reset_n),
      .pc8001_sub_system_clock_1_out_address_to_slave           (pc8001_sub_system_clock_1_out_address_to_slave),
      .pc8001_sub_system_clock_1_out_granted_gpio1_s1           (pc8001_sub_system_clock_1_out_granted_gpio1_s1),
      .pc8001_sub_system_clock_1_out_nativeaddress              (pc8001_sub_system_clock_1_out_nativeaddress),
      .pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1 (pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1),
      .pc8001_sub_system_clock_1_out_read                       (pc8001_sub_system_clock_1_out_read),
      .pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1   (pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1),
      .pc8001_sub_system_clock_1_out_requests_gpio1_s1          (pc8001_sub_system_clock_1_out_requests_gpio1_s1),
      .pc8001_sub_system_clock_1_out_write                      (pc8001_sub_system_clock_1_out_write),
      .reset_n                                                  (pll_io_reset_n)
    );

  gpio1 the_gpio1
    (
      .address  (gpio1_s1_address),
      .clk      (pll_io),
      .in_port  (in_port_to_the_gpio1),
      .readdata (gpio1_s1_readdata),
      .reset_n  (gpio1_s1_reset_n)
    );

  jtag_uart_avalon_jtag_slave_arbitrator the_jtag_uart_avalon_jtag_slave
    (
      .clk                                                             (pll_cpu),
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
      .reset_n                                                         (pll_cpu_reset_n)
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
      .clk            (pll_cpu),
      .dataavailable  (jtag_uart_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_avalon_jtag_slave_reset_n)
    );

  mmc_spi_avalon_slave_0_arbitrator the_mmc_spi_avalon_slave_0
    (
      .clk                                                                    (pll_peripheral),
      .d1_mmc_spi_avalon_slave_0_end_xfer                                     (d1_mmc_spi_avalon_slave_0_end_xfer),
      .mmc_spi_avalon_slave_0_address                                         (mmc_spi_avalon_slave_0_address),
      .mmc_spi_avalon_slave_0_chipselect                                      (mmc_spi_avalon_slave_0_chipselect),
      .mmc_spi_avalon_slave_0_irq                                             (mmc_spi_avalon_slave_0_irq),
      .mmc_spi_avalon_slave_0_irq_from_sa                                     (mmc_spi_avalon_slave_0_irq_from_sa),
      .mmc_spi_avalon_slave_0_read                                            (mmc_spi_avalon_slave_0_read),
      .mmc_spi_avalon_slave_0_readdata                                        (mmc_spi_avalon_slave_0_readdata),
      .mmc_spi_avalon_slave_0_readdata_from_sa                                (mmc_spi_avalon_slave_0_readdata_from_sa),
      .mmc_spi_avalon_slave_0_reset                                           (mmc_spi_avalon_slave_0_reset),
      .mmc_spi_avalon_slave_0_write                                           (mmc_spi_avalon_slave_0_write),
      .mmc_spi_avalon_slave_0_writedata                                       (mmc_spi_avalon_slave_0_writedata),
      .pc8001_sub_system_clock_6_out_address_to_slave                         (pc8001_sub_system_clock_6_out_address_to_slave),
      .pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0           (pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0 (pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_read                                     (pc8001_sub_system_clock_6_out_read),
      .pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0   (pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0          (pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_write                                    (pc8001_sub_system_clock_6_out_write),
      .pc8001_sub_system_clock_6_out_writedata                                (pc8001_sub_system_clock_6_out_writedata),
      .reset_n                                                                (pll_peripheral_reset_n)
    );

  mmc_spi the_mmc_spi
    (
      .MMC_CD     (MMC_CD_to_the_mmc_spi),
      .MMC_SCK    (MMC_SCK_from_the_mmc_spi),
      .MMC_SDI    (MMC_SDI_to_the_mmc_spi),
      .MMC_SDO    (MMC_SDO_from_the_mmc_spi),
      .MMC_WP     (MMC_WP_to_the_mmc_spi),
      .MMC_nCS    (MMC_nCS_from_the_mmc_spi),
      .address    (mmc_spi_avalon_slave_0_address),
      .chipselect (mmc_spi_avalon_slave_0_chipselect),
      .clk        (pll_peripheral),
      .irq        (mmc_spi_avalon_slave_0_irq),
      .read       (mmc_spi_avalon_slave_0_read),
      .readdata   (mmc_spi_avalon_slave_0_readdata),
      .reset      (mmc_spi_avalon_slave_0_reset),
      .write      (mmc_spi_avalon_slave_0_write),
      .writedata  (mmc_spi_avalon_slave_0_writedata)
    );

  nios2_jtag_debug_module_arbitrator the_nios2_jtag_debug_module
    (
      .clk                                                                (pll_cpu),
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
      .reset_n                                                            (pll_cpu_reset_n)
    );

  nios2_data_master_arbitrator the_nios2_data_master
    (
      .clk                                                                         (pll_cpu),
      .d1_epcs_flash_controller_epcs_control_port_end_xfer                         (d1_epcs_flash_controller_epcs_control_port_end_xfer),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                                     (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .d1_nios2_jtag_debug_module_end_xfer                                         (d1_nios2_jtag_debug_module_end_xfer),
      .d1_pc8001_sub_system_clock_0_in_end_xfer                                    (d1_pc8001_sub_system_clock_0_in_end_xfer),
      .d1_pc8001_sub_system_clock_1_in_end_xfer                                    (d1_pc8001_sub_system_clock_1_in_end_xfer),
      .d1_pc8001_sub_system_clock_2_in_end_xfer                                    (d1_pc8001_sub_system_clock_2_in_end_xfer),
      .d1_pc8001_sub_system_clock_3_in_end_xfer                                    (d1_pc8001_sub_system_clock_3_in_end_xfer),
      .d1_pc8001_sub_system_clock_4_in_end_xfer                                    (d1_pc8001_sub_system_clock_4_in_end_xfer),
      .d1_pc8001_sub_system_clock_5_in_end_xfer                                    (d1_pc8001_sub_system_clock_5_in_end_xfer),
      .d1_pc8001_sub_system_clock_6_in_end_xfer                                    (d1_pc8001_sub_system_clock_6_in_end_xfer),
      .d1_pc8001_sub_system_clock_7_in_end_xfer                                    (d1_pc8001_sub_system_clock_7_in_end_xfer),
      .d1_pc8001_sub_system_clock_9_in_end_xfer                                    (d1_pc8001_sub_system_clock_9_in_end_xfer),
      .d1_sysid_control_slave_end_xfer                                             (d1_sysid_control_slave_end_xfer),
      .d1_timer_0_s1_end_xfer                                                      (d1_timer_0_s1_end_xfer),
      .epcs_flash_controller_epcs_control_port_irq_from_sa                         (epcs_flash_controller_epcs_control_port_irq_from_sa),
      .epcs_flash_controller_epcs_control_port_readdata_from_sa                    (epcs_flash_controller_epcs_control_port_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                                     (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                                (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                             (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .mmc_spi_avalon_slave_0_irq_from_sa                                          (mmc_spi_avalon_slave_0_irq_from_sa),
      .nios2_data_master_address                                                   (nios2_data_master_address),
      .nios2_data_master_address_to_slave                                          (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable_pc8001_sub_system_clock_9_in                   (nios2_data_master_byteenable_pc8001_sub_system_clock_9_in),
      .nios2_data_master_dbs_address                                               (nios2_data_master_dbs_address),
      .nios2_data_master_dbs_write_16                                              (nios2_data_master_dbs_write_16),
      .nios2_data_master_granted_epcs_flash_controller_epcs_control_port           (nios2_data_master_granted_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_granted_jtag_uart_avalon_jtag_slave                       (nios2_data_master_granted_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_granted_nios2_jtag_debug_module                           (nios2_data_master_granted_nios2_jtag_debug_module),
      .nios2_data_master_granted_pc8001_sub_system_clock_0_in                      (nios2_data_master_granted_pc8001_sub_system_clock_0_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_1_in                      (nios2_data_master_granted_pc8001_sub_system_clock_1_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_2_in                      (nios2_data_master_granted_pc8001_sub_system_clock_2_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_3_in                      (nios2_data_master_granted_pc8001_sub_system_clock_3_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_4_in                      (nios2_data_master_granted_pc8001_sub_system_clock_4_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_5_in                      (nios2_data_master_granted_pc8001_sub_system_clock_5_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_6_in                      (nios2_data_master_granted_pc8001_sub_system_clock_6_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_7_in                      (nios2_data_master_granted_pc8001_sub_system_clock_7_in),
      .nios2_data_master_granted_pc8001_sub_system_clock_9_in                      (nios2_data_master_granted_pc8001_sub_system_clock_9_in),
      .nios2_data_master_granted_sysid_control_slave                               (nios2_data_master_granted_sysid_control_slave),
      .nios2_data_master_granted_timer_0_s1                                        (nios2_data_master_granted_timer_0_s1),
      .nios2_data_master_irq                                                       (nios2_data_master_irq),
      .nios2_data_master_no_byte_enables_and_last_term                             (nios2_data_master_no_byte_enables_and_last_term),
      .nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port (nios2_data_master_qualified_request_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave             (nios2_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_qualified_request_nios2_jtag_debug_module                 (nios2_data_master_qualified_request_nios2_jtag_debug_module),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in            (nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in),
      .nios2_data_master_qualified_request_sysid_control_slave                     (nios2_data_master_qualified_request_sysid_control_slave),
      .nios2_data_master_qualified_request_timer_0_s1                              (nios2_data_master_qualified_request_timer_0_s1),
      .nios2_data_master_read                                                      (nios2_data_master_read),
      .nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port   (nios2_data_master_read_data_valid_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave               (nios2_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_read_data_valid_nios2_jtag_debug_module                   (nios2_data_master_read_data_valid_nios2_jtag_debug_module),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in              (nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in),
      .nios2_data_master_read_data_valid_sysid_control_slave                       (nios2_data_master_read_data_valid_sysid_control_slave),
      .nios2_data_master_read_data_valid_timer_0_s1                                (nios2_data_master_read_data_valid_timer_0_s1),
      .nios2_data_master_readdata                                                  (nios2_data_master_readdata),
      .nios2_data_master_requests_epcs_flash_controller_epcs_control_port          (nios2_data_master_requests_epcs_flash_controller_epcs_control_port),
      .nios2_data_master_requests_jtag_uart_avalon_jtag_slave                      (nios2_data_master_requests_jtag_uart_avalon_jtag_slave),
      .nios2_data_master_requests_nios2_jtag_debug_module                          (nios2_data_master_requests_nios2_jtag_debug_module),
      .nios2_data_master_requests_pc8001_sub_system_clock_0_in                     (nios2_data_master_requests_pc8001_sub_system_clock_0_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_1_in                     (nios2_data_master_requests_pc8001_sub_system_clock_1_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_2_in                     (nios2_data_master_requests_pc8001_sub_system_clock_2_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_3_in                     (nios2_data_master_requests_pc8001_sub_system_clock_3_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_4_in                     (nios2_data_master_requests_pc8001_sub_system_clock_4_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_5_in                     (nios2_data_master_requests_pc8001_sub_system_clock_5_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_6_in                     (nios2_data_master_requests_pc8001_sub_system_clock_6_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_7_in                     (nios2_data_master_requests_pc8001_sub_system_clock_7_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_9_in                     (nios2_data_master_requests_pc8001_sub_system_clock_9_in),
      .nios2_data_master_requests_sysid_control_slave                              (nios2_data_master_requests_sysid_control_slave),
      .nios2_data_master_requests_timer_0_s1                                       (nios2_data_master_requests_timer_0_s1),
      .nios2_data_master_waitrequest                                               (nios2_data_master_waitrequest),
      .nios2_data_master_write                                                     (nios2_data_master_write),
      .nios2_data_master_writedata                                                 (nios2_data_master_writedata),
      .nios2_jtag_debug_module_readdata_from_sa                                    (nios2_jtag_debug_module_readdata_from_sa),
      .pc8001_sub_system_clock_0_in_readdata_from_sa                               (pc8001_sub_system_clock_0_in_readdata_from_sa),
      .pc8001_sub_system_clock_0_in_waitrequest_from_sa                            (pc8001_sub_system_clock_0_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_1_in_readdata_from_sa                               (pc8001_sub_system_clock_1_in_readdata_from_sa),
      .pc8001_sub_system_clock_1_in_waitrequest_from_sa                            (pc8001_sub_system_clock_1_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_2_in_readdata_from_sa                               (pc8001_sub_system_clock_2_in_readdata_from_sa),
      .pc8001_sub_system_clock_2_in_waitrequest_from_sa                            (pc8001_sub_system_clock_2_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_3_in_readdata_from_sa                               (pc8001_sub_system_clock_3_in_readdata_from_sa),
      .pc8001_sub_system_clock_3_in_waitrequest_from_sa                            (pc8001_sub_system_clock_3_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_4_in_readdata_from_sa                               (pc8001_sub_system_clock_4_in_readdata_from_sa),
      .pc8001_sub_system_clock_4_in_waitrequest_from_sa                            (pc8001_sub_system_clock_4_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_5_in_readdata_from_sa                               (pc8001_sub_system_clock_5_in_readdata_from_sa),
      .pc8001_sub_system_clock_5_in_waitrequest_from_sa                            (pc8001_sub_system_clock_5_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_6_in_readdata_from_sa                               (pc8001_sub_system_clock_6_in_readdata_from_sa),
      .pc8001_sub_system_clock_6_in_waitrequest_from_sa                            (pc8001_sub_system_clock_6_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_7_in_readdata_from_sa                               (pc8001_sub_system_clock_7_in_readdata_from_sa),
      .pc8001_sub_system_clock_7_in_waitrequest_from_sa                            (pc8001_sub_system_clock_7_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_9_in_readdata_from_sa                               (pc8001_sub_system_clock_9_in_readdata_from_sa),
      .pc8001_sub_system_clock_9_in_waitrequest_from_sa                            (pc8001_sub_system_clock_9_in_waitrequest_from_sa),
      .pll_cpu                                                                     (pll_cpu),
      .pll_cpu_reset_n                                                             (pll_cpu_reset_n),
      .reset_n                                                                     (pll_cpu_reset_n),
      .sysid_control_slave_readdata_from_sa                                        (sysid_control_slave_readdata_from_sa),
      .timer_0_s1_irq_from_sa                                                      (timer_0_s1_irq_from_sa),
      .timer_0_s1_readdata_from_sa                                                 (timer_0_s1_readdata_from_sa)
    );

  nios2_instruction_master_arbitrator the_nios2_instruction_master
    (
      .clk                                                                                (pll_cpu),
      .d1_epcs_flash_controller_epcs_control_port_end_xfer                                (d1_epcs_flash_controller_epcs_control_port_end_xfer),
      .d1_nios2_jtag_debug_module_end_xfer                                                (d1_nios2_jtag_debug_module_end_xfer),
      .d1_pc8001_sub_system_clock_8_in_end_xfer                                           (d1_pc8001_sub_system_clock_8_in_end_xfer),
      .epcs_flash_controller_epcs_control_port_readdata_from_sa                           (epcs_flash_controller_epcs_control_port_readdata_from_sa),
      .nios2_instruction_master_address                                                   (nios2_instruction_master_address),
      .nios2_instruction_master_address_to_slave                                          (nios2_instruction_master_address_to_slave),
      .nios2_instruction_master_dbs_address                                               (nios2_instruction_master_dbs_address),
      .nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port           (nios2_instruction_master_granted_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_granted_nios2_jtag_debug_module                           (nios2_instruction_master_granted_nios2_jtag_debug_module),
      .nios2_instruction_master_granted_pc8001_sub_system_clock_8_in                      (nios2_instruction_master_granted_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port (nios2_instruction_master_qualified_request_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_qualified_request_nios2_jtag_debug_module                 (nios2_instruction_master_qualified_request_nios2_jtag_debug_module),
      .nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in            (nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_read                                                      (nios2_instruction_master_read),
      .nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port   (nios2_instruction_master_read_data_valid_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_read_data_valid_nios2_jtag_debug_module                   (nios2_instruction_master_read_data_valid_nios2_jtag_debug_module),
      .nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in              (nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_readdata                                                  (nios2_instruction_master_readdata),
      .nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port          (nios2_instruction_master_requests_epcs_flash_controller_epcs_control_port),
      .nios2_instruction_master_requests_nios2_jtag_debug_module                          (nios2_instruction_master_requests_nios2_jtag_debug_module),
      .nios2_instruction_master_requests_pc8001_sub_system_clock_8_in                     (nios2_instruction_master_requests_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_waitrequest                                               (nios2_instruction_master_waitrequest),
      .nios2_jtag_debug_module_readdata_from_sa                                           (nios2_jtag_debug_module_readdata_from_sa),
      .pc8001_sub_system_clock_8_in_readdata_from_sa                                      (pc8001_sub_system_clock_8_in_readdata_from_sa),
      .pc8001_sub_system_clock_8_in_waitrequest_from_sa                                   (pc8001_sub_system_clock_8_in_waitrequest_from_sa),
      .reset_n                                                                            (pll_cpu_reset_n)
    );

  nios2 the_nios2
    (
      .clk                                   (pll_cpu),
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

  pc8001_sub_system_clock_0_in_arbitrator the_pc8001_sub_system_clock_0_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_0_in_end_xfer                         (d1_pc8001_sub_system_clock_0_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_0_in           (nios2_data_master_granted_pc8001_sub_system_clock_0_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_0_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_0_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_0_in          (nios2_data_master_requests_pc8001_sub_system_clock_0_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_0_in_address                             (pc8001_sub_system_clock_0_in_address),
      .pc8001_sub_system_clock_0_in_byteenable                          (pc8001_sub_system_clock_0_in_byteenable),
      .pc8001_sub_system_clock_0_in_endofpacket                         (pc8001_sub_system_clock_0_in_endofpacket),
      .pc8001_sub_system_clock_0_in_endofpacket_from_sa                 (pc8001_sub_system_clock_0_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_0_in_nativeaddress                       (pc8001_sub_system_clock_0_in_nativeaddress),
      .pc8001_sub_system_clock_0_in_read                                (pc8001_sub_system_clock_0_in_read),
      .pc8001_sub_system_clock_0_in_readdata                            (pc8001_sub_system_clock_0_in_readdata),
      .pc8001_sub_system_clock_0_in_readdata_from_sa                    (pc8001_sub_system_clock_0_in_readdata_from_sa),
      .pc8001_sub_system_clock_0_in_reset_n                             (pc8001_sub_system_clock_0_in_reset_n),
      .pc8001_sub_system_clock_0_in_waitrequest                         (pc8001_sub_system_clock_0_in_waitrequest),
      .pc8001_sub_system_clock_0_in_waitrequest_from_sa                 (pc8001_sub_system_clock_0_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_0_in_write                               (pc8001_sub_system_clock_0_in_write),
      .pc8001_sub_system_clock_0_in_writedata                           (pc8001_sub_system_clock_0_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_0_out_arbitrator the_pc8001_sub_system_clock_0_out
    (
      .clk                                                      (pll_io),
      .d1_gpio0_s1_end_xfer                                     (d1_gpio0_s1_end_xfer),
      .gpio0_s1_readdata_from_sa                                (gpio0_s1_readdata_from_sa),
      .pc8001_sub_system_clock_0_out_address                    (pc8001_sub_system_clock_0_out_address),
      .pc8001_sub_system_clock_0_out_address_to_slave           (pc8001_sub_system_clock_0_out_address_to_slave),
      .pc8001_sub_system_clock_0_out_byteenable                 (pc8001_sub_system_clock_0_out_byteenable),
      .pc8001_sub_system_clock_0_out_granted_gpio0_s1           (pc8001_sub_system_clock_0_out_granted_gpio0_s1),
      .pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1 (pc8001_sub_system_clock_0_out_qualified_request_gpio0_s1),
      .pc8001_sub_system_clock_0_out_read                       (pc8001_sub_system_clock_0_out_read),
      .pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1   (pc8001_sub_system_clock_0_out_read_data_valid_gpio0_s1),
      .pc8001_sub_system_clock_0_out_readdata                   (pc8001_sub_system_clock_0_out_readdata),
      .pc8001_sub_system_clock_0_out_requests_gpio0_s1          (pc8001_sub_system_clock_0_out_requests_gpio0_s1),
      .pc8001_sub_system_clock_0_out_reset_n                    (pc8001_sub_system_clock_0_out_reset_n),
      .pc8001_sub_system_clock_0_out_waitrequest                (pc8001_sub_system_clock_0_out_waitrequest),
      .pc8001_sub_system_clock_0_out_write                      (pc8001_sub_system_clock_0_out_write),
      .pc8001_sub_system_clock_0_out_writedata                  (pc8001_sub_system_clock_0_out_writedata),
      .reset_n                                                  (pll_io_reset_n)
    );

  pc8001_sub_system_clock_0 the_pc8001_sub_system_clock_0
    (
      .master_address       (pc8001_sub_system_clock_0_out_address),
      .master_byteenable    (pc8001_sub_system_clock_0_out_byteenable),
      .master_clk           (pll_io),
      .master_endofpacket   (pc8001_sub_system_clock_0_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_0_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_0_out_read),
      .master_readdata      (pc8001_sub_system_clock_0_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_0_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_0_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_0_out_write),
      .master_writedata     (pc8001_sub_system_clock_0_out_writedata),
      .slave_address        (pc8001_sub_system_clock_0_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_0_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_0_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_0_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_0_in_read),
      .slave_readdata       (pc8001_sub_system_clock_0_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_0_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_0_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_0_in_write),
      .slave_writedata      (pc8001_sub_system_clock_0_in_writedata)
    );

  pc8001_sub_system_clock_1_in_arbitrator the_pc8001_sub_system_clock_1_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_1_in_end_xfer                         (d1_pc8001_sub_system_clock_1_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_1_in           (nios2_data_master_granted_pc8001_sub_system_clock_1_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_1_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_1_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_1_in          (nios2_data_master_requests_pc8001_sub_system_clock_1_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_1_in_address                             (pc8001_sub_system_clock_1_in_address),
      .pc8001_sub_system_clock_1_in_byteenable                          (pc8001_sub_system_clock_1_in_byteenable),
      .pc8001_sub_system_clock_1_in_endofpacket                         (pc8001_sub_system_clock_1_in_endofpacket),
      .pc8001_sub_system_clock_1_in_endofpacket_from_sa                 (pc8001_sub_system_clock_1_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_1_in_nativeaddress                       (pc8001_sub_system_clock_1_in_nativeaddress),
      .pc8001_sub_system_clock_1_in_read                                (pc8001_sub_system_clock_1_in_read),
      .pc8001_sub_system_clock_1_in_readdata                            (pc8001_sub_system_clock_1_in_readdata),
      .pc8001_sub_system_clock_1_in_readdata_from_sa                    (pc8001_sub_system_clock_1_in_readdata_from_sa),
      .pc8001_sub_system_clock_1_in_reset_n                             (pc8001_sub_system_clock_1_in_reset_n),
      .pc8001_sub_system_clock_1_in_waitrequest                         (pc8001_sub_system_clock_1_in_waitrequest),
      .pc8001_sub_system_clock_1_in_waitrequest_from_sa                 (pc8001_sub_system_clock_1_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_1_in_write                               (pc8001_sub_system_clock_1_in_write),
      .pc8001_sub_system_clock_1_in_writedata                           (pc8001_sub_system_clock_1_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_1_out_arbitrator the_pc8001_sub_system_clock_1_out
    (
      .clk                                                      (pll_io),
      .d1_gpio1_s1_end_xfer                                     (d1_gpio1_s1_end_xfer),
      .gpio1_s1_readdata_from_sa                                (gpio1_s1_readdata_from_sa),
      .pc8001_sub_system_clock_1_out_address                    (pc8001_sub_system_clock_1_out_address),
      .pc8001_sub_system_clock_1_out_address_to_slave           (pc8001_sub_system_clock_1_out_address_to_slave),
      .pc8001_sub_system_clock_1_out_byteenable                 (pc8001_sub_system_clock_1_out_byteenable),
      .pc8001_sub_system_clock_1_out_granted_gpio1_s1           (pc8001_sub_system_clock_1_out_granted_gpio1_s1),
      .pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1 (pc8001_sub_system_clock_1_out_qualified_request_gpio1_s1),
      .pc8001_sub_system_clock_1_out_read                       (pc8001_sub_system_clock_1_out_read),
      .pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1   (pc8001_sub_system_clock_1_out_read_data_valid_gpio1_s1),
      .pc8001_sub_system_clock_1_out_readdata                   (pc8001_sub_system_clock_1_out_readdata),
      .pc8001_sub_system_clock_1_out_requests_gpio1_s1          (pc8001_sub_system_clock_1_out_requests_gpio1_s1),
      .pc8001_sub_system_clock_1_out_reset_n                    (pc8001_sub_system_clock_1_out_reset_n),
      .pc8001_sub_system_clock_1_out_waitrequest                (pc8001_sub_system_clock_1_out_waitrequest),
      .pc8001_sub_system_clock_1_out_write                      (pc8001_sub_system_clock_1_out_write),
      .pc8001_sub_system_clock_1_out_writedata                  (pc8001_sub_system_clock_1_out_writedata),
      .reset_n                                                  (pll_io_reset_n)
    );

  pc8001_sub_system_clock_1 the_pc8001_sub_system_clock_1
    (
      .master_address       (pc8001_sub_system_clock_1_out_address),
      .master_byteenable    (pc8001_sub_system_clock_1_out_byteenable),
      .master_clk           (pll_io),
      .master_endofpacket   (pc8001_sub_system_clock_1_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_1_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_1_out_read),
      .master_readdata      (pc8001_sub_system_clock_1_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_1_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_1_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_1_out_write),
      .master_writedata     (pc8001_sub_system_clock_1_out_writedata),
      .slave_address        (pc8001_sub_system_clock_1_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_1_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_1_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_1_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_1_in_read),
      .slave_readdata       (pc8001_sub_system_clock_1_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_1_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_1_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_1_in_write),
      .slave_writedata      (pc8001_sub_system_clock_1_in_writedata)
    );

  pc8001_sub_system_clock_2_in_arbitrator the_pc8001_sub_system_clock_2_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_2_in_end_xfer                         (d1_pc8001_sub_system_clock_2_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_2_in           (nios2_data_master_granted_pc8001_sub_system_clock_2_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_2_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_2_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_2_in          (nios2_data_master_requests_pc8001_sub_system_clock_2_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_2_in_address                             (pc8001_sub_system_clock_2_in_address),
      .pc8001_sub_system_clock_2_in_byteenable                          (pc8001_sub_system_clock_2_in_byteenable),
      .pc8001_sub_system_clock_2_in_endofpacket                         (pc8001_sub_system_clock_2_in_endofpacket),
      .pc8001_sub_system_clock_2_in_endofpacket_from_sa                 (pc8001_sub_system_clock_2_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_2_in_nativeaddress                       (pc8001_sub_system_clock_2_in_nativeaddress),
      .pc8001_sub_system_clock_2_in_read                                (pc8001_sub_system_clock_2_in_read),
      .pc8001_sub_system_clock_2_in_readdata                            (pc8001_sub_system_clock_2_in_readdata),
      .pc8001_sub_system_clock_2_in_readdata_from_sa                    (pc8001_sub_system_clock_2_in_readdata_from_sa),
      .pc8001_sub_system_clock_2_in_reset_n                             (pc8001_sub_system_clock_2_in_reset_n),
      .pc8001_sub_system_clock_2_in_waitrequest                         (pc8001_sub_system_clock_2_in_waitrequest),
      .pc8001_sub_system_clock_2_in_waitrequest_from_sa                 (pc8001_sub_system_clock_2_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_2_in_write                               (pc8001_sub_system_clock_2_in_write),
      .pc8001_sub_system_clock_2_in_writedata                           (pc8001_sub_system_clock_2_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_2_out_arbitrator the_pc8001_sub_system_clock_2_out
    (
      .clk                                                         (pll_io),
      .cmt_dout_s1_readdata_from_sa                                (cmt_dout_s1_readdata_from_sa),
      .d1_cmt_dout_s1_end_xfer                                     (d1_cmt_dout_s1_end_xfer),
      .pc8001_sub_system_clock_2_out_address                       (pc8001_sub_system_clock_2_out_address),
      .pc8001_sub_system_clock_2_out_address_to_slave              (pc8001_sub_system_clock_2_out_address_to_slave),
      .pc8001_sub_system_clock_2_out_byteenable                    (pc8001_sub_system_clock_2_out_byteenable),
      .pc8001_sub_system_clock_2_out_granted_cmt_dout_s1           (pc8001_sub_system_clock_2_out_granted_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1 (pc8001_sub_system_clock_2_out_qualified_request_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_read                          (pc8001_sub_system_clock_2_out_read),
      .pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1   (pc8001_sub_system_clock_2_out_read_data_valid_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_readdata                      (pc8001_sub_system_clock_2_out_readdata),
      .pc8001_sub_system_clock_2_out_requests_cmt_dout_s1          (pc8001_sub_system_clock_2_out_requests_cmt_dout_s1),
      .pc8001_sub_system_clock_2_out_reset_n                       (pc8001_sub_system_clock_2_out_reset_n),
      .pc8001_sub_system_clock_2_out_waitrequest                   (pc8001_sub_system_clock_2_out_waitrequest),
      .pc8001_sub_system_clock_2_out_write                         (pc8001_sub_system_clock_2_out_write),
      .pc8001_sub_system_clock_2_out_writedata                     (pc8001_sub_system_clock_2_out_writedata),
      .reset_n                                                     (pll_io_reset_n)
    );

  pc8001_sub_system_clock_2 the_pc8001_sub_system_clock_2
    (
      .master_address       (pc8001_sub_system_clock_2_out_address),
      .master_byteenable    (pc8001_sub_system_clock_2_out_byteenable),
      .master_clk           (pll_io),
      .master_endofpacket   (pc8001_sub_system_clock_2_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_2_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_2_out_read),
      .master_readdata      (pc8001_sub_system_clock_2_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_2_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_2_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_2_out_write),
      .master_writedata     (pc8001_sub_system_clock_2_out_writedata),
      .slave_address        (pc8001_sub_system_clock_2_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_2_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_2_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_2_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_2_in_read),
      .slave_readdata       (pc8001_sub_system_clock_2_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_2_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_2_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_2_in_write),
      .slave_writedata      (pc8001_sub_system_clock_2_in_writedata)
    );

  pc8001_sub_system_clock_3_in_arbitrator the_pc8001_sub_system_clock_3_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_3_in_end_xfer                         (d1_pc8001_sub_system_clock_3_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_3_in           (nios2_data_master_granted_pc8001_sub_system_clock_3_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_3_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_3_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_3_in          (nios2_data_master_requests_pc8001_sub_system_clock_3_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_3_in_address                             (pc8001_sub_system_clock_3_in_address),
      .pc8001_sub_system_clock_3_in_byteenable                          (pc8001_sub_system_clock_3_in_byteenable),
      .pc8001_sub_system_clock_3_in_endofpacket                         (pc8001_sub_system_clock_3_in_endofpacket),
      .pc8001_sub_system_clock_3_in_endofpacket_from_sa                 (pc8001_sub_system_clock_3_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_3_in_nativeaddress                       (pc8001_sub_system_clock_3_in_nativeaddress),
      .pc8001_sub_system_clock_3_in_read                                (pc8001_sub_system_clock_3_in_read),
      .pc8001_sub_system_clock_3_in_readdata                            (pc8001_sub_system_clock_3_in_readdata),
      .pc8001_sub_system_clock_3_in_readdata_from_sa                    (pc8001_sub_system_clock_3_in_readdata_from_sa),
      .pc8001_sub_system_clock_3_in_reset_n                             (pc8001_sub_system_clock_3_in_reset_n),
      .pc8001_sub_system_clock_3_in_waitrequest                         (pc8001_sub_system_clock_3_in_waitrequest),
      .pc8001_sub_system_clock_3_in_waitrequest_from_sa                 (pc8001_sub_system_clock_3_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_3_in_write                               (pc8001_sub_system_clock_3_in_write),
      .pc8001_sub_system_clock_3_in_writedata                           (pc8001_sub_system_clock_3_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_3_out_arbitrator the_pc8001_sub_system_clock_3_out
    (
      .clk                                                        (pll_io),
      .cmt_din_s1_readdata_from_sa                                (cmt_din_s1_readdata_from_sa),
      .d1_cmt_din_s1_end_xfer                                     (d1_cmt_din_s1_end_xfer),
      .pc8001_sub_system_clock_3_out_address                      (pc8001_sub_system_clock_3_out_address),
      .pc8001_sub_system_clock_3_out_address_to_slave             (pc8001_sub_system_clock_3_out_address_to_slave),
      .pc8001_sub_system_clock_3_out_byteenable                   (pc8001_sub_system_clock_3_out_byteenable),
      .pc8001_sub_system_clock_3_out_granted_cmt_din_s1           (pc8001_sub_system_clock_3_out_granted_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1 (pc8001_sub_system_clock_3_out_qualified_request_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_read                         (pc8001_sub_system_clock_3_out_read),
      .pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1   (pc8001_sub_system_clock_3_out_read_data_valid_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_readdata                     (pc8001_sub_system_clock_3_out_readdata),
      .pc8001_sub_system_clock_3_out_requests_cmt_din_s1          (pc8001_sub_system_clock_3_out_requests_cmt_din_s1),
      .pc8001_sub_system_clock_3_out_reset_n                      (pc8001_sub_system_clock_3_out_reset_n),
      .pc8001_sub_system_clock_3_out_waitrequest                  (pc8001_sub_system_clock_3_out_waitrequest),
      .pc8001_sub_system_clock_3_out_write                        (pc8001_sub_system_clock_3_out_write),
      .pc8001_sub_system_clock_3_out_writedata                    (pc8001_sub_system_clock_3_out_writedata),
      .reset_n                                                    (pll_io_reset_n)
    );

  pc8001_sub_system_clock_3 the_pc8001_sub_system_clock_3
    (
      .master_address       (pc8001_sub_system_clock_3_out_address),
      .master_byteenable    (pc8001_sub_system_clock_3_out_byteenable),
      .master_clk           (pll_io),
      .master_endofpacket   (pc8001_sub_system_clock_3_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_3_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_3_out_read),
      .master_readdata      (pc8001_sub_system_clock_3_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_3_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_3_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_3_out_write),
      .master_writedata     (pc8001_sub_system_clock_3_out_writedata),
      .slave_address        (pc8001_sub_system_clock_3_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_3_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_3_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_3_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_3_in_read),
      .slave_readdata       (pc8001_sub_system_clock_3_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_3_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_3_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_3_in_write),
      .slave_writedata      (pc8001_sub_system_clock_3_in_writedata)
    );

  pc8001_sub_system_clock_4_in_arbitrator the_pc8001_sub_system_clock_4_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_4_in_end_xfer                         (d1_pc8001_sub_system_clock_4_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_4_in           (nios2_data_master_granted_pc8001_sub_system_clock_4_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_4_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_4_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_4_in          (nios2_data_master_requests_pc8001_sub_system_clock_4_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_4_in_address                             (pc8001_sub_system_clock_4_in_address),
      .pc8001_sub_system_clock_4_in_byteenable                          (pc8001_sub_system_clock_4_in_byteenable),
      .pc8001_sub_system_clock_4_in_endofpacket                         (pc8001_sub_system_clock_4_in_endofpacket),
      .pc8001_sub_system_clock_4_in_endofpacket_from_sa                 (pc8001_sub_system_clock_4_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_4_in_nativeaddress                       (pc8001_sub_system_clock_4_in_nativeaddress),
      .pc8001_sub_system_clock_4_in_read                                (pc8001_sub_system_clock_4_in_read),
      .pc8001_sub_system_clock_4_in_readdata                            (pc8001_sub_system_clock_4_in_readdata),
      .pc8001_sub_system_clock_4_in_readdata_from_sa                    (pc8001_sub_system_clock_4_in_readdata_from_sa),
      .pc8001_sub_system_clock_4_in_reset_n                             (pc8001_sub_system_clock_4_in_reset_n),
      .pc8001_sub_system_clock_4_in_waitrequest                         (pc8001_sub_system_clock_4_in_waitrequest),
      .pc8001_sub_system_clock_4_in_waitrequest_from_sa                 (pc8001_sub_system_clock_4_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_4_in_write                               (pc8001_sub_system_clock_4_in_write),
      .pc8001_sub_system_clock_4_in_writedata                           (pc8001_sub_system_clock_4_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_4_out_arbitrator the_pc8001_sub_system_clock_4_out
    (
      .clk                                                             (pll_io),
      .cmt_gpio_out_s1_readdata_from_sa                                (cmt_gpio_out_s1_readdata_from_sa),
      .d1_cmt_gpio_out_s1_end_xfer                                     (d1_cmt_gpio_out_s1_end_xfer),
      .pc8001_sub_system_clock_4_out_address                           (pc8001_sub_system_clock_4_out_address),
      .pc8001_sub_system_clock_4_out_address_to_slave                  (pc8001_sub_system_clock_4_out_address_to_slave),
      .pc8001_sub_system_clock_4_out_byteenable                        (pc8001_sub_system_clock_4_out_byteenable),
      .pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1           (pc8001_sub_system_clock_4_out_granted_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1 (pc8001_sub_system_clock_4_out_qualified_request_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_read                              (pc8001_sub_system_clock_4_out_read),
      .pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1   (pc8001_sub_system_clock_4_out_read_data_valid_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_readdata                          (pc8001_sub_system_clock_4_out_readdata),
      .pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1          (pc8001_sub_system_clock_4_out_requests_cmt_gpio_out_s1),
      .pc8001_sub_system_clock_4_out_reset_n                           (pc8001_sub_system_clock_4_out_reset_n),
      .pc8001_sub_system_clock_4_out_waitrequest                       (pc8001_sub_system_clock_4_out_waitrequest),
      .pc8001_sub_system_clock_4_out_write                             (pc8001_sub_system_clock_4_out_write),
      .pc8001_sub_system_clock_4_out_writedata                         (pc8001_sub_system_clock_4_out_writedata),
      .reset_n                                                         (pll_io_reset_n)
    );

  pc8001_sub_system_clock_4 the_pc8001_sub_system_clock_4
    (
      .master_address       (pc8001_sub_system_clock_4_out_address),
      .master_byteenable    (pc8001_sub_system_clock_4_out_byteenable),
      .master_clk           (pll_io),
      .master_endofpacket   (pc8001_sub_system_clock_4_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_4_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_4_out_read),
      .master_readdata      (pc8001_sub_system_clock_4_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_4_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_4_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_4_out_write),
      .master_writedata     (pc8001_sub_system_clock_4_out_writedata),
      .slave_address        (pc8001_sub_system_clock_4_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_4_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_4_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_4_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_4_in_read),
      .slave_readdata       (pc8001_sub_system_clock_4_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_4_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_4_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_4_in_write),
      .slave_writedata      (pc8001_sub_system_clock_4_in_writedata)
    );

  pc8001_sub_system_clock_5_in_arbitrator the_pc8001_sub_system_clock_5_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_5_in_end_xfer                         (d1_pc8001_sub_system_clock_5_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_5_in           (nios2_data_master_granted_pc8001_sub_system_clock_5_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_5_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_5_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_5_in          (nios2_data_master_requests_pc8001_sub_system_clock_5_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_5_in_address                             (pc8001_sub_system_clock_5_in_address),
      .pc8001_sub_system_clock_5_in_byteenable                          (pc8001_sub_system_clock_5_in_byteenable),
      .pc8001_sub_system_clock_5_in_endofpacket                         (pc8001_sub_system_clock_5_in_endofpacket),
      .pc8001_sub_system_clock_5_in_endofpacket_from_sa                 (pc8001_sub_system_clock_5_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_5_in_nativeaddress                       (pc8001_sub_system_clock_5_in_nativeaddress),
      .pc8001_sub_system_clock_5_in_read                                (pc8001_sub_system_clock_5_in_read),
      .pc8001_sub_system_clock_5_in_readdata                            (pc8001_sub_system_clock_5_in_readdata),
      .pc8001_sub_system_clock_5_in_readdata_from_sa                    (pc8001_sub_system_clock_5_in_readdata_from_sa),
      .pc8001_sub_system_clock_5_in_reset_n                             (pc8001_sub_system_clock_5_in_reset_n),
      .pc8001_sub_system_clock_5_in_waitrequest                         (pc8001_sub_system_clock_5_in_waitrequest),
      .pc8001_sub_system_clock_5_in_waitrequest_from_sa                 (pc8001_sub_system_clock_5_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_5_in_write                               (pc8001_sub_system_clock_5_in_write),
      .pc8001_sub_system_clock_5_in_writedata                           (pc8001_sub_system_clock_5_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_5_out_arbitrator the_pc8001_sub_system_clock_5_out
    (
      .clk                                                            (pll_io),
      .cmt_gpio_in_s1_readdata_from_sa                                (cmt_gpio_in_s1_readdata_from_sa),
      .d1_cmt_gpio_in_s1_end_xfer                                     (d1_cmt_gpio_in_s1_end_xfer),
      .pc8001_sub_system_clock_5_out_address                          (pc8001_sub_system_clock_5_out_address),
      .pc8001_sub_system_clock_5_out_address_to_slave                 (pc8001_sub_system_clock_5_out_address_to_slave),
      .pc8001_sub_system_clock_5_out_byteenable                       (pc8001_sub_system_clock_5_out_byteenable),
      .pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1           (pc8001_sub_system_clock_5_out_granted_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1 (pc8001_sub_system_clock_5_out_qualified_request_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_read                             (pc8001_sub_system_clock_5_out_read),
      .pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1   (pc8001_sub_system_clock_5_out_read_data_valid_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_readdata                         (pc8001_sub_system_clock_5_out_readdata),
      .pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1          (pc8001_sub_system_clock_5_out_requests_cmt_gpio_in_s1),
      .pc8001_sub_system_clock_5_out_reset_n                          (pc8001_sub_system_clock_5_out_reset_n),
      .pc8001_sub_system_clock_5_out_waitrequest                      (pc8001_sub_system_clock_5_out_waitrequest),
      .pc8001_sub_system_clock_5_out_write                            (pc8001_sub_system_clock_5_out_write),
      .pc8001_sub_system_clock_5_out_writedata                        (pc8001_sub_system_clock_5_out_writedata),
      .reset_n                                                        (pll_io_reset_n)
    );

  pc8001_sub_system_clock_5 the_pc8001_sub_system_clock_5
    (
      .master_address       (pc8001_sub_system_clock_5_out_address),
      .master_byteenable    (pc8001_sub_system_clock_5_out_byteenable),
      .master_clk           (pll_io),
      .master_endofpacket   (pc8001_sub_system_clock_5_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_5_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_5_out_read),
      .master_readdata      (pc8001_sub_system_clock_5_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_5_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_5_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_5_out_write),
      .master_writedata     (pc8001_sub_system_clock_5_out_writedata),
      .slave_address        (pc8001_sub_system_clock_5_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_5_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_5_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_5_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_5_in_read),
      .slave_readdata       (pc8001_sub_system_clock_5_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_5_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_5_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_5_in_write),
      .slave_writedata      (pc8001_sub_system_clock_5_in_writedata)
    );

  pc8001_sub_system_clock_6_in_arbitrator the_pc8001_sub_system_clock_6_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_6_in_end_xfer                         (d1_pc8001_sub_system_clock_6_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_6_in           (nios2_data_master_granted_pc8001_sub_system_clock_6_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_6_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_6_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_6_in          (nios2_data_master_requests_pc8001_sub_system_clock_6_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_6_in_address                             (pc8001_sub_system_clock_6_in_address),
      .pc8001_sub_system_clock_6_in_byteenable                          (pc8001_sub_system_clock_6_in_byteenable),
      .pc8001_sub_system_clock_6_in_endofpacket                         (pc8001_sub_system_clock_6_in_endofpacket),
      .pc8001_sub_system_clock_6_in_endofpacket_from_sa                 (pc8001_sub_system_clock_6_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_6_in_nativeaddress                       (pc8001_sub_system_clock_6_in_nativeaddress),
      .pc8001_sub_system_clock_6_in_read                                (pc8001_sub_system_clock_6_in_read),
      .pc8001_sub_system_clock_6_in_readdata                            (pc8001_sub_system_clock_6_in_readdata),
      .pc8001_sub_system_clock_6_in_readdata_from_sa                    (pc8001_sub_system_clock_6_in_readdata_from_sa),
      .pc8001_sub_system_clock_6_in_reset_n                             (pc8001_sub_system_clock_6_in_reset_n),
      .pc8001_sub_system_clock_6_in_waitrequest                         (pc8001_sub_system_clock_6_in_waitrequest),
      .pc8001_sub_system_clock_6_in_waitrequest_from_sa                 (pc8001_sub_system_clock_6_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_6_in_write                               (pc8001_sub_system_clock_6_in_write),
      .pc8001_sub_system_clock_6_in_writedata                           (pc8001_sub_system_clock_6_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_6_out_arbitrator the_pc8001_sub_system_clock_6_out
    (
      .clk                                                                    (pll_peripheral),
      .d1_mmc_spi_avalon_slave_0_end_xfer                                     (d1_mmc_spi_avalon_slave_0_end_xfer),
      .mmc_spi_avalon_slave_0_readdata_from_sa                                (mmc_spi_avalon_slave_0_readdata_from_sa),
      .pc8001_sub_system_clock_6_out_address                                  (pc8001_sub_system_clock_6_out_address),
      .pc8001_sub_system_clock_6_out_address_to_slave                         (pc8001_sub_system_clock_6_out_address_to_slave),
      .pc8001_sub_system_clock_6_out_byteenable                               (pc8001_sub_system_clock_6_out_byteenable),
      .pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0           (pc8001_sub_system_clock_6_out_granted_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0 (pc8001_sub_system_clock_6_out_qualified_request_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_read                                     (pc8001_sub_system_clock_6_out_read),
      .pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0   (pc8001_sub_system_clock_6_out_read_data_valid_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_readdata                                 (pc8001_sub_system_clock_6_out_readdata),
      .pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0          (pc8001_sub_system_clock_6_out_requests_mmc_spi_avalon_slave_0),
      .pc8001_sub_system_clock_6_out_reset_n                                  (pc8001_sub_system_clock_6_out_reset_n),
      .pc8001_sub_system_clock_6_out_waitrequest                              (pc8001_sub_system_clock_6_out_waitrequest),
      .pc8001_sub_system_clock_6_out_write                                    (pc8001_sub_system_clock_6_out_write),
      .pc8001_sub_system_clock_6_out_writedata                                (pc8001_sub_system_clock_6_out_writedata),
      .reset_n                                                                (pll_peripheral_reset_n)
    );

  pc8001_sub_system_clock_6 the_pc8001_sub_system_clock_6
    (
      .master_address       (pc8001_sub_system_clock_6_out_address),
      .master_byteenable    (pc8001_sub_system_clock_6_out_byteenable),
      .master_clk           (pll_peripheral),
      .master_endofpacket   (pc8001_sub_system_clock_6_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_6_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_6_out_read),
      .master_readdata      (pc8001_sub_system_clock_6_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_6_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_6_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_6_out_write),
      .master_writedata     (pc8001_sub_system_clock_6_out_writedata),
      .slave_address        (pc8001_sub_system_clock_6_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_6_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_6_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_6_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_6_in_read),
      .slave_readdata       (pc8001_sub_system_clock_6_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_6_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_6_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_6_in_write),
      .slave_writedata      (pc8001_sub_system_clock_6_in_writedata)
    );

  pc8001_sub_system_clock_7_in_arbitrator the_pc8001_sub_system_clock_7_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_7_in_end_xfer                         (d1_pc8001_sub_system_clock_7_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_granted_pc8001_sub_system_clock_7_in           (nios2_data_master_granted_pc8001_sub_system_clock_7_in),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_7_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_7_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_7_in          (nios2_data_master_requests_pc8001_sub_system_clock_7_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .nios2_data_master_writedata                                      (nios2_data_master_writedata),
      .pc8001_sub_system_clock_7_in_address                             (pc8001_sub_system_clock_7_in_address),
      .pc8001_sub_system_clock_7_in_byteenable                          (pc8001_sub_system_clock_7_in_byteenable),
      .pc8001_sub_system_clock_7_in_endofpacket                         (pc8001_sub_system_clock_7_in_endofpacket),
      .pc8001_sub_system_clock_7_in_endofpacket_from_sa                 (pc8001_sub_system_clock_7_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_7_in_nativeaddress                       (pc8001_sub_system_clock_7_in_nativeaddress),
      .pc8001_sub_system_clock_7_in_read                                (pc8001_sub_system_clock_7_in_read),
      .pc8001_sub_system_clock_7_in_readdata                            (pc8001_sub_system_clock_7_in_readdata),
      .pc8001_sub_system_clock_7_in_readdata_from_sa                    (pc8001_sub_system_clock_7_in_readdata_from_sa),
      .pc8001_sub_system_clock_7_in_reset_n                             (pc8001_sub_system_clock_7_in_reset_n),
      .pc8001_sub_system_clock_7_in_waitrequest                         (pc8001_sub_system_clock_7_in_waitrequest),
      .pc8001_sub_system_clock_7_in_waitrequest_from_sa                 (pc8001_sub_system_clock_7_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_7_in_write                               (pc8001_sub_system_clock_7_in_write),
      .pc8001_sub_system_clock_7_in_writedata                           (pc8001_sub_system_clock_7_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_7_out_arbitrator the_pc8001_sub_system_clock_7_out
    (
      .clk                                                                      (clk_0),
      .d1_sub_system_pll_pll_slave_end_xfer                                     (d1_sub_system_pll_pll_slave_end_xfer),
      .pc8001_sub_system_clock_7_out_address                                    (pc8001_sub_system_clock_7_out_address),
      .pc8001_sub_system_clock_7_out_address_to_slave                           (pc8001_sub_system_clock_7_out_address_to_slave),
      .pc8001_sub_system_clock_7_out_byteenable                                 (pc8001_sub_system_clock_7_out_byteenable),
      .pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave           (pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave (pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_read                                       (pc8001_sub_system_clock_7_out_read),
      .pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave   (pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_readdata                                   (pc8001_sub_system_clock_7_out_readdata),
      .pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave          (pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_reset_n                                    (pc8001_sub_system_clock_7_out_reset_n),
      .pc8001_sub_system_clock_7_out_waitrequest                                (pc8001_sub_system_clock_7_out_waitrequest),
      .pc8001_sub_system_clock_7_out_write                                      (pc8001_sub_system_clock_7_out_write),
      .pc8001_sub_system_clock_7_out_writedata                                  (pc8001_sub_system_clock_7_out_writedata),
      .reset_n                                                                  (clk_0_reset_n),
      .sub_system_pll_pll_slave_readdata_from_sa                                (sub_system_pll_pll_slave_readdata_from_sa)
    );

  pc8001_sub_system_clock_7 the_pc8001_sub_system_clock_7
    (
      .master_address       (pc8001_sub_system_clock_7_out_address),
      .master_byteenable    (pc8001_sub_system_clock_7_out_byteenable),
      .master_clk           (clk_0),
      .master_endofpacket   (pc8001_sub_system_clock_7_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_7_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_7_out_read),
      .master_readdata      (pc8001_sub_system_clock_7_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_7_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_7_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_7_out_write),
      .master_writedata     (pc8001_sub_system_clock_7_out_writedata),
      .slave_address        (pc8001_sub_system_clock_7_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_7_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_7_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_7_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_7_in_read),
      .slave_readdata       (pc8001_sub_system_clock_7_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_7_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_7_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_7_in_write),
      .slave_writedata      (pc8001_sub_system_clock_7_in_writedata)
    );

  pc8001_sub_system_clock_8_in_arbitrator the_pc8001_sub_system_clock_8_in
    (
      .clk                                                                     (pll_cpu),
      .d1_pc8001_sub_system_clock_8_in_end_xfer                                (d1_pc8001_sub_system_clock_8_in_end_xfer),
      .nios2_instruction_master_address_to_slave                               (nios2_instruction_master_address_to_slave),
      .nios2_instruction_master_dbs_address                                    (nios2_instruction_master_dbs_address),
      .nios2_instruction_master_granted_pc8001_sub_system_clock_8_in           (nios2_instruction_master_granted_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in (nios2_instruction_master_qualified_request_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_read                                           (nios2_instruction_master_read),
      .nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in   (nios2_instruction_master_read_data_valid_pc8001_sub_system_clock_8_in),
      .nios2_instruction_master_requests_pc8001_sub_system_clock_8_in          (nios2_instruction_master_requests_pc8001_sub_system_clock_8_in),
      .pc8001_sub_system_clock_8_in_address                                    (pc8001_sub_system_clock_8_in_address),
      .pc8001_sub_system_clock_8_in_byteenable                                 (pc8001_sub_system_clock_8_in_byteenable),
      .pc8001_sub_system_clock_8_in_endofpacket                                (pc8001_sub_system_clock_8_in_endofpacket),
      .pc8001_sub_system_clock_8_in_endofpacket_from_sa                        (pc8001_sub_system_clock_8_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_8_in_nativeaddress                              (pc8001_sub_system_clock_8_in_nativeaddress),
      .pc8001_sub_system_clock_8_in_read                                       (pc8001_sub_system_clock_8_in_read),
      .pc8001_sub_system_clock_8_in_readdata                                   (pc8001_sub_system_clock_8_in_readdata),
      .pc8001_sub_system_clock_8_in_readdata_from_sa                           (pc8001_sub_system_clock_8_in_readdata_from_sa),
      .pc8001_sub_system_clock_8_in_reset_n                                    (pc8001_sub_system_clock_8_in_reset_n),
      .pc8001_sub_system_clock_8_in_waitrequest                                (pc8001_sub_system_clock_8_in_waitrequest),
      .pc8001_sub_system_clock_8_in_waitrequest_from_sa                        (pc8001_sub_system_clock_8_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_8_in_write                                      (pc8001_sub_system_clock_8_in_write),
      .reset_n                                                                 (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_8_out_arbitrator the_pc8001_sub_system_clock_8_out
    (
      .clk                                                                   (pll_sdram),
      .d1_sdram_s1_end_xfer                                                  (d1_sdram_s1_end_xfer),
      .pc8001_sub_system_clock_8_out_address                                 (pc8001_sub_system_clock_8_out_address),
      .pc8001_sub_system_clock_8_out_address_to_slave                        (pc8001_sub_system_clock_8_out_address_to_slave),
      .pc8001_sub_system_clock_8_out_byteenable                              (pc8001_sub_system_clock_8_out_byteenable),
      .pc8001_sub_system_clock_8_out_granted_sdram_s1                        (pc8001_sub_system_clock_8_out_granted_sdram_s1),
      .pc8001_sub_system_clock_8_out_qualified_request_sdram_s1              (pc8001_sub_system_clock_8_out_qualified_request_sdram_s1),
      .pc8001_sub_system_clock_8_out_read                                    (pc8001_sub_system_clock_8_out_read),
      .pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1                (pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1),
      .pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register (pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register),
      .pc8001_sub_system_clock_8_out_readdata                                (pc8001_sub_system_clock_8_out_readdata),
      .pc8001_sub_system_clock_8_out_requests_sdram_s1                       (pc8001_sub_system_clock_8_out_requests_sdram_s1),
      .pc8001_sub_system_clock_8_out_reset_n                                 (pc8001_sub_system_clock_8_out_reset_n),
      .pc8001_sub_system_clock_8_out_waitrequest                             (pc8001_sub_system_clock_8_out_waitrequest),
      .pc8001_sub_system_clock_8_out_write                                   (pc8001_sub_system_clock_8_out_write),
      .pc8001_sub_system_clock_8_out_writedata                               (pc8001_sub_system_clock_8_out_writedata),
      .reset_n                                                               (pll_sdram_reset_n),
      .sdram_s1_readdata_from_sa                                             (sdram_s1_readdata_from_sa),
      .sdram_s1_waitrequest_from_sa                                          (sdram_s1_waitrequest_from_sa)
    );

  pc8001_sub_system_clock_8 the_pc8001_sub_system_clock_8
    (
      .master_address       (pc8001_sub_system_clock_8_out_address),
      .master_byteenable    (pc8001_sub_system_clock_8_out_byteenable),
      .master_clk           (pll_sdram),
      .master_endofpacket   (pc8001_sub_system_clock_8_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_8_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_8_out_read),
      .master_readdata      (pc8001_sub_system_clock_8_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_8_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_8_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_8_out_write),
      .master_writedata     (pc8001_sub_system_clock_8_out_writedata),
      .slave_address        (pc8001_sub_system_clock_8_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_8_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_8_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_8_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_8_in_read),
      .slave_readdata       (pc8001_sub_system_clock_8_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_8_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_8_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_8_in_write),
      .slave_writedata      (pc8001_sub_system_clock_8_in_writedata)
    );

  pc8001_sub_system_clock_9_in_arbitrator the_pc8001_sub_system_clock_9_in
    (
      .clk                                                              (pll_cpu),
      .d1_pc8001_sub_system_clock_9_in_end_xfer                         (d1_pc8001_sub_system_clock_9_in_end_xfer),
      .nios2_data_master_address_to_slave                               (nios2_data_master_address_to_slave),
      .nios2_data_master_byteenable                                     (nios2_data_master_byteenable),
      .nios2_data_master_byteenable_pc8001_sub_system_clock_9_in        (nios2_data_master_byteenable_pc8001_sub_system_clock_9_in),
      .nios2_data_master_dbs_address                                    (nios2_data_master_dbs_address),
      .nios2_data_master_dbs_write_16                                   (nios2_data_master_dbs_write_16),
      .nios2_data_master_granted_pc8001_sub_system_clock_9_in           (nios2_data_master_granted_pc8001_sub_system_clock_9_in),
      .nios2_data_master_no_byte_enables_and_last_term                  (nios2_data_master_no_byte_enables_and_last_term),
      .nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in (nios2_data_master_qualified_request_pc8001_sub_system_clock_9_in),
      .nios2_data_master_read                                           (nios2_data_master_read),
      .nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in   (nios2_data_master_read_data_valid_pc8001_sub_system_clock_9_in),
      .nios2_data_master_requests_pc8001_sub_system_clock_9_in          (nios2_data_master_requests_pc8001_sub_system_clock_9_in),
      .nios2_data_master_waitrequest                                    (nios2_data_master_waitrequest),
      .nios2_data_master_write                                          (nios2_data_master_write),
      .pc8001_sub_system_clock_9_in_address                             (pc8001_sub_system_clock_9_in_address),
      .pc8001_sub_system_clock_9_in_byteenable                          (pc8001_sub_system_clock_9_in_byteenable),
      .pc8001_sub_system_clock_9_in_endofpacket                         (pc8001_sub_system_clock_9_in_endofpacket),
      .pc8001_sub_system_clock_9_in_endofpacket_from_sa                 (pc8001_sub_system_clock_9_in_endofpacket_from_sa),
      .pc8001_sub_system_clock_9_in_nativeaddress                       (pc8001_sub_system_clock_9_in_nativeaddress),
      .pc8001_sub_system_clock_9_in_read                                (pc8001_sub_system_clock_9_in_read),
      .pc8001_sub_system_clock_9_in_readdata                            (pc8001_sub_system_clock_9_in_readdata),
      .pc8001_sub_system_clock_9_in_readdata_from_sa                    (pc8001_sub_system_clock_9_in_readdata_from_sa),
      .pc8001_sub_system_clock_9_in_reset_n                             (pc8001_sub_system_clock_9_in_reset_n),
      .pc8001_sub_system_clock_9_in_waitrequest                         (pc8001_sub_system_clock_9_in_waitrequest),
      .pc8001_sub_system_clock_9_in_waitrequest_from_sa                 (pc8001_sub_system_clock_9_in_waitrequest_from_sa),
      .pc8001_sub_system_clock_9_in_write                               (pc8001_sub_system_clock_9_in_write),
      .pc8001_sub_system_clock_9_in_writedata                           (pc8001_sub_system_clock_9_in_writedata),
      .reset_n                                                          (pll_cpu_reset_n)
    );

  pc8001_sub_system_clock_9_out_arbitrator the_pc8001_sub_system_clock_9_out
    (
      .clk                                                                   (pll_sdram),
      .d1_sdram_s1_end_xfer                                                  (d1_sdram_s1_end_xfer),
      .pc8001_sub_system_clock_9_out_address                                 (pc8001_sub_system_clock_9_out_address),
      .pc8001_sub_system_clock_9_out_address_to_slave                        (pc8001_sub_system_clock_9_out_address_to_slave),
      .pc8001_sub_system_clock_9_out_byteenable                              (pc8001_sub_system_clock_9_out_byteenable),
      .pc8001_sub_system_clock_9_out_granted_sdram_s1                        (pc8001_sub_system_clock_9_out_granted_sdram_s1),
      .pc8001_sub_system_clock_9_out_qualified_request_sdram_s1              (pc8001_sub_system_clock_9_out_qualified_request_sdram_s1),
      .pc8001_sub_system_clock_9_out_read                                    (pc8001_sub_system_clock_9_out_read),
      .pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1                (pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1),
      .pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register (pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register),
      .pc8001_sub_system_clock_9_out_readdata                                (pc8001_sub_system_clock_9_out_readdata),
      .pc8001_sub_system_clock_9_out_requests_sdram_s1                       (pc8001_sub_system_clock_9_out_requests_sdram_s1),
      .pc8001_sub_system_clock_9_out_reset_n                                 (pc8001_sub_system_clock_9_out_reset_n),
      .pc8001_sub_system_clock_9_out_waitrequest                             (pc8001_sub_system_clock_9_out_waitrequest),
      .pc8001_sub_system_clock_9_out_write                                   (pc8001_sub_system_clock_9_out_write),
      .pc8001_sub_system_clock_9_out_writedata                               (pc8001_sub_system_clock_9_out_writedata),
      .reset_n                                                               (pll_sdram_reset_n),
      .sdram_s1_readdata_from_sa                                             (sdram_s1_readdata_from_sa),
      .sdram_s1_waitrequest_from_sa                                          (sdram_s1_waitrequest_from_sa)
    );

  pc8001_sub_system_clock_9 the_pc8001_sub_system_clock_9
    (
      .master_address       (pc8001_sub_system_clock_9_out_address),
      .master_byteenable    (pc8001_sub_system_clock_9_out_byteenable),
      .master_clk           (pll_sdram),
      .master_endofpacket   (pc8001_sub_system_clock_9_out_endofpacket),
      .master_nativeaddress (pc8001_sub_system_clock_9_out_nativeaddress),
      .master_read          (pc8001_sub_system_clock_9_out_read),
      .master_readdata      (pc8001_sub_system_clock_9_out_readdata),
      .master_reset_n       (pc8001_sub_system_clock_9_out_reset_n),
      .master_waitrequest   (pc8001_sub_system_clock_9_out_waitrequest),
      .master_write         (pc8001_sub_system_clock_9_out_write),
      .master_writedata     (pc8001_sub_system_clock_9_out_writedata),
      .slave_address        (pc8001_sub_system_clock_9_in_address),
      .slave_byteenable     (pc8001_sub_system_clock_9_in_byteenable),
      .slave_clk            (pll_cpu),
      .slave_endofpacket    (pc8001_sub_system_clock_9_in_endofpacket),
      .slave_nativeaddress  (pc8001_sub_system_clock_9_in_nativeaddress),
      .slave_read           (pc8001_sub_system_clock_9_in_read),
      .slave_readdata       (pc8001_sub_system_clock_9_in_readdata),
      .slave_reset_n        (pc8001_sub_system_clock_9_in_reset_n),
      .slave_waitrequest    (pc8001_sub_system_clock_9_in_waitrequest),
      .slave_write          (pc8001_sub_system_clock_9_in_write),
      .slave_writedata      (pc8001_sub_system_clock_9_in_writedata)
    );

  sdram_s1_arbitrator the_sdram_s1
    (
      .clk                                                                   (pll_sdram),
      .d1_sdram_s1_end_xfer                                                  (d1_sdram_s1_end_xfer),
      .pc8001_sub_system_clock_8_out_address_to_slave                        (pc8001_sub_system_clock_8_out_address_to_slave),
      .pc8001_sub_system_clock_8_out_byteenable                              (pc8001_sub_system_clock_8_out_byteenable),
      .pc8001_sub_system_clock_8_out_granted_sdram_s1                        (pc8001_sub_system_clock_8_out_granted_sdram_s1),
      .pc8001_sub_system_clock_8_out_qualified_request_sdram_s1              (pc8001_sub_system_clock_8_out_qualified_request_sdram_s1),
      .pc8001_sub_system_clock_8_out_read                                    (pc8001_sub_system_clock_8_out_read),
      .pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1                (pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1),
      .pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register (pc8001_sub_system_clock_8_out_read_data_valid_sdram_s1_shift_register),
      .pc8001_sub_system_clock_8_out_requests_sdram_s1                       (pc8001_sub_system_clock_8_out_requests_sdram_s1),
      .pc8001_sub_system_clock_8_out_write                                   (pc8001_sub_system_clock_8_out_write),
      .pc8001_sub_system_clock_8_out_writedata                               (pc8001_sub_system_clock_8_out_writedata),
      .pc8001_sub_system_clock_9_out_address_to_slave                        (pc8001_sub_system_clock_9_out_address_to_slave),
      .pc8001_sub_system_clock_9_out_byteenable                              (pc8001_sub_system_clock_9_out_byteenable),
      .pc8001_sub_system_clock_9_out_granted_sdram_s1                        (pc8001_sub_system_clock_9_out_granted_sdram_s1),
      .pc8001_sub_system_clock_9_out_qualified_request_sdram_s1              (pc8001_sub_system_clock_9_out_qualified_request_sdram_s1),
      .pc8001_sub_system_clock_9_out_read                                    (pc8001_sub_system_clock_9_out_read),
      .pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1                (pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1),
      .pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register (pc8001_sub_system_clock_9_out_read_data_valid_sdram_s1_shift_register),
      .pc8001_sub_system_clock_9_out_requests_sdram_s1                       (pc8001_sub_system_clock_9_out_requests_sdram_s1),
      .pc8001_sub_system_clock_9_out_write                                   (pc8001_sub_system_clock_9_out_write),
      .pc8001_sub_system_clock_9_out_writedata                               (pc8001_sub_system_clock_9_out_writedata),
      .reset_n                                                               (pll_sdram_reset_n),
      .sdram_s1_address                                                      (sdram_s1_address),
      .sdram_s1_byteenable_n                                                 (sdram_s1_byteenable_n),
      .sdram_s1_chipselect                                                   (sdram_s1_chipselect),
      .sdram_s1_read_n                                                       (sdram_s1_read_n),
      .sdram_s1_readdata                                                     (sdram_s1_readdata),
      .sdram_s1_readdata_from_sa                                             (sdram_s1_readdata_from_sa),
      .sdram_s1_readdatavalid                                                (sdram_s1_readdatavalid),
      .sdram_s1_reset_n                                                      (sdram_s1_reset_n),
      .sdram_s1_waitrequest                                                  (sdram_s1_waitrequest),
      .sdram_s1_waitrequest_from_sa                                          (sdram_s1_waitrequest_from_sa),
      .sdram_s1_write_n                                                      (sdram_s1_write_n),
      .sdram_s1_writedata                                                    (sdram_s1_writedata)
    );

  sdram the_sdram
    (
      .az_addr        (sdram_s1_address),
      .az_be_n        (sdram_s1_byteenable_n),
      .az_cs          (sdram_s1_chipselect),
      .az_data        (sdram_s1_writedata),
      .az_rd_n        (sdram_s1_read_n),
      .az_wr_n        (sdram_s1_write_n),
      .clk            (pll_sdram),
      .reset_n        (sdram_s1_reset_n),
      .za_data        (sdram_s1_readdata),
      .za_valid       (sdram_s1_readdatavalid),
      .za_waitrequest (sdram_s1_waitrequest),
      .zs_addr        (zs_addr_from_the_sdram),
      .zs_ba          (zs_ba_from_the_sdram),
      .zs_cas_n       (zs_cas_n_from_the_sdram),
      .zs_cke         (zs_cke_from_the_sdram),
      .zs_cs_n        (zs_cs_n_from_the_sdram),
      .zs_dq          (zs_dq_to_and_from_the_sdram),
      .zs_dqm         (zs_dqm_from_the_sdram),
      .zs_ras_n       (zs_ras_n_from_the_sdram),
      .zs_we_n        (zs_we_n_from_the_sdram)
    );

  sub_system_pll_pll_slave_arbitrator the_sub_system_pll_pll_slave
    (
      .clk                                                                      (clk_0),
      .d1_sub_system_pll_pll_slave_end_xfer                                     (d1_sub_system_pll_pll_slave_end_xfer),
      .pc8001_sub_system_clock_7_out_address_to_slave                           (pc8001_sub_system_clock_7_out_address_to_slave),
      .pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave           (pc8001_sub_system_clock_7_out_granted_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave (pc8001_sub_system_clock_7_out_qualified_request_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_read                                       (pc8001_sub_system_clock_7_out_read),
      .pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave   (pc8001_sub_system_clock_7_out_read_data_valid_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave          (pc8001_sub_system_clock_7_out_requests_sub_system_pll_pll_slave),
      .pc8001_sub_system_clock_7_out_write                                      (pc8001_sub_system_clock_7_out_write),
      .pc8001_sub_system_clock_7_out_writedata                                  (pc8001_sub_system_clock_7_out_writedata),
      .reset_n                                                                  (clk_0_reset_n),
      .sub_system_pll_pll_slave_address                                         (sub_system_pll_pll_slave_address),
      .sub_system_pll_pll_slave_read                                            (sub_system_pll_pll_slave_read),
      .sub_system_pll_pll_slave_readdata                                        (sub_system_pll_pll_slave_readdata),
      .sub_system_pll_pll_slave_readdata_from_sa                                (sub_system_pll_pll_slave_readdata_from_sa),
      .sub_system_pll_pll_slave_reset                                           (sub_system_pll_pll_slave_reset),
      .sub_system_pll_pll_slave_write                                           (sub_system_pll_pll_slave_write),
      .sub_system_pll_pll_slave_writedata                                       (sub_system_pll_pll_slave_writedata)
    );

  //pll_cpu out_clk assignment, which is an e_assign
  assign pll_cpu = out_clk_sub_system_pll_c0;

  //pll_sdram out_clk assignment, which is an e_assign
  assign pll_sdram = out_clk_sub_system_pll_c1;

  //pll_io out_clk assignment, which is an e_assign
  assign pll_io = out_clk_sub_system_pll_c2;

  //pll_peripheral out_clk assignment, which is an e_assign
  assign pll_peripheral = out_clk_sub_system_pll_c3;

  sub_system_pll the_sub_system_pll
    (
      .address   (sub_system_pll_pll_slave_address),
      .areset    (areset_to_the_sub_system_pll),
      .c0        (out_clk_sub_system_pll_c0),
      .c1        (out_clk_sub_system_pll_c1),
      .c2        (out_clk_sub_system_pll_c2),
      .c3        (out_clk_sub_system_pll_c3),
      .clk       (clk_0),
      .locked    (locked_from_the_sub_system_pll),
      .phasedone (phasedone_from_the_sub_system_pll),
      .read      (sub_system_pll_pll_slave_read),
      .readdata  (sub_system_pll_pll_slave_readdata),
      .reset     (sub_system_pll_pll_slave_reset),
      .write     (sub_system_pll_pll_slave_write),
      .writedata (sub_system_pll_pll_slave_writedata)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                     (pll_cpu),
      .d1_sysid_control_slave_end_xfer                         (d1_sysid_control_slave_end_xfer),
      .nios2_data_master_address_to_slave                      (nios2_data_master_address_to_slave),
      .nios2_data_master_granted_sysid_control_slave           (nios2_data_master_granted_sysid_control_slave),
      .nios2_data_master_qualified_request_sysid_control_slave (nios2_data_master_qualified_request_sysid_control_slave),
      .nios2_data_master_read                                  (nios2_data_master_read),
      .nios2_data_master_read_data_valid_sysid_control_slave   (nios2_data_master_read_data_valid_sysid_control_slave),
      .nios2_data_master_requests_sysid_control_slave          (nios2_data_master_requests_sysid_control_slave),
      .nios2_data_master_write                                 (nios2_data_master_write),
      .reset_n                                                 (pll_cpu_reset_n),
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
      .clk                                            (pll_cpu),
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
      .reset_n                                        (pll_cpu_reset_n),
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
      .clk        (pll_cpu),
      .irq        (timer_0_s1_irq),
      .readdata   (timer_0_s1_readdata),
      .reset_n    (timer_0_s1_reset_n),
      .write_n    (timer_0_s1_write_n),
      .writedata  (timer_0_s1_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  pc8001_sub_system_reset_pll_io_domain_synch_module pc8001_sub_system_reset_pll_io_domain_synch
    (
      .clk      (pll_io),
      .data_in  (1'b1),
      .data_out (pll_io_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    0 |
    0 |
    nios2_jtag_debug_module_resetrequest_from_sa |
    nios2_jtag_debug_module_resetrequest_from_sa |
    0 |
    0);

  //reset is asserted asynchronously and deasserted synchronously
  pc8001_sub_system_reset_pll_cpu_domain_synch_module pc8001_sub_system_reset_pll_cpu_domain_synch
    (
      .clk      (pll_cpu),
      .data_in  (1'b1),
      .data_out (pll_cpu_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  pc8001_sub_system_reset_pll_peripheral_domain_synch_module pc8001_sub_system_reset_pll_peripheral_domain_synch
    (
      .clk      (pll_peripheral),
      .data_in  (1'b1),
      .data_out (pll_peripheral_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  pc8001_sub_system_reset_pll_sdram_domain_synch_module pc8001_sub_system_reset_pll_sdram_domain_synch
    (
      .clk      (pll_sdram),
      .data_in  (1'b1),
      .data_out (pll_sdram_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  pc8001_sub_system_reset_clk_0_domain_synch_module pc8001_sub_system_reset_clk_0_domain_synch
    (
      .clk      (clk_0),
      .data_in  (1'b1),
      .data_out (clk_0_reset_n),
      .reset_n  (reset_n_sources)
    );

  //pc8001_sub_system_clock_0_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_0_out_endofpacket = 0;

  //pc8001_sub_system_clock_1_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_1_out_endofpacket = 0;

  //pc8001_sub_system_clock_2_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_2_out_endofpacket = 0;

  //pc8001_sub_system_clock_3_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_3_out_endofpacket = 0;

  //pc8001_sub_system_clock_4_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_4_out_endofpacket = 0;

  //pc8001_sub_system_clock_5_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_5_out_endofpacket = 0;

  //pc8001_sub_system_clock_6_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_6_out_endofpacket = 0;

  //pc8001_sub_system_clock_7_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_7_out_endofpacket = 0;

  //pc8001_sub_system_clock_8_in_writedata of type writedata does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_8_in_writedata = 0;

  //pc8001_sub_system_clock_8_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_8_out_endofpacket = 0;

  //pc8001_sub_system_clock_9_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pc8001_sub_system_clock_9_out_endofpacket = 0;

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
`include "sub_system_pll.vo"
`include "avalonif_mmc.v"
`include "mmc_spi.v"
`include "cmt_gpio_out.v"
`include "timer_0.v"
`include "cmt_dout.v"
`include "sdram.v"
`include "sdram_test_component.v"
`include "sysid.v"
`include "pc8001_sub_system_clock_7.v"
`include "pc8001_sub_system_clock_2.v"
`include "nios2_test_bench.v"
`include "nios2_oci_test_bench.v"
`include "nios2_jtag_debug_module_tck.v"
`include "nios2_jtag_debug_module_sysclk.v"
`include "nios2_jtag_debug_module_wrapper.v"
`include "nios2.v"
`include "gpio0.v"
`include "pc8001_sub_system_clock_8.v"
`include "pc8001_sub_system_clock_1.v"
`include "jtag_uart.v"
`include "pc8001_sub_system_clock_9.v"
`include "epcs_flash_controller.v"
`include "pc8001_sub_system_clock_3.v"
`include "pc8001_sub_system_clock_6.v"
`include "gpio1.v"
`include "pc8001_sub_system_clock_0.v"
`include "cmt_din.v"
`include "pc8001_sub_system_clock_5.v"
`include "pc8001_sub_system_clock_4.v"
`include "cmt_gpio_in.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             MMC_CD_to_the_mmc_spi;
  wire             MMC_SCK_from_the_mmc_spi;
  wire             MMC_SDI_to_the_mmc_spi;
  wire             MMC_SDO_from_the_mmc_spi;
  wire             MMC_WP_to_the_mmc_spi;
  wire             MMC_nCS_from_the_mmc_spi;
  wire             areset_to_the_sub_system_pll;
  wire             clk;
  reg              clk_0;
  wire             data0_to_the_epcs_flash_controller;
  wire             dclk_from_the_epcs_flash_controller;
  wire             epcs_flash_controller_epcs_control_port_dataavailable_from_sa;
  wire             epcs_flash_controller_epcs_control_port_endofpacket_from_sa;
  wire             epcs_flash_controller_epcs_control_port_readyfordata_from_sa;
  wire    [  7: 0] in_port_to_the_cmt_din;
  wire    [  7: 0] in_port_to_the_cmt_gpio_in;
  wire    [  7: 0] in_port_to_the_gpio1;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             locked_from_the_sub_system_pll;
  wire    [  7: 0] out_port_from_the_cmt_dout;
  wire    [  7: 0] out_port_from_the_cmt_gpio_out;
  wire    [  7: 0] out_port_from_the_gpio0;
  wire             pc8001_sub_system_clock_0_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_0_out_endofpacket;
  wire             pc8001_sub_system_clock_1_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_1_out_endofpacket;
  wire             pc8001_sub_system_clock_2_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_2_out_endofpacket;
  wire             pc8001_sub_system_clock_3_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_3_out_endofpacket;
  wire             pc8001_sub_system_clock_4_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_4_out_endofpacket;
  wire             pc8001_sub_system_clock_5_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_5_out_endofpacket;
  wire             pc8001_sub_system_clock_6_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_6_out_endofpacket;
  wire    [  1: 0] pc8001_sub_system_clock_6_out_nativeaddress;
  wire             pc8001_sub_system_clock_7_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_7_out_endofpacket;
  wire    [  1: 0] pc8001_sub_system_clock_7_out_nativeaddress;
  wire             pc8001_sub_system_clock_8_in_endofpacket_from_sa;
  wire    [ 15: 0] pc8001_sub_system_clock_8_in_writedata;
  wire             pc8001_sub_system_clock_8_out_endofpacket;
  wire    [ 21: 0] pc8001_sub_system_clock_8_out_nativeaddress;
  wire             pc8001_sub_system_clock_9_in_endofpacket_from_sa;
  wire             pc8001_sub_system_clock_9_out_endofpacket;
  wire    [ 21: 0] pc8001_sub_system_clock_9_out_nativeaddress;
  wire             phasedone_from_the_sub_system_pll;
  wire             pll_cpu;
  wire             pll_io;
  wire             pll_peripheral;
  wire             pll_sdram;
  reg              reset_n;
  wire             sce_from_the_epcs_flash_controller;
  wire             sdo_from_the_epcs_flash_controller;
  wire             sysid_control_slave_clock;
  wire    [ 11: 0] zs_addr_from_the_sdram;
  wire    [  1: 0] zs_ba_from_the_sdram;
  wire             zs_cas_n_from_the_sdram;
  wire             zs_cke_from_the_sdram;
  wire             zs_cs_n_from_the_sdram;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram;
  wire    [  1: 0] zs_dqm_from_the_sdram;
  wire             zs_ras_n_from_the_sdram;
  wire             zs_we_n_from_the_sdram;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  pc8001_sub_system DUT
    (
      .MMC_CD_to_the_mmc_spi               (MMC_CD_to_the_mmc_spi),
      .MMC_SCK_from_the_mmc_spi            (MMC_SCK_from_the_mmc_spi),
      .MMC_SDI_to_the_mmc_spi              (MMC_SDI_to_the_mmc_spi),
      .MMC_SDO_from_the_mmc_spi            (MMC_SDO_from_the_mmc_spi),
      .MMC_WP_to_the_mmc_spi               (MMC_WP_to_the_mmc_spi),
      .MMC_nCS_from_the_mmc_spi            (MMC_nCS_from_the_mmc_spi),
      .areset_to_the_sub_system_pll        (areset_to_the_sub_system_pll),
      .clk_0                               (clk_0),
      .data0_to_the_epcs_flash_controller  (data0_to_the_epcs_flash_controller),
      .dclk_from_the_epcs_flash_controller (dclk_from_the_epcs_flash_controller),
      .in_port_to_the_cmt_din              (in_port_to_the_cmt_din),
      .in_port_to_the_cmt_gpio_in          (in_port_to_the_cmt_gpio_in),
      .in_port_to_the_gpio1                (in_port_to_the_gpio1),
      .locked_from_the_sub_system_pll      (locked_from_the_sub_system_pll),
      .out_port_from_the_cmt_dout          (out_port_from_the_cmt_dout),
      .out_port_from_the_cmt_gpio_out      (out_port_from_the_cmt_gpio_out),
      .out_port_from_the_gpio0             (out_port_from_the_gpio0),
      .phasedone_from_the_sub_system_pll   (phasedone_from_the_sub_system_pll),
      .pll_cpu                             (pll_cpu),
      .pll_io                              (pll_io),
      .pll_peripheral                      (pll_peripheral),
      .pll_sdram                           (pll_sdram),
      .reset_n                             (reset_n),
      .sce_from_the_epcs_flash_controller  (sce_from_the_epcs_flash_controller),
      .sdo_from_the_epcs_flash_controller  (sdo_from_the_epcs_flash_controller),
      .zs_addr_from_the_sdram              (zs_addr_from_the_sdram),
      .zs_ba_from_the_sdram                (zs_ba_from_the_sdram),
      .zs_cas_n_from_the_sdram             (zs_cas_n_from_the_sdram),
      .zs_cke_from_the_sdram               (zs_cke_from_the_sdram),
      .zs_cs_n_from_the_sdram              (zs_cs_n_from_the_sdram),
      .zs_dq_to_and_from_the_sdram         (zs_dq_to_and_from_the_sdram),
      .zs_dqm_from_the_sdram               (zs_dqm_from_the_sdram),
      .zs_ras_n_from_the_sdram             (zs_ras_n_from_the_sdram),
      .zs_we_n_from_the_sdram              (zs_we_n_from_the_sdram)
    );

  sdram_test_component the_sdram_test_component
    (
      .clk      (pll_sdram),
      .zs_addr  (zs_addr_from_the_sdram),
      .zs_ba    (zs_ba_from_the_sdram),
      .zs_cas_n (zs_cas_n_from_the_sdram),
      .zs_cke   (zs_cke_from_the_sdram),
      .zs_cs_n  (zs_cs_n_from_the_sdram),
      .zs_dq    (zs_dq_to_and_from_the_sdram),
      .zs_dqm   (zs_dqm_from_the_sdram),
      .zs_ras_n (zs_ras_n_from_the_sdram),
      .zs_we_n  (zs_we_n_from_the_sdram)
    );

  initial
    clk_0 = 1'b0;
  always
    #10 clk_0 <= ~clk_0;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on