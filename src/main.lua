 
function _init()
	hand = test_hand()
end

function _update60()

end

function _draw()
	cls(1)
	print_hand(test_hand())
	print_hand(test_hand2())
	print_hand(sort_hand(test_hand2()))
end