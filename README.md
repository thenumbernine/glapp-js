I want to get my luajit apps running in-browser.
This is doable for Lua, but for LuaJIT I can't find anything out there that has accomplished this.

So one avenue I'm poking at is building luajit with emscripten.

Meanwhile I thought I'd poke at the slow option of just emulating the ffi calls, while running Lua in-browser with https://fengari.io/
