const urlparams = new URLSearchParams(location.search);

let rundir = urlparams.get('dir');
let runfile = urlparams.get('file');

let runargs = urlparams.get('args') || '';	//store it in JSON

let editmode = !!urlparams.get('edit');
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
--rundir='glapp/tests'; runfile='test_es_directcalls.lua';				-- WORKS README
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

const merge = (mergedst, ...mergesrcs) => {
	mergesrcs.forEach(mergesrc => {
		for (let k in mergesrc) {
			mergedst[k] = mergesrc[k];
		}
	});
	return mergedst;
};

//TODO put this in util.js
const Dom = args => {
	const tagName = args.tagName;
	if (!tagName) throw "can't make a dom without a tagName";
	const dom = document.createElement(tagName);
	const reservedFields = {
		// the following are same name but dif setter
		tagName : 1,
		style : 1,
		attrs : 1,
		children : 1,
		// the following are my names
		events : 1,
		appendTo : 1,
		prependTo : 1,
	};
	const reserved = {};
	if (args) {
		for (let k in args) {
			if (k in reservedFields) {
				reserved[k] = args[k];
			} else {
				dom[k] = args[k];
			}
		}
	}
	if (reserved.style !== undefined) {
		if (typeof(reserved.style) == 'object') {
			merge(dom.style, reserved.style);
		} else {
			dom.style = reserved.style;
		}
	}
	if (reserved.attrs !== undefined) {
		for (let k in reserved.attrs) {
			dom.setAttribute(k, reserved.attrs[k]);
		}
	}
	if (reserved.events !== undefined) {
		for (let k in reserved.events) {
			dom.addEventListener(k, reserved.events[k]);
		}
	}

	//add last for load event's sake
	if (reserved.appendTo !== undefined) {
		reserved.appendTo.append(dom);
	}
	if (reserved.prependTo !== undefined) {
		reserved.prependTo.prepend(dom);
	}
	if (reserved.children !== undefined) {
		reserved.children.forEach(child => {
			dom.append(child);
		});
	}

	return dom;
}

const DomTag = tagName => {
	return args => Dom(merge({tagName:tagName}, args));
};

const Canvas = DomTag('canvas');
const Img = DomTag('img');
const A = DomTag('a');
const Br = DomTag('br');
const Div = DomTag('div');
const Input = DomTag('input');
const Button = DomTag('button');
const Span = DomTag('span');
const TextArea = DomTag('textarea');


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
// smh why do you have to go through 'getLuaModule' BEFORE EVEN CREATING A LUA OBJECT to get to the Emscripten filesystem object ...
const FS = (await factory.getLuaModule()).module.FS;
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
		const img = Img({
			src : blobUrl,
			style : {
				display : 'none',
			},
			prependTo : document.body,
		});
		await img.decode();
		const width = img.width;
		const height = img.height;
		const canvas = Canvas({
			width : width,
			height : height,
			style : {
				display : 'none',
			},
			prependTo : document.body,
		});
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
				if (!part) continue;

				const current = `${parent}/${part}`;
				try {
					FS.mkdir(current);
				} catch (err) {} // ignore EEXIST

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
// or TODO autogen this from lua rockspec files?  and allow a GET param to a rockspec?  and in each repo provide rockspec dependencies?
const addFromToDir = (fromPath, toPath, files) =>
	Promise.all(files.map(f => mountFile(fromPath+'/'+f, toPath+'/'+f)));

const addLuaDir = (path, files) => addFromToDir('/lua/'+path, path, files);

//await mountFile('/bit/bit.lua', 'bit/bit.lua');
// in a smart future, this would be executed upon callback of any filesystem read event to see if the file is there, and wait and load, or cache the failure ...
// and in a smarter future, you'd do a first pass of running the app to capture all associated files to preload ...
// but for now just load everything
await Promise.all([
	addFromToDir('.', '.', ['ffi.lua']),
	addFromToDir('ffi', 'ffi', ['EGL.lua', 'OpenGL.lua', 'OpenGLES3.lua', 'cimgui.lua', 'req.lua', 'sdl.lua']),
	addFromToDir('ffi/c', 'ffi/c', ['errno.lua', 'stdlib.lua', 'string.lua']),
	addFromToDir('ffi/c/sys', 'ffi/c/sys', ['time.lua']),
	addFromToDir('ffi/cpp', 'ffi/cpp', ['vector-lua.lua', 'vector.lua']),
	addFromToDir('ffi/gcwrapper', 'ffi/gcwrapper', ['gcwrapper.lua']),
	addFromToDir('lfs_ffi', 'lfs_ffi', ['lfs_ffi.lua']),

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
	addLuaDir('dkjson', ['dkjson.lua']),
	addLuaDir('mesh', ['chopupboxes2.lua', 'chopupboxes.lua', 'clipcube.lua', 'combine.lua', 'common.lua', 'earcut.lua', 'edgegraph.lua', 'filtermtls.lua', 'mesh.lua', 'objloader.lua', 'resave.lua', 'tilemesh.lua', 'tileview.lua', 'unwrapuvs.lua', 'view.lua']),
	addLuaDir('mesh/meshes', ['cube.mtl', 'hue.png', 'cube.obj', 'cube-rgb.obj', 'cube-yup-zback.obj', 'cube-zup-xfwd.obj']),
	addLuaDir('audio', ['audio.lua', 'buffer.lua', 'currentsystem.lua', 'source.lua']),
	addLuaDir('audio/null', ['audio.lua', 'buffer.lua', 'source.lua']),
	addLuaDir('glapp', ['glapp.lua', 'mouse.lua', 'orbit.lua', 'view.lua']),
	addLuaDir('glapp/tests', ['compute.lua', 'compute-spirv.lua', 'cubemap.lua', 'events.lua', 'info.lua', 'minimal.lua', 'pointtest.lua', 'test_es_directcalls.lua', 'test_tex.lua', 'test_es.lua', 'test.lua', 'test_vertexattrib.lua', 'src.png']),
	addLuaDir('imgui', ['imgui.lua']),
	addLuaDir('imguiapp', ['imguiapp.lua', 'withorbit.lua']),
	addLuaDir('imguiapp/tests', ['console.lua', 'demo.lua', 'font.lua']),
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

const refreshEditMode = () => {
	if (editmode) {
		fsDiv.style.display = 'block';
		titleBarDiv.style.display = 'block';
		taDiv.style.display = 'block';
		outDiv.style.display = 'block';
		rootSplit.setVisible(true);
	} else {
		fsDiv.style.display = 'none';
		taDiv.style.display = 'none';
		titleBarDiv.style.display = 'none';
		outDiv.style.display = 'none';
		rootSplit.setVisible(false);
	}
	resize();
};

// edit button
A({
	innerText : '+',
	style : {
		position : 'absolute',
		top : '0px',
		right : '0px',
		height : '14px',
		width : '14px',
		background : 'Transparent',
		outline : 'none',
		textDecoration : 'none',
		color : '#ffffff',
		cursor : 'pointer',	//not by default for anchorss?
	},
	events : {
		click : e => {
			editmode = !editmode;
			refreshEditMode();	// refresh size
		},
	},
	appendTo : document.body,
});

// imgui binding code.
// i wanted to do this in lua but wasmoon disagrees.
const imgui = {
	init : function() {
		// TODO make sure this.div is attached too? or trust it's not tampered with ...
		this.div = Div({
			style : {
				position : 'absolute',
				left : '0px',
				top : '0px',
				backgroundColor : '#000000',
				opacity : .8,
				border : '1px solid #5f5f5f',
				padding : '3px',
				borderRadius : '7px',
			},
			appendTo : document.body,
		});
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
		this.lastTouchedDom = undefined;
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
	create : function(idsuffix, createCB) {
		// TODO maybe I should be using order of creation instead of text names?
		const id = 'imgui_'+idsuffix; // ... plus id stack
		let dom = document.getElementById(id);
		if (dom) {
			// TODO and make sure the dom tag is correct
			dom.taggedThisFrame = true;
			this.lastTouchedDom = dom;
			return dom;
		}
		dom = createCB();
		dom.id = id;
		if (!this.div) throw "imgui.create called before imgui.newFrame...";
		if (this.lastTouchedDom && this.lastTouchedDom.nextSibling) {
			this.div.insertBefore(dom, this.lastTouchedDom.nextSibling);
		} else {
			this.div.appendChild(dom);
		}
		dom.taggedThisFrame = true;
		this.lastTouchedDom = dom;
		return dom;
	},

	text : function(fmt) {
		this.create(fmt, () => Div({innerText : fmt}));
	},

	button : function(label, size) {
		const button = this.create(label, () => {
			const button = Button({
				innerText : label,
				style : {
					display : 'block',
				},
				events : {
					click :  e => {
						button.imguiClicked = true;
					},
				},
			});
			return button;
		});
		const clicked = button.imguiClicked;
		button.imguiClicked = false;
		return clicked;
	},
	inputFloat : function(label, v, v_min, v_max, format, flags) {
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			},
		}));
		// TODO use id stack instead of label, or something, idk
		const input = this.create(label+'_value', () => Input({
			value : v[0],
		}));
		// TODO upon creation set this, then monitor its changes and return' true' if found
		let changed = false;
		// TODO this will probably trigger 'change' upon first write/read, or even a few, thanks to string<->float
		const iv = parseFloat(input.value)
		if (v[0] !== iv) {
			v[0] = iv;
			changed = true;
		}
		this.create(label+'_bf', Br);
		return changed;
	},
	inputInt : function(label, v, v_min, v_max, format, flags) {
		this.create(label, () => Span({
			innerText : label,
			style : {
				paddingRight : '20px',
			}
		}));
		// TODO use id stack instead of label, or something, idk
		const input = this.create(label+'_value', () => Input({
			value : v[0],
		}));
		// TODO upon creation set this, then monitor its changes and return' true' if found
		let changed = false;
		// TODO this will probably trigger 'change' upon first write/read, or even a few, thanks to string<->float
		const iv = parseInt(input.value)
		if (v[0] !== iv) {
			v[0] = iv;
			changed = true;
		}
		this.create(label+'_bf', Br);
		return changed;
	},
};

let splitDragging;
class Split {
	static size = 2;

	constructor(args) {
		const thiz = this;
		this.dir = args.dir;
		this.onDrag = args.onDrag;
		this.divider = Div({
			style : {
				position : 'absolute',
				backgroundColor : '#ffffff',
				cursor : this.dir == 'horz' ? 'ns-resize' : 'ew-resize',
				zIndex : 1,
				userSelect : 'none',
			},
			events : {
				mousedown : e => {
					splitDragging = thiz;
				},
			},
			appendTo : document.body,
		});

		this.bounds = args.bounds || [0,0,1,1];
		this.offset = args.offset;
		this.L = args.L;
		this.R = args.R;

		this.refreshOffset();
	}

	setVisible(x) {
		this.divider.style.display = x ? 'block' : 'none';
		if (this.L) this.L.setVisible(x);
		if (this.R) this.R.setVisible(x);
	}

	dragMouse(x,y) {
		const [rectX, rectY, rectW, rectH] = this.bounds;
		if (this.dir == 'horz') {
			this.offset = y - rectY;
		} else if (this.dir == 'vert') {
			this.offset = x - rectX;
		} else {
			throw 'idk '+this.dir;
		}
		this.refreshOffset();
	}

	refreshOffset() {
		const childBounds = this.getChildBounds();
		this.refreshDom();
		this.onDrag(this, childBounds);
		if (this.L) {
			this.L.setBounds(...childBounds.L);
			this.L.refreshOffset();
		}
		if (this.R) {
			this.R.setBounds(...childBounds.R);
			this.R.refreshOffset();
		}
	}

	//called by refreshOffset after dragMouse and after ctor
	setBounds(...bounds) {
		this.bounds = [...bounds];
		this.refreshDom();
		const childBounds = this.getChildBounds();
		this.onDrag(this, childBounds);
		if (this.L) this.L.setBounds(...childBounds.L);
		if (this.R) this.R.setBounds(...childBounds.R);
	}

	//called upon resize
	resizeBounds(...bounds) {
		const f = this.offset / (this.dir == 'horz' ? this.bounds[3] : this.bounds[2]);
		this.bounds = [...bounds];
		this.offset = parseInt(f * (this.dir == 'horz' ? this.bounds[3] : this.bounds[2]));
		this.refreshDom();
		const childBounds = this.getChildBounds();
		this.onDrag(this, childBounds);
		if (this.L) this.L.resizeBounds(...childBounds.L);
		if (this.R) this.R.resizeBounds(...childBounds.R);
	}

	refreshDom() {
		const [rectX, rectY, rectW, rectH] = this.bounds;
		if (this.dir == 'horz') {
			this.divider.style.left = rectX+'px';
			this.divider.style.top = (rectY + this.offset)+'px';
			this.divider.style.width = rectW+'px';
			this.divider.style.height = Split.size+'px';
		} else if (this.dir == 'vert') {
			this.divider.style.left = (rectX + this.offset)+'px';
			this.divider.style.top = rectY+'px';
			this.divider.style.width = Split.size+'px';
			this.divider.style.height = rectH+'px';
		} else {
			throw 'idk '+this.dir;
		}
	}

	getChildBounds() {
		const [rectX, rectY, rectW, rectH] = this.bounds;
		if (this.dir == 'horz') {
			return {
				L : [
					rectX,
					rectY,
					rectW,
					this.offset-1,
				],
				R : [
					rectX,
					rectY + this.offset+1,
					rectW,
					rectH - this.offset - 1,
				],
			};
		} else if (this.dir == 'vert') {
			return {
				L : [
					rectX,
					rectY,
					this.offset-1,
					rectH,
				],
				R : [
					rectX + this.offset+1,
					rectY,
					rectW - this.offset-1,
					rectH,
				],
			};
		}
	}
}
window.addEventListener('mousemove', e => {
	if (splitDragging) {
		splitDragging.dragMouse(e.pageX, e.pageY);
	}
});
window.addEventListener('mouseup', e => {
	if (splitDragging) {
		splitDragging = undefined;
	}
});

// resize uses this too
let fsDiv;
let taDiv;
let titleBarDiv;
let outDiv;
let outTextArea;
// store as pixel <=> smoother scrolling when resizing divider, store as fraction <=> smoother when resizing window ... shrug

let aceEditor;
let editorPath;
let editorFileNameSpan;
let editorArgsInput;
let editorSaveButton;
const editorRun = () => {
	editorSave();			// auto-save before run?
	const parts = editorPath.split('/');
	runfile = parts.pop();
	rundir = parts.join('/');
	runargs = editorArgsInput.value;
	doRun();
};
const editorSave = () => {
	FS.writeFile(editorPath, new TextEncoder().encode(
		aceEditor.getValue()
	), {encoding:'binary'});
	editorSaveButton.setAttribute('disabled', 'disabled');
};
const editorLoad = () => {
	let failed;
	try {
		const fileStr = new TextDecoder().decode(FS.readFile(editorPath, {encoding:'binary'}));
		aceEditor.setValue(fileStr);
		aceEditor.clearSelection();
	} catch (e) {		// TODO file went wrong ... what to do
		e = ''+e;
		outTextArea.value += e + '\n';	// or if this happens at init, is outTextArea cleared shortly after?
		console.log(e);
		failed = true;
	}
	if (failed && !editmode) {
		editmode = true;
		refreshEditMode();
	}
	aceEditor.focus();
};

const fileInfoForPath = {};
let openedFileInfo;
const setEditorFilePath = path => {
	if (openedFileInfo) {
		openedFileInfo.titleDiv.style.backgroundColor = '#000000';	//reset
	}
	openedFileInfo = fileInfoForPath[path];
	if (openedFileInfo) {
		openedFileInfo.titleDiv.style.backgroundColor = '#003f7f';							//select

		// here reveal folder and all children
		let fileInfo = openedFileInfo;
		while (fileInfo) {
			if (fileInfo.childrenDiv) fileInfo.childrenDiv.style.display = 'block';
			fileInfo = fileInfo.parentFileInfo;
		}
	}

	if (editorPath) {
		editorSave();		// auto-save before changing files?
	}

	editorPath = path;
	editorFileNameSpan.innerText = editorPath;
	editorLoad();
};

const isDir = path => FS.lstat(path).mode & 0x4000;

{
	imgui.init();	// make the imgui div

	fsDiv = Div({
		style : {
			position : 'absolute',
			display : 'none',
			zIndex : -1,	//under imgui div
			backgroundColor : '#000000',
			color : '#ffffff',
			overflow : 'auto',
		},
		appendTo : document.body,
	});

	const makeFileDiv = (path, name, parentFileInfo) => {
		//FS.chdir(path);

		const fileDiv = Div({
			style : {
				border : '1px solid #5f5f5f',
				borderRadius : '7px',
				padding : '3px',
			},
			appendTo : parentFileInfo ? parentFileInfo.childrenDiv : fsDiv,
		});

		const titleDiv = Div({
			appendTo : fileDiv,
		});

		const pathIsDir = isDir(path);
		const fileInfo = {
			path : path,
			name : name,
			isDir : pathIsDir,
			parentFileInfo : parentFileInfo,
			fileDiv : fileDiv,
			titleDiv : titleDiv,
			sortChildren : function(){
				const childrenDiv = this.childrenDiv;
				[...childrenDiv.children].sort((a, b) => {
					return a.fileInfo.name.localeCompare(b.fileInfo.name);
				}).forEach(node => {
					childrenDiv.removeChild(node);
					childrenDiv.appendChild(node);
				});
			},
		};
		fileDiv.fileInfo = fileInfo;
		fileInfoForPath[path] = fileInfo;

		if (pathIsDir) {
			// if it's a dir then this holds all the children and turns display:none/block upon clikc
			const childrenDiv = Div({
				style : {
					marginLeft : '16px',
					display : path == '/' ? 'block' : 'none',
				},
				appendTo : fileDiv,
			});
			fileInfo.childrenDiv = childrenDiv;
			name = name.substr(0,1) == '/' ? name : '/' + name;
			try {
				if (path != '/dev' && path != '/proc') {	//giving exceptions from accessing them
					FS.readdir(path).forEach(f => {
						if (f != '.' && f != '..') {
							let chpath = path.substr(-1) == '/' ? path + f : path + '/' + f;
							makeFileDiv(chpath, f, fileInfo);
						}
					});
					fileInfo.sortChildren();
				}
			} catch (e) {
				console.log('for path '+path+' thought it was a dir but it wasnt: '+e);
			}
			titleDiv.style.cursor = 'pointer';
			titleDiv.addEventListener('click', e => {
				if (childrenDiv.style.display == 'none') {
					childrenDiv.style.display = 'block';
				} else {
					childrenDiv.style.display = 'none';
				}
			});
		} else {
			titleDiv.style.cursor = 'pointer';
			titleDiv.addEventListener('click', e => {
				setEditorFilePath(path);
			});
		}
		titleDiv.innerText = name;	//update name if it's a dir

		//delete button
		A({
			style : {
				color : '#ff3f3f',
				cssFloat : 'right',
				//textAlign : 'right',	// for children?
				right : '0px',
				backgroundColor : '#000000',
				border : '1px solid #5f5f5f',
				borderRadius : '7px',
				paddingLeft : '3px',
				paddingRight : '3px',
			},
			events : {
				click : e => {
					e.stopPropagation();	//stop fallthru to title click
					if (pathIsDir) {
						FS.rmdir(path);	// can we rmdir empty dirs? nope.
					} else {
						FS.unlink(path);
					}

					// remove from children ...
					parentFileInfo?.childrenDiv.removeChild(fileInfo.fileDiv);

					if (editorPath == path) {
						 // TODO what to set the editor path to if we delete the current file?
					}
				},
			},
			appendTo : titleDiv,
			children : [
				Img({
					src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TpSIVh3YQcchQnSxIleKoVShChVArtOpg8tI/aGJIUlwcBdeCgz+LVQcXZ10dXAVB8AfE2cFJ0UVKvC8ptIjxweV9nPfO4b77AKFZY5rVMwFoum1m0ykxX1gRQ68IIUKVREJmljErSRn4rq97BPh+F+dZ/vf+XANq0WJAQCSeYYZpE68TJzdtg/M+cZRVZJX4nHjcpAaJH7muePzGueyywDOjZi47RxwlFstdrHQxq5ga8RRxTNV0yhfyHquctzhrtTpr98lfGC7qy0tcpxpBGgtYhAQRCuqoogYbcdp1Uixk6Tzl4x92/RK5FHJVwcgxjw1okF0/+B/8nq1Vmkx4SeEU0PviOB+jQGgXaDUc5/vYcVonQPAZuNI7/o0mMP1JeqOjxY6AwW3g4rqjKXvA5Q4w9GTIpuxKQSqhVALez+ibCkDkFuhf9ebWPsfpA5CjWWVugINDYKxM2Ws+7+7rntu/d9rz+wHKUnLK2aV6FwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwgBHitISrQAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACIElEQVRYw+2WTWsTURSGnzszZmgSdzKSgm5cKGjVCmlFaBCl7vQfdGndSVuwXWkqAdeWqosu6kcFoSCCrkRQzELwKxSTSiP4C0pdFdNMnFwX02DmZqKTZsYvemAW99wz8z5c3nPuCALE12OZx8BZOosn8UL+3K+KhCIkgINKTT9wj63FCEIseTJSLscLedlYGsoLT4FhwosFpFRzz4AzjYWmbJ4m+jjVvND4w/HXAXz+DZoeDdWEw5uPHpG4s2lC/zZsasd9qllCiOfxQr7lhI02xQ+AdMgAb4GBoCbsieD4e/6JLtgGaHtlxeZnMR/dR2QG2pbJwaNs3LlBdeYaCBEegDh5Av3IYbS9ezBzWURm0Fe8MjWBk0rx7cB+5E9AOwaQL17hfCi6MMkkZu6KB6IhLhMJt7dXyoiXr8P1gH1hHKdYaoFoES9/wpyaDuyBdpOwCBxq2YjtIDZ3Hb3P3ZLr63xZW/OKT2Zhw/b7bCleyPd11wV2DXt0zHMSAcVDbEO7Ru32AjjOj1y9TmzxYcfiWwIQQ2nMq5dBb7owNY3KxEXk8f5oAcRQGjM3jdiZdO/W0jLGStn1QyJBZXK8YwitG3F7dAzzUrYriGAAvZY7gBRxqjbYNV8Ieq0QJ2HKQiR9xJuMqUJIa1cgACPQJHxfojp7C7HbwpmZ84orEPr5EcTqKmLpY3gAAPW7i4Fa1Lg5v/0/8H8AvItA641f8jtDCMZ/I7Ih8wAAAABJRU5ErkJggg==',
					height : 14,
				}),
			],
		});

		if (pathIsDir) {
			//new-folder button
			A({
				style : {
					color : '#3fff3f',
					cssFloat : 'right',
					//textAlign : 'right',	// for children?
					right : '0px',
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					paddingLeft : '3px',
					paddingRight : '3px',
				},
				events : {
					click : e => {
						e.stopPropagation();	//stop fallthru to title click
						const newname = prompt('File Name:', '');
						if (newname) {
							const newpath = path == '/' ? ('/' + newname) : (path + '/' + newname);
							FS.mkdir(newpath);
							makeFileDiv(newpath, newname, fileInfo);
							fileInfo.sortChildren();
						}
					},
				},
				appendTo : titleDiv,
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV9bpUUqDi0i4pCh6mJBVMRRq1CECqFWaNXB5NIvaNKQpLg4Cq4FBz8Wqw4uzro6uAqC4AeIs4OToouU+L+k0CLGg+N+vLv3uHsH+BsVpppd44CqWUY6mRCyuVUh+IogIgihH6MSM/U5UUzBc3zdw8fXuzjP8j735+hV8iYDfALxLNMNi3iDeHrT0jnvE0dZSVKIz4nHDLog8SPXZZffOBcd9vPMqJFJzxNHiYViB8sdzEqGSjxFHFNUjfL9WZcVzluc1UqNte7JXxjOayvLXKc5hCQWsQQRAmTUUEYFFuK0aqSYSNN+wsM/6PhFcsnkKoORYwFVqJAcP/gf/O7WLExOuEnhBND9Ytsfw0BwF2jWbfv72LabJ0DgGbjS2v5qA5j5JL3e1mJHQN82cHHd1uQ94HIHGHjSJUNypABNf6EAvJ/RN+WAyC3Qs+b21trH6QOQoa5SN8DBITBSpOx1j3eHOnv790yrvx9hlHKgn1zBvAAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwgXENBo0mQAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAA1klEQVRYw+2WPQrCQBCFH9EiQTxO+tzEU3gFY59brb3XENKHz2YCKiHkZ7MbZB8MW8ww8+aXlRIS9gZQDmpALYgfeYFqULYlgWYg8FppzW8+hUCfeTmgq0DdCiLNFAKAGNHXZvMEFROrWvaV8EGgsOCA6hmtHfU7y9Ay6kyq4ATM7rZkDnwSOIDutprhCcxc7VNUAmN+s9iX9xgw1sPvvnpC9BZsSgDkQM7LtPqc/P9ugZX9K/OPS+h2V4FZH5ItZsDXl8wtJTB0Ca/2XiSdg1y/hISYeAMW5MAnrSYD2QAAAABJRU5ErkJggg==',
						height : 14,
					}),
				],
			});

			//new-file button
			A({
				style : {
					color : '#3fff3f',
					cssFloat : 'right',
					//textAlign : 'right',	// for children?
					right : '0px',
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					paddingLeft : '3px',
					paddingRight : '3px',
				},
				events : {
					click : e => {
						e.stopPropagation();	//stop fallthru to title click
						const newname = prompt('File Name:', '');
						if (newname) {
							const newpath = path == '/' ? ('/' + newname) : (path + '/' + newname);
							FS.writeFile(newpath, '', {encoding:'binary'});
							makeFileDiv(newpath, newname, fileInfo);
							fileInfo.sortChildren();
							setEditorFilePath(newpath);			//auto-open?
						}
					},
				},
				appendTo : titleDiv,
				children : [
					Img({
						src : 'data:image/png;base64,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IlhNUCBDb3JlIDQuNC4wLUV4aXYyIj4KIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CiAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgIHhtbG5zOkdJTVA9Imh0dHA6Ly93d3cuZ2ltcC5vcmcveG1wLyIKICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIgogICB4bXBNTTpEb2N1bWVudElEPSJnaW1wOmRvY2lkOmdpbXA6NzU4NjMwMGYtNjRmYS00MDMyLTlkYWMtN2IxMTdkOGQyYjgyIgogICB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjAwYTExNjRmLWFiNDgtNGVhMy04NzFhLWU2YmQ2ZWNjNGRkYyIKICAgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjI4ZmViYjVjLTRlMWEtNDAzMC1hODIwLTZjZTg0Y2U2MTA2NyIKICAgZGM6Rm9ybWF0PSJpbWFnZS9wbmciCiAgIEdJTVA6QVBJPSIyLjAiCiAgIEdJTVA6UGxhdGZvcm09IkxpbnV4IgogICBHSU1QOlRpbWVTdGFtcD0iMTcyMTM3NTg4NTExNDc2OCIKICAgR0lNUDpWZXJzaW9uPSIyLjEwLjM4IgogICB0aWZmOk9yaWVudGF0aW9uPSIxIgogICB4bXA6Q3JlYXRvclRvb2w9IkdJTVAgMi4xMCIKICAgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNDowNzoxOVQxMzo1ODowMyswNjowMCIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjQ6MDc6MTlUMTM6NTg6MDMrMDY6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJzYXZlZCIKICAgICAgc3RFdnQ6Y2hhbmdlZD0iLyIKICAgICAgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo3ZDA3YjY4My1mMjMwLTQ1MjUtOWU5Ni0zZDhhZDc4ZjRjYTQiCiAgICAgIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkdpbXAgMi4xMCAoTGludXgpIgogICAgICBzdEV2dDp3aGVuPSIyMDI0LTA3LTE5VDEzOjU4OjA1KzA2OjAwIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Pihzw7IAAAAGYktHRAD/AP8A/6C9p5MAAAAJcEhZcwAALiMAAC4jAXilP3YAAAAHdElNRQfoBxMHOgWWwytdAAAAGXRFWHRDb21tZW50AENyZWF0ZWQgd2l0aCBHSU1QV4EOFwAAAQlJREFUWMPtlz0OgkAQhR/EwphszUk8B0fwAtzAeAYL76OFVlhoYaW3oKHA5FmwBEGQZXf5S5gpaJjZb+btQAYYrRE+iBOIBFT2F4gdiJXp4fsWh1b5HYRnUjlBxCACEEIxzilBPPQg0rYTRKAR+324JkSuuTAA8PQhshR68uWx2hBmAJGMXldA3NSmwwzg0DAd264BlhIiqgF4dgugMqIlc3v5qjr1BbmGlYUgQtv/AHUJLLzbjwR/bGIAqeb8aWdx1MJJdWC+hIMDLAzjr8PeAQt55zswSoC31ExY1F8UcjcAXORzY7HQLNe5u8WkrvI0Ryxz+n2tZlW+11nRji2X07InMoePsdoHHAdgdUB5RO8AAAAASUVORK5CYII=',
						height : 14,
					}),
				],
			});
		}
	};
	FS.chdir('/');
	makeFileDiv('/', '/', undefined);
	FS.chdir('/');

	taDiv = Div({
		id : 'taDiv',
		style : {
			position : 'absolute',
			display : 'none',
			//overflow : 'hidden',
			zIndex : -1,	//under imgui div
		},
		events : {
			keydown : async (e) => {
				//what's a good hotkey for run?
				// ctrl-r ? nah that's "reload"
				// shift-f5?  can browser trap f-keys?
				// shift-enter?
				if (e.shiftKey && e.key == 'Enter') {
					e.preventDefault();
					editorRun();
				}
			},
		},
		appendTo : document.body,
	});

	titleBarDiv = Div({
		style : {
			height : '1em',
			position : 'absolute',
			display : 'none',
			border : '1px solid #5f5f5f',
			borderRadius : '7px',
			padding : '1px',
			backgroundColor : '#000000',
		},
		appendTo : document.body,
		children : [
			//run
			A({
				href : '#',
				title : 'Shift+Enter to Run',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				events : {
					click : async (e) => {
						editorRun();
					},
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSkUqDu0g4pChOlkRFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFlmhUaAzTdNjOppJjLr4jhV4QRRQijiMjMMmYlKQ3f8XWPAF/vEjzL/9yfo1ctWAwIiMQzzDBt4nXiqU3b4LxPHGNlWSU+Jx4x6YLEj1xXPH7jXHJZ4JkxM5uZI44Ri6UOVjqYlU2NeJI4rmo65Qs5j1XOW5y1ao217slfGCnoy0tcpzmIFBawCAkiFNRQQRU2ErTqpFjI0H7Sxz/g+iVyKeSqgJFjHhvQILt+8D/43a1VnBj3kiJJoOvFcT6GgPAu0Kw7zvex4zRPgOAzcKW3/RsNYPqT9Hpbix8BfdvAxXVbU/aAyx2g/8mQTdmVgjSFYhF4P6NvygPRW6Bn1euttY/TByBLXaVvgINDYLhE2Ws+7+7u7O3fM63+fgBQSXKZtanoYgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwQwFATaXXwAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACRklEQVRYw8WXzWsTURTFfzMdMBWLXai4cOUi0hakdVLIUtpVCvkHFNx0PSAoFsUKGhAEC8ZZu3GRjd0VGgQV3Qk6tAgGHKEgfmEiWKmYFmqfmxt5bVN985HxbGfenPPOvHfvuRaG8ALrIDAFTABjQB4YkMdrwFtgCXgM1H1XrZp81zIgzgMzwBkgZ6h3HagBt3xXhbEEeIHVD1SA80Af8bAJVIFrvqt+GgvwAus4sAAMkw4aQNl31co/BXiBVQAWgcOkixZQ8l0V7ClAdv68B+S6iKLuhKWR7wdepGj7335HwXdVG8DWHtzIgBzhqGxzQK5aI8Fpj4pfwLDvqrDjwIwp+dWh91wf+cLJA1eSCOgTTiwvsAaBz6ZF5u6pLQAUiqD5jAefLtDeWoojYh04agOlCBVOuz4WhSOnuTz0MK4bOWDKBiaTeDm47xDT+Qrnjj2h3x6LunzSBkaTnqgEboza0tVSQQw38rbWUlNBx42LJxZMXh+w+c+wJUykBoXiZfMpt9+UTV5fc4AQcNMgX934yvy7O7z6cdN0SegAy0kFJChKy45kuOkMd63jkQPUpSzmMtq1XorrtqTXmumqZvsj3zZa3Atnuf9hIi45QM131Xe9Hb8GnIxu3yYw8qcdS3SuZnj9q524rheiWQklvUZDuNgmQDJaWYJjr9CSeN7eJUBErEg+aPWIvLRzNtjVCyS3F+VQpml7cedM0FWA5sQ4MCcBMslpnwPGu01FUYbTS8DZTIfTPcbzkkS4buN5KH0l0nj+GwVB22gu8TRJAAAAAElFTkSuQmCC',
						height : 14,
					}),
				],
			}),

			//save
			editorSaveButton = A({
				href : '#',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				attrs : {
					disabled : 'disabled',		// bleh, only works with buttons ... why is js behavior so unevenly applied?
				},
				events : {
					click : e => { editorSave(); },
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSkUqDu0g4pChOlkRFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFlmhUaAzTdNjOppJjLr4jhV4QRRQijiMjMMmYlKQ3f8XWPAF/vEjzL/9yfo1ctWAwIiMQzzDBt4nXiqU3b4LxPHGNlWSU+Jx4x6YLEj1xXPH7jXHJZ4JkxM5uZI44Ri6UOVjqYlU2NeJI4rmo65Qs5j1XOW5y1ao217slfGCnoy0tcpzmIFBawCAkiFNRQQRU2ErTqpFjI0H7Sxz/g+iVyKeSqgJFjHhvQILt+8D/43a1VnBj3kiJJoOvFcT6GgPAu0Kw7zvex4zRPgOAzcKW3/RsNYPqT9Hpbix8BfdvAxXVbU/aAyx2g/8mQTdmVgjSFYhF4P6NvygPRW6Bn1euttY/TByBLXaVvgINDYLhE2Ws+7+7u7O3fM63+fgBQSXKZtanoYgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwQxBXdxTM8AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAB5UlEQVRYw+2XPU9UQRiFn3ddE9aG0KF0WBHDR03cBBMLQ0VDgYmdriUVDQUk/gBMSCz0DxD+AIWJ8WOBihCjhZ0fBUpJISwhsIfmHXO9XHZW7u6NxZ5mPt6ZOWfOfWduBgBJVUl1SU11D28lVUjDyU9UDC6IMEl14C7QAF4CB4n4LHAH+Am84nI8BW4Cv3yNdN83YNL73wHTZtYIDgTbn2e4s+6xnRbkSNpJj0v2Sar47i84UQLM5xzQJfhup333AFPAhqRKiYJwmYjCBKREbAcR5Q6t/Qi4ARy1I0LS65CUMQFNL69FFv3SInzWam5MwA8vJyTNA5ttOjIBjHl9l8gRCljOiA1LOsxx8RxLGs1YdzkMKEWs/Qo8AL5fIS/2gRkz+5znE2BmdUnDwHgsF1K588nMzmIDy20eHwEfu3E0y5H8GASGcnLsm9nePwmQ1AesAk86sUtJa8BjMztq14GVTpE75rx8GBUgqT9Bvg0sAr+vSFwBngH3gDlJC+nPkeXA7UT/CzN7n9P+JaDuzUHgLwFZ94Al6qcdsL/RKljo37AnoCegJ+C/FSCvDxTIG7hUBrb8aVaTFO7vP08zSSM5yW4l6jVJDaDm7U2TVAXeANcLdv8EuJ98IX/o8vM8oOlcVYBzQKxhLYk+dM8AAAAASUVORK5CYII=',
						height : 14,
					}),
				],
			}),

			// reload
			A({
				href : '#',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				events : {
					click : e => { editorLoad(); },
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSkUqDu0g4pChOlkRFXHUKhShQqgVWnUwufQLmhiSFBdHwbXg4Mdi1cHFWVcHV0EQ/ABxdnBSdJES/5cUWsR4cNyPd/ced+8AoVFlmhUaAzTdNjOppJjLr4jhV4QRRQijiMjMMmYlKQ3f8XWPAF/vEjzL/9yfo1ctWAwIiMQzzDBt4nXiqU3b4LxPHGNlWSU+Jx4x6YLEj1xXPH7jXHJZ4JkxM5uZI44Ri6UOVjqYlU2NeJI4rmo65Qs5j1XOW5y1ao217slfGCnoy0tcpzmIFBawCAkiFNRQQRU2ErTqpFjI0H7Sxz/g+iVyKeSqgJFjHhvQILt+8D/43a1VnBj3kiJJoOvFcT6GgPAu0Kw7zvex4zRPgOAzcKW3/RsNYPqT9Hpbix8BfdvAxXVbU/aAyx2g/8mQTdmVgjSFYhF4P6NvygPRW6Bn1euttY/TByBLXaVvgINDYLhE2Ws+7+7u7O3fM63+fgBQSXKZtanoYgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwQyJWcyP8QAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAAB+UlEQVRYw8WXT0hUURTGv2tiOA0ECmXhIoKQBEEEcdHCTeBOaCmtAikH3LUUWwRCIG1duHHhwl2LRKQQXAgRWePGRX8wEHUmhFaDimL82lxDXvdeZ95943yrx3vnfN85755z7r1SBIA+NRLAZ2AGaG1kAACbQHcjAwA4BJ5dprgBvvA/3gDX6yF4BRgG5oBvhLENPMhSfNSS1oI/wAvAxAh3AmvE4R3Qkka8B9iNFP+RalYAd4BypPg8cC2N+FVg4wLyX8ACsO/4VgFGYtZ9IiC8AzwGmhxzAGAduBsj3mYzcGENaAsMolepii1B+Nwj/h3IeyZhGRjKqt8/eAIY9NhPAR1Zibd6xD/Wc6Q3nXu+77FZrGcAzeeeb3psfkb81W5JBcenOWNMMRmA71BxGJHgPUnjjverkorJJSh5SGKK7JbnfclVA7se48GIAHy+e74123N0wQHQnmL9261vEiVfF0jSWwdXTtJ0iuynra+q0PgXdX9gHxirIfuxAM/ARc7LAefXQC7gm7M2PrxP+hgHSZekjUBb7kualbRii8lIui3poaSnkm54/I4k9RljvlbzC5+QPUZrreLJDMVfph2lBeA4QvgEGI/dJXsdJ59qUMz08movJUvAaUD01HbRo2p5TYpA8pL67UZzNiF/S9qS9MkYU6mF7y+NXuL7i6ZMtwAAAABJRU5ErkJggg==',
						height : 14,
					}),
				],
			}),

			//share / rewrite url
			A({
				href : '#',
				style : {
					border : '1px solid #5f5f5f',
					borderRadius : '7px',
					padding : '3px',
				},
				events : {
					click : e => {
						const newUrlParams = new URLSearchParams();
						newUrlParams.set('file', runfile);
						newUrlParams.set('dir', rundir);
						newUrlParams.set('args', runargs);
						const url = location.origin + location.pathname + '?' + newUrlParams.toString();
						history.replaceState({
							runfile : runfile,
							rundir : rundir,
							runargs : runargs,
						}, document.title, url);

						navigator.clipboard.writeText(url);

						if (navigator.share) {
							navigator.share({
								title : document.title,
								text : 'GLApp',
								url : url,
							})
						}
					},
				},
				children : [
					Img({
						src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw0AcxV/TSqVUHNpBxCFDdbIgWsRRq1CECqFWaNXB5NIvaNKSpLg4Cq4FBz8Wqw4uzro6uAqC4AeIs4OToouU+L+k0CLGg+N+vLv3uHsHCK0q08zABKDplpFJJcVcflUMviKICEJIICAzsz4nSWl4jq97+Ph6F+dZ3uf+HANqwWSATySeZXXDIt4gnt606pz3iaOsLKvE58TjBl2Q+JHristvnEsOCzwzamQz88RRYrHUw0oPs7KhESeIY6qmU76Qc1nlvMVZqzZY5578heGCvrLMdZojSGERS5AgQkEDFVRhIU6rToqJDO0nPfzDjl8il0KuChg5FlCDBtnxg//B727N4tSkmxROAn0vtv0xCgR3gXbTtr+Pbbt9AvifgSu966+1gJlP0ptdLXYEDG4DF9ddTdkDLneAoae6bMiO5KcpFIvA+xl9Ux6I3AKhNbe3zj5OH4AsdZW+AQ4OgbESZa97vLu/t7d/z3T6+wFaYXKdgHsyPwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwo1B/eNxe0AAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAADAUlEQVRYw81XPUwUQRSeO3KJgViAhbHDaAXG4kqJnQ2NVEaiiVpamAsWGq0oDFEbLbAT7DQEzEFIKDhOExGN5AINajbcBvnZHLe3t7u3fzN7szvzbHbNcZ4Rwy74mknmTfb75u2b772HUAy2trbWqev6c9d1t33fB9d1TULIzPr6+gUUt4mieIZS+gMCM00TPM8DAADOObUs63qc+AnXdQsAABjjRVEUexBCKJfLnTAM4xFjDBhjtFKp9MaCXi6X+wEA6vV6cWFhoaPZb9v2YwAA27Zfx0LAsqynAACO4zxo5V9eXj4NAOB5XjHcS0ZJgDF2HCGEOOd6K//ExIQcnOuMJQKmad4JItAyxNVqtR8AgBDyJXLwjY2NboxxLkh+uru7e6XJf6perxcBAKrVaiYy4Hw+n9J1/aHneQQAgFJqAQAwxgBjPKvr+rDjOC9839eC2y9NTk6mIgEvlUoXCSHfQ0DTNF8GInTb930TGoxzDhjjN+VyueOvHx4aGkptbW2lVVXtW11d7W72C4LQZVnWOGMMglt9lSRpj8oVCoUuRVFuGIYxrGnaXUEQzu3rVoqi3KOUVpqYf5IkKR0k0i1KaRUAwPd9W9O0+2NjY9GE1DCMVyGo4zjfNE1bCslwzm1CyOeQmOM4s4IgdEeWTJqmDQRJZO/s7FwK97PZ7LFarTYaAlNKtxVFGYj8GWGM3wMA1Gq1m6384e1VVb0aJW6jEqY552hubi77h7NvEUKovb39fFwEjtYwxu+O4hc0JuHlMAklSfqVhNPT04eThMEzHD+yZ/hfCFFomUwmtbm5mVZVtW9lZeVAUmya5r9JcYTFyGouRoSQN7Isd0RKYp/leLSxHE9NTaUij0ZjQ8I5p6VS6XAakoO2ZJEqIee8J1gXW/lHRkY+IIRQIpE4GwuBZDJpBWvLrndwcPAkQgi1tbXpsQ8m+Xy+1WDyBADAsqx4BpOm0eyjKIq9CCE0Pz+/ZzSTZbk3LgL7GU6vxV5ZAzF61jCeG4SQmWKx+Nt4/hMEvsjczhecQwAAAABJRU5ErkJggg==',
						height : 14,
					}),
				],
			}),

			editorFileNameSpan = Span({
				style : {
					paddingLeft : '5px',
				},
			}),

			editorArgsInput = Input({
				value : runargs,
				placeholder : 'args in JSON format',
				style : {
					color : '#ffffff',
					background : 'Transparent',
					position : 'absolute',
					right : '0px',
				},
			}),
		],
	});

	outDiv = Div({
		style : {
			position : 'absolute',
			display : 'none',
			zIndex : -1,	//under imgui div
		},
		appendTo : document.body,
		children : [
			outTextArea = TextArea({
				readOnly : true,
				style : {
					backgroundColor : '#000000',
					color : '#ffffff',
					width : '100%',
					height : '100%',
					tabSize : 4,
					MozTabSize : 4,
					OTabSize : 4,
					whiteSpace : 'pre',
					overflowWrap : 'normal',
					overflow : 'auto',
				},
			}),
		],
	});

	// ace editor: https://github.com/ajaxorg/ace
	aceEditor = ace.edit("taDiv");
	aceEditor.setBehavioursEnabled(false);
	aceEditor.setTheme("ace/theme/tomorrow_night_bright");
	const LuaMode = ace.require("ace/mode/lua").Mode;
	aceEditor.session.setMode(new LuaMode());
}
window.imgui = imgui;

document.body.style.overflow = 'hidden';	//slowly sorting this out ...
let canvas;

const rootSplit = new Split({
	bounds : [0, 0, window.innerWidth, window.innerHeight],
	dir : 'vert',
	offset : window.innerWidth / 4,
	onDrag : (split, childBounds) => {
		const L = childBounds.L;
//console.log('setting fsDiv to', L);
		fsDiv.style.left = L[0]+'px';
		fsDiv.style.top = L[1]+'px';
		fsDiv.style.width = L[2]+'px';
		fsDiv.style.height = L[3]+'px';
	},
	R : new Split({
		dir : 'vert',
		offset : window.innerWidth / 2,
		onDrag : (split, childBounds) => {
			const L = childBounds.L;
//console.log('setting taDiv to', L);
			titleBarDiv.style.left = L[0] + 'px';
			titleBarDiv.style.top = L[1] + 'px';
			titleBarDiv.style.width = (L[2] - 2) + 'px';	// minus 1px padding x2
			titleBarDiv.style.height = '20px';

			taDiv.style.left = L[0] + 'px';
			taDiv.style.top = (L[1] + 24) + 'px';
			taDiv.style.width = L[2] + 'px';
			taDiv.style.height = (L[3] - 24) + 'px';

			const R = childBounds.R;


		},
		R : new Split({
			dir : 'horz',
			offset : window.innerHeight / 2,
			onDrag : (split, childBounds) => {
				const U = childBounds.L;
				if (canvas) {
					if (editmode) {
						canvas.style.left = U[0] + 'px';
						canvas.style.top = U[1] + 'px';
						canvas.width = U[2];
						canvas.height = U[3];
					} else {
						canvas.style.left = '0px';
						canvas.style.top = '0px';
						canvas.width = window.innerWidth;
						canvas.height = window.innerHeight;
					}
				}

				const D = childBounds.R;
				outDiv.style.left = D[0] + 'px';
				outDiv.style.top = D[1] + 'px';
				outDiv.style.width = D[2] + 'px';
				outDiv.style.height = D[3] + 'px';
			},
		}),
	}),
});
window.rootSplit = rootSplit;
const resize = e => {
	rootSplit.resizeBounds(0, 0, window.innerWidth, window.innerHeight);
};
window.addEventListener('resize', resize);
refreshEditMode();	// will trigger resize()

// make sure to do this after initializing the Splits / editor UI, in case we need to popup the editor
// in fact, why not do this within doRun?
if (rundir && runfile) {
	setEditorFilePath(rundir+'/'+runfile);
}

let gl;
const closeGL = () => {
	if (gl) {
		const WEBGL_lose_context = gl.getExtension('WEBGL_lose_context');
		if (WEBGL_lose_context) WEBGL_lose_context.loseContext();
	}
	gl = undefined;
};
const closeCanvas = () => {
	closeGL();
	if (canvas) document.body.removeChild(canvas);
	canvas = undefined;
};

let lua;
const doRun = async () => {
	//TODO maybe, if our run file is dif from the last run file then window.history.pushState() ?
	{
		const newParams = new URLSearchParams();
		newParams.set('file', runfile);
		newParams.set('dir', rundir);
		if (runargs) newParams.set('args', runargs);
		if (editmode) newParams.set('edit', editmode);
		const url = location.origin + location.pathname + '?' + newParams.toString();
		history.pushState({
			runfile : runfile,
			rundir : rundir,
			runargs : runargs,
		}, document.title, url);
	}

	closeCanvas();
	//if (lua) lua.close();	//tf why are all these essential functions hidden?

	// if i make a new lua state then will it preserve the filesystem?
	lua = await factory.createEngine({
		// looks like this is true by default, and if it's false then i get the same error within js instead of within lua ...
		// was this what was screwing up my ability to allocate ArrayBuffer from within the Lua code? gah...
		// disabling this does lose me my Lua call stack upon getting that same error...
		//enableProxy:false,//true,
		//insertObjects:true,
		//traceAllocations:true,
	});
	window.lua = lua;

	lua.global.set('js', {
		global : window,	//for fengari compat

		FS : FS,

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
			closeCanvas();
			canvas = Canvas({
				style : {
					position : 'absolute',
					userSelect : 'none',
				},
				prependTo : document.body,
			});
window.canvas = canvas;			// global?  do I really need it? debugging?  used in ffi.cimgui right now
			resize();	// set our initial size
			return canvas;
		},

		// these functions should have been easy to do in lua ...
		// ... but wasmoon has some kind of lua-syntax within some internally run code for wrappers to js objects ... bleh
		webglInit : (gl_) => {
			closeGL();
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
		redirectPrint : s => {
			outTextArea.value += s + '\n';
			console.log('> '+s);	//log here too?
		},
	});

	imgui.clear();
	outTextArea.value = '';

	// ofc you can't push extra args into the call, i guess you only can via global assignments?
	FS.chdir(rundir);
	// TODO HERE reset the Lua state altogether
	let args = [];
	try {
		args = JSON.parse(runargs) || [];
	} catch (e) {
		console.log(e);
	}
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

local function shim()
	local rundir = '`+rundir+`'
	local runfile = '`+runfile+`'
	_G.arg = {`+args.map(arg => '"'+arg+'"')+`}
	-- ok this has become the launcer of everything
	-- Lua 5.3
	-- TODO move this into main.js

	package.path = table.concat({
		'./?.lua',
		'/?.lua',
		'/?/?.lua',
	}, ';')

	-- this modifies some of the _G functions so it should go first
	local ffi = require 'ffi'

	-- shim layer stuff
	package.loaded['audio.currentsystem'] = 'null'

	-- shim complex to not try to use ffi complex types (until I implement them)
	do
		local push_G_ffi = _G.ffi
		_G.ffi = nil
		local push_package_ffi = package.loaded.ffi
		package.loaded.ffi = nil
		local pushreq = require
		require = function(fn, ...)
			if fn == 'ffi' then return false, "nope" end
			return pushreq(fn, ...)
		end

		require 'complex'

		_G.ffi = push_G_ffi
		require = pushreq
		package.loaded.ffi = push_package_ffi
	end

	-- shim layer canvas loader
	do
		local class = require 'ext.class'
		local path = require 'ext.path'

		local CanvasImageLoader = class()
		package.loaded['image.luajit.png'] = CanvasImageLoader
		package.loaded['image.luajit.jpeg'] = CanvasImageLoader
		package.loaded['image.luajit.bmp'] = CanvasImageLoader
		package.loaded['image.luajit.gif'] = CanvasImageLoader
		package.loaded['image.luajit.tiff'] = CanvasImageLoader
		--package.loaded['image.luajit.fits'] = CanvasImageLoader	-- I'm pretty sure canvases can't load FITS files
		local Image = require 'image'	-- don't require until after setting image.luajit.png

		-- ... though it could be, right?
		function CanvasImageLoader:save(args) error("save not supported") end

		function CanvasImageLoader:load(fn)
			local jssrc = js.loadImage(path(fn).path)
			local len = jssrc.buffer.byteLength
			-- copy from javascript Uint8Array to our ffi memory
			local dstbuf = ffi.new('char[?]', len)
			ffi.dataToArray('Uint8Array', dstbuf, len):set(jssrc.buffer)
			return {
				data = dstbuf,
				width = jssrc.width,
				height = jssrc.height,
				channels = jssrc.channels,
			}
		end
	end

	-- shim audio TODO
	do
		-- TODO change to browser-based audio
		package.loaded['audio.currentsystem'] = 'null'
		-- TODO provide audio, buffer, source classes
	end

	-- start it as a new thread ...
	-- TODO can I just wrap the whole dofile() in a main thread?
	-- the tradeoff is I'd lose my ability for main coroutine detection ...
	-- or maybe I should shim that function as well ...
	local sdl = require 'ffi.sdl'
	local function run(path, file, ...)
		local fn = '/'..path..'/'..file
		arg[0] = fn
		--dofile(fn)	-- doesn't handle ...
		assert(loadfile(fn))(table.unpack(arg))
	end
	sdl.mainthread = coroutine.create(function()
		run(rundir, runfile)
	end)

	local interval
	local window = js.global
	local function tryToResume()
		--coroutine.assertresume(sdl.mainthread)
		if coroutine.status(sdl.mainthread) == 'dead' then return false, 'dead' end
		local res, err = coroutine.resume(sdl.mainthread)
		if not res then
			print('coroutine.resume failed')
			print(err)
			print(debug.traceback(sdl.mainthread))
			window:clearInterval(interval)
		end
	end

	tryToResume()

	-- set up main loop
	-- TOOD use requestAnimationFrame instead
	interval = window:setInterval(function()
		-- also in SDL_PollEvent, tho I could just route it through GLApp:update ...
		tryToResume()
	end, 10)
end

xpcall(function()	-- wasmoon has no error handling ... just says "ERROR:ERROR"
	shim()
end, function(err)
	print(err)
	print(debug.traceback())
end)
`);
};

if (runfile && rundir) {

	// push initial state ...
	const newParams = new URLSearchParams();
	newParams.set('file', runfile);
	newParams.set('dir', rundir);
	newParams.set('args', runargs);
	if (editmode) newParams.set('edit', editmode);
	const url = location.origin + location.pathname + '?' + newParams.toString();
	history.pushState({
		runfile : runfile,
		rundir : rundir,
		runargs : runargs,
	}, document.title, url);

	await doRun();
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
