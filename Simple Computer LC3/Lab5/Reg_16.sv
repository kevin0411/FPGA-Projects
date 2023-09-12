module reg_16 (input  logic Clk, Load, Reset,
              input  logic [15:0]  Din,
              output logic [15:0]  Dout);


    always_ff @ (posedge Clk)
    begin
		 if (Load)
		 begin
			  Dout <= Din;
		 end
		 if (Reset)
		 begin
			  Dout <= 16'b0;
		 end
    end
	
endmodule 