async function require(path) {
	let _module = window.module;
	window.module = {};
	await import(path);
	let exports = module.exports;
	window.module = _module;
	return exports;
}

/* some lua emscripten build ... * /

window.LuaModule = {
	print : s => { console.log(s); },
	printErr : s => { console.log(s); },
	stdin : () => {},
};
const m = await require('./lua.vm.js');
window.LuaModule = undefined;

const Lua = m.Lua;
const FS = m.FS;

console.log(Lua.theGlobal);

Lua.execute(`
print(js.global)
`);
/* */


/* WASMOON ... WELL, EMSCRIPTEN-LUA WORKS GREAT, AND ITS FILESYSTEM SUPPORT IS GREAT, BUT WASMOON'S DUTY TO GLUE IT TO JS AND MITIGATE API AND ERRORS IS NOT SO CLEAN ... */
await import('./wasmoon.min.js');	// defines the global 'wasmoon', returns nothing, and that isn't documented in any corner of all of the internet
const LuaFactory = wasmoon.LuaFactory;
const factory = new LuaFactory();
const lua = await factory.createEngine();

// https://github.com/hellpanderrr/lua-in-browser
async function mountFile(file_path, lua_path) {
    const fileContent = await fetch(file_path).then(data => data.text());
    await factory.mountFile(lua_path, fileContent);
}

// TODO autogen this remotely ... like i did in lua.vm-util.js.lua
await mountFile('ffi.lua', 'ffi.lua');
await mountFile('ffi/EGL.lua', 'ffi/EGL.lua');
await mountFile('ffi/OpenGL.lua', 'ffi/OpenGL.lua');
await mountFile('ffi/OpenGLES3.lua', 'ffi/OpenGLES3.lua');
await mountFile('ffi/cimgui.lua', 'ffi/cimgui.lua');
await mountFile('ffi/req.lua', 'ffi/req.lua');
await mountFile('ffi/sdl.lua', 'ffi/sdl.lua');
await mountFile('ffi/c/errno.lua', 'ffi/c/errno.lua');
await mountFile('ffi/c/stdlib.lua', 'ffi/c/stdlib.lua');
await mountFile('ffi/c/string.lua', 'ffi/c/string.lua');
await mountFile('ffi/c/sys/time.lua', 'ffi/c/sys/time.lua');
await mountFile('ffi/cpp/vector-lua.lua', 'ffi/cpp/vector-lua.lua');
await mountFile('ffi/cpp/vector.lua', 'ffi/cpp/vector.lua');
await mountFile('ffi/gcwrapper/gcwrapper.lua', 'ffi/gcwrapper/gcwrapper.lua');
await mountFile('init-jslua-bridge.lua', 'init-jslua-bridge.lua');
await mountFile('/lua/bit/bit.lua', 'lua/bit/bit.lua');
await mountFile('/lua/template/showcode.lua', 'lua/template/showcode.lua');
await mountFile('/lua/template/template.lua', 'lua/template/template.lua');
await mountFile('/lua/ext/assert.lua', 'lua/ext/assert.lua');
await mountFile('/lua/ext/class.lua', 'lua/ext/class.lua');
await mountFile('/lua/ext/cmdline.lua', 'lua/ext/cmdline.lua');
await mountFile('/lua/ext/coroutine.lua', 'lua/ext/coroutine.lua');
await mountFile('/lua/ext/ctypes.lua', 'lua/ext/ctypes.lua');
await mountFile('/lua/ext/debug.lua', 'lua/ext/debug.lua');
await mountFile('/lua/ext/detect_ffi.lua', 'lua/ext/detect_ffi.lua');
await mountFile('/lua/ext/detect_lfs.lua', 'lua/ext/detect_lfs.lua');
await mountFile('/lua/ext/detect_os.lua', 'lua/ext/detect_os.lua');
await mountFile('/lua/ext/env.lua', 'lua/ext/env.lua');
await mountFile('/lua/ext/ext.lua', 'lua/ext/ext.lua');
await mountFile('/lua/ext/fromlua.lua', 'lua/ext/fromlua.lua');
await mountFile('/lua/ext/gcmem.lua', 'lua/ext/gcmem.lua');
await mountFile('/lua/ext/io.lua', 'lua/ext/io.lua');
await mountFile('/lua/ext/load.lua', 'lua/ext/load.lua');
await mountFile('/lua/ext/math.lua', 'lua/ext/math.lua');
await mountFile('/lua/ext/meta.lua', 'lua/ext/meta.lua');
await mountFile('/lua/ext/number.lua', 'lua/ext/number.lua');
await mountFile('/lua/ext/op.lua', 'lua/ext/op.lua');
await mountFile('/lua/ext/os.lua', 'lua/ext/os.lua');
await mountFile('/lua/ext/path.lua', 'lua/ext/path.lua');
await mountFile('/lua/ext/range.lua', 'lua/ext/range.lua');
await mountFile('/lua/ext/reload.lua', 'lua/ext/reload.lua');
await mountFile('/lua/ext/require.lua', 'lua/ext/require.lua');
await mountFile('/lua/ext/string.lua', 'lua/ext/string.lua');
await mountFile('/lua/ext/table.lua', 'lua/ext/table.lua');
await mountFile('/lua/ext/timer.lua', 'lua/ext/timer.lua');
await mountFile('/lua/ext/tolua.lua', 'lua/ext/tolua.lua');
await mountFile('/lua/ext/xpcall.lua', 'lua/ext/xpcall.lua');
await mountFile('/lua/matrix/curl.lua', 'lua/matrix/curl.lua');
await mountFile('/lua/matrix/determinant.lua', 'lua/matrix/determinant.lua');
await mountFile('/lua/matrix/div.lua', 'lua/matrix/div.lua');
await mountFile('/lua/matrix/ffi.lua', 'lua/matrix/ffi.lua');
await mountFile('/lua/matrix/grad.lua', 'lua/matrix/grad.lua');
await mountFile('/lua/matrix/helmholtzinv.lua', 'lua/matrix/helmholtzinv.lua');
await mountFile('/lua/matrix/index.lua', 'lua/matrix/index.lua');
await mountFile('/lua/matrix/inverse.lua', 'lua/matrix/inverse.lua');
await mountFile('/lua/matrix/lapinv.lua', 'lua/matrix/lapinv.lua');
await mountFile('/lua/matrix/matrix.lua', 'lua/matrix/matrix.lua');
await mountFile('/lua/gl/arraybuffer.lua', 'lua/gl/arraybuffer.lua');
await mountFile('/lua/gl/attribute.lua', 'lua/gl/attribute.lua');
await mountFile('/lua/gl/buffer.lua', 'lua/gl/buffer.lua');
await mountFile('/lua/gl/call.lua', 'lua/gl/call.lua');
await mountFile('/lua/gl/elementarraybuffer.lua', 'lua/gl/elementarraybuffer.lua');
await mountFile('/lua/gl/fbo.lua', 'lua/gl/fbo.lua');
await mountFile('/lua/gl/geometry.lua', 'lua/gl/geometry.lua');
await mountFile('/lua/gl/get.lua', 'lua/gl/get.lua');
await mountFile('/lua/gl/gl.lua', 'lua/gl/gl.lua');
await mountFile('/lua/gl/gradienttex2d.lua', 'lua/gl/gradienttex2d.lua');
await mountFile('/lua/gl/gradienttex.lua', 'lua/gl/gradienttex.lua');
await mountFile('/lua/gl/hsvtex2d.lua', 'lua/gl/hsvtex2d.lua');
await mountFile('/lua/gl/hsvtex.lua', 'lua/gl/hsvtex.lua');
await mountFile('/lua/gl/intersect.lua', 'lua/gl/intersect.lua');
await mountFile('/lua/gl/kernelprogram.lua', 'lua/gl/kernelprogram.lua');
await mountFile('/lua/gl/pingpong3d.lua', 'lua/gl/pingpong3d.lua');
await mountFile('/lua/gl/pingpong.lua', 'lua/gl/pingpong.lua');
await mountFile('/lua/gl/pixelpackbuffer.lua', 'lua/gl/pixelpackbuffer.lua');
await mountFile('/lua/gl/pixelunpackbuffer.lua', 'lua/gl/pixelunpackbuffer.lua');
await mountFile('/lua/gl/program.lua', 'lua/gl/program.lua');
await mountFile('/lua/gl/report.lua', 'lua/gl/report.lua');
await mountFile('/lua/gl/sceneobject.lua', 'lua/gl/sceneobject.lua');
await mountFile('/lua/gl/setup.lua', 'lua/gl/setup.lua');
await mountFile('/lua/gl/shader.lua', 'lua/gl/shader.lua');
await mountFile('/lua/gl/shaderstoragebuffer.lua', 'lua/gl/shaderstoragebuffer.lua');
await mountFile('/lua/gl/tex1d.lua', 'lua/gl/tex1d.lua');
await mountFile('/lua/gl/tex2d.lua', 'lua/gl/tex2d.lua');
await mountFile('/lua/gl/tex3d.lua', 'lua/gl/tex3d.lua');
await mountFile('/lua/gl/texbuffer.lua', 'lua/gl/texbuffer.lua');
await mountFile('/lua/gl/texcube.lua', 'lua/gl/texcube.lua');
await mountFile('/lua/gl/tex.lua', 'lua/gl/tex.lua');
await mountFile('/lua/gl/vertexarray.lua', 'lua/gl/vertexarray.lua');
await mountFile('/lua/glapp/glapp.lua', 'lua/glapp/glapp.lua');
await mountFile('/lua/glapp/mouse.lua', 'lua/glapp/mouse.lua');
await mountFile('/lua/glapp/orbit.lua', 'lua/glapp/orbit.lua');
await mountFile('/lua/glapp/view.lua', 'lua/glapp/view.lua');
await mountFile('/lua/glapp/tests/compute.lua', 'lua/glapp/tests/compute.lua');
await mountFile('/lua/glapp/tests/compute-spirv.clcpp', 'lua/glapp/tests/compute-spirv.clcpp');
await mountFile('/lua/glapp/tests/compute-spirv.lua', 'lua/glapp/tests/compute-spirv.lua');
await mountFile('/lua/glapp/tests/cubemap.lua', 'lua/glapp/tests/cubemap.lua');
await mountFile('/lua/glapp/tests/events.lua', 'lua/glapp/tests/events.lua');
await mountFile('/lua/glapp/tests/info.lua', 'lua/glapp/tests/info.lua');
await mountFile('/lua/glapp/tests/minimal.lua', 'lua/glapp/tests/minimal.lua');
await mountFile('/lua/glapp/tests/pointtest.lua', 'lua/glapp/tests/pointtest.lua');
await mountFile('/lua/glapp/tests/src.png', 'lua/glapp/tests/src.png');
await mountFile('/lua/glapp/tests/test_es2.lua', 'lua/glapp/tests/test_es2.lua');
await mountFile('/lua/glapp/tests/test_es.lua', 'lua/glapp/tests/test_es.lua');
await mountFile('/lua/glapp/tests/test.lua', 'lua/glapp/tests/test.lua');
await mountFile('/lua/glapp/tests/test_vertexattrib.lua', 'lua/glapp/tests/test_vertexattrib.lua');


class Foo {};

lua.global.set('js', {
	global : window,
	// welp looks like wasmoon wraps only some builtin classes (ArrayBuffer) into lambdas to treat them all ONLY AS CTORS so i can't access properties of them, because retarded
	// so I cannot pass them through lua back to js for any kind of operations
	// so all JS operations now have to be abstracted into a new api
	// but we're still passing this back to JS ... wasmoon will probably require its own whole different ffi.lua implementation ... trashy.
	newArrayBuffer : (...args) => new ArrayBuffer(...args),
	newDataView : (...args) => new DataView(...args),
	newUint8Array : (...args) => new Uint8Array(...args),
	newFloat32Array : (...args) => new Float32Array(...args),
	newInt32Array : (...args) => new Int32Array(...args),
	newTextDecoder : (...args) => new TextDecoder(...args),
	dateNow : () => Date.now(),
});
lua.doString(`
xpcall(function()	-- wasmoon has no error handling ... just says "ERROR:ERROR"
	package.path = table.concat({
		'./?.lua',
		'/lua/?.lua',
		'/lua/?/?.lua',
	}, ';')
	dofile'init-jslua-bridge.lua'
end, function(err)
	print(err)
	print(debug.traceback())
end)
`);
//await lua.doFile(`init-jslua-bridge.lua`);
/* */


/* FENGARI ... WHICH WORKS GREAT EXCEPT FOR __gc AND FILESYSTEM SUPPORT * /

const m = await require('./fengari-web.js');
fengari.load(`

js.newArrayBuffer = function(...) return js.new(js.global.ArrayBuffer, ...) end
js.newDataView = function(...) return js.new(js.global.DataView, ...) end
js.newUint8Array = function(...) return js.new(js.global.Uint8Array, ...) end
js.newFloat32Array = function(...) return js.new(js.global.Float32Array, ...) end
js.newInt32Array = function(...) return js.new(js.global.Int32Array, ...) end
js.newTextDecoder = function(...) return js.new(js.global.TextDecoder, ...) end
js.dateNow = function() return js.global.Date.now() end

--print(package.path)	-- ./lua/5.3/?.lua;./lua/5.3/?/init.lua;./?.lua;./?/init.lua
package.path = table.concat({
	'./?.lua',
	'/lua/?.lua',
	'/lua/?/?.lua',
}, ';')

-- fengari doesn't have a fake-filesystem so ...
assert(not package.io)
local io = require 'io'
package.loaded.io = io
_G.io = io

dofile'init-jslua-bridge.lua'
`)();

/* */
