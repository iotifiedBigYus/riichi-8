-- tile


assert(class)
assert(entity)


function get_small_tile_face_sprites_vert()
	-- will be turned into split table
	local sprites = {}

	for value = 1,37 do
		local spr_numbers_vert = 0x21
		local spr_honors_vert = 0x04-28
		local spr_fives_vert = 0x20

		if value <= 27 then
			-- number tiles
			add(sprites, spr_numbers_vert+(value-1)%9)
		elseif value <= 34 then
			-- honors
			add(sprites, spr_honors_vert+value)
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

	for value = 1,37 do
		local spr_numbers_horz = 0x31
		local spr_honors_horz = 0x14-28
		local spr_fives_horz = 0x30

		if value <= 27 then
			-- number tiles
			add(sprites, spr_numbers_horz+(value-1)%9)
		elseif value <= 34 then
			-- honors
			add(sprites, spr_honors_horz+value)
		else
			-- "red" fives
			add(sprites, spr_fives_horz)
		end
	end

	return sprites
end


tile = entity:subclass{
	value = 32,
	status = 1, --[[
		status = 1: face up
		status = 2: face down
		status = 3: standing face towards
		status = 4: on edge face towards
	]]
	--value_color = 0,
	--relative_value = 41,
	--sprite = nil,
	--w = 6,
	--h = 8,
	--spr_flip = false,

	value_colors = split[[
		8,8,8,8,8,8,8,8,8,
		12,12,12,12,12,12,12,12,12,
		11,11,11,11,11,11,11,11,11,
		0,0,0,0,
		0,0,0,
		8,12,11
	]],
	relative_values = split[[
		1,2,3,4,5,6,7,8,9,
		11,12,13,14,15,16,17,18,19,
		21,22,23,24,25,26,27,28,29,
		31,32,33,34,
		41,42,43,
		4.5,14.5,24.5
	]], --[[
		relative value is used to sort tiles.
		the absolute values used can be chosen arbitrarily.
	]]
	face_sprites_vert = get_small_tile_face_sprites_vert(), --TODO: replace with split table
	face_sprites_horz = get_small_tile_face_sprites_horz(),
	misc_sprites_vert = split"0x00,0x01,0x02,0x03",
	misc_sprites_horz = split"0x00,0x11,0x12,0x13",
	ws = split"6,6,6,8", --based on status
	hs = split"8,8,4,4",
	spr_x = 3,
	spr_y = 3,
	spr_w = 0.875,
	spr_h = 0.875,
	
	set_value = function(_ENV, new_value)
		value = new_value
		_ENV:update()
		return _ENV
	end,

	set_status = function(_ENV, new_status)
		assert(new_status >= 1 and new_status <= 4)
		status = new_status
		_ENV:update()
		return _ENV
	end,

	set_state = function(_ENV, state)
		x, y, rotation, status = unpack(state)
		rotation = fit_in_four(rotation)
		status = fit_in_four(status)
		_ENV:update()
		return _ENV
	end,

	update = function(_ENV)
		relative_value = relative_values[value]

		w,h = ws[status], hs[status]
		
		local turn = rotation % 2 == 0
		if turn then w,h = h,w end

		value_color = value_colors[value]

		spr_flip = rotation > 2
		if status == 1 then
			-- 1: face visible
			sprite = turn
			and face_sprites_horz[value]
			or  face_sprites_vert[value]
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
			value_color
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
}