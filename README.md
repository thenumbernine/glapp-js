[![Donate via Stripe](https://img.shields.io/badge/Donate-Stripe-green.svg)](https://buy.stripe.com/00gbJZ0OdcNs9zi288)<br>

### LuaJIT + OpenGL + SDL in Browser

This tool runs LuaJIT + SDL + OpenGL + ImGui code in browser.

The Lua is handled by one of a few Lua/JS backends.

The FFI, SDL, and ImGui calls are handled via a shim layer.

FFI is all handled with a pure-Lua implementation all up to the byte allocation, which is handed off to JS.  In theory you could swap that out and use the `ffi.lua` file in any vanilla Lua environment where you want to emulate luajit.

Maybe in the future I'll use an Emscripten-compiled luajit-compatible Lua ffi library.  There are a few floating around, but every one that I used on my own LuaJIT code I got an immediate segfault and turned back.

The `ffi/OpenGLES3.lua` file is an interface layer between GLES and WebGL.

The `main.js` and `ffi/sdl.lua` files handle the canvas object and the Lua wrapping thread to allow for my internal SDL busy-loops to become interval loops in browser.

### Lua/JS 

I'm going through different Lua/JS libraries to see which works best.

- Fengari is great to work with, interop is flawless, however it's missing filesystem support.  Since it is not Emscripten-compiled, it does not come with Emscripten's filesystem library.

- Wasmoon is Emscripten-compiled and so you do get Emscripten's filesystem for free, however everything Wasmoon itself brings to the table makes things more difficult.
	- The Wasmoon wrapping filesystem calls are all in TEXT, not BINARY, so I have to side-step them.
	- The Wasmoon interop functions are full of holes.
		- Lua calls to JS code will detect different objects every time for the same Lua object (or for the same original JS object even),
		- There's strange cases where my own classes and objects will be passed through fine, but builtin functions like `ArrayBuffer` when passed through will get extra crap wrapped around them.
		- Randomly within Lua, some `jsobj:memberFuncCall()`'s will work and some will not.  I can't figure out what the difference is and I don't plan to waste my time finding out.
- Other contenders?
	- https://github.com/Doridian/LuaJS
