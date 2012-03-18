// UKP
// version 1.0

//`define DEBUG

module ukp(clk, vcoclk, usbclk, vtune, clk_out, usb_dm, usb_dp, record_n,
`ifdef DEBUG
	sclk, sdata
`else
	kbd_adr, kbd_data
`endif
);
	input clk; // 14.318MHz
	input vcoclk; // 48MHz
	input usbclk; // 12MHz
	output vtune, clk_out;
	output record_n;
	inout usb_dm, usb_dp;
`ifdef DEBUG
	input sclk;
	output sdata;
`else
	input [3:0] kbd_adr;
	output [7:0] kbd_data;
`endif
	parameter S_OPCODE = 0;
	parameter S_LDI0 = 1;
	parameter S_LDI1 = 2;
	parameter S_B0 = 3;
	parameter S_B1 = 4;
	function sel4;
		input [1:0] sel;
		input [3:0] a;
		case (sel)
			2'b00: sel4 = a[3];
			2'b01: sel4 = a[2];
			2'b10: sel4 = a[1];
			2'b11: sel4 = a[0];
		endcase
	endfunction
	function [3:0] decode4;
		input [1:0] sel;
		input g;
		if (g)
			case (sel)
				2'b00: decode4 = 4'b0001;
				2'b01: decode4 = 4'b0010;
				2'b10: decode4 = 4'b0100;
				2'b11: decode4 = 4'b1000;
			endcase
		else decode4 = 4'b0000;
	endfunction
	wire [3:0] inst;
	wire sample;
	reg connected = 0, inst_ready = 0, g = 0, p = 0, m = 0, cond = 0, nak = 0, dm1 = 0;
	reg bank = 0, record1 = 0;
	reg [2:0] state = 0;
	reg [7:0] w = 0;
	reg [9:0] pc = 0;
	reg [2:0] timing = 0;
	reg [3:0] tmp = 0;
	reg [13:0] interval = 0;
	reg [5:0] bitadr = 0;
	reg [7:0] data = 0;
	clockgen clockgen(.refclk(clk), .vcoclk(vcoclk), .vtune(vtune), .clk_out(clk_out));
	ukprom ukprom(.clk(usbclk), .adr(pc), .data(inst));
	wire interval_cy = interval == 12001;
	wire next = ~(state == S_OPCODE & (
		~inst[3] & inst[2] & timing != 0 |
		~inst[3] & ~inst[2] & inst[1] & usb_dm |
		inst == 4'b1110 & ~interval_cy |
		inst == 4'b1101 & (~sample | (usb_dp | usb_dm) & w != 1)
	));
	wire branch = state == S_B1 & cond;
	wire record;
	wire [7:0] map;
	wire [3:0] keydata;
	always @(posedge usbclk) begin
		if (inst_ready) begin
			if (state == S_OPCODE) begin
				if (inst == 4'b0001) state <= S_LDI0;
				if (inst == 4'b1100) connected <= ~connected;
				if (~inst[3] & inst[2] & timing == 0) begin
					g <= ~inst[1] | ~inst[0];
					p <= ~inst[1] & inst[0];
					m <= inst[1] & ~inst[0];
				end
				if (inst[3] & ~inst[2]) begin
					state <= S_B0;
					cond <= sel4(inst[1:0], { ~usb_dm, connected, nak, w != 1 });
				end
				if (inst == 4'b1011 | inst == 4'b1101 & sample) w <= w - 1;
			end
			if (state == S_LDI0) begin
				w[3:0] <= inst;
				state <= S_LDI1;
			end
			if (state == S_LDI1) begin
				w[7:4] <= inst;
				state <= S_OPCODE;
			end
			if (state == S_B0) begin
				tmp <= inst;
				state <= S_B1;
			end
			if (state == S_B1) state <= S_OPCODE;
			if (next | branch) begin
				pc <= branch ? { inst, tmp, 2'b00 } : pc + 1;
				inst_ready <= 0;
			end
		end
		else inst_ready <= 1;
		if (inst_ready & state == S_OPCODE & inst == 4'b0010) begin
			timing <= 0;
			bitadr <= 0;
			nak <= 1;
		end
		else timing <= timing + 1;
		if (sample) begin
			if (bitadr == 8) nak <= usb_dm;
			data[6:0] <= data[7:1];
			data[7] <= dm1 ~^ usb_dm;
			dm1 <= usb_dm;
			bitadr <= bitadr + 1;
		end
		interval <= interval_cy ? 0 : interval + 1;
		record1 <= record;
		if (~record & record1) bank <= ~bank;
	end
	assign usb_dp = g ? p : 1'bZ;
	assign usb_dm = g ? m : 1'bZ;
	assign sample = inst_ready & state == S_OPCODE & inst == 4'b1101 & timing == 1;
	
`ifdef DEBUG
	reg [6:0] readadr = 0;
	reg [4:0] s_timing = 0;
	reg sclk1 = 0, sclk2 = 0;
	always @(posedge clk) begin
		if (sclk1 ^ sclk2) begin
			readadr <= readadr + 1;
		end
		else if (sclk2) begin
			if (s_timing == 31) readadr <= 0;
			else s_timing <= s_timing + 1;
		end
		else s_timing <= 0;
		sclk1 <= sclk;
		sclk2 <= sclk1;
	end
`endif // DEBUG

	assign record = connected & ~nak;
	assign record_n = ~record;
	keymap keymap(.clk(usbclk), .adr({ ~timing[0], data[6:0] }), .data(map));
	wire mod = bitadr == 24;
	assign keydata = mod ? { data[0] | data[4], data[1] | data[5], data[2] | data[6], data[3] | data[7] } : decode4(map[1:0], record1);
	wire [4:0] kbd_adr_in = record1 ? mod ? 5'b10001 : map[6:2] : interval[4:0];
   
`ifdef DEBUG
	RAMB4_S1_S4 keyboard(
		.CLKA(usbclk), .ADDRA({ 4'b0000, ~bank, readadr }), .DIA(1'b0), .DOA(sdata),
		.WEA(1'b0), .ENA(1'b1), .RSTA(1'b0),
		.WEB(~record1 | (mod | bitadr == 40 | bitadr == 48) & (timing == 0 | timing == 1)), 
		.ENB(~record1 | mod | map[7]), .RSTB(1'b0), .CLKB(usbclk), 
		.ADDRB({ 4'b0000, bank, kbd_adr_in }), .DIB(keydata));
`endif // DEBUG

`ifdef USE_XILINX
   RAMB4_S4_S8 keyboard(
						.CLKB(clk),
						.ADDRB({ 4'b0000, ~bank, kbd_adr}),
						.DIB(8'h00),
						.DOB(kbd_data),
						.WEA(~record1 | (mod | bitadr == 40 | bitadr == 48) & (timing == 0 | timing == 1)), 
						.ENA(~record1 | mod | map[7]),
						.RSTA(1'b0),
						.CLKA(usbclk), 
						.ADDRA({ 4'b0000, bank, kbd_adr_in }),
						.DIA(keydata), 
						.WEB(1'b0),
						.ENB(1'b1),
						.RSTB(1'b0)
						);
`endif // USE_XILINX

   ARAMB4_S4_S8 keyboard(
						 .data_a(keydata),
						 .wren_a(~record1 | (mod | bitadr == 40 | bitadr == 48) & (timing == 0 | timing == 1)),
						 .address_a({ 4'b0000, bank, kbd_adr_in }),
						 
						 .data_b(8'h00),
						 .address_b({ 4'b0000, ~bank, kbd_adr}),
						 .wren_b(1'b0),
						 
						 .clock_a(usbclk),
						 .enable_a(~record1 | mod | map[7]),
						 
						 .clock_b(clk),
						 .enable_b(1'b1),
						 
						 .aclr_a(1'b0),
						 .aclr_b(1'b0),
						 
						 .q_a(),
						 .q_b(kbd_data)
						 );

endmodule // ukp



module keymap(clk, adr, data);
	input clk;
	input [7:0] adr;
	output [7:0] data;
	reg [7:0] data; 
	always @(posedge clk) begin
		case (adr)
			8'h00: data = 8'b00000000;
			8'h01: data = 8'b00000000;
			8'h02: data = 8'b00000000;
			8'h03: data = 8'b00000000;
			8'h04: data = 8'b10010001;
			8'h05: data = 8'b10010010;
			8'h06: data = 8'b10010011;
			8'h07: data = 8'b10010100;
			8'h08: data = 8'b10010101;
			8'h09: data = 8'b10010110;
			8'h0a: data = 8'b10010111;
			8'h0b: data = 8'b10011000;
			8'h0c: data = 8'b10011001;
			8'h0d: data = 8'b10011010;
			8'h0e: data = 8'b10011011;
			8'h0f: data = 8'b10011100;
			8'h10: data = 8'b10011101;
			8'h11: data = 8'b10011110;
			8'h12: data = 8'b10011111;
			8'h13: data = 8'b10100000;
			8'h14: data = 8'b10100001;
			8'h15: data = 8'b10100010;
			8'h16: data = 8'b10100011;
			8'h17: data = 8'b10100100;
			8'h18: data = 8'b10100101;
			8'h19: data = 8'b10100110;
			8'h1a: data = 8'b10100111;
			8'h1b: data = 8'b10101000;
			8'h1c: data = 8'b10101001;
			8'h1d: data = 8'b10101010;
			8'h1e: data = 8'b10110001;
			8'h1f: data = 8'b10110010;
			8'h20: data = 8'b10110011;
			8'h21: data = 8'b10110100;
			8'h22: data = 8'b10110101;
			8'h23: data = 8'b10110110;
			8'h24: data = 8'b10110111;
			8'h25: data = 8'b10111000;
			8'h26: data = 8'b10111001;
			8'h27: data = 8'b10110000;
			8'h28: data = 8'b10001111;
			8'h29: data = 8'b11001111;
			8'h2a: data = 8'b11000011;
			8'h2b: data = 8'b00000000;
			8'h2c: data = 8'b11001110;
			8'h2d: data = 8'b10101111;
			8'h2e: data = 8'b10101110;
			8'h2f: data = 8'b10010000;
			8'h30: data = 8'b10101011;
			8'h31: data = 8'b10101100;
			8'h32: data = 8'b00000000;
			8'h33: data = 8'b10111011;
			8'h34: data = 8'b10111010;
			8'h35: data = 8'b00000000;
			8'h36: data = 8'b10111100;
			8'h37: data = 8'b10111101;
			8'h38: data = 8'b10111110;
			8'h39: data = 8'b00000001;
			8'h3a: data = 8'b11001001;
			8'h3b: data = 8'b11001010;
			8'h3c: data = 8'b11001011;
			8'h3d: data = 8'b11001100;
			8'h3e: data = 8'b11001101;
			8'h3f: data = 8'b00000000;
			8'h40: data = 8'b00000000;
			8'h41: data = 8'b00000000;
			8'h42: data = 8'b00000000;
			8'h43: data = 8'b00000000;
			8'h44: data = 8'b00000000;
			8'h45: data = 8'b11001000;
			8'h46: data = 8'b00000000;
			8'h47: data = 8'b00000000;
			8'h48: data = 8'b00000000;
			8'h49: data = 8'b00000000;
			8'h4a: data = 8'b00000000;
			8'h4b: data = 8'b00000000;
			8'h4c: data = 8'b00000000;
			8'h4d: data = 8'b00000000;
			8'h4e: data = 8'b00000000;
			8'h4f: data = 8'b11000010;
			8'h50: data = 8'b00000000;
			8'h51: data = 8'b00000000;
			8'h52: data = 8'b11000001;
			8'h53: data = 8'b11000000;
			8'h54: data = 8'b00000000;
			8'h55: data = 8'b10001010;
			8'h56: data = 8'b00000000;
			8'h57: data = 8'b10001011;
			8'h58: data = 8'b10001111;
			8'h59: data = 8'b10000001;
			8'h5a: data = 8'b10000010;
			8'h5b: data = 8'b10000011;
			8'h5c: data = 8'b10000100;
			8'h5d: data = 8'b10000101;
			8'h5e: data = 8'b10000110;
			8'h5f: data = 8'b10000111;
			8'h60: data = 8'b10001000;
			8'h61: data = 8'b10001001;
			8'h62: data = 8'b10000000;
			8'h63: data = 8'b10001110;
			8'h64: data = 8'b00000000;
			8'h65: data = 8'b00000000;
			8'h66: data = 8'b00000000;
			8'h67: data = 8'b10001100;
			8'h68: data = 8'b00000000;
			8'h69: data = 8'b00000000;
			8'h6a: data = 8'b00000000;
			8'h6b: data = 8'b00000000;
			8'h6c: data = 8'b00000000;
			8'h6d: data = 8'b00000000;
			8'h6e: data = 8'b00000000;
			8'h6f: data = 8'b00000000;
			8'h70: data = 8'b00000000;
			8'h71: data = 8'b00000000;
			8'h72: data = 8'b00000000;
			8'h73: data = 8'b00000000;
			8'h74: data = 8'b00000000;
			8'h75: data = 8'b00000000;
			8'h76: data = 8'b00000000;
			8'h77: data = 8'b00000000;
			8'h78: data = 8'b00000000;
			8'h79: data = 8'b00000000;
			8'h7a: data = 8'b00000000;
			8'h7b: data = 8'b00000000;
			8'h7c: data = 8'b00000000;
			8'h7d: data = 8'b00000000;
			8'h7e: data = 8'b00000000;
			8'h7f: data = 8'b00000000;
			8'h80: data = 8'b00000000;
			8'h81: data = 8'b00000000;
			8'h9b: data = 8'b11111111;
			8'h9d: data = 8'b11111000;
			8'hda: data = 8'b11111110;
			8'hdc: data = 8'b11111011;
			8'hde: data = 8'b11111101;
			8'he0: data = 8'b11111100;
			default: data = 8'bXXXXXXXX;
		endcase
	end
endmodule
