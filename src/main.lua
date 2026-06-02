 
function _init()
	srand(0)
	hand1 = hand.generate()
end

function _update60()

end

function _draw()
	cls(1)
	draw_discards(test_discards())
	draw_discards(test_discards(),2)
	draw_discards(test_discards(),3)
	draw_discards(test_discards(),4)
	color(6)
	print_hand(test_hand())
	print_hand(test_hand2())
	print_hand(sort_hand(test_hand2()))
	print(analysis.is_terminal_or_honor(11))

	print(meld_finder.find(test_tiles34()))

	function a()
		return 1,2
	end
		
	function b()
		return 1 - a()
	end
	hand.print(hand.parse(hand.encode(hand1)))
	hand.print(hand1)
	hand.print("\#0"..shanten.calculate(hand1))
end