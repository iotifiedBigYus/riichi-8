-- entity


assert(util)
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
		assert(new_rotation >= 1 and new_rotation <= 4)
		rotation = new_rotation
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