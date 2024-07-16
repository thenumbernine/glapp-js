const urlparams = new URLSearchParams(location.search);
const rundir = urlparams.get('dir') || 'glapp/tests';
const runfile = urlparams.get('file') || 'test_tex.lua';
const runargs = ((args) => {
	return args ? JSON.parse(args) : [];	// assume it's a JS array
})(urlparams.get('args'));
/* progress so far
--run('glapp/tests', 'test_es.lua')				-- WORKS gl objs
--run('glapp/tests', 'test_es2.lua')			-- WORKS only gles calls
--run('glapp/tests', 'test_tex.lua')			-- WORKS only gles calls
--run('rule110', 'rule110.lua')					-- WORKS
--run('line-integral-convolution', 'run.lua')	-- WORKS
--run('n-points', 'run.lua')					-- fails for indexes of type short or int ...
--run('seashell', 'run.lua')					-- needs complex number support
--run('SphericalHarmonicGraph', 'run.lua')		-- needs complex
--run('geographic-charts', 'test.lua')			-- needs complex
--run('glapp/tests', 'test.lua')				-- fails, glmatrixmode
--run('glapp/tests', 'minimal.lua')
--run('glapp/tests', 'pointtest.lua')
--run('glapp/tests', 'info.lua')
--run('prime-spiral', 'run.lua')				-- fails, glColor3f
--run('n-points', 'run_orbit.lua')
--run('sphere-grid', 'run.lua')
--run('metric', 'run.lua')
--run('sand-attack', 'run.lua', 'skipCustomFont', 'gl=OpenGLES3')
*/

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
window.lua = lua;

// i hate javascript
const FS = lua.cmodule.module.FS;

// ok so wasmoon and javascript combined their tardpowers to make image loading at runtime impossible
// this is thanks to wasmoon callbacks being retarded and not allowing async await, and javascript not allowing await in non-async functions (which is retarded)
// so I've got to preload ALL IMAGES just in case they're needed.
const imageCache = {};
const preloadImage = async (fn, ext) => {
	try {
//console.log('preloadImage', fn);
		// why is the world so retarded
		// why can't FS just SIT ON THE BLOB and NOT FUCK WITH IT
		const fileBlob = FS.readFile(fn, {encoding:'binary'});
if (fileBlob.constructor != Uint8Array) throw 'expected Uint8Array';
		// TODO detect mime image type from filename
		const blobUrl = URL.createObjectURL(new Blob([new Uint8Array(fileBlob)], {'type':'image/'+ext}));
		const img = new Image();
		document.body.prepend(img);
		img.style.display = 'none';
		img.src = blobUrl;
		await img.decode();
		const width = img.width;
		const height = img.height;
		const canvas = document.createElement('canvas');
		canvas.style.display = 'none';
		document.body.prepend(canvas);
		canvas.width = width;
		canvas.height = height;
		const ctx = canvas.getContext('2d');
		ctx.drawImage(img, 0, 0);
		const imgData = new Uint8Array(ctx.getImageData(0, 0, width, height).data.buffer);
if (imgData.constructor != Uint8Array) throw 'expected Uint8Array';
		document.body.removeChild(img);
		document.body.removeChild(canvas);
		imageCache[fn] = {
			width : width,
			height : height,
			buffer : imgData,
			channels : 4,	// always?
			format : 'unsigned char',
		};
	} catch (e) {
		console.log('error loading image');
		console.log(fn);
		console.log(e);
	}
};

const fetchBytes = src => {
	return new Promise((resolve, reject) => {
		const req = new XMLHttpRequest();
		req.open('GET', src, true);
		req.responseType = 'arraybuffer';
		req.onload = ev => {
			resolve(new Uint8Array(req.response));
		};
		req.onerror = function () {
			reject({
				status: this.status,
				statusText: req.statusText
			});
		};
		req.send(null);
	});
};

// https://github.com/hellpanderrr/lua-in-browser
const mountFile = (filePath, luaPath) => {
	return fetchBytes(filePath)
	.then((fileContent) => {
		// contents of wasmoon factory.ts BUT WITH BINARY ENCODING FDJLFUICLJFSDFLKJDS:LJFD

		const fileSep = luaPath.lastIndexOf('/');
        const file = luaPath.substring(fileSep + 1);
        const body = luaPath.substring(0, luaPath.length - file.length - 1);

        if (body.length > 0) {
            const parts = body.split('/').reverse();
            let parent = '';

            while (parts.length) {
                const part = parts.pop();
                if (!part) {
                    continue;
                }

                const current = `${parent}/${part}`;
                try {
                    FS.mkdir(current);
                } catch (err) {
                    // ignore EEXIST
                }

                parent = current;
            }
        }

		FS.writeFile(luaPath, fileContent, {encoding:'binary'});

		// and now the images separately, because javascript and wasmoon is retarded
		const ext = luaPath.split('.').pop();
		if (ext == 'png' ||
			ext == 'jpg' ||
			ext == 'jpeg' ||
			ext == 'gif' ||
			ext == 'tiff' ||
			ext == 'bmp'
		) {
			return preloadImage(luaPath, ext);
		}
	});
}

// TODO autogen this remotely ... like i did in lua.vm-util.js.lua
const addDir = (fromPath, toPath, files) =>
	Promise.all(files.map(f => mountFile(fromPath+'/'+f, toPath+'/'+f)));

const addLuaDir = (path, files) => addDir('/lua/' + path, 'lua/' + path, files);

//await mountFile('/lua/bit/bit.lua', 'lua/bit/bit.lua');
// in a smart future, this would be executed upon callback of any filesystem read event to see if the file is there, and wait and load, or cache the failure ...
// and in a smarter future, you'd do a first pass of running the app to capture all associated files to preload ...
// but for now just load everything
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
	addLuaDir('gl', ['arraybuffer.lua', 'attribute.lua', 'buffer.lua', 'call.lua', 'elementarraybuffer.lua', 'fbo.lua', 'geometry.lua', 'get.lua', 'gl.lua', 'gradienttex2d.lua', 'gradienttex.lua', 'hsvtex2d.lua', 'hsvtex.lua', 'intersect.lua', 'kernelprogram.lua', 'pingpong3d.lua', 'pingpong.lua', 'pixelpackbuffer.lua', 'pixelunpackbuffer.lua', 'program.lua', 'report.lua', 'sceneobject.lua', 'setup.lua', 'shader.lua', 'shaderstoragebuffer.lua', 'tex1d.lua', 'tex2d.lua', 'tex3d.lua', 'texbuffer.lua', 'texcube.lua', 'tex.lua', 'types.lua', 'vertexarray.lua']),
	addLuaDir('cl', ['assert.lua', 'assertparam.lua', 'buffer.lua', 'checkerror.lua', 'cl.lua', 'commandqueue.lua', 'context.lua', 'device.lua', 'event.lua', 'getinfo.lua', 'imagegl.lua', 'kernel.lua', 'memory.lua', 'platform.lua', 'program.lua']),
	addLuaDir('cl/obj', ['buffer.lua', 'domain.lua', 'env.lua', 'half.lua', 'kernel.lua', 'number.lua', 'program.lua', 'reduce.lua']),
	addLuaDir('cl/tests', ['cpptest-obj.lua', 'cpptest-standalone.lua', 'getbin.lua', 'info.lua', 'obj.lua', 'obj-multi.lua', 'readme-test.lua', 'reduce.lua', 'test.lua']),
	addLuaDir('image', ['image.lua']),
	addLuaDir('image/luajit', ['bmp.lua', 'fits.lua', 'gif.lua', 'image.lua', 'jpeg.lua', 'loader.lua', 'png.lua', 'tiff.lua']),
	addLuaDir('glapp', ['glapp.lua', 'mouse.lua', 'orbit.lua', 'view.lua']),
	addLuaDir('glapp/tests', ['compute.lua', 'compute-spirv.lua', 'cubemap.lua', 'events.lua', 'info.lua', 'minimal.lua', 'pointtest.lua', 'test_es2.lua', 'test_tex.lua', 'test_es.lua', 'test.lua', 'test_vertexattrib.lua', 'src.png']),
	addLuaDir('imgui', ['imgui.lua']),
	addLuaDir('imguiapp', ['imguiapp.lua', 'withorbit.lua']),
	addLuaDir('line-integral-convolution', ['run.lua']),
	addLuaDir('rule110', ['rule110.lua']),
	addLuaDir('n-points', ['run.lua', 'run_orbit.lua']),
	addLuaDir('seashell', ['eqn.lua', 'run.lua', 'cached-eqns.glsl']),
	addLuaDir('seashell/cloudy', ['bluecloud_bk.jpg', 'bluecloud_dn.jpg', 'bluecloud_ft.jpg', 'bluecloud_lf.jpg', 'bluecloud_rt.jpg', 'bluecloud_up.jpg', 'browncloud_bk.jpg', 'browncloud_dn.jpg', 'browncloud_ft.jpg', 'browncloud_lf.jpg', 'browncloud_rt.jpg', 'browncloud_up.jpg', 'graycloud_bk.jpg', 'graycloud_dn.jpg', 'graycloud_ft.jpg', 'graycloud_lf.jpg', 'graycloud_rt.jpg', 'graycloud_up.jpg', 'yellowcloud_bk.jpg', 'yellowcloud_dn.jpg', 'yellowcloud_ft.jpg', 'yellowcloud_lf.jpg', 'yellowcloud_rt.jpg', 'yellowcloud_up.jpg']),
	addLuaDir('complex', ['complex.lua']),
	addLuaDir('bignumber', ['bignumber.lua', 'test.lua']),
	addLuaDir('symmath', ['abs.lua', 'acosh.lua', 'acos.lua', 'Array.lua', 'asinh.lua', 'asin.lua', 'atan2.lua', 'atanh.lua', 'atan.lua', 'cbrt.lua', 'clone.lua', 'commutativeRemove.lua', 'conj.lua', 'Constant.lua', 'cosh.lua', 'cos.lua', 'Derivative.lua', 'distributeDivision.lua', 'eval.lua', 'expand.lua', 'exp.lua', 'Expression.lua', 'factorDivision.lua', 'factorial.lua', 'factorLinearSystem.lua', 'factor.lua', 'Function.lua', 'hasChild.lua', 'Heaviside.lua', 'Im.lua', 'Integral.lua', 'Invalid.lua', 'Limit.lua', 'log.lua', 'make_README.lua', 'map.lua', 'Matrix.lua', 'multiplicity.lua', 'namespace.lua', 'polyCoeffs.lua', 'polydiv.lua', 'prune.lua', 'Re.lua', 'replace.lua', 'setup.lua', 'simplify.lua', 'sinh.lua', 'sin.lua', 'solve.lua', 'sqrt.lua', 'Sum.lua', 'symmath.lua', 'tableCommutativeEqual.lua', 'tanh.lua', 'tan.lua', 'taylor.lua', 'Tensor.lua', 'tidy.lua', 'TotalDerivative.lua', 'UserFunction.lua', 'Variable.lua', 'Vector.lua', 'Wildcard.lua']),
	addLuaDir('symmath/export', ['C.lua', 'Console.lua', 'Export.lua', 'GnuPlot.lua', 'JavaScript.lua', 'Language.lua', 'LaTeX.lua', 'Lua.lua', 'Mathematica.lua', 'MathJax.lua', 'MultiLine.lua', 'SingleLine.lua', 'SymMath.lua', 'Verbose.lua']),
	addLuaDir('symmath/matrix', ['determinant.lua', 'diagonal.lua', 'eigen.lua', 'EulerAngles.lua', 'exp.lua', 'hermitian.lua', 'identity.lua', 'inverse.lua', 'nullspace.lua', 'pseudoInverse.lua', 'Rotation.lua', 'trace.lua', 'transpose.lua']),
	addLuaDir('symmath/op', ['add.lua', 'approx.lua', 'Binary.lua', 'div.lua', 'eq.lua', 'Equation.lua', 'ge.lua', 'gt.lua', 'le.lua', 'lt.lua', 'mod.lua', 'mul.lua', 'ne.lua', 'pow.lua', 'sub.lua', 'unm.lua']),
	addLuaDir('symmath/physics', ['diffgeom.lua', 'Faraday.lua', 'MatrixBasis.lua', 'StressEnergy.lua', 'units.lua']),
	addLuaDir('symmath/set', ['Complex.lua', 'EvenInteger.lua', 'Integer.lua', 'Natural.lua', 'Null.lua', 'OddInteger.lua', 'RealInterval.lua', 'RealSubset.lua', 'Set.lua', 'sets.lua', 'Universal.lua']),
	addLuaDir('symmath/tensor', ['Chart.lua', 'DenseCache.lua', 'dual.lua', 'Index.lua', 'KronecherDelta.lua', 'LeviCivita.lua', 'Manifold.lua', 'Ref.lua', 'symbols.lua', 'wedge.lua']),
	addLuaDir('symmath/visitor', ['DistributeDivision.lua', 'Expand.lua', 'ExpandPolynomial.lua', 'FactorDivision.lua', 'Factor.lua', 'Prune.lua', 'Tidy.lua', 'Visitor.lua']),
]).catch(e => { throw e; });

lua.global.set('js', {
	global : window,	//for fengari compat
	// welp looks like wasmoon wraps only some builtin classes (ArrayBuffer) into lambdas to treat them all ONLY AS CTORS so i can't access properties of them, because retarded
	// so I cannot pass them through lua back to js for any kind of operations
	// so all JS operations now have to be abstracted into a new api
	// but we're still passing this back to JS ... wasmoon will probably require its own whole different ffi.lua implementation ... trashy.
	newnamed : (cl, ...args) => new window[cl](...args),
	dateNow : () => Date.now(),
	loadImage : fn => {
		if (fn.substr(0,1) != '/') fn = FS.cwd() + '/' + fn;
console.log('loadImage', fn);
		if (fn.substr(0,1) == '/') fn = fn.substr(1);
		const img = imageCache[fn];
		if (!img) throw "you need to decode up front file "+fn;
		return img;
	},

	fixYourShitWASMOON : (gl) => {
		// these calls didn't work from within Lua, but they work fine here.
		gl.getExtension('OES_element_index_uint');
		gl.getExtension('OES_standard_derivatives');
		gl.getExtension('OES_texture_float');	//needed for webgl framebuffer+rgba32f
		gl.getExtension('OES_texture_float_linear');
		gl.getExtension('EXT_color_buffer_float');	//needed for webgl2 framebuffer+rgba32f
	},
});

// ofc you can't push extra args into the call, i guess you only can via global assignments?
FS.chdir('/lua/'+rundir);
lua.doString(`
xpcall(function()	-- wasmoon has no error handling ... just says "ERROR:ERROR"
	assert(loadfile'/init-jslua-bridge.lua')(
		`+[rundir, runfile]
			.concat(runargs).map(arg => '"'+arg+'"')
			.join(', ')
		+`
	)
end, function(err)
	print(err)
	print(debug.traceback())
end)`);
//await lua.doFile(`init-jslua-bridge.lua`);
/* */


/* FENGARI ... WHICH WORKS GREAT EXCEPT FOR __gc AND FILESYSTEM SUPPORT * /

const m = await require('./fengari-web.js');

// TODO can I do this in js instead of in lua?  then I could just copy from above
fengari.load(`
js.newnamed = function(cl, ...) return js.new(js.global[cl], ...) end
js.dateNow = function() return js.global.Date.now() end

-- fengari doesn't have a fake-filesystem so ...
assert(not package.io)
local io = require 'io'
package.loaded.io = io
_G.io = io
xpcall(function()
	dofile'init-jslua-bridge.lua'
end, function(err)
	print(err)
	print(debug.traceback())
end)
`)();

/* */
