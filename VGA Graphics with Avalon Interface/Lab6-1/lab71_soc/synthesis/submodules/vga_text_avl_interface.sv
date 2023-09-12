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
font_rom f_rom(.addr(rom_addr), .data(rom_data));
vga_controller vga_control(.Clk(CLK), .Reset(RESET), .hs(hs), .vs(vs), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .DrawX(DrawX), .DrawY(DrawY));

// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff
always_ff @(posedge CLK) 
begin
	if(RESET)
		begin
		int i;
		for(i = 0; i < 601; i++)
			LOCAL_REG[i] = 32'b00000000000000000000000000000000;
		end
	else if(AVL_READ && AVL_WRITE && AVL_CS)
		begin
		end
	else if(AVL_READ && AVL_CS)
		AVL_READDATA <= LOCAL_REG[AVL_ADDR];
	else if(AVL_WRITE && AVL_CS)
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


//handle drawing (may either be combinational or sequential - or both).
	//Lab 7-1
	logic [3:0] BKG_B;
	logic [3:0] BKG_G;
	logic [3:0] BKG_R;
	logic [3:0] FGD_B;
	logic [3:0] FGD_G;
	logic [3:0] FGD_R;
	
	always_comb
	begin
		BKG_B = LOCAL_REG[600][4:1];
		BKG_G = LOCAL_REG[600][8:5];
		BKG_R = LOCAL_REG[600][12:9];
		FGD_B = LOCAL_REG[600][16:13];
		FGD_G = LOCAL_REG[600][20:17];
		FGD_R = LOCAL_REG[600][24:21];
	end
	
	//Lab 7-1
	logic shape_on;
	logic shape2_on;
	logic shape3_on;
	logic shape4_on;
	logic[10:0] shape_size_x = 8;
	logic[10:0] shape_size_y = 16;

	//Lab 7-1
	logic [6:0]col;
	logic [5:0]row;
	logic [10:0]shape_x;
	logic [10:0]shape_y;
	logic [11:0]addr;
	logic [31:0]data;
	
	always_comb
	begin
		col = DrawX[9:3];
		row = DrawY[9:4];
		shape_x = col << 3;
		shape_y = row << 4;
		addr = (row*80) + col;
		addr = addr[11:2];
		data = LOCAL_REG[addr];
	end
	
	always_comb
	begin:Ball_on_proc
//		if(DrawX >= shape_x && DrawX < (shape_x + shape_size_x) &&
//			DrawY >= shape_y && DrawY < (shape_y + shape_size_y))
		if(col[1:0] == 2'b00)
		begin
			shape_on = 1'b1;
			shape2_on = 1'b0;
			shape3_on = 1'b0;
			shape4_on = 1'b0;
			rom_addr = (DrawY - shape_y + 16*data[6:0]);
		end
//		else if(DrawX >= (shape_x + shape_size_x) && DrawX < (shape_x + shape_size_x + shape_size_x) &&
//				DrawY >= shape_y && DrawY < (shape_y + shape_size_y))
		else if(col[1:0] == 2'b01)
		begin
			shape_on = 1'b0;
			shape2_on = 1'b1;
			shape3_on = 1'b0;
			shape4_on = 1'b0;
			rom_addr = (DrawY - shape_y + 16*data[14:8]);
		end
//		else if(DrawX >= (shape_x + shape_size_x + shape_size_x) && DrawX < (shape_x + shape_size_x + shape_size_x + shape_size_x) &&
//				DrawY >= shape_y && DrawY < (shape_y + shape_size_y))
		else if(col[1:0] == 2'b10)
		begin
			shape_on = 1'b0;
			shape2_on = 1'b0;
			shape3_on = 1'b1;
			shape4_on = 1'b0;
			rom_addr = (DrawY - shape_y + 16*data[22:16]);
		end
//		else if(DrawX >= (shape_x + shape_size_x + shape_size_x + shape_size_x) && DrawX < (shape_x + shape_size_x + shape_size_x + shape_size_x + shape_size_x) &&
//				DrawY >= shape_y && DrawY < (shape_y + shape_size_y))
		else if(col[1:0] == 2'b11)
		begin
			shape_on = 1'b0;
			shape2_on = 1'b0;
			shape3_on = 1'b0;
			shape4_on = 1'b1;
			rom_addr = (DrawY - shape_y + 16*data[30:24]);
		end
		else
		begin
			shape_on = 1'b0;
			shape2_on = 1'b0;
			shape3_on = 1'b0;
			shape4_on = 1'b0;
			rom_addr = 10'b0;
		end
	end
	
	always_ff @(posedge pixel_clk) 
	begin:RGB_Display
	if(!blank)
		begin
			red = 4'b0000;
			green = 4'b0000;
			blue = 4'b0000;
		end
	else
		begin
			if ((shape_on == 1'b1))
			begin
				if(rom_data[7 - (DrawX - shape_x)] == 1'b1)
				begin
					if(data[7]==0)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
				else
				begin
					if(data[7]==1)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
			end
			else if ((shape2_on == 1'b1))
			begin
				if(rom_data[7 - (DrawX - shape_x - shape_x)] == 1'b1)
				begin
					if(data[15]==0)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
				else
				begin
					if(data[15]==1)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
			end
			else if ((shape3_on == 1'b1))
			begin
				if(rom_data[7 - (DrawX - shape_x - shape_x - shape_x)] == 1'b1)
				begin
					if(data[23]==0)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
				else
				begin
					if(data[23]==1)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
			end
			else if ((shape4_on == 1'b1))
			begin
				if(rom_data[7 - (DrawX - shape_x - shape_x - shape_x - shape_x)] == 1'b1)
				begin
					if(data[31]==0)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
				else
				begin
					if(data[31]==1)
					begin
						red = FGD_R;
						green = FGD_G;
						blue = FGD_B;
					end
					else
					begin
						red = BKG_R;
						green = BKG_G;
						blue = BKG_B;
					end
				end
			end
			else
			begin
				red = BKG_R;
				green = BKG_G;
				blue = BKG_B;
			end
		end
	end 
		

endmodule
