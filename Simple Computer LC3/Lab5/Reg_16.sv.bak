module reg_8 (input  logic Clk, Clear_En, Shift_In, Load, Shift_En, Add_En, Sub_En,
              input  logic [7:0]  D,
              output logic [7:0]  Data_Out,
				  output logic Shift_Out, X);

		 logic [7:0]addtemp, subtemp;
		 logic ax, sx;
		 adder9 AD0(.A(Data_Out), .S(D), .A_new(addtemp), .X(ax));
		 subtracter9 SUB0(.A(Data_Out), .S(D), .A_new(subtemp), .X(sx));


    always_ff @ (posedge Clk)
    begin
	 	 if (Clear_En) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
		 begin
			  Data_Out <= 8'h0;
			  X=1'b0;
		 end
		 if (Load)
		 begin
			  Data_Out <= D;
			  X=1'b0;
		 end
		 if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
			  X=Shift_In;
	    end
		 if (Add_En)
		 begin
			X<=ax;
			Data_Out <= addtemp;
		 end
		 if (Sub_En)
		 begin
			X<=sx;
			Data_Out <= subtemp;
		 end
		 
    end
	 
	 assign Shift_Out = Data_Out[0];
	
endmodule 