-- value collection


assert(class)
assert(is_terminal_or_honor)


collection = class:subclass{
	sibling_mapping = split[[
		0,0,0,0,35,0,0,0,0,
		0,0,0,0,36,0,0,0,0,
		0,0,0,0,37,0,0,0,0,
		0,0,0,0,
		0,0,0,
		5,14,23,
	]],

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

	add_value = function(_ENV, value, mul)
		mul = mul or 1
		values[value] += 1 * mul
		return _ENV
	end,

	add_sequence = function(_ENV, first)
		for i=0,2 do
			values[first+i] += 1
		end
		return _ENV
	end,

	add_collection = function(_ENV, collection)
		for i = 1,37 do
			values[i] += collection.values[i]
		end
		return _ENV
	end,

	check_tuple = function(_ENV, value, num)
		-- num is the length of the meld being checked for
		-- pon: num = 3
		-- quad: num = 4
		local collections = {}

		local sibling = sibling_mapping[value]

		local val1 = values[value]
		local val2 = sibling > 0 and values[sibling] or 0

		-- only value
		if val1 >= num-1 then
			add(collections,
				global.collection:new()
					:add_value(value, num)
			)
		end

		-- with the siblings
		for s = 1, min(val2,num-1) do
			--> val2 > 0 implies that sibling > 0
			if val1 + s >= num-1 then
				add(collections,
					global.collection:new()
						:add_value(value, num-s)
						:add_value(sibling, s)
				)
			end
		end

		return collections
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