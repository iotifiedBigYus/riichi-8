-- points


function calculate_points(han, fu, mul)
	local base = 4 * fu * 2 ^ han
	if han > 12 then
		base = 8000
	elseif han > 4 or base > 2000 then --> change to 1920 for kiriage mangan
		base = split"2000,2000,2000,2000,2000,3000,3000,4000,4000,4000,6000,6000"[han]
	end
	return ceil(0.01 * mul * base)*100
end
