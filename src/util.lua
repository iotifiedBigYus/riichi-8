-- util
-- https://easings.net/


function empty_values()
	return split[[
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,
		0,0,0,0,
		0,0,0,
		0,0,0
	]]
end


function sum_values(values1, values2)
	values_sum = {}
	for i = 1,37 do
		values_sum[i] = values1[i] + values2[i]
	end
	return values_sum
end


function ease_in_out_quad(x)
	return x < 0.5 and 2 * x * x or 1 - (-2 * x + 2)^2 / 2
end


function fit_in_four(x)
	assert(x)
	return (x-1)%4+1
end


function animate(obj, key, value, frames, easing, no_snap)
	return function()
		local value0 = obj[key]
		for i = 1,frames do
			local t = easing and easing(i/frames) or i/frames
			obj[key] = value0 + (value-value0)*t
			yield()
		end
		if (no_snap) return
		obj[key] = flr(obj[key]) -- snap on finish
	end
end


function set_later(obj, key, value, frames)
	return function()
		for _ = 1,frames do
			yield()
		end
		obj[key] = value
	end
end


function parse_line(line)
	local indices = {}
	local n_tiles = empty_values()
	
	for i = 1,#line do
		local offset = 0;
		local is_number = false;
		local s = sub( line, i,i )
		if s == 'm' then
			--
		elseif s == 'p' then
			offset = 1
		elseif s == 's' then
			offset = 2
		elseif s == 'z' then
			offset = 3
		else
			is_number = true
		end

		if is_number then
			add(indices, tonum(s));
		else
			foreach(indices, function(i)
				if i > 0 then
					n_tiles[i + offset*9] += 1
				else
					n_tiles[35 + offset] += 1
				end
			end)
			indices = {}
		end
	end

	return n_tiles;
end


function encode_n_tiles(n_tiles, in_color)
	local code = in_color and "\#0" or ""
	local suffix = { "m", "p", "s", "z" }

	for i = 1,4 do
		local had_tile = false

		code ..= in_color and ({"\f8", "\fc", "\fb", "\f6" })[i] or ""

		-- red fives
		if i <= 3 do
			local n = n_tiles[34 + i];
			for _ = 1,n do
				had_tile = true;
				code ..= 0
			end
		end
		-- number tiles
		for j = 1,9 do
			local t = (i-1) * 9 + j
			if (t > 34) break
			local n = n_tiles[t];
			for _ = 1,n do
				had_tile = true;
				code ..= j
			end
		end
		if (had_tile) code ..= suffix[i]
	end
	return code
end