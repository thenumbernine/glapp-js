-- fengari launcher
-- Lua 5.3
xpcall(function()
	--print(package.path)	-- ./lua/5.3/?.lua;./lua/5.3/?/init.lua;./?.lua;./?/init.lua
	package.path = table.concat({
		'./?.lua',
		'/lua/?.lua',
		'/lua/?/?.lua',
	}, ';')

	-- fengari doesn't have a fake-filesystem so ...
	-- [[ require 'io'
	assert(not package.io)
	local io = require 'io'
	package.loaded.io = io
	_G.io = io
	--]]

	-- this modifies some of the _G functions so it should go first
	local ffi = require 'ffi'

	-- add DEBUG lines
	-- needs io to exist first ...
	--require 'ext.debug'

	-- TODO while we're here, connect gles3 calls to webgl

--[=[
	ffi.cdef[[
struct A {
	int a[1];
	int b[1];
};
]]
	local c = ffi.new'struct A';
	print('ffi.null', ffi.null)
	print('c', c)
	print('ffi.typeof(c)', ffi.typeof(c))
	print('ffi.typeof(c.a)', ffi.typeof(c.a))	-- should be: ctype<int (&)[1]>
	assert(type(c) == 'cdata')
	assert(type(c.b) == 'cdata')
	assert(ffi.sizeof(c) == 8)
	assert(ffi.sizeof(c.b) == 4)
	c.b[0] = 1				-- TODO this should be an error: cannot convert 'number' to 'int [1]'
	print('c.b', c.b)		-- should be: cdata<int (&)[1]>: 0x7485879aea1c
	print('c.b[0]', c.b[0])
	assert(c.b[0] == 1)
	local v = ffi.cast('int', 2)
	c.b[0] = v
	print('c.b[0]', c.b[0])
	assert(c.b[0] == 2)
--]=]
--[=[
	print'mem: null'
	if ffi.memdump then print('mem', ffi.memdump()) end
	local s = 'testing'

	local l = ffi.new'int[1]'
	print'mem: null, int[1] l'
	if ffi.memdump then print('mem', ffi.memdump()) end
	print('l', l)
	print('l[0]', l[0])
	l[0] = #s
	print('l[0]', l[0])
	print('mem: null, int[1] l='..#s)
	if ffi.memdump then print('mem', ffi.memdump()) end

	local p = ffi.new'const char*[1]'	-- luajit requires const char*, not char*
	print('mem: null, int[1] l='..#s..' char*[1] p')
	if ffi.memdump then print('mem', ffi.memdump()) end
	print('p', p)
	print('p[0]', p[0])
	p[0] = s
	print('mem: null, int[1] l='..#s..' char*[1] p=0xc char[8] s='..s)
	if ffi.memdump then print('mem', ffi.memdump()) end

	print('p[0]', p[0])	-- pointer has changed
	print("ffi.cast('intptr_t', p[0])", ffi.cast('intptr_t', p[0]))
	if ffi.memdump then print('mem', ffi.memdump()) end
	print('p[0]', p[0])
	--print('memGetPtr(p[0])', ffi.memGetPtr(p[0]))
	--print('memGetPtr(20)', ffi.memGetPtr(20))
	print('ffi.string(p[0])', ffi.string(p[0]))
--]=]
--[=[
	if ffi.memdump then print('mem', ffi.memdump()) end
	local v = ffi.new'void*'
	print('v', v)
	if ffi.memdump then print('mem', ffi.memdump()) end
--]=]
--[=[
	local i = ffi.new('int32_t', 42)
	print(i)
	print(tonumber(i))

	local a = ffi.new('char[20]')
	local p = ffi.cast('char*', a)
	local p2 = ffi.cast('int*', p)
	print('a', a)
	print('p', p)
	print('p2', p2)
	print(ffi.cast('intptr_t', a))	-- same
	print(ffi.cast('intptr_t', p))	-- should assign the pointer to the new intptr_t
	print(ffi.cast('intptr_t', p2))
	print(('%x'):format(tonumber(ffi.cast('intptr_t', p2))))
--]=]
--[=[
	local struct = require 'struct'
	print('struct', struct)

	local A = struct{
		name = 'A',
		fields = {
			{name='a', type='float'},
			{name='b', type='int'},
		},
	}
	print('type(A)', type(A))
	print('A', A)
--]=]
--[=[
	local quatd = require 'vec-ffi.quatd'
	print('quatd', quatd)	-- should be a type?
	print('type(quatd)', type(quatd))
	print('ffi.sizeof(quatd)', ffi.sizeof(quatd))
	local q = quatd()
	--print('quatd size', getmetatable(q).type.size)
	print('ffi.sizeof(q)', ffi.sizeof(q))

	print('q.x', q.x)
	--print("q.notthere", q.notthere)
	print("q.fieldToString", q.fieldToString)
	print("q:fieldToString('x', 'double')", q:fieldToString('x', 'double'))

	--print('q', q)
--]=]
--[=[
	local sdl = require 'ffi.sdl'
	local eventPtr = ffi.new'SDL_Event[1]'
	local event = eventPtr
	print('event', event)
	print('event[0]', event[0])
	print('event[0].type', event[0].type)	-- I think luajit coerces this into a number
	print('tonumber(event[0].type)', tonumber(event[0].type))
	print('sdl.SDL_WINDOWEVENT', sdl.SDL_WINDOWEVENT)
	print('ffi.C.SDL_WINDOWEVENT', ffi.C.SDL_WINDOWEVENT)
	event[0].type = sdl.SDL_WINDOWEVENT
	print('event[0].type', event[0].type)
	event[0].window.event = sdl.SDL_WINDOWEVENT_SIZE_CHANGED
	event[0].window.data1 = 123
	event[0].window.data2 = 456
	print(event[0].type)
	print(event[0].window.event)
--]=]
-- [=[
	local f = ffi.new('float[2]', 3, 5)
	print('f', f)
	print('f[0]', f[0])
	print('f[1]', f[1])
	local g = ffi.new('float*', f)
	print('g[0]', g[0])
	print('g[1]', g[1])
	print('g', g)
--]=]
--[=[
	-- run it and initialize glapp variable
	
	-- start it as a new thread ...
	-- TODO can I just wrap the whole dofile() in a main thread?
	-- the tradeoff is I'd lose my ability for main coroutine detection ...
	-- or maybe I should shim that function as well ...
	local sdl = require 'ffi.sdl'
	sdl.mainthread = coroutine.create(function()
		--dofile'/lua/glapp/tests/test_es2.lua'	-- only gles calls
		--dofile'/lua/glapp/tests/test_es.lua'	-- gl objs
		dofile'/lua/line-integral-convolution/run.lua'
	end)
	local res, err = coroutine.resume(sdl.mainthread)
	if not res then
		print('coroutine.resume failed')
		print(err)
		print(debug.traceback(sdl.mainthread))
	end

	-- set up main loop
	-- TOOD use requestAnimationFrame instead
	local interval
	local window = js.global.window
	interval = window:setInterval(function()
		-- also in SDL_PollEvent, tho I could just route it through GLApp:update ...
		--[[
		coroutine.assertresume(sdl.mainthread)
		--]]
		-- [[
		local res, err = coroutine.resume(sdl.mainthread)
		if not res then
			print('coroutine.resume failed')
			print(err)
			print(debug.traceback(sdl.mainthread))
			window:clearInterval(interval)
		end
		--]]
	end, 10)
	print('mainthread interval', interval)

--]=]
	print'run-fengari.lua done'
end, function(err)
	print(tostring(err)..'\n'..debug.traceback())
end)
