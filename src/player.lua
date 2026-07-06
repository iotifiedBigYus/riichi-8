assert(util)

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
	assert(player)
	local t = get_tile()

	player.hand.tiles[t] += 1

	local obj = new_tile_object(t)
	player.pick_up_tile_obj = obj
	add(player.tile_objs, obj)

	update_player_tile_object_positions()
end


function get_starting_hand(player, i_player)
	assert(wall)
	for _ = 1,13 do
		local t = get_tile()
		player.hand.tiles[t] += 1
	end

	if i_player == 1 then
		for t,n in ipairs(player.hand.tiles) do
			for _ = 1,n do
				add(player.tile_objs, new_tile_object(t))
			end
		end
	end
end


function discard_tile(player, tile)
	assert(player)
	assert(tile)

	add(player.discard_pile.tiles, tile)

	player.hand.tiles[tile] -= 1
	assert(player.hand.tiles[tile] >= 0)
end


function test_player()
	return {
		hand = test_player_hand()
	}
end


function update_player_tile_object_positions()
	assert(player)
	assert(user)
	if player == user then
		update_user_tile_object_positions()
	end
end


function draw_melds(meld_objs, i_player)
	for i,mo in ipairs(meld_objs) do
		local y = Y_P1_MELDS-8*i
		local x = X_P1_MELDS
		for t in all(mo.tiles) do
			if t > 0 then
				x -= 6
				draw_tile(t,x,y)
			elseif t < 0 then
				x -= 8
				draw_tile(-t,x,y+2,true)
			else
				if #mo.tiles == 3 then
					x-=8
					draw_quad_stack( x, y, true)
				else
					x-=6
					draw_tile_flipped( x, y )
				end
			end
		end
	end
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