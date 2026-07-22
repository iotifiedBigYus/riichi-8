-- meld stack


assert(empty_values)
assert(class)
assert(entity)


meld_stack = entity:subclass{
	--length = 0,

	new = function(self)
		return entity.new(self, {
			melds = {},
			meld_states = {}, --[[
				state: desired {x, y, rotation}
				for each meld in melds
			]]
		})
	end,

	set_melds = function(_ENV, new_melds)
		melds = new_melds
		_ENV:update()
		return _ENV
	end,

	add_meld = function(_ENV, meld)
		add(melds, meld)
		_ENV:update()
		return _ENV
	end,

	get_values = function(_ENV)
		local values = empty_values()
		foreach(melds, function(meld)
			values = add_values(values, meld:get_values())
		end)
		return values
	end,

	get_meld_state = function(_ENV, i)
		local meld_x, meld_y = _ENV:get_rotated_pos(
			0,
			8-8*i
		)
		return {
			meld_x,
			meld_y,
			rotation
		}
	end,

	apply_meld_states = function(_ENV)
		--trim
		for i,meld in ipairs(melds) do
			meld:set_state(meld_states[i])
		end
		return _ENV
	end,

	apply_tile_states = function(_ENV)
		for i,meld in ipairs(melds) do
			meld:set_state(meld_states[i]):apply_tile_states()
		end
		return _ENV
	end,

	update = function(_ENV)
		length = #melds

		meld_states = {}
		for i = 1,length do
			add(meld_states, _ENV:get_rotated_state(
				0,
				8-8*i,
				rotation
			))
		end

		return _ENV
	end,

	draw = function(_ENV)
		foreach(melds, function(m) m:draw() end)
		return _ENV
	end,
}