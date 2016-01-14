module pattern(red, green, blue, x_in, y_in, clk, rst, zoom_level, keys);
	parameter fractional = 10;
	parameter integral   = 10;
	parameter width      = fractional + integral;						
							
	output reg [9:0] red;
	output reg [9:0] green;
	output reg [9:0] blue;
	input	     [9:0] x_in;
	input      [9:0] y_in;
	input		        clk;
	input            rst;
	input      [17:0] zoom_level;
	input      [3:0] keys;

	reg  signed [width - 1:0] x;
	reg  signed [width - 1:0] y;
	reg  signed [width - 1:0] x1;
	reg  signed [width - 1:0] y1;
	wire signed [width - 1:0] x2;
	wire signed [width - 1:0] y2;
	
	wire signed   [width - 1:0] out_real;
	wire signed   [width - 1:0] out_imag;
	
	reg unsigned [width - 1:0] zoom_level_w;
	reg unsigned [width - 1:0] x_offset = /*32'h1AA00;*/32'h6A800;
	reg unsigned [width - 1:0] y_offset = /*32'hF000*/32'h3c000;
	reg unsigned [width - 1:0] x_offset_zoom;
	reg unsigned [width - 1:0] y_offset_zoom;
	reg unsigned [8:0]        counter;

	fixed_multiplication f1(x1, zoom_level_w, x2); // 1/213
	fixed_multiplication f2(y1, zoom_level_w, y2); // 1/240, 32'h4444

	reg  [width - 1:0] c_real;
	reg  [width - 1:0] c_imag;
	wire               overflow;
	wire [7:0]         iters;

	mandelbrot m(clk, rst, x, y, overflow, out_real, out_imag, iters);
	
	always@(posedge clk) begin
		if (zoom_level[8] == 1)
			zoom_level_w <= 32'd1;
		else if (zoom_level[7] == 1)
			zoom_level_w <= 32'd2;
		else if (zoom_level[6] == 1)
			zoom_level_w <= 32'd3;
		else if (zoom_level[5] == 1)
			zoom_level_w <= 32'd4;
		else if (zoom_level[4] == 1)
			zoom_level_w <= 32'd5;
		else if (zoom_level[3] == 1)
			zoom_level_w <= 32'd6;
		else if (zoom_level[2] == 1)
			zoom_level_w <= 32'd7;
		else if (zoom_level[1] == 1)
			zoom_level_w <= 32'd8;
		else if (zoom_level[0] == 1)
			zoom_level_w <= 32'd9;
		else
			zoom_level_w <= 32'd10;
		//zoom_level_w <= zoom_level;
	end
	
	always@(posedge clk) begin
		counter <= counter + 1;
		if (keys[0] != 1 && counter == 0)
			x_offset <= x_offset + 32'h1;
		if (keys[1] != 1 && counter == 0)
			y_offset <= y_offset - 32'h1;
		if (keys[2] != 1 && counter == 0)
			y_offset <= y_offset + 32'h1;
		if (keys[3] != 1 && counter == 0)
			x_offset <= x_offset - 32'h1;
			
		x_offset_zoom = x_offset * zoom_level_w;
		y_offset_zoom = y_offset * zoom_level_w;
	end
	
	always@(posedge clk)
	begin
		x1 <= ((x_in << fractional) - x_offset); // iX - 426
		y1 <= ((y_in << fractional) - y_offset); // iY - 240
		
		x <= x2;
		y <= y2;
		
		case (iters)
        0: begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end
        1: begin red <= 10'h12; green <= 10'h23; blue <= 10'h0; end
        2: begin red <= 10'h25; green <= 10'h46; blue <= 10'h0; end
        3: begin red <= 10'h38; green <= 10'h69; blue <= 10'h0; end
        4: begin red <= 10'h4b; green <= 10'h8d; blue <= 10'h0; end
        5: begin red <= 10'h5e; green <= 10'hb0; blue <= 10'h0; end
        6: begin red <= 10'h70; green <= 10'hd3; blue <= 10'h0; end
        7: begin red <= 10'h83; green <= 10'hf6; blue <= 10'h0; end
        8: begin red <= 10'h96; green <= 10'h11a; blue <= 10'h0; end
        9: begin red <= 10'ha9; green <= 10'h13d; blue <= 10'h0; end
        10: begin red <= 10'hbc; green <= 10'h160; blue <= 10'h0; end
        11: begin red <= 10'hce; green <= 10'h184; blue <= 10'h0; end
        12: begin red <= 10'he1; green <= 10'h1a7; blue <= 10'h0; end
        13: begin red <= 10'hf4; green <= 10'h1ca; blue <= 10'h0; end
        14: begin red <= 10'h107; green <= 10'h1ed; blue <= 10'h0; end
        15: begin red <= 10'h11a; green <= 10'h211; blue <= 10'h0; end
        16: begin red <= 10'h12d; green <= 10'h234; blue <= 10'h0; end
        17: begin red <= 10'h13f; green <= 10'h257; blue <= 10'h0; end
        18: begin red <= 10'h152; green <= 10'h27a; blue <= 10'h0; end
        19: begin red <= 10'h165; green <= 10'h29e; blue <= 10'h0; end
        20: begin red <= 10'h178; green <= 10'h2c1; blue <= 10'h0; end
        21: begin red <= 10'h18b; green <= 10'h2e4; blue <= 10'h0; end
        22: begin red <= 10'h19d; green <= 10'h308; blue <= 10'h0; end
        23: begin red <= 10'h1b0; green <= 10'h32b; blue <= 10'h0; end
        24: begin red <= 10'h1c3; green <= 10'h34e; blue <= 10'h0; end
        25: begin red <= 10'h1d6; green <= 10'h371; blue <= 10'h0; end
        26: begin red <= 10'h1e9; green <= 10'h395; blue <= 10'h0; end
        27: begin red <= 10'h1fb; green <= 10'h3b8; blue <= 10'h0; end
        28: begin red <= 10'h20e; green <= 10'h3db; blue <= 10'h0; end
        29: begin red <= 10'h221; green <= 10'h3ff; blue <= 10'h0; end
        30: begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end
        default: begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end
endcase
	end

endmodule