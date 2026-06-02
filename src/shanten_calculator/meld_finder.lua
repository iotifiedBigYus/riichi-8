-- https://github.com/Kraballa/ShantenCalculator/blob/master/ShantenCalculator/MeldFinder.cs


-- find_all_groups: small_meld, 
-- value_melds: shanten.from_melds
-- find_best_meld_combo: find_all_groups, value_melds
-- find: find_best_meld_combo


meld_finder = {}


-- find the best possible meld combo and increment a reference value accordingly.
function meld_finder.count(tiles, n_sets, n_p_sets, n_pairs)
	local melds = meld_finder.find(tiles)
	--printh("count #melds: "..tostr(#melds),"output.txt")

	foreach (melds, function(m)
		if m.type == "set" then
			n_sets += 1
		elseif m.type == "p set" then
			n_p_sets += 1
		elseif m.type == "pair" then
			n_pairs += 1
		end
	end)

	return n_sets, n_p_sets, n_pairs
end


-- small_meld represents a meld from a set of 9 tiles. Used individually for man, pin and sou.
function meld_finder.small_meld(tiles, type)
	return {
		tiles = tiles,
		type = type
	}
end


-- disassemble a set of honor tiles (int[7]) into a number of pairs and triplets.
function meld_finder.count_z(tiles, n_pairs, n_triplets)
	foreach(tiles, function(t)
		if t >= 3 then
			n_triplets += 1
		elseif t == 2 then
			n_pairs += 1
		end
	end)

	return n_pairs, n_triplets
end


-- from a given set of tiles (int[9]) list all possible combinations into sets, p_ets and pairs.
function meld_finder.find_all_groups(tiles)
	local groups = {}

	local new_group = function(tiles)
		local group = {}
		foreach(tiles, function() add(group,0) end)
		return group
	end

	for i,t in ipairs(tiles) do
		if t >= 3 then -- 111
			--printh("find_all 111 i, t: "..tostr(i)..", "..tostr(t),"output.txt")
			local group = new_group(tiles)
			group[i] = 3;
			add(groups, meld_finder.small_meld(group, "set"))
		end

		-- we have to prioritize pairs because of chiitoitsu.
		if t >= 2 then -- 11
			--printh("find_all 11 i, t: "..tostr(i)..", "..tostr(t),"output.txt")
			local group = new_group(tiles)
			group[i] = 2
			add(groups, meld_finder.small_meld(group, "pair"))
		end
	end

	-- we have to prioritize runs over partial sets because that way we can get better shanten with less groups
	for i = 1,7 do
		if tiles[i] >= 1 and tiles[i+1] >= 1 and tiles[i+2] >= 1 then
			local group = new_group(tiles)
			group[i], group[i+1], group[i+2] = 1, 1, 1
			add(groups, meld_finder.small_meld(group, "set"))
			--printh("find_all runs group: "..hand.encode9(group),"output.txt")
		end
	end

	for i = 1,#tiles do
		if i <= 7 then -- 13
			if tiles[i] >= 1 and tiles[i+2] >= 1 then
				local group = new_group(tiles)
				group[i], group[i+2] = 1, 1
				add(groups, meld_finder.small_meld(group, "p set"))
				--printh("find_all 13 group: "..hand.encode9(group),"output.txt")
			end
		end
		if i <= 8 then -- 12
			if tiles[i] >= 1 and tiles[i+1] >= 1 then
				local group = new_group(tiles)
				group[i], group[i+1] = 1, 1
				add(groups, meld_finder.small_meld(group, "p set"))
				--printh("find_all 12 group: "..hand.encode9(group),"output.txt")
			end
		end
	end

	--printh("find_all #groups: "..tostr(#groups),"output.txt")
	return groups
end


-- value a list of melds. a set is worth 2 points while a pair or p_set is worth 1 point.
function meld_finder.value_melds(melds)
	n_pairs, n_p_sets, n_sets = 0, 0, 0

	foreach(melds, function(m)
		if m.type == "set" then
			n_sets += 1
		elseif m.type == "p set" then
			n_p_sets += 1
		elseif m.type == "pair" then
			n_pairs += 1
		end
	end)

	
	--printh("value_melds #melds: "..tostr(#melds),"output.txt")
	--printh("value_melds n_sets, n_p_sets, n_pairs: "..tostr(n_sets)..", "..tostr(n_p_sets)..", "..tostr(n_pairs),"output.txt")

	return shanten.from_melds(n_sets, n_p_sets, n_pairs);
end


-- recursively search best melds from a set of tiles (int[9]).
-- we apply a recursive dfs algorithm to find the most value set of (partial) melds.
function meld_finder.find_best_meld_combo(tiles, best_melds, current_melds)

	--printh("find_best tiles: "..hand.encode9(tiles),"output.txt")
	local groups = meld_finder.find_all_groups(tiles)

	if #groups > 0 then -- check if we can recourse further
		foreach(groups, function(m)
			-- apply hand
			for i = 1,#tiles do
				tiles[i] -= m.tiles[i];
			end

			add(current_melds, m)
			--printh("find_best #current_melds: "..tostr(#current_melds),"output.txt")
			meld_finder.find_best_meld_combo(tiles, best_melds, current_melds)
			current_melds[#current_melds] = nil
			--printh("find_best #current_melds: "..tostr(#current_melds),"output.txt")

			-- apply hand
			for i = 1,#tiles do
				tiles[i] += m.tiles[i];
			end
		end)
	else -- end of recursion
		if meld_finder.value_melds(current_melds) < meld_finder.value_melds(best_melds) then
			--printh("find_best meld change","output.txt")
			-- best_melds table needs to mutate so all callers up the recursion stack see the updated melds.
			-- replacing the reference does not work.
			for i = 1,#best_melds do best_melds[i] = nil end
    	for i, v in ipairs(current_melds) do
				local tiles_copy = {}
				for j, t in ipairs(v.tiles) do tiles_copy[j] = t end
				best_melds[i] = meld_finder.small_meld(tiles_copy, v.type)
			end
		end
	end

	--printh("find_best #best_melds: "..tostr(#best_melds),"output.txt")

	return best_melds
end


-- disassemble a set of tiles of one suit (int[9]) into a list of melds.
-- this list contains the best combo of sets, pairs and partial sets where sets are valued 2 points and the rest 1.
function meld_finder.find(tiles)
	return meld_finder.find_best_meld_combo(tiles, {}, {})
end