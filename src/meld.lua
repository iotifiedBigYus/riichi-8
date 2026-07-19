-- meld


assert(entity)
assert(small_tile)


meld = entity:subclass{
	origin = 1,
	-- type = nil
	-- taken_tile = nil,
	-- added_tile = nil,

	new = function(self)
		return entity.new(self, {
			m_tiles = {},
			own_tiles = {},
		})
	end,

	set_origin = function(_ENV, new_origin)
		assert(new_origin >= 1 and new_origin <= 4)
		origin = new_origin
		_ENV:update()
		return _ENV
	end,

	set_taken_tile = function(_ENV, tile)
		taken_tile = tile
		_ENV:update()
		return _ENV
	end,

	set_own_tiles = function(_ENV, tile1, tile2, tile3, tile4)
		assert(tile2)
		own_tiles = {}
		foreach(
			{tile1, tile2, tile3, tile4},
			function(t) add(own_tiles, t)end
		)
		_ENV:update()
		return _ENV
	end,

	set_added_tile = function(_ENV, tile)
		added_tile = tile
		_ENV:update()
		return _ENV
	end,

	update = function(_ENV)
		-- m_tiles:
		-- {1,2,-3} -> from left -||
		-- {5,-5,5} -> from across |-|
		-- {-5,5,5} -> from right ||-
		-- {14,14,-14,14} -> kan from across ||-|
		-- {14,0,14} -> added kan from across |=|
		-- {0,14,14,0} -> closed kan :||:

		if #own_tiles == 4 then
			type = 4
		elseif #own_tiles == 3 then
			type = 3
		elseif taken_tile then
			type = 2
		else
			type = 1
		end
		
		m_tiles = {}
		foreach(own_tiles, function(t) add(m_tiles,t)end)

		if taken_tile then
			add(m_tiles, added_tile and 0 or -taken_tile, ({nil, 1, 2})[origin])
		elseif origin == 1 then
			m_tiles[1],m_tiles[4] = 0,0
		end

		return _ENV
	end,

	draw = function(_ENV)
		local x1 = 0
		for t in all(m_tiles) do
			local st = small_tile:new():set_rotation(rotation)
			if t > 0 then
				st:set_tile(t)
				:set_pos(
					_ENV:get_rotated_pos(x1-3,-4)
				):draw()
				x1 -= 6
			elseif t < 0 then
				st:set_tile(-t)
				:set_rotation(rotation%4+1)
				:set_pos(
					_ENV:get_rotated_pos(x1-4,-3)
				):draw()
				x1 -= 8
			else
				if #m_tiles == 3 then
					st:set_rotation(rotation)
					:set_status(4)
					:set_pos(
						_ENV:get_rotated_pos(x1-4,-2)
					):draw()
					:set_pos(
						_ENV:get_rotated_pos(x1-4,-6)
					):draw()
					x1 -= 8
				else
					st:set_status(2)
					:set_pos(
						_ENV:get_rotated_pos(x1-3,-4)
					):draw()
					x1-=6
				end
			end
		end
		return _ENV
	end,
}