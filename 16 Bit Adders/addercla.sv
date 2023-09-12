module addercla (input logic A, B, cin, output logic s);
	assign s = A^B^cin;

endmodule 

module addercla4 (input logic [3:0] A, B, input logic cin, output logic [3:0] s, output logic pg, gg);
	
	logic g0, g1, g2, g3, p0, p1, p2, p3;
	logic c1, c2, c3;
	
		assign g0 = A[0]&B[0];
		assign g1 = A[1]&B[1];
		assign g2 = A[2]&B[2];
		assign g3 = A[3]&B[3];
		
		assign p0 = A[0]^B[0];
		assign p1 = A[1]^B[1];
		assign p2 = A[2]^B[2];
		assign p3 = A[3]^B[3];

		assign c1 = (cin&p0)|g0;
		assign c2 = ((cin&p0)|g0)&p1|g1;
		assign c3 = (((cin&p0)|g0)&p1|g1)&p2|g2;

		addercla CLA0(.A(A[0]), .B(B[0]), .cin(cin), .s(s[0]));
		addercla CLA1(.A(A[1]), .B(B[1]), .cin(c1), .s(s[1]));
		addercla CLA2(.A(A[2]), .B(B[2]), .cin(c2), .s(s[2]));
		addercla CLA3(.A(A[3]), .B(B[3]), .cin(c3), .s(s[3]));

		assign pg = p0&p1&p2&p3;
		assign gg = g3|(g2&p3)|(g1&p3&p2)|(g0&p3&p2&p1);

endmodule 

