-- small tile


assert(util)
assert(class)
assert(entity)


small_tile = entity:new{
	tile = 32,
	tile_colors = split[[
		8,8,8,8,8,8,8,8,8,
		12,12,12,12,12,12,12,12,12,
		11,11,11,11,11,11,11,11,11,
		0,0,0,0,
		0,0,0,
		8,12,11
	]],
	tile_color = 0,
	x = 0,
	y = 0,
	ws = split"6,6,6,8", --based on status
	hs = split"8,8,4,4",
	w = 6,
	h = 8,
	sprite = 0,
	spr_x = 3,
	spr_y = 3,
	spr_w = 0.875,
	spr_h = 0.875,
	--spr_flip = false,
	status = 1,
	-- status = 1: face up
	-- status = 2: face down
	-- status = 3: standing face towards
	-- status = 4: on edge face towards
	rotation = 1,
	-- rotation = 1: down
	-- rotation = 2: right
	-- rotation = 3: up
	-- rotation = 4: left
	spr_numbers_vert = 0x21,
	spr_numbers_horz = 0x31,
	spr_honors_vert = 0x04-28,
	spr_honors_horz = 0x14-28,
	spr_fives_vert = 0x20,
	spr_fives_horz = 0x30,
	spr_misc_vert = 0x01-2,
	spr_misc_horz = 0x11-2,
	
	set_tile = function(_ENV, new_tile)
		tile = new_tile
		_ENV:update()
		return _ENV
	end,

	set_status = function(_ENV, new_status)
		assert(new_status >= 1 and new_status <= 4)
		status = new_status
		_ENV:update()
		return _ENV
	end,

	update = function(_ENV)
		tile_color = tile_colors[tile]

		w,h = ws[status], hs[status]
		local turn = rotation % 2 == 0
		if turn then w,h = h,w end

		spr_flip = rotation > 2
		if status > 1 then
			-- flipped, standing, on edge
			sprite = turn and spr_misc_horz + status or spr_misc_vert + status
		elseif tile <= 27 then
			-- number tiles
			local i = turn and spr_numbers_horz or spr_numbers_vert
			sprite = i+(tile-1)%9
		elseif tile <= 34 then
			-- honors
			sprite = turn and spr_honors_horz+tile or spr_honors_vert+tile
		else
			-- "red" fives
			sprite = turn and spr_fives_horz or spr_fives_vert
		end

		return _ENV
	end,
	
	draw = function(_ENV)
		-- backfill
		rectfill(
			x-.5*w, y-.5*h, x+.5*w, y+.5*h,
			tile_color
		)
		-- sprite
		spr(
			sprite,
			x-spr_x, y-spr_y,
			spr_w, spr_h,
			spr_flip, spr_flip
		)
		-- outline
		rect(x-.5*w, y-.5*h, x+.5*w, y+.5*h,0)

		return _ENV
	end,

	draw_all_tiles = function(_ENV)
		--debug
		for i = 1,4 do
			for j = 1,37 do
				_ENV:new()
				:set_tile(j)
				:set_pos(
					1+spr_x+(j-1)%16*8,
					1+spr_y+flr((j-1)/16)*8 + (i-1)*32
				)
				:set_rotation(i)
				:draw()
			end
			for j = 1,4 do
				_ENV:new()
				:set_status(j)
				:set_pos(
					4+(j-1)%16*8,
					4+flr((j-1)/16)*8 + (i-1)*32 + 24
				)
				:set_rotation(i)
				:draw()
			end
		end

		return _ENV
	end,

	draw_n_tiles = function(_ENV, n_tiles)
		local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
		local i = 1
		for tile,n in ipairs(n_tiles) do
			for _ = 1,n do
				local x = ox+3+(i-1)%16*6
				local y = oy+4+flr((i-1)/16)*8
				_ENV:new():set_tile(tile):set_pos(x,y):draw()
				poke(0x5f27, y+10)
				i += 1
			end
		end
		poke(0x5f25,c)

		return _ENV
	end,

	draw_i_tiles = function(_ENV, i_tiles)
		local ox,oy,c = peek(0x5f26),peek(0x5f27),peek(0x5f25)
		for i,tile in ipairs(i_tiles) do
			local x = ox+3+(i-1)%16*6
			local y = oy+4+flr((i-1)/16)*8
			_ENV:new():set_tile(tile):set_pos(x,y):draw()
			poke(0x5f27, y+10)
		end
		poke(0x5f25,c)

		return _ENV
	end,
}