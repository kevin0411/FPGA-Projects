module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  logic pg0, pg4, pg8, pg12;
	  logic gg0, gg4, gg8, gg12;
	  logic c4, c8, c12;
	 
		addercla4 CLA40 (.A(A[3:0]), .B(B[3:0]), .cin(cin), .s(S[3:0]), .pg(pg0), .gg(gg0));
		assign c4 = gg0|(pg0&cin);
		addercla4 CLA41 (.A(A[7:4]), .B(B[7:4]), .cin(c4), .s(S[7:4]), .pg(pg4), .gg(gg4));
		assign c8 = gg4|(gg0&pg4)|cin*pg0*pg4;
		addercla4 CLA42 (.A(A[11:8]), .B(B[11:8]), .cin(c8), .s(S[11:8]), .pg(pg8), .gg(gg8));
		assign c12 = gg8|(gg4*pg8)|(gg0*pg8*pg4)|(cin*pg8*pg4*pg0);
		addercla4 CLA43 (.A(A[15:12]), .B(B[15:12]), .cin(c12), .s(S[15:12]), .pg(pg12), .gg(gg12));
		assign cout = gg12|(pg12&(gg8|(gg4*pg8)|(gg0*pg8*pg4)|(cin*pg8*pg4*pg0)));

endmodule
