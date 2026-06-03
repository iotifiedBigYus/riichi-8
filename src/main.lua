 
function _init()
	srand(0)
	hand1 = hand.generate()
end

function _update60()

end

function _draw()
	cls(1)
	--draw_discards(test_discards())
	--draw_discards(test_discards(),2)
	--draw_discards(test_discards(),3)
	--draw_discards(test_discards(),4)
	color(6)
	print_hand(test_hand())
	print_hand(test_hand2())
	print_hand(sort_hand(test_hand2()))
	print(analysis.is_terminal_or_honor(11))

	draw_tile2(19, 10, 10)

	draw_discards2(test_discards3())
	draw_discards2(test_discards3(),2)
	draw_discards2(test_discards3(),3)
	draw_discards2(test_discards3(),4)

	function a()
		return 1,2
	end
		
	function b()
		return 1 - a()
	end
end