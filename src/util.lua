-- util
-- https://easings.net/


util = {}


function empty_tiles()
	return split[[
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,
		0,0,0,
		0,0,0
	]]
end


function ease_in_out_quad(x)
	return x < 0.5 and 2 * x * x or 1 - (-2 * x + 2)^2 / 2
end