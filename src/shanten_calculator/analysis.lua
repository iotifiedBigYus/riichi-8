-- https://github.com/Kraballa/ShantenCalculator/blob/master/ShantenCalculator/Analysis.cs

-- uses: meld_finder.lua

-- Various methods surrounding the analysis of a set of tiles.
analysis = {}


function analysis.is_terminal_or_honor(tile)
	return tile % 9 <= 1 or tile > 27
end


-- count the number of unique pairs.
function analysis.count_pairs(tiles) -- tiles is a table of integers
	local n_pairs = 0

	foreach(tiles, function(t)
		if (t >= 2) n_pairs += 1
	end)

	return n_pairs
end


function analysis.count_terminals_honors(tiles)
	local n, n_pairs = 0, 0

	for i,t in ipairs(tiles) do
		if analysis.is_terminal_or_honor(i) then
			if (t >= 1) n += 1
			if (t >= 2) n_pairs += 1
		end
	end

	return n, n_pairs
end


-- scan a list of tiles from a single suit. we need to count pairs because a full hand needs a pair
function analysis.scan(tiles)
	n_p_set, n_set, n_pairs = 0, 0, 0

	-- split into sections so it's easier to disassemble
	----printh("scan tiles: "..hand.encode(tiles),"output.txt")

	man, pin, sou, z = analysis.split(tiles)
	--printh("scan man tiles: "..hand.encode9(man),"output.txt")
	--printh("scan pin tiles: "..hand.encode9(pin),"output.txt")
	--printh("scan sou tiles: "..hand.encode9(sou),"output.txt")
	--printh("scan z tiles: "..hand.encode7(z),"output.txt")

	n_pairs, n_set = meld_finder.count_z(z, n_pairs, n_set);
	--printh("scan n_pairs, n_set: "..tostr(n_pairs)..", "..tostr(n_set),"output.txt")
	n_set, n_p_set, n_pairs = meld_finder.count(man, n_set, n_p_set, n_pairs)
	--printh("scan n_set, n_p_set, n_pairs: "..tostr(n_set)..", "..tostr(n_p_set)..", "..tostr(n_pairs),"output.txt")
	n_set, n_p_set, n_pairs = meld_finder.count(pin, n_set, n_p_set, n_pairs)
	n_set, n_p_set, n_pairs = meld_finder.count(sou, n_set, n_p_set, n_pairs)

	return n_set, n_p_set, n_pairs
end


function analysis.split(tiles)
	man, pin, sou, z = {}, {}, {}, {}

	for i = 1,9 do
		man[i] = tiles[i]
		pin[i] = tiles[i+9]
		sou[i] = tiles[i+18]
		if (i<=7) z[i] = tiles[i + 27];
	end

	return man, pin, sou, z
end