module full_adder (input logic A, B, cin, output logic s, cout);
	assign s = A^B^cin;
	assign cout = (A&B)|(B&cin)|(A&cin);
endmodule 
