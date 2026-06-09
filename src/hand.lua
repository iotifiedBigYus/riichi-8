

function parse_hand(line)
	local indices = {}
	local tiles = empty_tiles()
	
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


function encode_hand(tiles)
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


function draw_melds(meld_objs, i_player)
	for i,mo in ipairs(meld_objs) do
		local y = Y_P1_MELDS-8*i
		local x = X_P1_MELDS
		for t in all(mo.tiles) do
			if t > 0 then
				x -= 6
				draw_tile(t,x,y)
			elseif t < 0 then
				x -= 8
				draw_tile(-t,x,y+2,true)
			else
				if #mo.tiles == 3 then
					x-=8
					draw_quad_stack( x, y, true)
				else
					x-=6
					draw_tile_flipped( x, y )
				end
			end
		end
	end
end


function print_hand(hand)
	-- s t c o a
	-- l a r
	local symbol = {
		chii               = "s",
		triplet            = "t",
		["concealed quad"] = "c",
		["open quad"]      = "o",
		["added quad"]     = "a",
		left               = "l",
		across             = "a",
		right              = "r"
	}

	local out = "hand:\n"

	-- tiles
	local prev_suit = ""
	foreach(hand.tiles, function(t)
		if (t.suit != prev_suit) out ..= prev_suit
		prev_suit = t.suit
		out ..= tostr(t.number)
	end)
	out ..= prev_suit

	-- drawn tile
	if (hand.draw) out ..= "\n" .. tostr(hand.draw.number) .. hand.draw.suit

	-- melds
	foreach(hand.melds, function(m)
		out ..= "\n"
		foreach(m.tiles, function(t)
			out ..= tostr(t.number)
		end)
		out ..= m.tiles[1].suit .. symbol[m.type] .. symbol[m.origin]
		-- its assumed all tiles share the same suit, only first one is used
	end)

	-- of tiles previous positions
	out ..= "\n"
	foreach(hand.tiles, function(t)
		if(t.prev_pos) out ..= t.prev_pos .. " "
	end)

	print(out)
	return out
end


function sort_hand(hand)
	-- mutates the hand
	local tiles = hand.tiles

	for i=1,#tiles do
		tiles[i].prev_pos = i
	end
	
	for k,v in ipairs(tiles) do
		local j = k
		while j > 1 and tiles[j-1].number > tiles[j].number do
			tiles[j],tiles[j-1] = tiles[j-1],tiles[j]
			j = j - 1
		end
	end

	return hand
end


function is_complete(hand)
	tiles = {hand. draw, unpack(hand.tiles)}
end


function test_discards3()
	local tiles = {}
	for i = 1,37 do
		add(tiles,i)
	end
	return {
		riichi = 8,
		tiles = tiles
	}
end


function test_discards4()
	local tiles = {}
	for i = 14,37 do
		add(tiles,i)
	end
	return {
		riichi = 8,
		tiles = tiles
	}
end