// CLOCKGEN
// version 1.0

module clockgen(refclk, vcoclk, vtune, clk_out);
	input refclk;     // X'tal
	input vcoclk;     // GCK2 VCO Clock
	output vtune;
	output clk_out;
	reg phase_a, phase_b;
	assign vtune = ~phase_a & ~phase_b ? 1'bZ : phase_a; 
	reg [4:0] cnt_a;
	reg [5:0] cnt_b;
	reg carry_a, carry_b;
	assign full_a = cnt_a == 16;
	assign full_b = cnt_b == 56;
	always @(posedge refclk) begin
		cnt_a <= full_a ? 0 : cnt_a + 1;
		carry_a <= full_a;
	end
	always @(posedge vcoclk) begin
		cnt_b   <= full_b ? 0 : cnt_b + 1;
		carry_b <= full_b;
	end
	reg [1:0] cnt;
	always @(posedge vcoclk) cnt <= cnt + 1;
	assign clk_out = cnt[1];
	wire ph_sync = phase_a & phase_b;
	always @(posedge carry_a or posedge ph_sync) 
		phase_a <= ph_sync ? 1'b0 : 1'b1;
	always @(posedge carry_b or posedge ph_sync) 
		phase_b <= ph_sync ? 1'b0 : 1'b1;
endmodule
