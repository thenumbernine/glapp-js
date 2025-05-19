[![Donate via Stripe](https://img.shields.io/badge/Donate-Stripe-green.svg)](https://buy.stripe.com/00gbJZ0OdcNs9zi288)<br>

# LuaJIT + OpenGL + SDL in Browser

-	[[interactive editor]](https://thenumbernine.github.io/glapp/)
[![](pic.png)](https://thenumbernine.github.io/glapp/)


-	[[launch]](https://thenumbernine.github.io/glapp/?dir=glapp/tests&file=test_es.lua)
	[[source]](https://thenumbernine.github.io/lua/glapp/tests/test_es.lua)
	polygon demo
-	[[launch]](https://thenumbernine.github.io/glapp/?dir=glapp/tests&file=test_tex.lua)
	[[source]](https://thenumbernine.github.io/lua/glapp/tests/test_tex.lua)
	texture demo

This tool runs LuaJIT + SDL + OpenGL + ImGui code in browser.

The LuaJIT is "emulated" via vanilla-Lua + lua-FFI , compiled to wasm, which is built via my [lua-ffi-wasm](http://github.com/thenumbernine/lua-ffi-wasm) project.

The FFI is implemented using my [fork](https://github.com/thenumbernine/luaffifb) of the luaffifb project, modified for WASM, making use of Emscripten's dlsym implementation and LibFFI's WASM32 support.

# Why?

The native LuaJIT version is fast, and always runs at least twice or more as fast as a browser+JS+WebGL-equivalent app.
Too bad the modern standard browser platform sucks so much, and is so slow.
I'm only making this for compatability's sake, not as a primary deployment option.  To share with normies who only know how to open browser windows but who can't download binaries.

# Code Editor

I'm using [Ace](https://github.com/ajaxorg/ace) for the code editor.  No complaints at all, integrating and using it is flawless.

# GET parameters:

- `pkg` = The package-name, referencing collections-of-files per-git-repo to load.  If omitted then it is inferred from the rundir.
- `dir` = The directory to start in.
- `file` = The file to run.
- `args` = JSON-encoded CLI arguments to be passed to the file.

# Last

- TODO maybe - pause button <-> pause the setinterval for the main event loop.
- Maybe some progress bars while it downloads folders.  Maybe even some buttons for downloading optional folders instead of grabbing everything up front.
