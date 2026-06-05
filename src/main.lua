 
function _init()
	srand(0)
	hand1 = hand.generate()

	player = test_player()
end

function _update60()
	update_player(player)
end

function _draw()
	cls(1)
	color(6)
	print_hand(test_hand())
	print_hand(test_hand2())
	print_hand(sort_hand(test_hand2()))
	print(analysis.is_terminal_or_honor(11))

	--draw_discards(test_discards3())
	--draw_discards(test_discards3(),2)
	--draw_discards(test_discards3(),3)
	--draw_discards(test_discards3(),4)

	draw_player(player)

	draw_quad_stack(10, 10)
	draw_quad_stack(10, 20, true)
	draw_tile_flipped(20, 10)
	draw_tile_flipped(20, 20, true)
end