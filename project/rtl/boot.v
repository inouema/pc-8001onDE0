// BOOT
// version 1.0

module boot(clk, 
	ata_reset_n, ata_cs_n, ata_adr, ata_iord_n, ata_iowr_n, ata_data,
	ram_adr, ram_ce_n, ram_oe_n, ram_we_n, ram_data, 
	cpu_cs, cpu_adr, cpu_iord, cpu_iowr, data_in, data_out,
	cpu_reset_n);
	input clk;
	output [7:0] ram_data;
	input [2:0] cpu_adr;
	input cpu_cs, cpu_iord, cpu_iowr;
	input [7:0] data_in;
	output [7:0] data_out;
	output [1:0] ata_cs_n;
	output [2:0] ata_adr;
	output cpu_reset_n;
	output ata_reset_n, ata_iord_n, ata_iowr_n, ram_ce_n, ram_oe_n, ram_we_n;
	output [16:0] ram_adr;
	inout [15:0] ata_data;
	parameter ATA_DATA = 0;
	// ata write
	parameter ATA_SECTOR_COUNT = 2;
	parameter ATA_SECTOR_NUMBER = 3;
	parameter ATA_CYLINDER_LOW = 4;
	parameter ATA_CYLINDER_HIGH = 5;
	parameter ATA_DEVICE_HEAD = 6;
	parameter ATA_COMMAND = 7;
	// ata read
	parameter ATA_STATUS = 7;
	//	
	parameter A_STATE_END = 8;
	parameter A_STATE_READ_END = 4;
	parameter A_STATE_WRITE_END = 4;
	function [2:0] adr;
		input [3:0] state;
		case (state) 
			1: adr = ATA_STATUS;
			2: adr = ATA_DEVICE_HEAD;
			3: adr = ATA_STATUS;
			4: adr = ATA_SECTOR_COUNT;
			5: adr = ATA_SECTOR_NUMBER;
			6: adr = ATA_CYLINDER_LOW;
			7: adr = ATA_CYLINDER_HIGH;
			8: adr = ATA_DEVICE_HEAD;
			9: adr = ATA_COMMAND;
			10: adr = ATA_STATUS;
			11: adr = ATA_DATA;
			default: adr = cpu_adr;
		endcase
	endfunction
	function [7:0] data;
		input [3:0] state;
		case (state)
			2: data = 0;
			4: data = 8'h80;
			5: data = 8'h4d;
			6: data = 0;
			7: data = 0;
			8: data = 8'h40;
			9: data = 8'h20;
			default: data = data_in;
		endcase
	endfunction
	reg [3:0] state = 0;
	reg [3:0] a_state = 0;
	reg [15:0] data_tmp = 0;
	reg [16:0] ram_adr = 0;
	reg iord = 0, iowr = 0, cs0 = 0, data_g = 0, ram_we = 0, ram_data_g = 0, cpu_reset_n = 0;
	wire rd_g, wr_g;
	always @(posedge clk) begin
		if (state == 0) begin
			state <= 1;
			cs0 <= 1;
		end
		if (state == 1) begin
			if (a_state == 3) data_tmp <= ata_data;
			if (a_state == A_STATE_READ_END & ~data_tmp[3] & ~data_tmp[7]) begin
				state <= 2;
			end
		end
		if (state == 2) begin
			if (a_state == A_STATE_END) begin
				state <= 3;
			end
		end
		if (state == 3) begin
			if (a_state == 3) data_tmp <= ata_data;
			if (a_state == A_STATE_READ_END & ~data_tmp[3] & ~data_tmp[7]) begin
				state <= 4;
			end
		end
		if (state == 4) begin
			if (a_state == A_STATE_WRITE_END) begin
				state <= 5;
			end
		end
		if (state == 5) begin
			if (a_state == A_STATE_WRITE_END) begin
				state <= 6;
			end
		end
		if (state == 6) begin
			if (a_state == A_STATE_WRITE_END) begin
				state <= 7;
			end
		end
		if (state == 7) begin
			if (a_state == A_STATE_WRITE_END) begin
				state <= 8;
			end
		end
		if (state == 8) begin
			if (a_state == A_STATE_WRITE_END) begin
				state <= 9;
			end
		end
		if (state == 9) begin
			if (a_state == A_STATE_END) begin
				state <= 10;
			end
		end
		if (state == 10) begin
			if (a_state == 3) data_tmp <= ata_data;
			if (a_state == A_STATE_READ_END & ~data_tmp[7]) begin
				if (data_tmp[3]) begin
					state <= 11;
				end
				else begin
					state <= 12;
					ram_adr <= 0;
					cs0 <= 0;
			// release CPU reset if boot sequence has no error.
					cpu_reset_n <= ~data_tmp[0];
				end
			end
		end
		if (state == 11) begin
			if (a_state == 3) data_tmp <= ata_data;
			if (a_state == 5) begin
				data_tmp[7:0] <= data_tmp[15:8];
				ram_adr <= ram_adr + 1;
			end
			if (a_state == 8) ram_adr <= ram_adr + 1;
			if (a_state == A_STATE_END) begin
				state <= 10;
			end
		end
		// test
		if (state == 12) begin
			if (cpu_cs & cpu_iord) state <= 13;
			if (cpu_cs & cpu_iowr) state <= 14;
		end
		if (state == 13) begin
			if (a_state == 3) data_tmp <= ata_data;
			if (a_state == A_STATE_READ_END) state <= 15;
		end
		if (state == 14) begin
			if (a_state == A_STATE_WRITE_END) state <= 15;
		end
		if (state == 15 & ~cpu_iord & ~cpu_iowr) state <= 12;
		//
		if (state == 0 | 
			(state == 1 | state == 3) & a_state == A_STATE_READ_END & ~data_tmp[3] & ~data_tmp[7] | 
			(state == 1 | state == 3) & a_state == A_STATE_END | 
			(state == 4 | state == 5 | state == 6 | state == 7 | state == 8) & a_state == A_STATE_WRITE_END | 
			state == 10 & a_state == A_STATE_READ_END & data_tmp[3] & ~data_tmp[7] |
			state == 10 & a_state == A_STATE_END & data_tmp[7] |
			(state == 2 | state == 9 | state == 11) & a_state == A_STATE_END |
			state == 12 & cpu_cs & (cpu_iord | cpu_iowr))
				a_state <= 1;
		else if (a_state) a_state <= a_state + 1;
		iord <= (a_state == 1 | a_state == 2) & rd_g;
		iowr <= (a_state == 1 | a_state == 2) & wr_g;
		data_g <= (a_state == 1 | a_state == 2 | a_state == 3) & wr_g;
		ram_we <= (a_state == 3 | a_state == 6) & state == 11;
		ram_data_g <= state == 11;
	end
	assign rd_g = state == 1 | state == 3 | state == 10 | state == 11 | state == 13;
	assign wr_g = state == 2 | state == 4 | state == 5 | 
		state == 6 | state == 7 | state == 8 | state == 9 | state == 14;
	assign ata_data = data_g ? { 8'h00, data(state) } : 16'hZZZZ;
	assign ata_cs_n = { 1'b1, ~(cs0 | cpu_cs & (cpu_iord | cpu_iowr)) };
	assign ata_adr = adr(state);
	assign ata_iord_n = ~iord;
	assign ata_iowr_n = ~iowr;
	assign ram_ce_n = cpu_reset_n;
	assign ram_oe_n = 1'b1;
	assign ram_we_n = ~ram_we;
	assign ram_data = ram_data_g ? data_tmp : 8'hZZ;
	assign ata_reset_n = 1'b1;
	assign data_out = data_tmp[7:0];
endmodule
