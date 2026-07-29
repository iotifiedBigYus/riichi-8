-- stack


assert(entity)
assert(new_instance)


stack = entity:subclass{
	--length = 0,

	new = function(self)
		return new_instance(self, {
			elements = {},
		})
	end,

	set_elements = function(_ENV, new_elements)
		elements = new_elements
		return _ENV:update()
	end,

	push = function(_ENV, ...)
		foreach({...}, function(element)
			add(elements, element)
		end)
		return _ENV:update()
	end,

	pop = function(_ENV)
		removed_element = deli(elements)
		_ENV:update()
		return removed_element
	end,

	update = function(_ENV)
		length = #elements
		return _ENV
	end,
}