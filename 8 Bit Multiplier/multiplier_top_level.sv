//Top level for ECE 385 multiplier lab

module multiplier_top_level  (input Clk, Reset_Load_Clear, Run, 
						input [7:0]			Din,
						output logic [7:0]	Aval, Bval,
						output logic Xval,
						output logic [6:0]	Hex0, 
											Hex1, 
											Hex2, 
											Hex3
										);

		//local logic variables go here
	 logic  Clear_En, Shift_En, Add_En, Sub_En, Load, Reset, Run1;
	 logic [7:0] A, B, Din_S;
	 
	 
	 //We can use the "assign" statement to do simple combinational logic
	 assign Aval = A;
	 assign Bval = B;
//	 assign LED = {Execute_SH,LoadA_SH,LoadB_SH,Reset_SH}; //Concatenate is a common operation in HDL
	 
	 //Instantiation of modules here
	 register_unit    reg_unit (
                        .Clk(Clk),
                        .Clear_En(Clear_En),
                        .Add_En(Add_En), //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Sub_En(Sub_En),
								.Load(Load),
								.Shift_En(Shift_En),
								.Shift_In(A[7]),
								.D(Din_S),
								.A(A),
								.B(B),
								.X(Xval)
								);

	 control          control_unit (
                        .Clk(Clk),
                        .Reset_Load_Clear(Reset),
                        .M(B[0]),
                        .Run(Run1),
                        .Shift_En(Shift_En),
								.Add_En(Add_En),
								.Sub_En(Sub_En),
								.Clear_En(Clear_En),
								.Load(Load)
								);

// 74 8c				
	 HexDriver        HexAL (
                        .In0(Aval[3:0]),
                        .Out0(Hex2) );
	 HexDriver        HexBL (
                        .In0(Bval[3:0]),
                        .Out0(Hex0) );
								
	 HexDriver        HexAU (
                        .In0(Aval[7:4]),
                        .Out0(Hex3) );	
	 HexDriver        HexBU (
                       .In0(Bval[7:4]),
                        .Out0(Hex1) );
								
	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[1:0] (Clk, {~Reset_Load_Clear, ~Run}, {Reset, Run1});
	  sync Din_sync[7:0] (Clk, Din, Din_S);
							
			
endmodule
