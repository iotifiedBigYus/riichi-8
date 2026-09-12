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
				0,0,0,0,0,0,0,
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
		for i = 1,34 do
			values[i] += collection.values[i]
		end
		return _ENV
	end,

	check_tuple = function(_ENV, value, num)
		-- num is the length of the meld being checked for
		-- pon: num = 3
		-- quad: num = 4
		-- TODO: should return meld or partial meld,
		-- not collection since it does not distinguish the discarded tile
		local collections = {}

		if values[value] >= num-1 then
			add(collections,
				global.collection:new()
					:add_value(value, num)
			)
		end

		return collections
	end,

	divide = function(_ENV)
		local suits = {}
		for s = 0,3 do
			local suit = global.collection:new()
			for i = 1,9 do
				local v = i + s*9
				if v > 34 then break end
				suit:add_value(v, values[v])
			end
			add(suits, suit)
		end

		return suits
	end,

	check_sequence = function(_ENV, value)
		local collections = {}

		local check = split[[
			0b001,0b011,0b111,0b111,0b111,0b111,0b111,0b110,0b100,
			0b001,0b011,0b111,0b111,0b111,0b111,0b111,0b110,0b100,
			0b001,0b011,0b111,0b111,0b111,0b111,0b111,0b110,0b100,
			0b000,0b000,0b000,0b000,0b000,0b000,0b000,
		]][value]

		if check & 0b001 > 0 then -- check to the right
			if values[value+1] * values[value+2] > 0 then
				add(collections,
					global.collection:new()
						:add_sequence(value)
				)
			end
		end
		if check & 0b010 > 0 and values[value-1] * values[value+1] > 0 then
			add(collections,
				global.collection:new()
					:add_sequence(value-1)
			)
		end
		if check & 0b100 > 0 and values[value-2] * values[value-1] > 0 then
			add(collections,
				global.collection:new()
					:add_sequence(value-2)
			)
		end

		return collections
	end,

	is_terminal_or_honor = function(_ENV)
		for i = 1,34 do
			if values[i] > 0 and not global.is_terminal_or_honor(i) then
				return false
			end
		end
		return true
	end,

	tostr = function(_ENV)
		local text = ""
		for i = 1,34 do
			text ..= global.tostr(values[i])
			if split[[
				0,0,0,0,0,0,0,0,1,
				0,0,0,0,0,0,0,0,1,
				0,0,0,0,0,0,0,0,1,
				0,0,0,0,0,0,1,
			]][i] > 0 then
				text ..= "\n"
			end
		end
		return text
	end
}