-- entity


assert(fit_in)
assert(class)


function new_instance(parent, table)
	return parent:subclass(table):update()
end


entity = class:subclass{
	x = 64,
	y = 64,
	rotation = 1,
	--[[
		~ rotation ~
		1: down
		2: right
		3: up
		4: left
	--]]
	status = 1, -- used by some subclasses
	size = 1, -- used by some subclasses

	new = new_instance,

	set_pos = function(_ENV, new_x, new_y)
		x, y = new_x, new_y
		return _ENV:update()
	end,

	set_rotation = function(_ENV, new_rotation)
		rotation = fit_in(new_rotation)
		return _ENV:update()
	end,

	set_status = function(_ENV, new_status)
		status = new_status
		return _ENV:update()
	end,

	set_size = function(_ENV, new_size)
		size = new_size
		return _ENV:update()
	end,

	set_state = function(_ENV, state)
		x, y, rotation, status, size = unpack(state)
		rotation = fit_in(rotation)
		if status <= 0 then status = nil end
		if size <= 0 then size = nil end
		return _ENV:update()
	end,

	get_pos = function(_ENV)
		--trim
		return x,y
	end,

	get_rotated_pos = function(_ENV, dx, dy)
		local ix,iy = split"1,0,-1,0"[rotation], split"0,-1,0,1"[rotation]
		local jx,jy = -iy,ix

		return x + dx*ix+dy*jx, y + dx*iy+dy*jy
	end,

	get_rotated_state = function(_ENV, dx, dy, new_rotation, new_status, new_size)
		local new_x, new_y = _ENV:get_rotated_pos(dx or 0,dy or 0)
		return {
			new_x,
			new_y,
			new_rotation or rotation,
			new_status or status,
			new_size or size,
		} 
	end,

	update = function(_ENV)
		return _ENV
	end,

	draw = function(_ENV)
		return _ENV
	end
}