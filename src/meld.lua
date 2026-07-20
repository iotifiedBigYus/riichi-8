-- meld


--TODO: make inherit from hand/wall
--TODO: make own_tiles and all_tiles become just tiles, redefine type logic


assert(empty_tiles)
assert(fit_in_four)
assert(entity)
assert(tile)


meld = entity:subclass{
	origin = 1, --[[
		relative to player
		1: oneself, 2: from the right, ...
	]]
	-- type = nil,
	-- taken_tile = nil,
	-- added_tile = nil,
	
	new = function(self)
		return entity.new(self, {
			own_tiles = {},
			all_tiles = {},
			--tile_states = {},
			--[[
				state: desired {x, y, rotation, status}
				for each tile in all_tiles
			]]
		})
	end,

	set_origin = function(_ENV, new_origin)
		origin = fit_in_four(new_origin)
		_ENV:update()
		return _ENV
	end,
	
	set_tiles = function(_ENV, new_own_tiles, new_taken_tile, new_added_tile)
		own_tiles = new_own_tiles
		taken_tile = new_taken_tile
		added_tile = new_added_tile

		_ENV:update()
		return _ENV
	end,

	set_added_tile = function(_ENV, tile)
		added_tile = tile
		_ENV:update()
		return _ENV
	end,

	get_values = function(_ENV)
		local values = empty_tiles()
		foreach(all_tiles, function(tile)
			values[tile.value] += 1
		end)
		return values
	end,

	get_own_tile_state = function(_ENV, i)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			split[[
				000,  0,0,0,
				-17,-11,0,0,
				-17, -3,0,0,
				-9,  -3,0,0,

				000,  0,0,0,
				-17,-11,0,0,
				-17, -3,0,0,
				-9,  -3,0,0,

				000,  0,  0,0,
				-23,-17,-11,0,
				-23, -9, -3,0,
				-15, -9, -3,0,
			
				-21,-15,-9,-3,
				000,  0, 0, 0,
				000,  0, 0, 0,
				000,  0, 0, 0,
			]][type*16 + origin*4 + i - 20],
			-4
		)
		return {
			tile_x,
			tile_y,
			rotation,
			split[[
				1,1,0,0,
				1,1,0,0,
				1,1,1,0,
				2,1,1,2,
			]][type*4 + i -4],
		}
	end,

	get_taken_tile_state = function(_ENV)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			split[[
				0,-4,-10,-16,
				0,-4,-10,-16,
				0,-4,-16,-22,
				0  0,  0,  0,
			]][type*4 + origin - 4],
			split"-3,-2,-3,0"[type]
		)
		return {
			tile_x,
			tile_y,
			fit_in_four(
				rotation + split[[
					1,-1,1,1,
					0, 0,0,0,
					1,-1,1,1,
					0, 0,0,0,
				]][type*4 + origin - 4]
			),
			split"1,4,1,0"[type],
		}
	end,

	get_added_tile_state = function(_ENV)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			split"0,-4,-10,-16"[origin],
			-6
		)
		return {
			tile_x,
			tile_y,
			rotation,
			4,
		}
	end,

	apply_tile_states = function(_ENV)
		for i,tile in ipairs(all_tiles) do
			tile:set_state(tile_states[i])
		end
		return _ENV
	end,

	update = function(_ENV)
		if #own_tiles == 4 then
			type = 4 -- closed kan
			taken_tile, added_tile = nil, nil
		elseif #own_tiles == 3 then
			type = 3 -- open kan
			added_tile = nil
		elseif added_tile then
			type = 2 -- added kan
		else
			type = 1 -- chii / pon
		end

		all_tiles = {unpack(own_tiles)}
		add(all_tiles, taken_tile)
		add(all_tiles, added_tile)

		tile_states = {}
		local i = 1
		for tile in all(all_tiles) do
			local state
			if tile == added_tile then
				state = _ENV:get_added_tile_state()
			elseif tile == taken_tile then
				state = _ENV:get_taken_tile_state()
			else
				state = _ENV:get_own_tile_state(i)
				i+=1
			end
			add(tile_states, state)
		end

		return _ENV
	end,

	draw = function(_ENV)
		foreach(all_tiles,function(t) t:draw() end)
		return _ENV
	end,
}