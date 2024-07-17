[![Donate via Stripe](https://img.shields.io/badge/Donate-Stripe-green.svg)](https://buy.stripe.com/00gbJZ0OdcNs9zi288)<br>

### LuaJIT + OpenGL + SDL in Browser

I want to get my luajit apps running in-browser.
This is doable for Lua, but for LuaJIT I can't find anything out there that has accomplished this.

So one avenue I'm poking at is building luajit with emscripten.

Meanwhile I thought I'd poke at the slow option of just emulating the ffi calls, while running Lua in-browser with https://fengari.io/

The ffi.lua file is an attempt to a luajit-ffi implementation for fengari.

The ffi/OpenGLES3.lua file is an interface layer between GLES and WebGL.
