
function new_hand()
	return {
		current = nil,
		rest = {},
		melds = {}
	}
end

function test_hand()

	return {
		draw = {
			suit = "m",
			number = 1
		},
		tiles = {
			{
				suit = "m",
				number = 1
			},
			{
				suit = "m",
				number = 1
			},
			{
				suit = "m",
				number = 2
			},
			{
				suit = "m",
				number = 2
			},
			{
				suit = "p",
				number = 7
			},
			{
				suit = "p",
				number = 7
			},
			{
				suit = "p",
				number = 7
			},
			{
				suit = "s",
				number = 5
			},
			{
				suit = "s",
				number = 6
			},
			{
				suit = "s",
				number = 7
			},
			{
				suit = "z",
				number = 1
			},
			{
				suit = "z",
				number = 1
			},
			{
				suit = "z",
				number = 1 
			},
		},
	}
end

function is_complete(hand)
	tiles = {hand.draw, unpack(hand.tiles)}
	?tiles[14].number
end


function print_hand(hand)

end