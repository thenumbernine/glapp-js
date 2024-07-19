const urlparams = new URLSearchParams(location.search);

let rundir = urlparams.get('dir');
let runfile = urlparams.get('file');

let runargs = ((args) => {
	return args ? JSON.parse(args) : [];	// assume it's a JS array
})(urlparams.get('args'));

let editmode = urlparams.get('edit');
if (!runfile || !rundir) {
	rundir = 'glapp/tests';
	runfile = 'test_tex.lua';
	editmode = true;
}
if (rundir) {
	if (rundir.substr(0, 1) != '/') rundir = '/' + rundir;
	if (rundir.substr(-1) == '/') rundir = rundir.substr(0, rundir.length-1);
}
/* progress so far
--rundir='glapp/tests'; runfile='test_es.lua';				-- WORKS README
--rundir='glapp/tests'; runfile='test_es2.lua';				-- WORKS README
--rundir='glapp/tests'; runfile='test_tex.lua';				-- WORKS README
--rundir='glapp/tests'; runfile='test.lua';					-- fails, glmatrixmode
--rundir='glapp/tests'; runfile='minimal.lua';
--rundir='glapp/tests'; runfile='pointtest.lua';
--rundir='glapp/tests'; runfile='info.lua';
--rundir='line-integral-convolution'; runfile='run.lua';	-- welp this was working for a good long while until I started adding imgui stuff ... now it's not working anymore ... 
--rundir='rule110'; runfile='rule110.lua';					-- WORKS README but imgui
--rundir='fibonacci-modulo'; runfile='run.lua';				-- WORKS README but imgui
--rundir='n-points'; runfile='run.lua';						-- WORKS README but imgui
--rundir='n-points'; runfile='run_orbit.lua';				-- todo ... or not, it's kinda dumb i guess
--rundir='geographic-charts'; runfile='test.lua';			-- WORKS README but indexed geometry could help it
--rundir='prime-spiral'; runfile='run.lua';					-- WORKS README but needs tracking shift for key events for it to work ...
--rundir='lambda-cdm'; runfile='run.lua';					-- WORKS README but imgui
--rundir='seashell'; runfile='run.lua';						-- very slow (didn't finish)
--rundir='SphericalHarmonicGraphs'; runfile='run.lua';		-- very slow (didn't finish)
--rundir='metric'; runfile='run.lua';
--rundir='sand-attack'; runfile='run.lua'; runargs=["skipCustomFont","config=nil"]		-- dir() is failing ... hmm
--rundir='surface-from-connection'; runfile='run.lua';		-- needs to be glsl-remade
TODO mesh viewer
TODO chess on manifold
TODO chompman
TODO tetris-attack
TODO dumpworld/zeta2d
TODO farmgame
TODO imgui library <-> html shim layer
TODO hydro-cl
TODO zeta3d / zetatron 3d metroidvania voxel
TODO nbody-gpu
TODO waves-in-curved space ... ?
TODO celestial-gravitomagnetics ... ?
TODO seismograph-stations ... ?
TODO earth-magnetic-field ... ?
TODO gravitational-waves
TODO hydro-cl
TODO cdfmesh
TODO VectorFieldDecomposition ... ?
TODO geo-center-earth ... ?
TODO asteroids3d
TODO tacticslua
TODO inspiration engine
TODO ... solarsystem graph ... takes GBs of data ...
--rundir='sphere-grid'; runfile='run.lua';
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
const factory = new wasmoon.LuaFactory();
window.factory = factory;
const lua = await factory.createEngine({
	// looks like this is true by default, and if it's false then i get the same error within js instead of within lua ...
	// was this what was screwing up my ability to allocate ArrayBuffer from within the Lua code? gah...
	// disabling this does lose me my Lua call stack upon getting that same error...
	//enableProxy:false,//true,
	//insertObjects:true,
	//traceAllocations:true,
});
window.lua = lua;

// i hate javascript
// can I get FS without getting lua?  would be nice to reset the Lua state without destroying the filesystem ...
const FS = lua.cmodule.module.FS;
window.FS = FS;

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
// or TODO autogen this from lua rockspec file
const addFromToDir = (fromPath, toPath, files) =>
	Promise.all(files.map(f => mountFile(fromPath+'/'+f, toPath+'/'+f)));

const addLuaDir = (path, files) => addFromToDir('/lua/'+path, path, files);

//await mountFile('/bit/bit.lua', 'bit/bit.lua');
// in a smart future, this would be executed upon callback of any filesystem read event to see if the file is there, and wait and load, or cache the failure ...
// and in a smarter future, you'd do a first pass of running the app to capture all associated files to preload ...
// but for now just load everything
await Promise.all([
	addFromToDir('.', '.', ['ffi.lua', 'init-jslua-bridge.lua']),
	addFromToDir('ffi', 'ffi', ['EGL.lua', 'OpenGL.lua', 'OpenGLES3.lua', 'cimgui.lua', 'req.lua', 'sdl.lua']),
	addFromToDir('ffi/c', 'ffi/c', ['errno.lua', 'stdlib.lua', 'string.lua']),
	addFromToDir('ffi/c/sys', 'ffi/c/sys', ['time.lua']),
	addFromToDir('ffi/cpp', 'ffi/cpp', ['vector-lua.lua', 'vector.lua']),
	addFromToDir('ffi/gcwrapper', 'ffi/gcwrapper', ['gcwrapper.lua']),

	addLuaDir('bit', ['bit.lua']),
	addLuaDir('template', ['output.lua', 'showcode.lua', 'template.lua']),
	addLuaDir('ext', ['assert.lua', 'class.lua', 'cmdline.lua', 'coroutine.lua', 'ctypes.lua', 'debug.lua', 'detect_ffi.lua', 'detect_lfs.lua', 'detect_os.lua', 'env.lua', 'ext.lua', 'fromlua.lua', 'gcmem.lua', 'io.lua', 'load.lua', 'math.lua', 'meta.lua', 'number.lua', 'op.lua', 'os.lua', 'path.lua', 'range.lua', 'reload.lua', 'require.lua', 'string.lua', 'table.lua', 'timer.lua', 'tolua.lua', 'xpcall.lua']),
	addLuaDir('struct', ['struct.lua', 'test.lua']),
	addLuaDir('modules', ['module.lua', 'modules.lua']),
	addLuaDir('vec-ffi', ['box2f.lua', 'box2i.lua', 'box3f.lua', 'create_box.lua', 'create_plane.lua', 'create_quat.lua', 'create_vec2.lua', 'create_vec3.lua', 'create_vec.lua', 'plane2f.lua', 'plane3f.lua', 'quatd.lua', 'quatf.lua', 'suffix.lua', 'vec2b.lua', 'vec2d.lua', 'vec2f.lua', 'vec2i.lua', 'vec2s.lua', 'vec2sz.lua', 'vec2ub.lua', 'vec3b.lua', 'vec3d.lua', 'vec3f.lua', 'vec3i.lua', 'vec3s.lua', 'vec3sz.lua', 'vec3ub.lua', 'vec4b.lua', 'vec4d.lua', 'vec4f.lua', 'vec4i.lua', 'vec4ub.lua', 'vec-ffi.lua']),
	addLuaDir('matrix', ['curl.lua', 'determinant.lua', 'div.lua', 'ffi.lua', 'grad.lua', 'helmholtzinv.lua', 'index.lua', 'inverse.lua', 'lapinv.lua', 'matrix.lua']),
	addLuaDir('gl', ['arraybuffer.lua', 'attribute.lua', 'buffer.lua', 'call.lua', 'elementarraybuffer.lua', 'fbo.lua', 'geometry.lua', 'get.lua', 'gl.lua', 'gradienttex2d.lua', 'gradienttex.lua', 'hsvtex2d.lua', 'hsvtex.lua', 'intersect.lua', 'kernelprogram.lua', 'pingpong3d.lua', 'pingpong.lua', 'pixelpackbuffer.lua', 'pixelunpackbuffer.lua', 'program.lua', 'report.lua', 'sceneobject.lua', 'setup.lua', 'shader.lua', 'shaderstoragebuffer.lua', 'tex1d.lua', 'tex2d.lua', 'tex3d.lua', 'texbuffer.lua', 'texcube.lua', 'tex.lua', 'types.lua', 'vertexarray.lua']),
	addLuaDir('cl', ['assert.lua', 'assertparam.lua', 'buffer.lua', 'checkerror.lua', 'cl.lua', 'commandqueue.lua', 'context.lua', 'device.lua', 'event.lua', 'getinfo.lua', 'imagegl.lua', 'kernel.lua', 'memory.lua', 'platform.lua', 'program.lua']),
	addLuaDir('cl/obj', ['buffer.lua', 'domain.lua', 'env.lua', 'half.lua', 'kernel.lua', 'number.lua', 'program.lua', 'reduce.lua']),
	addLuaDir('cl/tests', ['cpptest-obj.lua', 'cpptest-standalone.lua', 'getbin.lua', 'info.lua', 'obj.lua', 'obj-multi.lua', 'readme-test.lua', 'reduce.lua', 'test.lua']),
	addLuaDir('image', ['image.lua']),
	addLuaDir('image/luajit', ['bmp.lua', 'fits.lua', 'gif.lua', 'image.lua', 'jpeg.lua', 'loader.lua', 'png.lua', 'tiff.lua']),
	addLuaDir('audio', ['audio.lua', 'buffer.lua', 'currentsystem.lua', 'source.lua']),
	addLuaDir('audio/null', ['audio.lua', 'buffer.lua', 'source.lua']),
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
	addLuaDir('geographic-charts', ['code.lua', 'geographic-charts.lua', 'test.lua', 'earth-color.png']),
	addLuaDir('prime-spiral', ['run.lua', 'pi']),
	addLuaDir('fibonacci-modulo', ['run.lua', 'fibonacci.lua']),
	addLuaDir('lambda-cdm', ['bisect.lua', 'run.lua']),
	addLuaDir('surface-from-connection', ['run.lua']),
	addLuaDir('SphericalHarmonicGraphs', ['associatedlegendre.lua', 'factorial.lua', 'plot_associatedlegendre.lua', 'run.lua', 'sphericalharmonics.lua']),
	addLuaDir('sand-attack', ['app.lua', 'player.lua', 'run.lua', 'serialize.lua', 'splash.demo']), // isn't in the repo: 'config.lua'
	addLuaDir('sand-attack/font', ['Billow twirl Demo.ttf', 'Billow twirl Demo.url']),
	addLuaDir('sand-attack/menu', ['config.lua', 'highscore.lua', 'main.lua', 'menu.lua', 'newgame.lua', 'playerkeys.lua', 'playing.lua', 'splashscreen.lua']),
	//addLuaDir('sand-attack/music', ['Desert-City.ogg', 'Exotic-Plains.ogg', 'Ibn-Al-Noor.ogg', 'Market_Day.ogg', 'Return-of-the-Mummy.ogg', 'temple-of-endless-sands.ogg', 'wombat-noises-audio-the-legend-of-narmer.ogg'),
	addLuaDir('sand-attack/sandmodel', ['all.lua', 'automatacpu.lua', 'automatagpu.lua', 'cfd.lua', 'sandmodel.lua', 'sph.lua']),
	addLuaDir('sand-attack/sfx', ['levelup.url', 'levelup.wav', 'line.url', 'line.wav', 'place.url', 'place.wav']),
	addLuaDir('sand-attack/tex', ['splash.png', 'youlose.png']),
	//addLuaDir('sand-attack/highscores', ['2024-06-21-22-05-44.demo']),	// ... isn't in the repo ... interesting, mkdir didn't seem to work ... also interesting making an empty dir ?
]).catch(e => { throw e; });
// why is this here when it's not down there in FS.readdir'/' ?
//console.log('glapp', FS.stat('/glapp'));

const editButton = document.createElement('button');
editButton.innerText = '+';
editButton.style.position = 'absolute';
editButton.style.top = '0px';
editButton.style.right = '0px';
editButton.style.background = 'Transparent';
editButton.style.outline = 'none';
editButton.style.color = '#ffffff';
editButton.addEventListener('click', e => {
	editmode = !editmode;
	resize();	// refresh size
});
document.body.appendChild(editButton);

// imgui binding code.
// i wanted to do this in lua but wasmoon disagrees.
const imgui = {
	init : function() {
		// TODO make sure this.div is attached too? or trust it's not tampered with ...
		this.div = document.createElement('div');
		this.div.style.position = 'absolute';
		this.div.style.left = '0px';
		this.div.style.top = '0px';
		this.div.style.backgroundColor = '#000000';
		this.div.style.opacity = .8;
		this.div.style.border = '1px solid #5f5f5f';
		this.div.style.padding = '3px';
		this.div.style.borderRadius = '7px';
		document.body.appendChild(this.div);
	},
	clear : function() {
		for (let i = this.div.children.length-1; i >= 0; --i) {
			const ch = this.div.children[i];
			this.div.removeChild(ch);
		}
	},
	newFrame : function() {
		//clear all taggedThisFrame
		for (let i = this.div.children.length-1; i >= 0; --i) {
			const ch = this.div.children[i];
			ch.taggedThisFrame = false;
		}
		this.lastTouchedDom = null;
	},
	render : function() {
		//remove old dom elements that didn't get tagged
		for (let i = this.div.children.length-1; i >= 0; --i) {
			const ch = this.div.children[i];
			if (!ch.taggedThisFrame) {
				this.div.removeChild(ch);
			}
		}
	},
	create : function(idsuffix, tag, createCB) {
		// TODO maybe I should be using order of creation instead of text names?
		const id = 'imgui_'+idsuffix; // ... plus id stack
		let dom = document.getElementById(id);
		if (dom) {
			// TODO and make sure the dom tag is correct
			dom.taggedThisFrame = true;
			this.lastTouchedDom = dom;
			return dom;
		}
		dom = document.createElement(tag);
		dom.id = id;
		if (!this.div) throw "imgui.create called before imgui.newFrame...";
		if (this.lastTouchedDom && this.lastTouchedDom.nextSibling) {
			this.div.insertBefore(dom, this.lastTouchedDom.nextSibling);
		} else {
			this.div.appendChild(dom);
		}
		if (createCB) createCB(dom);
		dom.taggedThisFrame = true;
		this.lastTouchedDom = dom;
		return dom;
	},

	text : function(fmt) {
		this.create(fmt, 'div', text => {
			text.innerText = fmt;
		});
	},

	button : function(label, size) {
		const button = this.create(label, 'button', button => {
			button.innerText = label;
			button.style.display = 'block';
			button.addEventListener('click', e => {
				button.imguiClicked = true;
			});
		});
		const clicked = button.imguiClicked;
		button.imguiClicked = false;
		return clicked;
	},
	inputFloat : function(label, v, v_min, v_max, format, flags) {
		this.create(label, 'span', span => {
			span.innerText = label;
			span.style.paddingRight = '20px';
		});
		// TODO use id stack instead of label, or something, idk
		const input = this.create(label+'_value', 'input', input => {
			input.value = v[0];
		});
		// TODO upon creation set this, then monitor its changes and return' true' if found
		let changed = false;
		// TODO this will probably trigger 'change' upon first write/read, or even a few, thanks to string<->float
		const iv = parseFloat(input.value)
		if (v[0] !== iv) {
			v[0] = iv;
			changed = true;
		}
		this.create(label+'_bf', 'br');
		return changed;
	},
	inputInt : function(label, v, v_min, v_max, format, flags) {
		this.create(label, 'span', span => {
			span.innerText = label;
			span.style.paddingRight = '20px';
		});
		// TODO use id stack instead of label, or something, idk
		const input = this.create(label+'_value', 'input', input => {
			input.value = v[0];
		});
		// TODO upon creation set this, then monitor its changes and return' true' if found
		let changed = false;
		// TODO this will probably trigger 'change' upon first write/read, or even a few, thanks to string<->float
		const iv = parseInt(input.value)
		if (v[0] !== iv) {
			v[0] = iv;
			changed = true;
		}
		this.create(label+'_bf', 'br');
		return changed;
	},

};

// resize uses this too
let fsDiv;
let taDiv;
let titleBarDiv;
let outDiv;
let outTextArea;
// store as pixel <=> smoother scrolling when resizing divider, store as fraction <=> smoother when resizing window ... shrug
let fsFrac = .25;
let taFrac = .5;
let outFrac = .5;

//let editorTextArea;
let aceEditor;
let editorPath;
let editorFileNameSpan;
let editorSaveButton;
const editorSave = () => {
	FS.writeFile(editorPath, new TextEncoder().encode(
		//editorTextArea.value
		aceEditor.getValue()
	), {encoding:'binary'});
	editorSaveButton.setAttribute('disabled', 'disabled');
};
const editorLoad = () => {
	const fileStr = new TextDecoder().decode(FS.readFile(editorPath, {encoding:'binary'}));
	//editorTextArea.value = fileStr;
	aceEditor.setValue(fileStr);
	aceEditor.clearSelection();
};

const fileInfoForPath = {};
let openedFileInfo;
const setEditorFilePath = path => {
	if (openedFileInfo) {
		openedFileInfo.title.style.backgroundColor = '#000000';	//reset
	}
	openedFileInfo = fileInfoForPath[path];
	if (openedFileInfo) {
		openedFileInfo.title.style.backgroundColor = '#003f7f';							//select
	}

	if (editorPath) {
		editorSave();
	}

	editorPath = path;
	editorFileNameSpan.innerText = editorPath;
	editorLoad();
};

{	// add an edit button
	imgui.init();	// make the imgui div

	fsDiv = document.createElement('div');
	fsDiv.style.position = 'absolute';
	fsDiv.style.display = 'none';
	fsDiv.style.zIndex = -1;	//under imgui div
	fsDiv.style.backgroundColor = '#000000';
	fsDiv.style.color = '#ffffff';
	document.body.appendChild(fsDiv);

	const makeFileDiv = (path, name) => {
		//FS.chdir(path);
		const filediv = document.createElement('div');
		filediv.style.border = '1px solid #5f5f5f';
		filediv.style.borderRadius = '7px';
		filediv.style.padding = '3px';
		const title = document.createElement('div');
		filediv.appendChild(title);
		const stat = FS.lstat(path);
		if (stat.mode & 0x4000) {
			const chdiv = document.createElement('div');
			chdiv.style.marginLeft = '16px';
			chdiv.style.display = path == '/' ? 'block'
				: (rundir+'/').substr(0, (path+'/').length) == (path+'/') ? 'block' : 'none';
			filediv.appendChild(chdiv);
			name = name.substr(0,1) == '/' ? name : '/' + name;
			try {
//console.log('readdir', path);
				if (path != '/dev' && path != '/proc') {	//giving exceptions from accessing them
					const fs = FS.readdir(path);
					fs.sort();
					fs.forEach(f => {
						if (f != '.' && f != '..') {
							let chpath = path.substr(-1) == '/' ? path + f : path + '/' + f;
//console.log('got file', chpath);
							chdiv.appendChild(makeFileDiv(chpath, f));
						}
					});
				}
			} catch (e) {
				console.log('for path '+path+' thought it was a dir '+stat.mode.toString(16)+' but it wasnt: '+e);
			}
			title.style.cursor = 'pointer';
			title.addEventListener('click', e => {
				if (chdiv.style.display == 'none') {
					chdiv.style.display = 'block';
				} else {
					chdiv.style.display = 'none';
				}
			});
		} else {
			title.style.cursor = 'pointer';
			title.addEventListener('click', e => {
				setEditorFilePath(path);
			});
		}
		title.innerText = name;
		fileInfoForPath[path] = {
			div : filediv,
			title : title,
		};
		return filediv;
	};
	FS.chdir('/');
	fsDiv.appendChild(makeFileDiv('/', '/'));
	FS.chdir('/');

	taDiv = document.createElement('div');
	taDiv.id = 'taDiv';
	taDiv.style.position = 'absolute';
	taDiv.style.display = 'none';
	//taDiv.style.overflow = 'hidden';
	taDiv.style.zIndex = -1;	//under imgui div
	document.body.appendChild(taDiv);

	titleBarDiv = document.createElement('div');
	titleBarDiv.style.height = '1em';
	titleBarDiv.style.position = 'absolute';
	titleBarDiv.style.display = 'none';
	document.body.appendChild(titleBarDiv);

	const run = document.createElement('button');
	run.innerText = 'run';
	run.addEventListener('click', e => {
		editorSave();
		// run it
		const parts = editorPath.split('/');
		runfile = parts.pop();
		rundir = parts.join('/');
		runargs = [];	//TODO somewhere ...
		doRun();
	});
	titleBarDiv.appendChild(run);

	// TODO grey out upon textarea change?
	editorSaveButton = document.createElement('button');
	editorSaveButton.innerText = 'save';
	editorSaveButton.setAttribute('disabled', 'disabled');
	editorSaveButton.addEventListener('click', e => editorSave);
	titleBarDiv.appendChild(editorSaveButton);

	const editorLoadButton = document.createElement('button');
	editorLoadButton.innerText = 'load';
	editorLoadButton.addEventListener('click', e => { editorLoad(); });
	titleBarDiv.appendChild(editorLoadButton);

	editorFileNameSpan = document.createElement('span');
	titleBarDiv.appendChild(editorFileNameSpan);

	// TODO line numbers?
	/*
	editorTextArea = document.createElement('textarea');
	editorTextArea.style.backgroundColor = '#000000';
	editorTextArea.style.color = '#ffffff';
	editorTextArea.style.width = '100%';
	editorTextArea.style.height = '100%';
	editorTextArea.style.tabSize = 4;
	editorTextArea.style.MozTabSize = 4;
	editorTextArea.style.OTabSize = 4;
	editorTextArea.style.whiteSpace = 'pre';
	editorTextArea.style.overflowWrap = 'normal';
	editorTextArea.style.overflow = 'scroll';
	editorTextArea.addEventListener('input', e => {
		editorSaveButton.removeAttribute('disabled');
	});
	taDiv.appendChild(editorTextArea);
	*/	
    /* ace editor: https://github.com/ajaxorg/ace */
	aceEditor = ace.edit("taDiv");
	aceEditor.setTheme("ace/theme/tomorrow_night_bright");
	const LuaMode = ace.require("ace/mode/lua").Mode;
	aceEditor.session.setMode(new LuaMode());
	/* */

	outDiv = document.createElement('div');
	outDiv.style.position = 'absolute';
	outDiv.style.display = 'none';
	outDiv.style.zIndex = -1;	//under imgui div
	document.body.appendChild(outDiv);

	outTextArea = document.createElement('textarea');
	outTextArea.readOnly = true;
	outTextArea.style.backgroundColor = '#000000';
	outTextArea.style.color = '#ffffff';
	outTextArea.style.width = '100%';
	outTextArea.style.height = '100%';
	outTextArea.style.tabSize = 4;
	outTextArea.style.MozTabSize = 4;
	outTextArea.style.OTabSize = 4;
	outTextArea.style.whiteSpace = 'pre';
	outTextArea.style.overflowWrap = 'normal';
	outTextArea.style.overflow = 'auto';
	outDiv.appendChild(outTextArea);
}
window.imgui = imgui;
if (rundir && runfile) {
	setEditorFilePath(rundir+'/'+runfile);
}

document.body.style.overflow = 'hidden';	//slowly sorting this out ...
let canvas;
const resize = e => {
	const w = window.innerWidth;
	const h = window.innerHeight;
	if (editmode) {
		fsDiv.style.display = 'block';
		fsDiv.style.left = '0px';
		fsDiv.style.top = '0px';
		fsDiv.style.width = (fsFrac * w) + 'px';
		fsDiv.style.height = h + 'px';
		fsDiv.style.overflow = 'auto';
		// TODO resize bar / save ratio

		titleBarDiv.style.display = 'block';
		titleBarDiv.style.display = 'block';
		titleBarDiv.style.left = (fsFrac * w) + 'px';
		titleBarDiv.style.top = '0px';
		titleBarDiv.style.width = (taFrac * w) + 'px';
		titleBarDiv.style.height = '20px';

		taDiv.style.display = 'block';
		taDiv.style.left = (fsFrac * w) + 'px';
		taDiv.style.top = '20px';
		taDiv.style.width = (taFrac * w) + 'px';
		taDiv.style.height = (h - 20) + 'px';
		
		if (canvas) {
			canvas.style.left = ((fsFrac + taFrac) * w) + 'px';
			canvas.style.top = '0px';
			canvas.width = ((1 - fsFrac - taFrac) * w);
			canvas.height = (outFrac * h);
		}

		outDiv.style.display = 'block';
		outDiv.style.left = ((fsFrac + taFrac) * w) + 'px';
		outDiv.style.width = ((1 - fsFrac - taFrac) * w) + 'px';
		outDiv.style.top = (outFrac * h) + 'px';
		outDiv.style.height = ((1 - outFrac) * h) + 'px';
	} else {		// fullscreen
		fsDiv.style.display = 'none';
		taDiv.style.display = 'none';
		titleBarDiv.style.display = 'none';
		outDiv.style.display = 'none';
		if (canvas) {
			canvas.style.left = '0px';
			canvas.style.top = '0px';
			canvas.width = w;
			canvas.height = h;
		}
	}
};
resize();	//initialize fs and codetextarea
window.addEventListener('resize', resize);

let gl;
lua.global.set('js', {
	global : window,	//for fengari compat
	// welp looks like wasmoon wraps only some builtin classes (ArrayBuffer) into lambdas to treat them all ONLY AS CTORS so i can't access properties of them, because retarded
	// so I cannot pass them through lua back to js for any kind of operations
	// so all JS operations now have to be abstracted into a new api
	// but we're still passing this back to JS ... wasmoon will probably require its own whole different ffi.lua implementation ... trashy.
	newnamed : (cl, ...args) => new window[cl](...args),
	dateNow : () => Date.now(),
	loadImage : fn => {
		if (fn.substr(0,1) != '/') {
			fn = FS.cwd() + '/' + fn;
			if (fn.substr(0,1) == '/') fn = fn.substr(1);
		}
		const img = imageCache[fn];
		if (!img) throw "you need to decode up front file "+fn;
		return img;
	},

	createCanvas : () => {
		if (canvas) document.body.removeChild(canvas);

		canvas = document.createElement('canvas');
		canvas.style.position = 'absolute';
		canvas.style.userSelect = 'none';
		document.body.prepend(canvas);
		window.canvas = canvas;			// global?  do I really need it? debugging?

		resize();	// set our initial size

		return canvas;
	},

	// these functions should have been easy to do in lua ...
	// ... but wasmoon has some kind of lua-syntax within some internally run code for wrappers to js objects ... bleh
	jsglInit : (gl_) => {
		if (gl) {
			const WEBGL_lose_context = gl.getExtension('WEBGL_lose_context');
			if (WEBGL_lose_context) WEBGL_lose_context.loseContext();
		}
		gl = gl_;
		window.gl = gl;

		// these calls didn't work from within Lua, but they work fine here.
		gl.getExtension('OES_element_index_uint');
		gl.getExtension('OES_standard_derivatives');
		gl.getExtension('OES_texture_float');	//needed for webgl framebuffer+rgba32f
		gl.getExtension('OES_texture_float_linear');
		gl.getExtension('EXT_color_buffer_float');	//needed for webgl2 framebuffer+rgba32f
	},

	// using js proxy in wasmoon is complete trash ... makes me really appreciate how flawless it was in fengari
	// member object calls sometimes work and sometimes dont
	// the more i push code back into js the smoother things seem to go, but never 100%
	// so here's me pushing a lot of the cimgui stuff into js ...
	imguiNewFrame : () => imgui.newFrame(),
	imguiRender : () => imgui.render(),
	imguiText : (...args) => imgui.text(...args),
	imguiButton : (...args) => imgui.button(...args),
	imguiInputFloat : (...args) => imgui.inputFloat(...args),
	imguiInputInt : (...args) => imgui.inputInt(...args),

	// https://devcodef1.com/news/1119293/stdout-stderr-in-webassembly
	// if only it was this easy
	// why am I even using wasmoon?
	// https://github.com/ceifa/wasmoon/issues/21
	// wait does this say to just overwrite _G.print?  like you can't do that in a single line of "print=function..."
	// no, I want to override all output, including the stack traces that Lua prints when an error happens ... smh everyone ...
	redirectPrint : (s) => {
		outTextArea.value += s + '\n';
		console.log('> '+s);	//log here too?
	},
});

const doRun = () => {
	imgui.clear();
	outTextArea.value = '';

	// ofc you can't push extra args into the call, i guess you only can via global assignments?
	FS.chdir(rundir);
	lua.doString(`
	print = function(...)
		local s = ''
		local sep = ''
		for i=1,select('#', ...) do
			s = s .. sep .. tostring((select(i, ...)))
			sep = '\t'
		end
		js.redirectPrint(s)
	end
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
};
if (runfile && rundir) {
	doRun();
}
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
