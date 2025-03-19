local ffi = require 'ffi'

return {
	strerror = function(errno)
		return 'error '..tostring(errno)
	end,

	strlen = function(p)
		local start = p
		while p[0] ~= 0 do
			p = p + 1
		end
		return p - start
	end,
}
