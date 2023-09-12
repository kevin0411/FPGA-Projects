module full_adder (input logic A, B, cin, output logic s, cout);
	assign s = A^B^cin;
	assign cout = (A&B)|(B&cin)|(A&cin);
endmodule 

module adder4 (input logic [3:0] A, B, input logic cin, output logic [3:0] s, output logic cout);
	
	logic c1, c2, c3;

	 full_adder FA0(.A(A[0]), .B(B[0]), .cin(cin), .s(s[0]), .cout(c1));
	 full_adder FA1(.A(A[1]), .B(B[1]), .cin(c1), .s(s[1]), .cout(c2));
	 full_adder FA2(.A(A[2]), .B(B[2]), .cin(c2), .s(s[2]), .cout(c3));
	 full_adder FA3(.A(A[3]), .B(B[3]), .cin(c3), .s(s[3]), .cout(cout));

endmodule 
