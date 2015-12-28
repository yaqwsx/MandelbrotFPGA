module test_pattern;

wire [9:0] r;
wire [9:0] g;
wire [9:0] b;
reg  [9:0] x;
reg  [9:0] y;
reg        clk;
reg        reset;

pattern p(r, g, b, x, y, clk, reset);

always begin
	#1 clk = !clk;
end

initial begin
	clk = 0;
	reset = 1;
	#1
	
	#2
	x  = 10'd50;
	y  = 10'd42;
	
	#2
	x  = 10'd500;
	y  = 10'd38;
	
	#2
	x  = 10'd600;
	y  = 10'd256;
	
	#2
	x  = 10'd400;
	y  = 10'd450;
end
	
endmodule
