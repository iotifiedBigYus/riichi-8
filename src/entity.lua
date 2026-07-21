-- entity


assert(fit_in_four)
assert(class)


entity = class:subclass{
	x = 64,
	y = 64,
	rotation = 1,
	-- rotation = 1: down
	-- rotation = 2: right
	-- rotation = 3: up
	-- rotation = 4: left

	new = function(self, table)
		return self:subclass(table):update()
	end,

	set_pos = function(_ENV, new_x, new_y)
		x, y = new_x, new_y
		_ENV:update()
		return _ENV
	end,

	set_rotation = function(_ENV, new_rotation)
		rotation = fit_in_four(new_rotation)
		_ENV:update()
		return _ENV
	end,

	set_state = function(_ENV, state)
		x, y, rotation = unpack(state)
		rotation = fit_in_four(rotation)
		_ENV:update()
		return _ENV
	end,

	get_pos = function(_ENV)
		return x,y
	end,

	update = function(_ENV)
		return _ENV
	end,

	get_rotated_pos = function(_ENV, dx, dy)
		local ix,iy = split"1,0,-1,0"[rotation], split"0,-1,0,1"[rotation]
		local jx,jy = -iy,ix

		return x + dx*ix+dy*jx, y + dx*iy+dy*jy
	end,
}