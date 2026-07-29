-- meld


assert(empty_values)
assert(fit_in)
assert(entity)
assert(new_instance)
assert(tile)
assert(tile_stack)


meld = tile_stack:subclass{
	origin = 1,
	--[[
		relative to player
		1: oneself, 2: from the right, 3: across, ...
	]]
	-- taken_tile = nil,
	-- added_tile = nil,
	-- type = nil,
	
	new = function(self)
		return new_instance(self, {
			tiles = {},
			own_tiles = {},
			--tile_states = {},
			--[[
				state: desired {x, y, rotation, status}
				for each tile in tiles
			]]
		})
	end,

	set_origin = function(_ENV, new_origin)
		origin = fit_in(new_origin or 1)
		return _ENV:update()
	end,
	
	set_tiles = function(_ENV, new_own_tiles, new_taken_tile, new_added_tile)
		own_tiles = new_own_tiles
		taken_tile = new_taken_tile
		added_tile = new_added_tiles
		return _ENV:update()
	end,

	set_added_tile = function(_ENV, tile)
		added_tile = tile
		return _ENV:update()
	end,

	apply_tile_states = function(_ENV)
		for i,tile in ipairs(tiles) do
			tile:set_state(tile_states[i])
		end
		return _ENV
	end,

	update_tile_states = function(_ENV)
		tile_states = {}
		local i = 1
		for tile in all(tiles) do
			local state
			if tile == added_tile then
				state = _ENV:get_rotated_state(
					split"0,-4,-10,-16"[origin],
					-6,
					rotation,
					4
				)
			elseif tile == taken_tile then
				state = _ENV:get_rotated_state(
					split[[
						0,-4,-10,-16,
						0,-4,-10,-16,
						0,-4,-16,-22,
						0  0,  0,  0,
					]][type*4 + origin - 4],
					split"-3,-2,-3,0"[type],
					rotation + split[[
						0,-1,1,1,
						0, 0,0,0,
						0,-1,1,1,
						0, 0,0,0,
					]][type*4 + origin - 4],
					split"1,4,1,0"[type]
				)
			else
				state = _ENV:get_rotated_state(
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
					-4,
					rotation,
					split[[
						1,1,0,0,
						1,1,0,0,
						1,1,1,0,
						2,1,1,2,
					]][type*4 + i -4]
				)
				i+=1
			end
			add(tile_states, state)
		end

		return _ENV
	end,

	update = function(_ENV)
		tiles = {unpack(own_tiles)}
		add(tiles, taken_tile)
		add(tiles, added_tile)

		length = #tiles

		assert(length <= 4)

		if length <= 3 then
			type = 1 -- chii / pon
		elseif added_tile then
			type = 2 -- added kan
		elseif taken_tile then
			type = 3 -- open kan
		else
			type = 4 -- closed kan
		end

		return _ENV:update_tile_states()
	end,
}