

module testbench();
 

timeunit 10ns;

 

timeprecision 1ns;

 

logic [9:0] SW;
logic	Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;


logic [15:0] PC, MAR, MDR, IR;

assign MAR = test.slc.MAR;
assign MDR = test.slc.MDR;
assign IR = test.slc.IR;
assign PC = test.slc.PC;


always begin : CLOCK_GENERATION

 

#1 Clk = ~Clk;

 

end

 

 

initial begin : CLOCK_INITIALIZATION

                Clk = 0;

end

 

 

slc3_testtop test(.*);

 

 

initial begin: TEST_VECTORS


Continue = 0;

Run = 0;

#2 Continue = 1;
#2 Run = 1;



#10 Run = 0;
#2 Run = 1;


#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;

#2 Continue = 0;
#2 Run = 0;

#2 Continue = 1;
#2 Run = 1;

#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;

#30 Continue = 0;
#2 Continue = 1;



end
endmodule
