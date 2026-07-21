-- hand


-- TODO: figure out why there is a gap before the pulled tile


assert(tile_stack)


hand = tile_stack:subclass{
	status = 1,
	--[[
		1: revealed
		2: discarded
		3: standing
	]]
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

	set_pulled_tile = function(_ENV, new_pulled_tile)
		--trim
		pulled_tile = new_pulled_tile
		return _ENV:update()
	end,

	set_state = function(_ENV, state)
		x, y, rotation, status = unpack(state)
		rotation = fit_in_four(rotation)
		status = fit_in_four(status)
		return _ENV:update()
	end,

	set_status = function(_ENV, new_status)
		--trim
		status = new_status
		return _ENV:update()
	end,

	add_tile = function(_ENV, tile)
		-- assimilates the previous pulled tile
		add(previous_tiles, pulled_tile)
		pulled_tile = tile
		return _ENV:update()
	end,

	remove_tile = function(_ENV, tile)
		-- assimilates the pulled tile before removing
		add(previous_tiles, pulled_tile)
		pulled_tile = nil
		local removed_tile = del(previous_tiles, tile)
		_ENV:update()
		return removed_tile
	end,

	remove_tile_i = function(_ENV, i)
		-- assimilates the pulled tile before removing
		add(previous_tiles, pulled_tile)
		pulled_tile = nil
		local removed_tile = deli(previous_tiles, i)
		_ENV:update()
		return removed_tile
	end,

	get_pulled_tile_state = function(_ENV)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			3*previous_length+2,
			split"4,4,2"[status]
		)
		return {
			tile_x,
			tile_y,
			rotation,
			status,
		} 
	end,

	get_previous_tile_state = function(_ENV, i)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			(i-.5*previous_length-1)*6,
			split"4,4,2"[status]
		)
		return {
			tile_x,
			tile_y,
			rotation,
			status,
		}
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

		tile_states = {} --TODO: shorten
		local i = 1
		for tile in all(tiles) do
			local state
			if tile == pulled_tile then
				state = _ENV:get_pulled_tile_state()
			else
				state = _ENV:get_previous_tile_state(i)
				i+=1
			end
			add(tile_states, state)
		end

		return _ENV
	end,
}