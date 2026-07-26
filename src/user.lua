-- user, a player the user controls


--TODO: fix methods


assert(player)
assert(entity)


user = player:subclass{
	is_user = true,
	--selected_i = nil,

	update = function(_ENV)
		-- moving
		local di = 0
		if btnp(➡️) then
			di += 1
		end
		if btnp(⬅️) then
			di -= 1
		end
		
		if btnp(❎) then
			--discarded_v = hand:get_tile_i(selected_i).value
		end

		if selected_i then
			selected_i += di
		elseif di != 0 then
			selected_i = .5 - .5*di
		end
		hand:set_selected_tile_i(selected_i)

		return _ENV
	end,
	
	discard_selected_tile = function()
		assert(user)
	
		discard_tile(user, user.selected_obj.tile)
		user.pick_up_tile_obj = nil
	
		del(user.tile_objs, user.selected_obj)
		user.selected_obj = nil
	
		sort_tile_objects()
	end,
	
	sort_tile_objects = function()
		assert(user)
	
		local objs = user.tile_objs
	
		foreach(objs, function(to)
			to.prev_x = to.x
		end)
		
		for i = 1,#objs do
			local j = i
			while j > 1 and objs[j-1].tile > objs[j].tile do
				objs[j],objs[j-1] = objs[j-1],objs[j]
				j = j - 1
			end
		end
	end,
	
	draw_user = function()
		assert(user)
		draw_user_tile_objects(user.tile_objs)
		draw_melds(user.meld_objs,1)
	end,
	
	draw_user_tile_objects = function(tile_objs)
		assert(tile_objs)
		for to in all(tile_objs) do
			draw_large_tile(to.tile, to.x, to.y)
		end
	end,
}





