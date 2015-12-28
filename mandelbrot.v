
module mandelbrot(clk, reset, c_real_in, c_imag_in, overflow, real_out, imag_out, iters);
	parameter width      = 32;
	parameter iterations = 13;
	
	input                         reset;
	input                         clk;
	input  signed   [width - 1:0] c_real_in;
	input  signed   [width - 1:0] c_imag_in;
	output reg                    overflow;
	output signed   [width - 1:0] real_out;
	output signed   [width - 1:0] imag_out;
	output unsigned [7:0]         iters;
	

	reg  signed   [width - 1:0] i_real[0:iterations - 1];
	reg  signed   [width - 1:0] i_imag[0:iterations - 1];
	reg  signed   [width - 1:0] c_real[0:iterations - 1];
	reg  signed   [width - 1:0] c_imag[0:iterations - 1];
	wire signed   [width - 1:0] o_real[0:iterations - 1];
	wire signed   [width - 1:0] o_imag[0:iterations - 1];
	wire signed   [width - 1:0] size_square[0:iterations - 1];
	reg  unsigned [7:0]         iters_in[0:iterations - 1];
	wire unsigned [7:0]         iters_out[0:iterations - 1];
	
	assign real_out = o_real[iterations - 1];
	assign imag_out = o_imag[iterations - 1];
	assign iters    = iters_out[iterations - 1];

	genvar i;
	generate
		for (i = 0; i < iterations; i = i + 1) begin: mandelbrots
			mandelbrot_iter m(i_real[i], i_imag[i], c_real[i],
									c_imag[i], o_real[i], o_imag[i], size_square[i],
									iters_in[i], iters_out[i]);
		end
		
		always @(posedge clk or negedge reset) begin
			if (~reset) begin
				i_real[0] <= 32'd0;
				i_imag[0] <= 32'd0;
				c_real[0] <= 32'd0;
				c_imag[0] <= 32'd0;
				overflow <= 0;
			end else begin
				i_real[0] <= 32'd0;
				i_imag[0] <= 32'd0;
				c_real[0] <= c_real_in;
				c_imag[0] <= c_imag_in;
				overflow <= size_square[iterations - 1] >= 32'h1000000; // 4 in Q10.22
			end
		end

		for (i = 1; i < iterations; i = i + 1) begin: sets
			always @(posedge clk or negedge reset) begin
				if (~reset) begin
					i_real[i] <= 32'd0;
					i_imag[i] <= 32'd0;
					c_real[i] <= 32'd0;
					c_imag[i] <= 32'd0;
					iters_in[i] <= 8'd0;
				end else begin
					if (size_square[i - 1] >= 32'h1000000) begin
						i_real[i] <= 32'h1000000;
						i_imag[i] <= 32'h1000000;
						c_real[i] <= c_real[i - 1];
						c_imag[i] <= c_imag[i - 1];
						iters_in[i] <= iters_out[i - 1];
					end else begin
						i_real[i] <= o_real[i - 1];
						i_imag[i] <= o_imag[i - 1];
						c_real[i] <= c_real[i - 1];
						c_imag[i] <= c_imag[i - 1];
						iters_in[i] <= iters_out[i - 1];
					end
				end
			end
		end	
	endgenerate
endmodule
	
