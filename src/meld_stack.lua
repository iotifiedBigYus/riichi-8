-- meld stack


assert(class)
assert(entity)


meld_stack = entity:subclass{
	length = 0,
	ox = 50,
	oy = 50,

	new = function(self)
		return entity.new(self, {
			melds = {},
		})
	end,

	add_meld = function(_ENV, meld)
		add(
			melds,
			meld:set_pos(
				_ENV:get_next_pos()
			):set_rotation(rotation)
		)
		length += 1
		_ENV:update()
		return _ENV
	end,

	get_next_pos = function(_ENV)
		return _ENV:get_rotated_pos(ox, oy-length*8)
	end,

	update = function(_ENV)
		foreach(melds, function(m) m:update() end)
		return _ENV
	end,

	draw = function(_ENV)
		foreach(melds, function(m) m:draw() end)
		return _ENV
	end,
}