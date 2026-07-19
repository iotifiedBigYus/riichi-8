-- small tile


assert(util)
assert(class)
assert(entity)


function get_small_tile_face_sprites_vert()
	-- will be turned into split table
	local sprites = {}

	for tile = 1,37 do
		local spr_numbers_vert = 0x21
		local spr_honors_vert = 0x04-28
		local spr_fives_vert = 0x20

		if tile <= 27 then
			-- number tiles
			add(sprites, spr_numbers_vert+(tile-1)%9)
		elseif tile <= 34 then
			-- honors
			add(sprites, spr_honors_vert+tile)
		else
			-- "red" fives
			add(sprites, spr_fives_vert)
		end
	end
	
	return sprites
end


function get_small_tile_face_sprites_horz()
	-- will be turned into split table
	local sprites = {}

	for tile = 1,37 do
		local spr_numbers_horz = 0x31
		local spr_honors_horz = 0x14-28
		local spr_fives_horz = 0x30

		if tile <= 27 then
			-- number tiles
			add(sprites, spr_numbers_horz+(tile-1)%9)
		elseif tile <= 34 then
			-- honors
			add(sprites, spr_honors_horz+tile)
		else
			-- "red" fives
			add(sprites, spr_fives_horz)
		end
	end

	return sprites
end


small_tile = entity:subclass{
	tile = 32,
	tile_colors = split[[
		8,8,8,8,8,8,8,8,8,
		12,12,12,12,12,12,12,12,12,
		11,11,11,11,11,11,11,11,11,
		0,0,0,0,
		0,0,0,
		8,12,11
	]],
	ws = split"6,6,6,8", --based on status
	hs = split"8,8,4,4",
	w = 6,
	h = 8,
	spr_x = 3,
	spr_y = 3,
	spr_w = 0.875,
	spr_h = 0.875,
	face_sprites_vert = get_small_tile_face_sprites_vert(), --TODO: replace with split table
	face_sprites_horz = get_small_tile_face_sprites_horz(),
	misc_sprites_vert = split"0x00,0x01,0x02,0x03",
	misc_sprites_horz = split"0x00,0x11,0x12,0x13",
	status = 1, --[[
		status = 1: face up
		status = 2: face down
		status = 3: standing face towards
		status = 4: on edge face towards
	]]
	--tile_color = 0,
	--sprite = nil,
	--spr_flip = false,
	
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
		w,h = ws[status], hs[status]
		
		local turn = rotation % 2 == 0
		if turn then w,h = h,w end

		tile_color = tile_colors[tile]

		spr_flip = rotation > 2
		if status == 1 then
			-- 1: face visible
			sprite = turn
			and face_sprites_horz[tile]
			or  face_sprites_vert[tile]
		else
			-- 2: flipped
			-- 3: standing
			-- 4: on edge
			sprite = turn
			and misc_sprites_horz[status]
			or  misc_sprites_vert[status]
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
		--debug
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
		--debug
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