module pattern(red, green, blue, x_in, y_in, clk, rst);
	parameter fractional = 22;
	parameter integral   = 10;
	parameter width      = fractional + integral;						
							
	output reg [9:0] red;
	output reg [9:0] green;
	output reg [9:0] blue;
	input	     [9:0] x_in;
	input      [9:0] y_in;
	input		        clk;
	input            rst;

	reg  signed [width - 1:0] x;
	reg  signed [width - 1:0] y;
	reg  signed [width - 1:0] x1;
	reg  signed [width - 1:0] y1;
	wire signed [width - 1:0] x2;
	wire signed [width - 1:0] y2;

	fixed_multiplication f1(x1, 32'h4ceb, x2); // 1/213
	fixed_multiplication f2(y1, 32'h4444, y2); // 1/240

	reg [width - 1:0] c_real;
	reg [width - 1:0] c_imag;
	wire              overflow;

	mandelbrot m(clk, rst, x, y, overflow);
	
	always@(posedge clk)
	begin
		x1 <= ((x_in << fractional) - 32'h6A800000); // (iX - 426) / 426
		y1 <= ((y_in << fractional) - 32'h3c000000); // (iY)
		
		x <= x2;
		y <= y2;
		
		if (overflow) begin
			red   <= 10'hFFF;
			green <= 10'hFFF;
			blue   <= 10'hFFF;
		end else begin
			red   <= 10'h0;
			green <= 10'h0;
			blue   <= 10'h0;
		end
	end

endmodule