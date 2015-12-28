module test_mandelbrot;

reg                clk;
reg					 reset;
reg  signed [31:0] c_real;
reg  signed [31:0] c_imag;
wire               overflow;
wire signed [31:0] out_real;
wire signed [31:0] out_imag;

mandelbrot m(clk, reset, c_real, c_imag, overflow, out_real, out_imag);

always begin
	#1 clk = !clk;
end

initial begin
	clk = 0;
	reset = 1;
	#1
	
	#2
	c_real  = 32'h800000;
	c_imag  = 32'h800000;
	
	#2
	c_real = 32'hb851e;
	c_imag = 32'h1a3d70;
	
	#2
	c_real  = 32'h800000;
	c_imag  = 32'h800000;
end
	
endmodule
