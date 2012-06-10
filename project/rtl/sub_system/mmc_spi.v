// mmc_spi.v

// This file was auto-generated as part of a generation operation.
// If you edit it your changes will probably be lost.

`timescale 1 ps / 1 ps
module mmc_spi (
		input  wire        clk,        //            clock.clk
		input  wire        chipselect, //   avalon_slave_0.chipselect
		input  wire [1:0]  address,    //                 .address
		input  wire        read,       //                 .read
		output wire [31:0] readdata,   //                 .readdata
		input  wire        write,      //                 .write
		input  wire [31:0] writedata,  //                 .writedata
		input  wire        reset,      // clock_sink_reset.reset
		output wire        MMC_SCK,    //      conduit_end.export
		output wire        MMC_SDO,    //                 .export
		input  wire        MMC_SDI,    //                 .export
		input  wire        MMC_CD,     //                 .export
		input  wire        MMC_WP,     //                 .export
		output wire        MMC_nCS,    //                 .export
		output wire        irq         // interrupt_sender.irq
	);

	avalonif_mmc #(
		.IDLE (5'b01000),
		.SDO  (5'b00100),
		.SDI  (5'b00010),
		.DONE (5'b00001)
	) mmc_spi (
		.clk        (clk),        //            clock.clk
		.chipselect (chipselect), //   avalon_slave_0.chipselect
		.address    (address),    //                 .address
		.read       (read),       //                 .read
		.readdata   (readdata),   //                 .readdata
		.write      (write),      //                 .write
		.writedata  (writedata),  //                 .writedata
		.reset      (reset),      // clock_sink_reset.reset
		.MMC_SCK    (MMC_SCK),    //      conduit_end.export
		.MMC_SDO    (MMC_SDO),    //                 .export
		.MMC_SDI    (MMC_SDI),    //                 .export
		.MMC_CD     (MMC_CD),     //                 .export
		.MMC_WP     (MMC_WP),     //                 .export
		.MMC_nCS    (MMC_nCS),    //                 .export
		.irq        (irq)         // interrupt_sender.irq
	);

endmodule
