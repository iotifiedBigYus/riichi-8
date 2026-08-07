-- value collection


assert(class)
assert(is_terminal_or_honor)


collection = class:subclass{
	new = function(self)
		return self:subclass{
			values = split[[
				0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,
				0,0,0,0,
				0,0,0,
				0,0,0,
			]],
		}
	end,

	add_value = function(_ENV, value)
		values[value] += 1
		return _ENV
	end,

	add_collection = function(_ENV, collection)
		for i = 1,37 do
			values[i] += collection.values[i]
		end
		return _ENV
	end,

	is_terminal_or_honor = function(_ENV)
		for i = 1,37 do
			if values[i] > 0 and not global.is_terminal_or_honor(i) then
				return false
			end
		end
		return true
	end,

	tostr = function(_ENV)
		local text = ""
		for i = 1,37 do
			text ..= global.tostr(values[i])
			if split[[
				0,0,0,0,0,0,0,0,1,
				0,0,0,0,0,0,0,0,1,
				0,0,0,0,0,0,0,0,1,
				0,0,0,1,
				0,0,1,
				0,0,1,
			]][i] > 0 then
				text ..= "\n"
			end
		end
		return text
	end
}