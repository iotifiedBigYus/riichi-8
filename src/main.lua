 
function _init()
	hand = test_hand()
end

function _update60()

end

function _draw()
	cls(1)

	?hand.tiles[1].number
	is_complete(hand)
end