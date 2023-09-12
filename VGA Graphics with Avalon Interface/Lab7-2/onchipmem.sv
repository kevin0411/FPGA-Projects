`define NUM_REGS 601
`define CTRL_REG 600

module ram_32x8 #(parameter N = `NUM_REGS)(
						input [31:0] AVL_WRITEDATA,
						input [11:0] AVL_ADDR,
						input we, clk, reset,
						input logic [3:0] AVL_BYTE_EN,
						output logic[31:0] q
);
	logic [7:0] mem[N-1];

	always_ff@(posedge clk) 
	begin: on_chip
		if(we)
			if(AVL_BYTE_EN == 4'b1111)
				mem[AVL_ADDR] <= AVL_WRITEDATA;
			else if(AVL_BYTE_EN == 4'b1100)
				mem[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
			else if(AVL_BYTE_EN == 4'b0011)
				mem[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
			else if(AVL_BYTE_EN == 4'b1000)
				mem[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
			else if(AVL_BYTE_EN == 4'b0100)
				mem[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
			else if(AVL_BYTE_EN == 4'b0010)
				mem[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
			else if(AVL_BYTE_EN == 4'b0001)
				mem[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
		q<=mem[AVL_ADDR];
	end

endmodule 