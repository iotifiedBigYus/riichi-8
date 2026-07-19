-- routines


assert(class)


async = class:new{
	new = function(self)
		return class.new(self, {
			routines = {},
		})
	end,

	create = function(_ENV, func)
		add(routines, func)
	end,

	kill = function(_ENV)
		routines = {}
	end,

	resume = function(_ENV, func)
		foreach(routines, coresume)
	end,

	animate = function(_ENV, obj, key, value, frames, easing, no_snap)
		add(routines, cocreate(function()
			local value0 = obj[key]
			for i = 1,frames do
				local t = easing and easing(i/frames) or i/frames
				obj[key] = value0 + (value-value0)*t
				yield()
			end
			if (no_snap) return
			obj[key] = flr(obj[key]) -- snap on finish
		end))
	end,
}