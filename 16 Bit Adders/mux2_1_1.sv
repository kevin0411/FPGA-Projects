module mux2_1_1 (input logic couttop, coutbot, select, output logic cout);

		// 2 bit parallel multiplexer implemented using case statement
		always_comb
		begin
				unique case(select)
						1'b0	:	cout <= couttop;
						1'b1	:	cout <= coutbot;
				endcase
		end
		
		
endmodule 