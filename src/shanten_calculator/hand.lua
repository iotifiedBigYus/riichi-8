--https://github.com/Kraballa/ShantenCalculator/blob/master/ShantenCalculator/Hand.cs


hand = {}


function hand.generate()
	local all_tiles = {}
	local hand = {}

	for i = 1,34 do
		add(hand, 0)
		for _ = 1,4 do
			add(all_tiles,i)
		end
	end

	for _ = 1,14 do
		local tile = all_tiles[flr(rnd(#all_tiles))+1]
		hand[tile] += 1
		del(all_tiles, tile)
	end

	return hand
end


function hand.parse(line)
	local indices = {}
	local tiles = {}
	for _ = 1,34 do add(tiles,0) end
	
	for i = 1,#line do
		local offset = 0;
		local is_number = false;
		local s = sub( line, i,i )
		if s == 'm' then
			--
		elseif s == 'p' then
			offset = 9
		elseif s == 's' then
			offset = 18
		elseif s == 'z' then
			offset = 27
		else
			is_number = true
		end

		if is_number then
			add(indices, tonum(s));
		else
			foreach(indices, function(i)
				tiles[i + offset] += 1
			end)
			indices = {}
		end
	end

	return tiles;
end


function hand.encode(tiles)
	local code = ""
	local suffix = { "m", "p", "s", "z" }
	for i = 1,4 do
		local had_tile = false
		for j = 1,9 do
			if ((i-1) * 9 + j > 34) break
			local num = tiles[(i-1) * 9 + j];
			for _ = 1,num do
				had_tile = true;
				code ..= tonum(j)
			end
		end
		if (had_tile) code ..= suffix[i]
	end
	return code
end


function hand.encode9(tiles)
	local code = ""
	for j = 1,9 do
		local num = tiles[j];
		for _ = 1,num do
			code ..= tonum(j)
		end
	end
	return code
end


function hand.encode7(tiles)
	local code = ""
	for j = 1,7 do
		local num = tiles[j];
		for _ = 1,num do
			code ..= tonum(j)
		end
	end
	return code
end


function hand.print(tiles)
	print("\#0"..hand.encode(tiles))
end