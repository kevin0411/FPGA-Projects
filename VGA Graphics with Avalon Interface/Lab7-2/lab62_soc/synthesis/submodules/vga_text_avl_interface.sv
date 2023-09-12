/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x0257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/
`define NUM_REGS 601 //80*30 characters / 4 characters per register
`define CTRL_REG 600 //index of control register

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [9:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] LOCAL_REG       [`NUM_REGS]; // Registers
//put other local variables here
logic [10:0] rom_addr;
logic [7:0] rom_data;
logic [9:0] DrawX;
logic [9:0] DrawY;
logic pixel_clk, blank, sync;

//Declare submodules..e.g. VGA controller, ROMS, etc
//font_rom f_rom(.addr(rom_addr), .data(rom_data));
//vga_controller vga_control(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));

// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) 
begin
	if(AVL_READ && AVL_CS)
		AVL_READDATA <= LOCAL_REG[AVL_ADDR];
	else if(AVL_WRITE && AVL_CS)
		begin
			if(AVL_BYTE_EN == 4'b1111)
				LOCAL_REG[AVL_ADDR] <= AVL_WRITEDATA;
			else if(AVL_BYTE_EN == 4'b1100)
				LOCAL_REG[AVL_ADDR][31:16] <= AVL_WRITEDATA[31:16];
			else if(AVL_BYTE_EN == 4'b0011)
				LOCAL_REG[AVL_ADDR][15:0] <= AVL_WRITEDATA[15:0];
			else if(AVL_BYTE_EN == 4'b1000)
				LOCAL_REG[AVL_ADDR][31:24] <= AVL_WRITEDATA[31:24];
			else if(AVL_BYTE_EN == 4'b0100)
				LOCAL_REG[AVL_ADDR][23:16] <= AVL_WRITEDATA[23:16];
			else if(AVL_BYTE_EN == 4'b0010)
				LOCAL_REG[AVL_ADDR][15:8] <= AVL_WRITEDATA[15:8];
			else if(AVL_BYTE_EN == 4'b0001)
				LOCAL_REG[AVL_ADDR][7:0] <= AVL_WRITEDATA[7:0];
		end
end


//handle drawing (may either be combinational or sequential - or both).

	//Lab 7-1
//	logic shape_on;
//	logic shape2_on;
//	logic[10:0] shape_x = 300;
//	logic[10:0] shape_y = 300;
//	logic[10:0] shape_size_x = 8;
//	logic[10:0] shape_size_y = 16;

	//Lab 7-1
//	always_comb
//	begin:Ball_on_proc
//		if(DrawX >= shape_x && DrawX < shape_x + shape_size_x &&
//			DrawY >= shape_y && DrawY < shape_y + shape_size_y)
//		begin
//			shape_on = 1'b1;
//			shape2_on = 1'b0;
//			rom_addr = (DrawY - shape_y + 16*...);
//		end
//		else if(DrawX >= shape2_x && DrawX < shape2_x + shape2_size_x &&
//				DrawY >= shape2_y && DrawY < shape2_y + shape2_size_y)
//		begin
//			shape_on = 1'b0;
//			shape2_on = 1'b1;
//			rom_addr = (DrawY - shape2_y + 16*...);
//		end
//		else
//		begin
//			shape_on = 1'b0;
//			shape2_on = 1'b0;
//			rom_addr = 10'b0;
//		end
//	end
//
//	//Lab 7-1
//	always_comb
//	begin:RGB_Display
//		if ((shape_on == 1'b1) && rom_data[DrawX - shape_x] == 1'b1) 
//		begin 
//			Red = 8'h00;
//			Green = 8'hff;
//			Blue = 8'hff;
//		end       
//		else if ((shape2_on == 1'b1) && rom_data[DrawX - shape2_x] == 1'b1)
//		begin 
//			Red = 8'hff; 
//			Green = 8'hff;
//			Blue = 8'h00;
//		end
//		else
//		begin
//			Red = 8'h4f - DrawX[9:3];
//			Green = 8'h00;
//			Blue = 8'h44;
//		end
//	end 
		

endmodule
