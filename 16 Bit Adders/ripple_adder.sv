module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  //ogic c1, c2, c3;
	  
		//adder4 AD0(.A(A[3:0]), .B(B[3:0]), .cin(cin), .s(S[3:0]), .cout(c1));
		//adder4 AD1(.A(A[7:4]), .B(B[7:4]), .cin(c1), .s(S[7:4]), .cout(c2));
		//adder4 AD2(.A(A[11:8]), .B(B[11:8]), .cin(c2), .s(S[11:8]), .cout(c3));
		//adder4 AD3(.A(A[15:12]), .B(B[15:12]), .cin(c3), .s(S[15:12]), .cout(cout));		
		
	
	 logic c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;
	 full_adder FA0(.A(A[0]), .B(B[0]), .cin(cin), .s(S[0]), .cout(c1));
	 full_adder FA1(.A(A[1]), .B(B[1]), .cin(c1), .s(S[1]), .cout(c2));
	 full_adder FA2(.A(A[2]), .B(B[2]), .cin(c2), .s(S[2]), .cout(c3));
	 full_adder FA3(.A(A[3]), .B(B[3]), .cin(c3), .s(S[3]), .cout(c4));
	 full_adder FA4(.A(A[4]), .B(B[4]), .cin(c4), .s(S[4]), .cout(c5));
	 full_adder FA5(.A(A[5]), .B(B[5]), .cin(c5), .s(S[5]), .cout(c6));
	 full_adder FA6(.A(A[6]), .B(B[6]), .cin(c6), .s(S[6]), .cout(c7));
	 full_adder FA7(.A(A[7]), .B(B[7]), .cin(c7), .s(S[7]), .cout(c8));
	 full_adder FA8(.A(A[8]), .B(B[8]), .cin(c8), .s(S[8]), .cout(c9));
	 full_adder FA9(.A(A[9]), .B(B[9]), .cin(c9), .s(S[9]), .cout(c10));
	 full_adder FA10(.A(A[10]), .B(B[10]), .cin(c10), .s(S[10]), .cout(c11));
	 full_adder FA11(.A(A[11]), .B(B[11]), .cin(c11), .s(S[11]), .cout(c12));
	 full_adder FA12(.A(A[12]), .B(B[12]), .cin(c12), .s(S[12]), .cout(c13));
	 full_adder FA13(.A(A[13]), .B(B[13]), .cin(c13), .s(S[13]), .cout(c14));
	 full_adder FA14(.A(A[14]), .B(B[14]), .cin(c14), .s(S[14]), .cout(c15));
	 full_adder FA15(.A(A[15]), .B(B[15]), .cin(c15), .s(S[15]), .cout(cout));
     
endmodule
