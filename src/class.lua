-- class
-- https://youtu.be/X9qKODb-wXg


global = _ENV

class = setmetatable({
	subclass = function(self, table)
		assert(self)
		return setmetatable(
			table or {},
			{__index = self}
		)
	end,
}, {__index = _ENV})