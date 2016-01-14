module fixed_multiplication(a, b, res);
	parameter fractional = 10;
	parameter integral   = 10;
	parameter width      = fractional + integral;
	
	input  signed [width - 1:0] a;
	input  signed [width - 1:0] b;
	output signed [width - 1:0] res;
	
	wire   signed [width * 2 - 2:0] ab;
	
	assign ab  = a * b;
	assign res = ab[width + fractional - 1: fractional];
endmodule