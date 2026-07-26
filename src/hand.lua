-- hand


-- TODO: inherit from meld, which should inherit form something else than tile stack


assert(tile_stack)


hand = tile_stack:subclass{
	--[[
		~ status ~
		1: revealed
		2: discarded
		3: standing
	--]]
	--[[
		~ size ~
		1: small
		2: large
	--]]
	--selected_tile = nil,
	--pulled_tile = nil,
	--length = 0,
	--previous_length = 0,

	new = function(self)
		return entity.new(self, {
			tiles = {},
			previous_tiles = {},
			--tile_states = {},
			--[[
				state: desired {x, y, rotation, status}
				for each tile in tiles
			]]
		})
	end,

	set_tiles = function(_ENV, new_previous_tiles, new_pulled_tile)
		previous_tiles = new_previous_tiles
		pulled_tile = new_pulled_tile
		return _ENV:update()
	end,

	set_selected_tile_i = function(_ENV, i)
		if i then
			selected_tile = tiles[(i-1)%length+1]
		end
		return _ENV:update()
	end,

	add = function(_ENV, tile)
		-- assimilates the previous pulled tile
		add(previous_tiles, pulled_tile)
		pulled_tile = tile
		return _ENV:update()
	end,

	del = function(_ENV, tile)
		-- assimilates the pulled tile before removing
		add(previous_tiles, pulled_tile)
		pulled_tile = nil
		local removed_tile = del(previous_tiles, tile)
		_ENV:update()
		return removed_tile
	end,

	deli = function(_ENV, i)
		-- assimilates the pulled tile before removing
		add(previous_tiles, pulled_tile)
		pulled_tile = nil
		local removed_tile = deli(previous_tiles, i)
		_ENV:update()
		return removed_tile
	end,

	update_tile_states = function(_ENV)
		tile_states = {}
		local i = 1
		for tile in all(tiles) do
			local state
			local dy = tile == selected_tile and -2 or 0

			if tile == pulled_tile then
				state = _ENV:get_rotated_state(
					2+previous_length*split"3,4"[size],
					split"4,4,2, 6,0,0"[size*3 - 3 +status]+dy
				)
			else
				state = _ENV:get_rotated_state(
					(i-.5*previous_length-1)*split"6,8"[size],
					split"4,4,2, 6,0,0"[size*3 - 3 +status]+dy
				)
				i+=1
			end

			add(tile_states, state)
		end
		return _ENV
	end,

	update = function(_ENV)
		previous_length = #previous_tiles

		for i = 1,previous_length do
			local j = i
			while j > 1
			and previous_tiles[j-1].relative_value > previous_tiles[j].relative_value do
				previous_tiles[j],previous_tiles[j-1] = previous_tiles[j-1],previous_tiles[j]
				j -= 1
			end
		end

		tiles = {unpack(previous_tiles)}
		add(tiles, pulled_tile)

		length = #tiles

		return _ENV:update_tile_states()
	end,
}