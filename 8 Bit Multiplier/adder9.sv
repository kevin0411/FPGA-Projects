module adder9
(
	input  [7:0] A, S,
	output [7:0] A_new,
	output        X
);
	
	 logic c1, c2, c3, c4, c5, c6, c7, c8, c9;
	 full_adder FA0(.A(A[0]), .B(S[0]), .cin(0), .s(A_new[0]), .cout(c1));
	 full_adder FA1(.A(A[1]), .B(S[1]), .cin(c1), .s(A_new[1]), .cout(c2));
	 full_adder FA2(.A(A[2]), .B(S[2]), .cin(c2), .s(A_new[2]), .cout(c3));
	 full_adder FA3(.A(A[3]), .B(S[3]), .cin(c3), .s(A_new[3]), .cout(c4));
	 full_adder FA4(.A(A[4]), .B(S[4]), .cin(c4), .s(A_new[4]), .cout(c5));
	 full_adder FA5(.A(A[5]), .B(S[5]), .cin(c5), .s(A_new[5]), .cout(c6));
	 full_adder FA6(.A(A[6]), .B(S[6]), .cin(c6), .s(A_new[6]), .cout(c7));
	 full_adder FA7(.A(A[7]), .B(S[7]), .cin(c7), .s(A_new[7]), .cout(c8));
	 full_adder FA8(.A(A[7]), .B(S[7]), .cin(c8), .s(X), .cout(c9));
	 
endmodule
