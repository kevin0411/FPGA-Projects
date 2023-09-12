module register_unit (input  logic Clk, Clear_En, Add_En, Sub_En, Load, 
                            Shift_En, Shift_In,
                      input  logic [7:0]  D, 
                      output logic [7:0]  A,
                      output logic [7:0]  B,
							 output logic X);
	 logic A_out, B_out, x1;
    reg_8  reg_A (.Clk(Clk), .Clear_En(Clear_En), .Shift_In(Shift_In), .Load(0), .Shift_En(Shift_En), .Add_En(Add_En), .Sub_En(Sub_En),
	               .D(D), .Shift_Out(A_out), .X(X), .Data_Out(A));
    reg_8  reg_B (.Clk(Clk), .Clear_En(0), .Shift_In(A_out), .Load(Load), .Shift_En(Shift_En), .Add_En(0), .Sub_En(0), .D(D),
						.Shift_Out(B_out), .X(x1), .Data_Out(B));

endmodule
