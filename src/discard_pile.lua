-- discard pile


assert(entity)
assert(small_tile)


discard_pile = entity:new{
	ox = -12, -- offset from (x,y)
	oy = 20,
	riichi = 0,
	length = 0,

	new = function(self)
		return entity.new(self, {
			t_tiles = {},
		})
	end,

	add_tile = function(_ENV, tile, in_riichi)
		add(t_tiles, tile)
		length += 1
		if in_riichi and riichi == 0 then
			riichi = length
		end
		return _ENV
	end,

	get_length = function(_ENV)
		return length
	end,

	get_riichi = function(_ENV)
		return riichi
	end,

	remove_tile = function(_ENV, t)
		length -= 1
		return deli(t_tiles)
	end,

	draw = function(_ENV)
		local ry = flr((riichi-1)/6)
		for i,tile in ipairs(t_tiles) do
			-- x,y as if you are in first rotation
			local ty = flr((i-1)/6)
			local dx,dy = (i-1)%6*6-3+ox, ty*8+4+oy
			local tile_rotation = rotation
			if ry == ty and i > riichi then
				dx+=2
			elseif riichi == i then
				dx+=1
				tile_rotation = rotation%4+1
			end
			
			-- x,y are rotated
			small_tile:new()
			:set_tile(tile)
			:set_pos(_ENV:get_rotated_pos(dx, dy))
			:set_rotation(tile_rotation)
			:draw()
		end
		
		return _ENV
	end,
}