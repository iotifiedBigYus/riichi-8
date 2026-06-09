


function debug(...)
	local args = {...}
	local output = ""
	for a in all(args) do
		output ..= debug_type(a) .. " "
	end
	printh(output == "" and "[nil]" or output, "debug")
end


function debug_type(a)
	if type(a) == "string" then
		return a
	elseif type(a) == "table" then
		return debug_table(a)
	else
		return tostr(a)
	end
end


function debug_table(table)
	local output = "{ "
	for k,v in pairs(table) do
		output ..= "["..k .. "]" .. debug_type(v) .. " "
	end
	output ..= "}"
	return output
end