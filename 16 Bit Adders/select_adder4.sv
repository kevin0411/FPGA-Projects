module select_adder4 (input [3:0] A, B, input cin, output [3:0] s, output cout);

	logic [3:0] tops;
	logic [3:0] bots;
	logic topcout, botcout;

	adder4 A40(.A(A), .B(B), .cin(1'b0), .s(tops), .cout(topcout));
	adder4 A41(.A(A), .B(B), .cin(1'b1), .s(bots), .cout(botcout));
	
	mux2_1_1 MU1(.couttop(topcout), .coutbot(botcout), .select(cin), .cout(cout));
	mux2_1_4 MU4(.top(tops), .bot(bots), .cin(cin), .S(s));

endmodule 