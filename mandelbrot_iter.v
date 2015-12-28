module mandelbrot_iter(in_real, in_imag, c_real, c_imag, out_real, out_imag, size_square, iters_in, iters_out);
	parameter width = 32;
	
	input signed   [width - 1:0] in_real;
	input signed   [width - 1:0] in_imag;
	input signed   [width - 1:0] c_real;
	input signed   [width - 1:0] c_imag;
	input unsigned [7:0]         iters_in;
	
	output signed   [width - 1:0] out_real;
	output signed   [width - 1:0] out_imag;
	output signed   [width - 1:0] size_square;
	output unsigned [7:0]         iters_out;
	
	wire   signed [width - 1:0] real_square;
	wire   signed [width - 1:0] imag_square;
	wire   signed [width - 1:0] mixed;
	
	fixed_multiplication m1(in_real, in_real, real_square);
	fixed_multiplication m2(in_imag, in_imag, imag_square);
	fixed_multiplication m3(in_real, in_imag, mixed);
	
	assign out_real    = real_square - imag_square + c_real;
	assign out_imag    = (mixed * 2) + c_imag;
	assign size_square = real_square + imag_square;
	assign iters_out   = size_square >= 32'h1000000 ? iters_in : iters_in + 1;
endmodule
