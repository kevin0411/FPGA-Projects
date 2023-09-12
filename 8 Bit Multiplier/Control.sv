//Two-always example for state machine

module control (input  logic Clk, Reset_Load_Clear, M, Run,
                output logic Shift_En, Add_En, Sub_En, Clear_En, Load);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [5:0] {Y, A, A1, B, B1, C, C1, D, D1, E, E1, F, F1, G, G1, H, H1, I, I1, J, J1, K, K1, L, L1, N, N1, O, O1, P, P1, Q, R,T, Z}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset_Load_Clear)
            curr_state <= Y;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 

            Y : 	next_state = A;
				A :    if (Run)
								next_state=A1;
				A1: 	 if (!Run)
								if(M)
									next_state = B;
								else if(M==0) 
									next_state = C;				
            B :    next_state = B1; //Add state
				B1: 	 next_state = C; //Buffer state
            C :    next_state = C1; //Shift state
				C1:	 if (M) 
                       next_state = D;
						 else if(M==0) 
								next_state = E;
            D :    next_state = D1;
				D1: 	 next_state = E;
            E :	 next_state = E1; //Shift state
				E1 :    if (M) 
                       next_state = F;
						 else if(M==0) 
								next_state = G;
				F :    next_state = F1;
				F1: 	 next_state = G;
				G :	 next_state = G1; //Shift state
				G1 :	 if (M) 
                       next_state = H;
						 else if(M==0) 
								next_state = I;
				H :    next_state = H1;
				H1: 	 next_state = I;
				I :	 next_state = I1;
				I1 :	 if (M) 
                       next_state = J;
						 else if(M==0) 
								next_state = K;
            J :    next_state = J1;
				J1: 	 next_state = K;
				K :	 next_state = K1; //Shift state
				K1 :	 if (M) 
                       next_state = L;
						 else if(M==0) 
								next_state = N;
				L :    next_state = L1;
				L1: 	 next_state = N;
				N :	 next_state = N1; //Shift state
				N1 : 	 if (M) 
                       next_state = O;
						 else if(M==0) 
								next_state = P;
				O :    next_state = O1;
				O1: 	 next_state = P;
				P :	 next_state = P1; //Shift State
				P1 : 	 if (M) 
                       next_state = Q;
						 else if(M==0) 
								next_state = R;
				Q : 	 next_state = R;
				R : 	 next_state = T;
				T : if(Reset_Load_Clear)
								next_state = Y;
					 else if(Run)
								next_state = Z;
				Z : if (!Run)	 
						 if(M)
								next_state = B;
						 else if(M==0)
								next_state = C;
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
			  Y: 
					begin
						 Add_En = 1'b0;
						 Load = 1'b1;
						 Sub_En = 1'b0;
						 Clear_En = 1'b1;
						 Shift_En = 1'b0;
					end
	   	   A: 
	         begin
                Add_En = 1'b0;
					 Load = 1'b0;
					 Sub_En = 1'b0;
					 Clear_En = 1'b0;
                Shift_En = 1'b0;
		      end
	   	   Z: 
		      begin
                Add_En = 1'b0;
					 Load = 1'b0;
					 Sub_En = 1'b0;
					 Clear_En = 1'b1;
                Shift_En = 1'b0;
		      end
				B, D, F, H, J, L, O:
				begin
                Add_En = 1'b1;
					 Load = 1'b0;
					 Sub_En = 1'b0;
					 Clear_En = 1'b0;
                Shift_En = 1'b0;
		      end
				T:
				begin
                Add_En = 1'b0;
					 Load = 1'b0;
					 Sub_En = 1'b0;
					 Clear_En = 1'b0;
                Shift_En = 1'b0;
		      end
				Q:
				begin
                Add_En = 1'b0;
					 Load = 1'b0;
					 Sub_En = 1'b1;
					 Clear_En = 1'b0;
                Shift_En = 1'b0;
		      end
				C, E, G, I, K, N, P, R:
				begin
                Add_En = 1'b0;
					 Load = 1'b0;
					 Sub_En = 1'b0;
					 Clear_En = 1'b0;
                Shift_En = 1'b1;				
				end
	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 
                Add_En = 1'b0;
					 Load = 1'b0;
					 Sub_En = 1'b0;
					 Clear_En = 1'b0;
                Shift_En = 1'b0;
		      end
        endcase
    end

endmodule 