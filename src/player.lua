
function new_player()
	return {
		hand = {
			tiles = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			melds = {},
			drawn_tile = 1,
		},
		discarded_tiles = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		discard_pile = {
			riichi = 0,
			tiles = {}
		}
	}
end


function pick_up_tile(player)
	assert(wall)
	local t = get_tile()

	player.hand.tiles[t] += 1
end


function discard_tile(player, tile)
	assert(player)
	assert(tile)
	add(player.discard_pile.tiles, tile)

	next_turn()
end


function test_player()
	return {
		hand = test_player_hand()
	}
end


function draw_discard_pile(discard_pile, i_player)
	assert(discard_pile)

	tiles = discard_pile.tiles
	riichi = discard_pile.riichi

	i_player = i_player or 1
	local ry = flr((riichi-1)/6)

	if i_player == 1 then
		for i,t in ipairs(tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P1_DISCARDS+(i-1)%6*6, Y_P1_DISCARDS+ty*8
			if ry == ty and i > riichi then
				x+=2
			elseif riichi == i then
				y+=1
			end
			draw_tile(
				t,x,y,riichi == i
			)
		end
	elseif i_player == 2 then
		for i,t in ipairs(tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P2_DISCARDS+ty*8, Y_P2_DISCARDS-(i-1)%6*6-6
			if ry == ty and i > riichi then
				y-=2
			elseif riichi == i then
				x+=1
				y-=2
			end
			draw_tile(
				t,x,y,riichi != i
			)
		end
	elseif i_player == 3 then
		for i,t in ipairs(tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P3_DISCARDS-(i-1)%6*6-6, Y_P3_DISCARDS-ty*8-8
			if ry == ty and i > riichi then
				x-=2
			elseif riichi == i then
				x-=2
				y+=1
			end
			draw_tile(
				t,x,y,riichi == i
			)
		end
	elseif i_player == 4 then
		for i,t in ipairs(tiles) do
			local ty = flr((i-1)/6)
			local x,y = X_P4_DISCARDS-ty*8-8, Y_P4_DISCARDS+(i-1)%6*6
			if ry == ty and i > riichi then
				y+=2
			elseif riichi == i then
				x+=1
			end
			draw_tile(
				t,x,y,riichi != i
			)
		end
	end
end


function print_player_hand(hand, i_player)
	assert(hand)
	assert(i_player)
	local x,y
	if i_player == 1 then
		x,y = 40, 100
	elseif i_player == 2 then
		x,y = 50, 80
	elseif i_player == 3 then
		x,y = 40, 5
	elseif i_player == 4 then
		x,y = 0,30
	end
	print(encode_tiles(hand.tiles,true),x,y,7)
end