module test_mandelbrot_iter;

reg  signed [31:0] in_real;
reg  signed [31:0] in_imag;
reg  signed [31:0] c_real;
reg  signed [31:0] c_imag;
wire signed [31:0] out_real;
wire signed [31:0] out_imag;
wire signed [31:0] size_square;

mandelbrot_iter m(in_real, in_imag, c_real, c_imag, out_real, out_imag, size_square);

initial 
  begin 
    #5
	 in_real = 0;
	 in_imag = 0;
	 c_real  = 0;
	 c_imag  = 0;
	 
	 #5
	 in_real = 32'h7ae14;
	 in_imag = 32'h599999;
	 c_real  = 32'h800000;
	 c_imag  = 32'h1062;
	 
	 #5
	 in_real = 32'hfff851ec;
	 in_imag = 32'hffa66667;
	 c_real  = 32'h800000;
	 c_imag  = 32'hffffef9e;
	end
	
endmodule
