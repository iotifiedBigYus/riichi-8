 
function _init()
	srand(0)
	hand1 = hand.generate()

	printh("", "output", true)

	player = test_player()

	game = new_game()
	game:init_wall()

end

function _update60()
	update_player(player)
end

function _draw()
	cls(1)

	draw_discards(test_discards4())
	--draw_discards(test_discards3(),2)
	--draw_discards(test_discards3(),3)
	--draw_discards(test_discards3(),4)

	draw_player(player)


	color(6)
	
	draw_n_tiles(game.n_tiles,21)
	if(#game.i_tiles>1) ?game:get_tile()
	draw_n_tiles(game.n_tiles,21)
	--draw_n_tiles(game.n_tiles,21)
end