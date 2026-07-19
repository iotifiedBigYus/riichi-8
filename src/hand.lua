-- hand


assert(util)
assert(class)
assert(meld)
assert(meld_stack)


hand = class:new{
	--drawn_tile = nil,
	new = function(self)
		return class.new(self, {
			n_tiles = empty_tiles(),
			n_melds = {},
			meld_stack = global.meld_stack:new(),
		})
	end,

	draw = function(_ENV)

	end,
}


function print_hand(hand)
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


function sort_hand(hand)
	-- mutates the hand
	local tiles = hand.tiles

	for i=1,#tiles do
		tiles[i].prev_pos = i
	end
	
	for k,v in ipairs(tiles) do
		local j = k
		while j > 1 and tiles[j-1].number > tiles[j].number do
			tiles[j],tiles[j-1] = tiles[j-1],tiles[j]
			j = j - 1
		end
	end

	return hand
end