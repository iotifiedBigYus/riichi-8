
function new_hand()
	return {
		current = nil,
		rest = {},
		melds = {}
	}
end

function test_hand()
	return {
		is_closed = true,
		draw = {number = 1, suit = "m"},
		tiles = {
			{number = 1, suit = "m"},
			{number = 1, suit = "m"},
			{number = 2, suit = "m"},
			{number = 2, suit = "m"},
			{number = 7, suit = "p"},
			{number = 7, suit = "p"},
			{number = 7, suit = "p"},
			{number = 5, suit = "s"},
			{number = 6, suit = "s"},
			{number = 7, suit = "s"}
		},
		melds = {
			{
				type = "concealed quad",
				origin = "left",
				tiles = {
					{number = 1, suit = "z"},
					{number = 1, suit = "z"},
					{number = 1, suit = "z"},
					{number = 1, suit = "z"}
				}
			}
		}
	}
end

function test_hand2()
	return {
		is_closed = true,
		tiles = {
			{number = 2, suit = "m"},
			{number = 4, suit = "m"},
			{number = 6, suit = "m"},
			{number = 8, suit = "m"},
			{number = 1, suit = "m"},
			{number = 3, suit = "m"},
			{number = 5, suit = "m"},
			{number = 7, suit = "m"},
			{number = 9, suit = "m"},
			{number = 2, suit = "m"},
			{number = 4, suit = "m"},
			{number = 6, suit = "m"},
			{number = 8, suit = "m"}
		}
	}
end

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


function is_complete(hand)
	tiles = {hand. draw, unpack(hand.tiles)}
end