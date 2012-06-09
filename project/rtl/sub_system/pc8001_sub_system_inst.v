  //Example instantiation for system 'pc8001_sub_system'
  pc8001_sub_system pc8001_sub_system_inst
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

