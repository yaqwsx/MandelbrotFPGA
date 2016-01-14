import colorsys

levels = 31 
bits = 10

def v_num(num):
	return str(bits) + "'h" + hex(int(num))[2:]

print("case (iters)")

max = 2 ** bits - 1
for level in range (0, levels):
	if level == levels - 1:
		r, g, b = 0, 0, 0
	else:
		r, g, b = colorsys.hsv_to_rgb(88.0 / 360.0, 1, float(level) / (levels - 2))
	r, g, b = r * max, g * max, b * max
	s = "\t{0}: begin red <= {1}; green <= {2}; blue <= {3}; end".format(
		level, v_num(r), v_num(g), v_num(b))
	print(s)

print("\tdefault: begin red <= 10'h0; green <= 10'h0; blue <= 10'h0; end")
print("endcase")
