-- https://github.com/Kraballa/ShantenCalculator/blob/master/ShantenCalculator/Shanten.cs

-- uses: analysis.lua

-- Static class that provides the ability to calculate the shanten of a set of tiles.
-- Shanten is a number that is supposed to represent the difference to Tenpai.
-- A Shanten of 0 means Tenpai. A shanten of -1 (probably) means Ron.
-- Anything above 0 means the hand needs some unspecified Tile to get Shanten - 1.
shanten = {}


-- we can determine shanten algorithmically by calculating 3 possible tenpai configurations and taking the minimum.
function shanten.calculate(tiles)
	--printh(hand.encode(tiles),"output.txt")
	-- 13 - #term/honor - if(pair;1;0)
	local kokushi = shanten.calculate_kokushi(tiles)
	--printh(kokushi,"output.txt")
	-- 6 - #pairs
	local seven_pairs = shanten.calculate_chiitoitsu(tiles)
	--printh(seven_pairs,"output.txt")
	-- 8 - 2 * #blocks - #uncompleted block (special cases notwithstanding)
	local normal_shanten = shanten.calculate_other_hands(tiles)
	--printh(normal_shanten,"output.txt")

	return min(min(kokushi, seven_pairs), normal_shanten)
end


-- calculate tenpai when only looking for Kokushi (13 orphans).
function shanten.calculate_kokushi(tiles)
	local n, n_pairs = analysis.count_terminals_honors(tiles)
	return 13 - n - min(n_pairs, 1)
end


-- calculate tenpai when only looking for chiitoitsu (7 pairs).
function shanten.calculate_chiitoitsu(tiles)
	return 6 - analysis.count_pairs(tiles)
end


-- calculate tenpai when only looking at 4 groups + 1 pair (all other yaku).
function shanten.calculate_other_hands(tiles)
	return shanten.from_melds(analysis.scan(tiles))
end


function shanten.from_melds(n_sets, n_p_sets, n_pairs)
	-- normal shanten calculation.
	local shanten = 8 - (n_p_sets + n_pairs) - 2 * n_sets;

	-- special case: 5 blocks, no n_pairs
	if n_p_sets + n_sets == 5 and n_pairs == 0 then
		shanten += 1
	end

	-- special case 2: 6 blocks. there cannot be 6 blocks in a completed hand so count it as 5 blocks
	if n_p_sets + n_sets + n_pairs >= 6 then
		-- 5 blocks. -1 for every set. e.g. we have 2 sets and 4 partial sets. we can only count 5-2=3 partial sets
		while n_sets + n_p_sets + n_pairs >= 6 do
			if n_p_sets > 0 then
				n_p_sets -= 1
			elseif n_pairs > 0 then
				n_pairs -= 1
			end
		end
		local norm_p_set = min(5 - n_sets, n_p_sets);
		shanten = 8 - 2 * n_sets - (norm_p_set + n_pairs);
	end

	return shanten;
end