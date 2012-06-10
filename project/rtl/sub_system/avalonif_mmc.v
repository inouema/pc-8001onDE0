// Converted from avalonif_mmc.vhd
// by VHDL2Verilog ver1.00(2004/05/06)  Copyright(c) S.Morioka (http://www02.so-net.ne.jp/~morioka/v2v.htm)

//--------------------------------------------------------------------
// TITLE : MMC/SD SPI I/F for Avalon Slave
//
//     VERFASSER : S.OSAFUNE (J-7SYSTEM Works)
//     DATUM     : 2007/01/19 -> 2007/01/31 (HERSTELLUNG)
//               : 2007/01/31 (FESTSTELLUNG)
//
//               : 2008/07/17 FRCゼロフラグを追加 (NEUBEARBEITUNG)
//--------------------------------------------------------------------



module avalonif_mmc(
	clk,
	reset,
	chipselect,
	address,
	read,
	readdata,
	write,
	writedata,
	irq,
	MMC_nCS,
	MMC_SCK,
	MMC_SDO,
	MMC_SDI,
	MMC_CD,
	MMC_WP
	);

	//--- Avalonバス信号 -----------
	input			clk;
	input			reset;
	input			chipselect;
	input	[3:2]	address;
	input			read;
	output	[31:0]	readdata;
	input			write;
	input	[31:0]	writedata;
	output			irq;

	//--- MMC SPI信号 -----------
	// 各ピンの信号レベルはLVCMOSに設定すること
	output			MMC_nCS;
	output			MMC_SCK;
	output			MMC_SDO;
	//		MMC_SDI		: in  std_logic := '1';
	//		MMC_CD		: in  std_logic := '1';	-- カード挿入検出 
	//		MMC_WP		: in  std_logic := '1'	-- ライトプロテクト検出 
	input			MMC_SDI;
	input			MMC_CD;	// カード挿入検出 
	input			MMC_WP;	// ライトプロテクト検出 

	parameter IDLE	= 4'b1000;
	parameter SDO	= 4'b0100;
	parameter SDI	= 4'b0010;
	parameter DONE	= 4'b0001;

	reg 	[3:0]	state;
	reg     [7:0]   bitcount;

	wire	[31:0]	read_0_sig;
	wire	[31:0]	read_1_sig;
	wire	[31:0]	read_2_sig;

	reg 	[7:0]	divref_reg;
	reg 	[7:0]	divcount;
	reg 	[7:0]	rxddata;
	reg 	[7:0]	txddata;
	reg 			irqena_reg;
	reg 			exit_reg;
	reg 			mmc_wp_reg;
	reg 			mmc_cd_reg;
	reg 			ncs_reg;
	reg 			sck_reg;
	reg 			sdo_reg;
	reg 	[31:0]	frc_reg;
	reg 			frczero_reg;


	assign	irq	= (irqena_reg == 1'b1) ? (exit_reg) : (1'b0);

	assign	readdata	= (address == 2'b10) ? (read_2_sig)
				        : ((address == 2'b01) ? (read_1_sig) : (read_0_sig));

	assign	read_0_sig[31:16]	= 16'h0000;
	assign	read_0_sig[15]	= irqena_reg;
	assign	read_0_sig[14]	= 1'b0;
	assign	read_0_sig[13]	= 1'b0;
	assign	read_0_sig[12]	= frczero_reg;
	assign	read_0_sig[11]	= mmc_wp_reg;
	assign	read_0_sig[10]	= mmc_cd_reg;
	assign	read_0_sig[9]	= exit_reg;
	assign	read_0_sig[8]	= ncs_reg;
	assign	read_0_sig[7:0]	= rxddata;

	assign	read_1_sig[31:8]	= 24'h00_0000;
	assign	read_1_sig[7:0]	= divref_reg;

	assign	read_2_sig	= frc_reg;

	assign	MMC_nCS	= ncs_reg;
	assign	MMC_SCK	= sck_reg;
	assign	MMC_SDO	= sdo_reg;

	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			state	<= IDLE;
			divref_reg	<= 8'hFF;
			irqena_reg	<= 1'b0;
			ncs_reg	<= 1'b1;
			sck_reg	<= 1'b1;
			sdo_reg	<= 1'b1;
			exit_reg	<= 1'b1;
			frc_reg	<= 32'h0000_0000;
			frczero_reg	<= 1'b1;

		end else begin
			mmc_cd_reg	<= MMC_CD;
			mmc_wp_reg	<= MMC_WP;

			case (state)
			IDLE: begin
				if (chipselect == 1'b1 && write == 1'b1 && address[3] == 1'b0) begin
					case (address[2])
					1'b0: begin
						if (writedata[9] == 1'b0) begin
							state	<= SDO;
							bitcount	<= 0;
							divcount	<= divref_reg;
							exit_reg	<= 1'b0;
						end
						irqena_reg	<= writedata[15];
						ncs_reg	<= writedata[8];
						txddata	<= writedata[7:0];
					end
					1'b1: begin
						divref_reg	<= writedata[7:0];
					end
					endcase
				end
			end


			SDO: begin
				if (divcount == 0) begin
					state	<= SDI;
					divcount	<= divref_reg;
					sck_reg	<=  ~sck_reg;
					sdo_reg	<= txddata[7];
					txddata	<= {txddata[6:0], 1'b0};
				end else begin
					divcount	<= divcount - 1'b1;
				end
			end


			SDI: begin
				if (divcount == 0) begin
					if (bitcount == 7) begin
						state	<= DONE;
					end else begin
						state	<= SDO;
					end
					bitcount	<= bitcount + 1;
					divcount	<= divref_reg;
					sck_reg	<=  ~sck_reg;
					rxddata	<= {rxddata[6:0], MMC_SDI};
				end else begin
					divcount	<= divcount - 1'b1;
				end
			end

			DONE: begin
				if (divcount == 0) begin
					state	<= IDLE;
					sck_reg	<= 1'b1;
					sdo_reg	<= 1'b1;
					exit_reg	<= 1'b1;
				end else begin
					divcount	<= divcount - 1'b1;
				end
			end
			endcase

			if (chipselect == 1'b1 && write == 1'b1 && address == 2'b10) begin
				frc_reg	<= writedata;
			end else if (frc_reg != 0) begin
				frc_reg	<= frc_reg - 1'b1;
			end


			if (frc_reg == 0) begin
				frczero_reg	<= 1'b1;
			end else begin
				frczero_reg	<= 1'b0;
			end
		end
	end // always @ (posedge clk or posedge reset)

endmodule
