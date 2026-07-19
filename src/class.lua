-- class
-- https://youtu.be/X9qKODb-wXg


global = _ENV

class = {
	subclass = function(self, table)
		assert(self)
		table = table or {}
		setmetatable(table, {
			__index = self
		})
		return table
	end,
}

setmetatable(class, {__index = _ENV})