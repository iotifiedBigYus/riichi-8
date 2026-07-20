-- hand


assert(entity)
assert(large_tile)
assert(meld)
assert(meld_stack)


hand = entity:subclass{
	--length = 0,
	--is_open = false,

	new = function(self)
		return entity.new(self,{
			tiles = {},
			--tile_states = {},
			--[[
				state: desired {x, y, rotation, status}
				for each tile in all_tiles
			]]
		})
	end,

	set_tiles = function(_ENV, new_tiles)
		tiles = new_tiles
		_ENV:update()
		return _ENV
	end,

	set_openness = function(_ENV, new_is_open)
		is_open = new_is_open
		_ENV:update()
		return _ENV
	end,

	add_tile = function(_ENV, tile)
		add(tiles, tile)
		_ENV:update()
		return _ENV
	end,

	remove_tile = function(_ENV, tile)
		del(tiles, tile)
		_ENV:update()
		return _ENV
	end,

	apply_tile_states = function(_ENV)
		for i,tile in ipairs(tiles) do
			tile:set_state(tile_states[i])
		end
		return _ENV
	end,

	get_tile_state = function(_ENV, i)
		local tile_x, tile_y = _ENV:get_rotated_pos(
			(i-.5*length-1)*6,
			is_open and 4 or 2
		)
		--]]
		return {
			tile_x,
			tile_y,
			rotation,
			is_open and 1 or 3,
		}
	end,

	update = function(_ENV)
		length = #tiles

		for i = 1,length do
			local j = i
			while j > 1
			and tiles[j-1].relative_value > tiles[j].relative_value do
				tiles[j],tiles[j-1] = tiles[j-1],tiles[j]
				j-=1
			end
		end

		tile_states = {}
		for i = 1,length do
			add(tile_states, _ENV:get_tile_state(i))
		end

		return _ENV
	end,

	draw = function(_ENV)
		foreach(tiles, function(tile) tile:draw() end)
		meld_stack:draw()
		return _ENV
	end,
}


function print_hand(hand)
	--trim
	-- s t c o a
	-- l a r
	local symbol = {
		chii               = "s",
		triplet            = "t",
		["concealed quad"] = "c",
		["open quad"]      = "o",
		["added quad"]     = "a",
		left               = "l",
		across             = "a",
		right              = "r"
	}

	local out = "hand:\n"

	-- tiles
	local prev_suit = ""
	foreach(hand.tiles, function(t)
		if (t.suit != prev_suit) out ..= prev_suit
		prev_suit = t.suit
		out ..= tostr(t.number)
	end)
	out ..= prev_suit

	-- drawn tile
	if (hand.draw) out ..= "\n" .. tostr(hand.draw.number) .. hand.draw.suit

	-- melds
	foreach(hand.melds, function(m)
		out ..= "\n"
		foreach(m.tiles, function(t)
			out ..= tostr(t.number)
		end)
		out ..= m.tiles[1].suit .. symbol[m.type] .. symbol[m.origin]
		-- its assumed all tiles share the same suit, only first one is used
	end)

	-- of tiles previous positions
	out ..= "\n"
	foreach(hand.tiles, function(t)
		if(t.prev_pos) out ..= t.prev_pos .. " "
	end)

	print(out)
	return out
end