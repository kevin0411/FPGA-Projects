//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, 
							   input logic vga_clk, blank,
                       output logic [3:0]  Red, Green, Blue );
    
    logic ball_on;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
	 
	logic [18:0] rom_address;
	logic [3:0] rom_q;
	logic [3:0] palette_red, palette_green, palette_blue;
	logic negedge_vga_clk;
	// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~vga_clk;
	  
	  
//	  ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
	 always_comb
    begin:Ball_on_proc
        if ( (DistX >= -Size && DistX <= Size) && (DistY >= -Size && DistY <= Size))	
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
	  
jet_rom jet_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

jet_palette jet_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	assign rom_address = ((DrawX * 80) / 640) + (((DrawY * 80) / 480) * 80);

	 always_ff @(posedge vga_clk)
    begin:RGB_Display
		if(!blank)
			begin
				Red = 4'b0000;
				Green = 4'b0000;
				Blue = 4'b0000;
			end
		else
		begin
        if ((ball_on == 1'b1)) 
        begin 
            Red = palette_red;
            Green = palette_green;
            Blue = palette_blue;
        end       
        else 
        begin 
            Red = 4'h0; 
            Green = 4'hf;
            Blue = 4'h5;
        end  
		end
    end
    
endmodule


