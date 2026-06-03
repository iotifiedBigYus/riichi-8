
function new_hand()
	return {
		current = nil,
		rest = {},
		melds = {}
	}
end


function test_hand()
	return {
		is_closed = true,
		draw = {number = 1, suit = "m"},
		tiles = {
			{number = 1, suit = "m"},
			{number = 1, suit = "m"},
			{number = 2, suit = "m"},
			{number = 2, suit = "m"},
			{number = 7, suit = "p"},
			{number = 7, suit = "p"},
			{number = 7, suit = "p"},
			{number = 5, suit = "s"},
			{number = 6, suit = "s"},
			{number = 7, suit = "s"}
		},
		melds = {
			{
				type = "concealed quad",
				origin = "left",
				tiles = {
					{number = 1, suit = "z"},
					{number = 1, suit = "z"},
					{number = 1, suit = "z"},
					{number = 1, suit = "z"}
				}
			}
		}
	}
end


function test_hand2()
	return {
		is_closed = true,
		tiles = {
			{number = 2, suit = "m"},
			{number = 4, suit = "m"},
			{number = 6, suit = "m"},
			{number = 8, suit = "m"},
			{number = 1, suit = "m"},
			{number = 3, suit = "m"},
			{number = 5, suit = "m"},
			{number = 7, suit = "m"},
			{number = 9, suit = "m"},
			{number = 2, suit = "m"},
			{number = 4, suit = "m"},
			{number = 6, suit = "m"},
			{number = 8, suit = "m"}
		}
	}
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


function draw_tiles(tiles, n_player)
	if n_player == 1 then

	end
end


function test_discards()
	return {
		{number = 1, suit = "p"},
		{number = 9, suit = "m"},
		{number = 1, suit = "s", riichi = true},
		{number = 9, suit = "s"},
		{number = 5, suit = "z"},
		{number = 1, suit = "z"},
		{number = 8, suit = "s"},
		{number = 4, suit = "m"},
		{number = 7, suit = "s"},
		{number = 3, suit = "s"},
		{number = 1, suit = "s"}
	}
end

function test_discards2()
	return {
		{number = 1, suit = "p"},
		{number = 9, suit = "m"},
		{number = 1, suit = "s"},
		{number = 9, suit = "s"},
		{number = 5, suit = "z"},
		{number = 1, suit = "z"},
		{number = 8, suit = "s"},
		{number = 4, suit = "m"},
		{number = 7, suit = "s"},
		{number = 3, suit = "s", riichi = true},
		{number = 1, suit = "s", riichi = true},
		{number = 1, suit = "z"},
		{number = 2, suit = "z"},
		{number = 3, suit = "z"},
		{number = 4, suit = "z"},
		{number = 5, suit = "z"},
		{number = 6, suit = "z"},
		{number = 7, suit = "z"}
	}
end


function draw_discards(discards, i_player)
	if not i_player then i_player = 1 end

	if i_player == 1 then
		i_riichi = -1
		for i,t in ipairs(discards) do
			local ty = flr((i-1)/6)
			local x,y = X_P1_DISCARDS+(i-1)%6*6, Y_P1_DISCARDS+ty*8
			if i_riichi == ty then
				x+=2
			elseif t.riichi then
				i_riichi = ty
				y+=1
			end
			draw_tile(
				t,x,y,t.riichi
			)
		end
	elseif i_player == 2 then
		i_riichi = -1
		for i,t in ipairs(discards) do
			local ty = flr((i-1)/6)
			local x,y = X_P2_DISCARDS+ty*8, Y_P2_DISCARDS-(i-1)%6*6-6
			if i_riichi == ty then
				y-=2
			elseif t.riichi then
				i_riichi = ty
				x+=1
				y-=2
			end
			draw_tile(
				t,x,y, not t.riichi
			)
		end
	elseif i_player == 3 then
		i_riichi = -1
		for i,t in ipairs(discards) do
			local ty = flr((i-1)/6)
			local x,y = X_P3_DISCARDS-(i-1)%6*6-6, Y_P3_DISCARDS-ty*8-8
			if i_riichi == ty then
				x-=2
			elseif t.riichi then
				i_riichi = ty
				x-=2
				y+=1
			end
			draw_tile(
				t,x,y,t.riichi
			)
		end
	elseif i_player == 4 then
		i_riichi = -1
		for i,t in ipairs(discards) do
			local ty = flr((i-1)/6)
			local x,y = X_P4_DISCARDS-ty*8-8, Y_P4_DISCARDS+(i-1)%6*6
			if i_riichi == ty then
				y+=2
			elseif t.riichi then
				i_riichi = ty
				x+=1
			end
			draw_tile(
				t,x,y, not t.riichi
			)
		end
	end
end


function draw_tile(tile, x, y, horz)
	local w,h = 6,8
	if (horz) w,h = h,w

	local suit_color = {
		m = COLOR_MAN,
		p = COLOR_PIN,
		s = COLOR_SOU
	}

	if tile.suit != "z" then
		rectfill( -- backfill
			x, y, x+w, y+h,
			suit_color[tile.suit]
		)
	end
	rect(x,y,x+w,y+h,0) -- outline
	if tile.suit != "z" then
		local i = horz and SPR_TILE_NUMBERS_HORZ or SPR_TILE_NUMBERS_VERT
		spr(
			i+tile.number,
			x+1, y+1
		)
	else
		local i = horz and SPR_TILE_HONORS_HORZ or SPR_TILE_HONORS_VERT
		spr(
			i+tile.number,
			x+1, y+1
		)
	end
end


function draw_tile2(tile, x, y, horz)
	local w,h = 6,8
	if (horz) w,h = h,w

	-- backfill
	rectfill(
		x, y, x+w, y+h,
		get_tile_color(tile)
	)
	local n
	if tile <= 27 then
		local i = horz and SPR_TILE_NUMBERS_HORZ or SPR_TILE_NUMBERS_VERT
		n = i+(tile-1)%9+1
	elseif tile <= 34 then
		local i = horz and SPR_TILE_HONORS_HORZ or SPR_TILE_HONORS_VERT
		n = i+tile-27
	else
		n = horz and SPR_TILE_NUMBERS_HORZ or SPR_TILE_NUMBERS_VERT
	end
	spr(n, x+1, y+1)
	rect(x,y,x+w,y+h,0) -- outline
end


function get_tile_color(tile)
	if tile <= 9 or tile == 35 then return COLOR_MAN end
	if tile <= 18 or tile == 36 then return COLOR_PIN end
	if tile <= 27 or tile == 37 then return COLOR_SOU end
	return nil
end