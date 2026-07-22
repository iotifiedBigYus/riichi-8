-- hand


-- TODO: inherit from meld


assert(tile_stack)


hand = tile_stack:subclass{
	status = 1,
	--[[
		~ status ~
		1: revealed
		2: discarded
		3: standing
	--]]
	size = 1,
	--[[
		~ size ~
		1: small
		2: large
	--]]
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

	set_status = function(_ENV, new_status)
		--trim
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
		status = fit_in(status,3)
		size = fit_in(size,2)
		return _ENV:update()
	end,

	get_pulled_tile_state = function(_ENV)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			2+previous_length*split"3,4"[size],
			split"4,4,2, 6,0,0"[size*3 - 3 +status]
		)
		return {
			tile_x,
			tile_y,
			rotation,
			status,
			size,
		} 
	end,

	get_previous_tile_state = function(_ENV, i)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			(i-.5*previous_length-1)*split"6,8"[size],
			split"4,4,2, 6,0,0"[size*3 - 3 +status]
		)
		return {
			tile_x,
			tile_y,
			rotation,
			status,
			size,
		}
	end,

	add_tile = function(_ENV, tile)
		-- assimilates the previous pulled tile
		add(previous_tiles, pulled_tile)
		pulled_tile = tile
		return _ENV:update()
	end,

	add_tiles = function(_ENV, tiles)
		-- assimilates the previous pulled tile
		foreach(tiles, function(t)
			add(previous_tiles, pulled_tile)
			pulled_tile = t
		end)
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