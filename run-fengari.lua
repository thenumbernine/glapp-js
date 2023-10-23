-- fengari launcher
-- Lua 5.3
xpcall(function()
	--print(package.path)	-- ./lua/5.3/?.lua;./lua/5.3/?/init.lua;./?.lua;./?/init.lua
	package.path = './?.lua;./?/?.lua'

	-- fengari doesn't have a fake-filesystem so ...
	-- [[ require 'io'
	assert(not package.io)
	local io = require 'io'
	package.loaded.io = io
	_G.io = io
	--]]

	-- TODO while we're here, connect gles3 calls to webgl

	assert(assert(loadfile'glapp/tests/info.lua')())
	print'done'
end, function(err)
	print(err..'\n'..debug.traceback())
end)
