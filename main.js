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
const mountFile = (file_path, lua_path) => 
	fetch(file_path)
	.then(data => data.text())
	.then(fileContent => {
//console.log('mountFile', file_path, lua_path);
		return factory.mountFile(lua_path, fileContent);
	});

// TODO autogen this remotely ... like i did in lua.vm-util.js.lua
const addDir = (fromPath, toPath, files) =>
	Promise.all(files.map(f => mountFile(fromPath+'/'+f, toPath+'/'+f)));

const addLuaDir = (path, files) => addDir('/lua/' + path, 'lua/' + path, files);

//await mountFile('/lua/bit/bit.lua', 'lua/bit/bit.lua');
await Promise.all([
	addDir('.', '.', ['ffi.lua', 'init-jslua-bridge.lua']),
	addDir('ffi', 'ffi', ['EGL.lua', 'OpenGL.lua', 'OpenGLES3.lua', 'cimgui.lua', 'req.lua', 'sdl.lua']),
	addDir('ffi/c', 'ffi/c', ['errno.lua', 'stdlib.lua', 'string.lua']),
	addDir('ffi/c/sys', 'ffi/c/sys', ['time.lua']),
	addDir('ffi/cpp', 'ffi/cpp', ['vector-lua.lua', 'vector.lua']),
	addDir('ffi/gcwrapper', 'ffi/gcwrapper', ['gcwrapper.lua']),
	
	addLuaDir('bit', ['bit.lua']),
	addLuaDir('template', ['output.lua', 'showcode.lua', 'template.lua']),
	addLuaDir('ext', ['assert.lua', 'class.lua', 'cmdline.lua', 'coroutine.lua', 'ctypes.lua', 'debug.lua', 'detect_ffi.lua', 'detect_lfs.lua', 'detect_os.lua', 'env.lua', 'ext.lua', 'fromlua.lua', 'gcmem.lua', 'io.lua', 'load.lua', 'math.lua', 'meta.lua', 'number.lua', 'op.lua', 'os.lua', 'path.lua', 'range.lua', 'reload.lua', 'require.lua', 'string.lua', 'table.lua', 'timer.lua', 'tolua.lua', 'xpcall.lua']),
	addLuaDir('struct', ['struct.lua', 'test.lua']),
	addLuaDir('vec-ffi', ['box2f.lua', 'box2i.lua', 'box3f.lua', 'create_box.lua', 'create_plane.lua', 'create_quat.lua', 'create_vec2.lua', 'create_vec3.lua', 'create_vec.lua', 'plane2f.lua', 'plane3f.lua', 'quatd.lua', 'quatf.lua', 'suffix.lua', 'vec2b.lua', 'vec2d.lua', 'vec2f.lua', 'vec2i.lua', 'vec2s.lua', 'vec2sz.lua', 'vec2ub.lua', 'vec3b.lua', 'vec3d.lua', 'vec3f.lua', 'vec3i.lua', 'vec3s.lua', 'vec3sz.lua', 'vec3ub.lua', 'vec4b.lua', 'vec4d.lua', 'vec4f.lua', 'vec4i.lua', 'vec4ub.lua', 'vec-ffi.lua']),
	addLuaDir('matrix', ['curl.lua', 'determinant.lua', 'div.lua', 'ffi.lua', 'grad.lua', 'helmholtzinv.lua', 'index.lua', 'inverse.lua', 'lapinv.lua', 'matrix.lua']),
	addLuaDir('gl', ['arraybuffer.lua', 'attribute.lua', 'buffer.lua', 'call.lua', 'elementarraybuffer.lua', 'fbo.lua', 'geometry.lua', 'get.lua', 'gl.lua', 'gradienttex2d.lua', 'gradienttex.lua', 'hsvtex2d.lua', 'hsvtex.lua', 'intersect.lua', 'kernelprogram.lua', 'pingpong3d.lua', 'pingpong.lua', 'pixelpackbuffer.lua', 'pixelunpackbuffer.lua', 'program.lua', 'report.lua', 'sceneobject.lua', 'setup.lua', 'shader.lua', 'shaderstoragebuffer.lua', 'tex1d.lua', 'tex2d.lua', 'tex3d.lua', 'texbuffer.lua', 'texcube.lua', 'tex.lua', 'vertexarray.lua']),
	addLuaDir('cl', ['assert.lua', 'assertparam.lua', 'buffer.lua', 'checkerror.lua', 'cl.lua', 'commandqueue.lua', 'context.lua', 'device.lua', 'event.lua', 'getinfo.lua', 'imagegl.lua', 'kernel.lua', 'memory.lua', 'platform.lua', 'program.lua']),
	addLuaDir('cl/obj', ['buffer.lua', 'domain.lua', 'env.lua', 'half.lua', 'kernel.lua', 'number.lua', 'program.lua', 'reduce.lua']),
	addLuaDir('cl/tests', ['cpptest-obj.lua', 'cpptest-standalone.lua', 'getbin.lua', 'info.lua', 'obj.lua', 'obj-multi.lua', 'readme-test.lua', 'reduce.lua', 'test.lua']),
	addLuaDir('image', ['image.lua']),
	addLuaDir('image/luajit', ['bmp.lua', 'fits.lua', 'gif.lua', 'image.lua', 'jpeg.lua', 'loader.lua', 'png.lua', 'tiff.lua']),
	addLuaDir('glapp', ['glapp.lua', 'mouse.lua', 'orbit.lua', 'view.lua']),
	addLuaDir('glapp/tests', ['compute.lua', 'compute-spirv.lua', 'cubemap.lua', 'events.lua', 'info.lua', 'minimal.lua', 'pointtest.lua', 'test_es2.lua', 'test_es.lua', 'test.lua', 'test_vertexattrib.lua', 'compute-spirv.clcpp', 'src.png']),
	addLuaDir('imgui', ['imgui.lua']),
	addLuaDir('imguiapp', ['imguiapp.lua', 'withorbit.lua']),
	addLuaDir('line-integral-convolution', ['run.lua']),
]).catch(e => { throw e; });

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
