module mux2_1_4 (input logic [3:0] top, bot, input logic cin, output logic [3:0] S);

		// 4 bit parallel multiplexer implemented using case statement
		always_comb
		begin
				unique case(cin)
						1'b0	:	S <= top;
						1'b1	:	S <= bot;
				endcase
		end
		
		
endmodule 