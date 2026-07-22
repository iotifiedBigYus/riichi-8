-- user, a player the user controls


--TODO: inherit from player


assert(player)
assert(entity)


user = player:subclass{
	is_user = true,

	function new(self)
		return entity.new(self, {

		})
	end,

	function update(_ENV)
		return _ENV
	end,

	function update_user_tile_object_positions()
		assert(user)
	
		local ox = 63 - #user.tile_objs*4
		for i,to in ipairs(user.tile_objs) do
			local x = to == user.pick_up_tile_obj and ox + (i-1)*8+2 or ox + (i-1)*8
			set_tile_object_position(to, x)
		end
	end,

	function update_user_tile_object_positions()
		assert(user)
	
		local ox = 63 - #user.tile_objs*4
		for i,to in ipairs(user.tile_objs) do
			local x = to == user.pick_up_tile_obj and ox + (i-1)*8+2 or ox + (i-1)*8
			set_tile_object_position(to, x)
		end
	end,

	function set_tile_object_position(tile_obj, x, y)
		assert(tile_obj)
		tile_obj.x = x
		tile_obj.y = tile_obj.is_selected and Y_P1_SELECTED_TILE or Y_P1_TILE
	end,

	function switch_selected_horz(dx)
		if not user.selected_obj then
			select_tile_object(dx < 0 and #user.tile_objs or 1)
		elseif user.selected_obj.is_tile then
			deselect_object()
			select_tile_object((user.i_selected_tile_obj-1+dx)%#user.tile_objs+1)
		end
		update_user_tile_object_positions()
	end,
	
	function select_object(obj)
		assert(user)
		assert(obj)
		user.selected_obj = obj
		obj.is_selected = true
	end,
	
	function select_tile_object(i_tile_obj)
		assert(user)
		assert(i_tile_obj)
		select_object(user.tile_objs[i_tile_obj])
		user.i_selected_tile_obj = i_tile_obj
	end,
	
	function deselect_object()
		user.selected_obj.is_selected = false
		user.selected_obj = nil
	end,
	
	function discard_selected_tile()
		assert(user)
	
		discard_tile(user, user.selected_obj.tile)
		user.pick_up_tile_obj = nil
	
		del(user.tile_objs, user.selected_obj)
		user.selected_obj = nil
	
		sort_tile_objects()
	end,
	
	function sort_tile_objects()
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
	
	function draw_user()
		assert(user)
		draw_user_tile_objects(user.tile_objs)
		draw_melds(user.meld_objs,1)
	end,
	
	function draw_user_tile_objects(tile_objs)
		assert(tile_objs)
		for to in all(tile_objs) do
			draw_large_tile(to.tile, to.x, to.y)
		end
	end
}





