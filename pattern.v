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
	
	wire signed   [width - 1:0] out_real;
	wire signed   [width - 1:0] out_imag;

	fixed_multiplication f1(x1, 32'h4ceb, x2); // 1/213
	fixed_multiplication f2(y1, 32'h4ceb, y2); // 1/240, 32'h4444

	reg  [width - 1:0] c_real;
	reg  [width - 1:0] c_imag;
	wire               overflow;
	wire [7:0]         iters;

	mandelbrot m(clk, rst, x, y, overflow, out_real, out_imag, iters);
	
	always@(posedge clk)
	begin
		x1 <= ((x_in << fractional) - 32'h6A800000); // iX - 426
		y1 <= ((y_in << fractional) - 32'h3c000000); // iY - 240
		
		x <= x2;
		y <= y2;
		
		case (iters)
			0:	begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end
			1:	begin red <= 10'h31; green <= 10'h5d; blue <= 10'h0; end
			2:	begin red <= 10'h63; green <= 10'hba; blue <= 10'h0; end
			3:	begin red <= 10'h94; green <= 10'h117; blue <= 10'h0; end
			4:	begin red <= 10'hc6; green <= 10'h174; blue <= 10'h0; end
			5:	begin red <= 10'hf8; green <= 10'h1d1; blue <= 10'h0; end
			6:	begin red <= 10'h129; green <= 10'h22e; blue <= 10'h0; end
			7:	begin red <= 10'h15b; green <= 10'h28b; blue <= 10'h0; end
			8:	begin red <= 10'h18c; green <= 10'h2e8; blue <= 10'h0; end
			9:	begin red <= 10'h1be; green <= 10'h345; blue <= 10'h0; end
			10:	begin red <= 10'h1f0; green <= 10'h3a2; blue <= 10'h0; end
			11:	begin red <= 10'h221; green <= 10'h3ff; blue <= 10'h0; end
			12:	begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end
			default: begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end
		endcase

		/*if (overflow) begin
			red   <= 10'hFFF;
			green <= 10'hFFF;
			blue   <= 10'hFFF;
		end else begin
			red   <= 10'h0;
			green <= 10'h0;
			blue   <= 10'h0;
		end*/
	end

endmodule