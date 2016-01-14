// Displays a Mandelbrot set on VGA output
module MandelbrotFPGA(CLOCK_27, CLOCK_50, KEY, SW,	VGA_CLK,
							VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC,
							VGA_R, VGA_G, VGA_B, LEDG, LEDR);

input			  CLOCK_27;	//	27 MHz
input			  CLOCK_50;	//	50 MHz

input	 [3:0]  KEY;		//	Pushbutton[3:0]
input	 [17:0] SW;			//	Toggle Switch[17:0]
output [8:0]  LEDG;		//	LED Green[8:0]
output [17:0] LEDR;		//	LED Red[17:0]
output		  VGA_CLK;  //	VGA Clock
output		  VGA_HS;	//	VGA H_SYNC
output		  VGA_VS;	//	VGA V_SYNC
output		  VGA_BLANK;//	VGA BLANK
output		  VGA_SYNC;	//	VGA SYNC
output [9:0]  VGA_R;   	//	VGA Red[9:0]
output [9:0]  VGA_G;	 	//	VGA Green[9:0]
output [9:0]  VGA_B;   	//	VGA Blue[9:0]

wire		   VGA_CTRL_CLK;
wire		   AUD_CTRL_CLK;
wire [9:0]	mVGA_R;
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [9:0]  mVGA_X;
wire [9:0]  mVGA_Y;
wire		   DLY_RST;

Reset_Delay	   r0	(.iCLK(CLOCK_50), .oRESET(DLY_RST));
VGA_Audio_PLL 	p1	(.areset(~DLY_RST),.inclk0(CLOCK_27),.c0(VGA_CTRL_CLK),.c2(VGA_CLK));
VGA_Controller	u1	(	//	Host Side
							.iCursor_RGB_EN(4'h7),
							.oCoord_X(mVGA_X),
							.oCoord_Y(mVGA_Y),
							.iRed(mVGA_R),
							.iGreen(mVGA_G),
							.iBlue(mVGA_B),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST)	);
pattern			 u2	(mVGA_R, mVGA_G, mVGA_B, mVGA_X, mVGA_Y, VGA_CLK, DLY_RST, SW, KEY);

endmodule