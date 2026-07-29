-- tile


assert(class)
assert(entity)


tile = entity:subclass{
	value = 32,
	--[[
		~ status ~ 
		1: face up
		2: face down
		3: standing face towards
		4: on edge face towards
	--]]
	--[[
		~ size ~
		1: small (6x8)
		2: large (8x12)
	--]]
	--value_color = 0,
	--relative_value = 41,
	--sprite = nil,
	--spr_flip = false,
	--spr_x = 3,
	--spr_y = 3,
	--spr_w = 0.875,
	--spr_h = 0.875,
	--w = 6,
	--h = 8,

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
	]],
	--[[
		relative value is used to sort tiles.
		the absolute values used can be chosen arbitrarily.
	--]]
	face_sprites = split[[
		0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,
		0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,
		0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,
		0x04,0x05,0x06,0x07,
		0x08,0x09,0x0a,
		0x20,0x20,0x20,

		0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,
		0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,
		0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,
		0x14,0x15,0x16,0x17,
		0x18,0x19,0x1a,
		0x30,0x30,0x30,

		0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
		0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
		0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
		0x40,0x41,0x42,0x43,
		0x44,0x45,0x46,
		0x60,0x60,0x60,
	]],
	misc_sprites = split[[
		0x00,0x01,0x02,0x03,
		0x00,0x11,0x12,0x13,
	]],
	misc_sprites_vert = split"0x00,0x01,0x02,0x03",
	misc_sprites_horz = split"0x00,0x11,0x12,0x13",
	spr_xs = split"3,3",
	spr_ys = split"3,7",
	spr_ws = split"0.875,0.875",
	spr_hs = split"0.875,1.875",
	ws = split[[
		6,6,6,8,
		8,0,0,0,
	]], --based on status
	hs = split[[
		8,8,4,4,
		12,0,0,0,
	]],
	
	set_value = function(_ENV, new_value)
		value = new_value
		return _ENV:update()
	end,

	update = function(_ENV)
		local turn = (rotation-1)%2+1

		w,h = ws[size*4 - 4 + status], hs[size*4 - 4 + status]
		if turn == 2 then w,h = h,w end

		value_color = value_colors[value]
		relative_value = relative_values[value]

		spr_x = spr_xs[size]
		spr_y = spr_ys[size]
		spr_w = spr_ws[size]
		spr_h = spr_hs[size]

		spr_flip = rotation > 2
		if status == 1 then
			-- 1: face visible
			sprite = face_sprites[(size*2 + turn - 3)*37 + value]
		else
			-- 2: flipped
			-- 3: standing
			-- 4: on edge
			sprite = misc_sprites[turn*4 - 4 + status]
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