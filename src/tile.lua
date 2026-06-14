

function empty_tiles()
	local tiles = {}
	for _ = 1,37 do add(tiles,0) end
	return tiles
end


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


function get_tile_color(tile)
	if tile <= 9 or tile == 35 then return COLOR_MAN end
	if tile <= 18 or tile == 36 then return COLOR_PIN end
	if tile <= 27 or tile == 37 then return COLOR_SOU end
	return 0
end


function draw_tile_flipped(x, y, horz)
	local w,h = 6,8
	if (horz) w,h = h,w

	local i = horz and SPR_TILE_BACK_HORZ or SPR_TILE_BACK_VERT
	spr(i, x+1, y+1)
	rect(x,y,x+w,y+h,0) -- outlines
end


function draw_quad_stack(x, y, horz)
	local i = horz and SPR_TILE_SIDE_HORZ or SPR_TILE_SIDE_VERT
	rectfill(x,y,x+8,y+8,0) -- fill/outline
	spr(i, x+1, y+1)
end


function draw_all_tiles()
	for i = 1,37 do
		draw_tile(i,(i-1)%21*6,flr((i-1)/21)*8)
	end
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


function draw_i_tiles(i_tiles, w)
	local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
	for i,t in ipairs(i_tiles) do
		local y = oy+flr((i-1)/w)*8
		draw_tile(t,ox+(i-1)%w*6,y)
		poke(0x5f27, y+10)
	end
	poke(0x5f25,c)
end


function draw_large_tile(tile, x, y)
	assert(tile)
	assert(x)
	assert(y)
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


function new_tile_object(tile, x, y, i)
	return {
		tile = tile,
		x = x,
		y = y,
		is_tile = true,
		is_selected = false,
		prev_x = 0,
		prev_y = 0
	}
end