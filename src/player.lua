-- player


assert(util)
assert(class)
assert(hand)
assert(discard_pile)



player = class:new{
	score = 25000,
	-- in_riichi = false,

	new = function(self)
		return class.new(self, {
			hand = hand:new(),
			discard_pile = discard_pile:new(),
		})
	end,

	add_points = function(_ENV, points)
		score += points
		return _ENV
	end,

	get_score = function(_ENV)
		return score
	end,

	update = function(_ENV)
		return _ENV
	end,
}


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


function update_player_tile_object_positions()
	assert(player)
	assert(user)
	if player == user then
		update_user_tile_object_positions()
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