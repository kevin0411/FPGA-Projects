module background2_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:76799] /* synthesis ram_init_file = "./background2/background2.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
