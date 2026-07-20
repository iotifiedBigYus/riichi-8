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


function parse_line(line)
	local indices = {}
	local n_tiles = empty_tiles()
	
	for i = 1,#line do
		local offset = 0;
		local is_number = false;
		local s = sub( line, i,i )
		if s == 'm' then
			--
		elseif s == 'p' then
			offset = 1
		elseif s == 's' then
			offset = 2
		elseif s == 'z' then
			offset = 3
		else
			is_number = true
		end

		if is_number then
			add(indices, tonum(s));
		else
			foreach(indices, function(i)
				if i > 0 then
					n_tiles[i + offset*9] += 1
				else
					n_tiles[35 + offset] += 1
				end
			end)
			indices = {}
		end
	end

	return n_tiles;
end


function encode_n_tiles(n_tiles, in_color)
	local code = in_color and "\#0" or ""
	local suffix = { "m", "p", "s", "z" }

	for i = 1,4 do
		local had_tile = false

		code ..= in_color and ({"\f8", "\fc", "\fb", "\f6" })[i] or ""

		-- red fives
		if i <= 3 do
			local n = n_tiles[34 + i];
			for _ = 1,n do
				had_tile = true;
				code ..= 0
			end
		end
		-- number tiles
		for j = 1,9 do
			local t = (i-1) * 9 + j
			if (t > 34) break
			local n = n_tiles[t];
			for _ = 1,n do
				had_tile = true;
				code ..= j
			end
		end
		if (had_tile) code ..= suffix[i]
	end
	return code
end