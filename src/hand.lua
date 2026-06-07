



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


function draw_i_tiles(i_tiles, w)
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	for i,t in ipairs(i_tiles) do
		local y = oy+flr((i-1)/w)*8
		draw_tile(t,ox+(i-1)%w*6,y)
		poke(0x5f27, y+10)
	end
	poke(0x5f25,c)
end

function draw_n_tiles(n_tiles, w)
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	local m = 0
	for t,n in ipairs(n_tiles) do
		for _ = 1,n do
			local y = oy+flr(m/w)*8
			draw_tile(t,ox+m%w*6,y)
			poke(0x5f27, y+10)
			m += 1
		end
	end
	poke(0x5f25,c)
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


function draw_quad_stack(x, y, horz)
	local i = horz and SPR_TILE_SIDE_HORZ or SPR_TILE_SIDE_VERT
	rectfill(x,y,x+8,y+8,0) -- fill/outline
	spr(i, x+1, y+1)
end


function draw_tile_flipped(x, y, horz)
	local w,h = 6,8
	if (horz) w,h = h,w

	local i = horz and SPR_TILE_BACK_HORZ or SPR_TILE_BACK_VERT
	spr(i, x+1, y+1)
	rect(x,y,x+w,y+h,0) -- outlines
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