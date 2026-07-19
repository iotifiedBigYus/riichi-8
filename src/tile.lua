-- tile functions


assert(util)


function parse_tiles(line)
	local indices = {}
	local tiles = empty_tiles()
	
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
					tiles[i + offset*9] += 1
				else
					tiles[35 + offset] += 1
				end
			end)
			indices = {}
		end
	end

	return tiles;
end


function encode_tiles(tiles, in_color)
	local code = in_color and "\#0" or ""
	local suffix = { "m", "p", "s", "z" }

	for i = 1,4 do
		local had_tile = false

		code ..= in_color and ({"\f8", "\fc", "\fb", "\f6" })[i] or ""

		-- red fives
		if i <= 3 do
			local n = tiles[34 + i];
			for _ = 1,n do
				had_tile = true;
				code ..= 0
			end
		end
		-- number tiles
		for j = 1,9 do
			local t = (i-1) * 9 + j
			if (t > 34) break
			local n = tiles[t];
			for _ = 1,n do
				had_tile = true;
				code ..= j
			end
		end
		if (had_tile) code ..= suffix[i]
	end
	return code
end