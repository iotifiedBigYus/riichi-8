
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



function test_player_hand()
	local dt = {tile = 14, x = 0x71, y = 114}
	return {
		is_closed = false,
		drawn_tile = 14,
		i_selected_obj = 8,
		selected_obj = dt,
		tiles = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},

		tile_objs = {
			{tile =  1, x = 0x07, y = 116},
			{tile =  2, x = 0x0F, y = 116},
			{tile =  3, x = 0x17, y = 116},
			{tile =  4, x = 0x1F, y = 116},
			{tile =  5, x = 0x27, y = 116},
			{tile =  6, x = 0x2F, y = 116},
			{tile =  7, x = 0x37, y = 116},
			{tile =  8, x = 0x3F, y = 116},
			{tile =  9, x = 0x47, y = 116},
			{tile = 10, x = 0x4F, y = 116},
			{tile = 11, x = 0x57, y = 116},
			{tile = 12, x = 0x5F, y = 116},
			{tile = 13, x = 0x67, y = 116},
			dt
		},
	}
end


function test_player()
	return {
		hand = test_player_hand()
	}
end


function update_player(player)
	assert(player)
	update_player_hand(player.hand)
end


function update_player_hand(player_hand)
	assert(player_hand)
	--⬆️, ⬇️, ⬅️, ➡️, 
	if btnp(⬅️) then
		switch_selected_tile(player_hand, (player_hand.i_selected_obj-2)%#player_hand.tile_objs+1)
	elseif btnp(➡️) then
		switch_selected_tile(player_hand, (player_hand.i_selected_obj  )%#player_hand.tile_objs+1)
	end
end


function switch_selected_tile(player_hand, i)
	if(player_hand.selected_obj) player_hand.selected_obj.y = Y_P1_HAND
	player_hand.i_selected_obj = i
	player_hand.selected_obj = player_hand.tile_objs[i]
	player_hand.selected_obj.y = Y_P1_HAND - 2
end


function draw_player(player)
	assert(player)
	draw_player_hand(player.hand)
end


function draw_player_hand(player_hand)
	assert(player_hand)
	print(player_hand.i_selected_obj)
	draw_player_tiles(player_hand.tile_objs)
end


function draw_player_tiles(tile_objs)
	for to in all(tile_objs) do
		draw_large_tile(to.tile, to.x, to.y)
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


function draw_tiles(tiles, n_player)
	if n_player == 1 then

	end
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


function draw_discards(discards, i_player)
	i_player = i_player or 1
	local ry = flr((discards.riichi-1)/6)

	if i_player == 1 then
		for i,t in ipairs(discards.tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P1_DISCARDS+(i-1)%6*6, Y_P1_DISCARDS+ty*8
			if ry == ty and i > discards.riichi then
				x+=2
			elseif discards.riichi == i then
				y+=1
			end
			draw_tile(
				t,x,y,discards.riichi == i
			)
		end
	elseif i_player == 2 then
		for i,t in ipairs(discards.tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P2_DISCARDS+ty*8, Y_P2_DISCARDS-(i-1)%6*6-6
			if ry == ty and i > discards.riichi then
				y-=2
			elseif discards.riichi == i then
				x+=1
				y-=2
			end
			draw_tile(
				t,x,y,discards.riichi != i
			)
		end
	elseif i_player == 3 then
		for i,t in ipairs(discards.tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P3_DISCARDS-(i-1)%6*6-6, Y_P3_DISCARDS-ty*8-8
			if ry == ty and i > discards.riichi then
				x-=2
			elseif discards.riichi == i then
				x-=2
				y+=1
			end
			draw_tile(
				t,x,y,discards.riichi == i
			)
		end
	elseif i_player == 4 then
		for i,t in ipairs(discards.tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P4_DISCARDS-ty*8-8, Y_P4_DISCARDS+(i-1)%6*6
			if ry == ty and i > discards.riichi then
				y+=2
			elseif discards.riichi == i then
				x+=1
			end
			draw_tile(
				t,x,y,discards.riichi != i
			)
		end
	end
end


function draw_tile(tile, x, y, horz)
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


function draw_all_tiles()
	for i = 1,37 do
		draw_tile(i,(i-1)%21*6,flr((i-1)/21)*8)
	end
end


function get_tile_color(tile)
	if tile <= 9 or tile == 35 then return COLOR_MAN end
	if tile <= 18 or tile == 36 then return COLOR_PIN end
	if tile <= 27 or tile == 37 then return COLOR_SOU end
	return 0
end


function draw_large_tile(tile, x, y)
	local w,h = 8,12

	-- backfill
	rectfill(
		x, y, x+w, y+h,
		get_tile_color(tile)
	)
	local n
	if tile <= 27 then
		n = SPR_TILE_LARGE_NUMBERS+1+(tile-1)%9
	elseif tile <= 34 then
		n = SPR_TILE_LARGE_HONORS-27+tile
	else
		n = SPR_TILE_LARGE_NUMBERS
	end
	spr(n, x+1, y+1, 1, 1.5)
	rect(x,y,x+w,y+h,0) -- outline
end


function draw_all_large_tiles()
	for i = 1,37 do
		draw_large_tile(i,(i-1)%16*8,flr((i-1)/16)*12)
	end
end


function draw_hand(hand)
	local n = 0
	for t in all(hand.tiles) do

	end
	for i,t in ipairs(hand.tiles) do

	end
end