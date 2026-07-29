-- meld stack


assert(empty_values)
assert(class)
assert(entity)
assert(stack)


meld_stack = stack:subclass{

	set_melds = stack.set_elements,

	get_values = function(_ENV)
		--TODO: make it output list of values
		local values = empty_values()
		foreach(melds, function(meld)
			values = add_values(values, meld:get_values())
		end)
		return values
	end,

	apply_tile_states = function(_ENV)
		for i,meld in ipairs(melds) do
			meld:set_state(meld_states[i]):apply_tile_states()
		end
		return _ENV
	end,

	update = function(_ENV)
		length = #elements
		melds = elements

		meld_states = {}
		for i = 1,length do
			add(meld_states, _ENV:get_rotated_state(
				0,
				8-8*i
			))
		end

		return _ENV
	end,

	draw = function(_ENV)
		foreach(melds, function(m) m:draw() end)
		return _ENV
	end,
}