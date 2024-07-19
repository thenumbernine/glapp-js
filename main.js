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
		color : '#ffffff',
	},
	events : {
		click : e => {
			editmode = !editmode;
			resize();	// refresh size
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
		dom = createDB();
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

let aceEditor;
let editorPath;
let editorFileNameSpan;
let editorSaveButton;
const editorRun = () => {
	editorSave();			// auto-save before run?
	const parts = editorPath.split('/');
	runfile = parts.pop();
	rundir = parts.join('/');
	runargs = [];	//TODO somewhere ...
	doRun();
};
const editorSave = () => {
	FS.writeFile(editorPath, new TextEncoder().encode(
		aceEditor.getValue()
	), {encoding:'binary'});
	editorSaveButton.setAttribute('disabled', 'disabled');
};
const editorLoad = () => {
	const fileStr = new TextDecoder().decode(FS.readFile(editorPath, {encoding:'binary'}));
	aceEditor.setValue(fileStr);
	aceEditor.clearSelection();
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

		const fileInfo = {
			path : path,
			name : name,
			parentFileInfo : parentFileInfo,
			fileDiv : fileDiv,
			titleDiv : titleDiv,
		};
		fileInfoForPath[path] = fileInfo;

		const pathIsDir = isDir(path);
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
					const fs = FS.readdir(path);
					fs.sort();
					fs.forEach(f => {
						if (f != '.' && f != '..') {
							let chpath = path.substr(-1) == '/' ? path + f : path + '/' + f;
							makeFileDiv(chpath, f, fileInfo);
						}
					});
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
						 // ... ??? what to set the editor path to if we delete the current file?
					}
				},
			},
			appendTo : titleDiv,
			children : [
				Img({
					//src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TpSIVh3YQcchQnSxIleKoVShChVArtOpg8tI/aGJIUlwcBdeCgz+LVQcXZ10dXAVB8AfE2cFJ0UVKvC8ptIjxweV9nPfO4b77AKFZY5rVMwFoum1m0ykxX1gRQ68IIUKVREJmljErSRn4rq97BPh+F+dZ/vf+XANq0WJAQCSeYYZpE68TJzdtg/M+cZRVZJX4nHjcpAaJH7muePzGueyywDOjZi47RxwlFstdrHQxq5ga8RRxTNV0yhfyHquctzhrtTpr98lfGC7qy0tcpxpBGgtYhAQRCuqoogYbcdp1Uixk6Tzl4x92/RK5FHJVwcgxjw1okF0/+B/8nq1Vmkx4SeEU0PviOB+jQGgXaDUc5/vYcVonQPAZuNI7/o0mMP1JeqOjxY6AwW3g4rqjKXvA5Q4w9GTIpuxKQSqhVALez+ibCkDkFuhf9ebWPsfpA5CjWWVugINDYKxM2Ws+7+7rntu/d9rz+wHKUnLK2aV6FwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwc7H3K642YAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAADU0lEQVRYw7WXPWhTURTHf7mmtkn7EtOhZHRQB8GKSqDdJCoq+LFJwUEQREVQnLp2bZeuguCiLW6lFWyt9dFN8Q2lFR3aYkWoX0PVPE3afD2Hd5PXJPe9XGM9y3v38/zvPef87zkhNMVOp2LAWeAEcBQ4ABhyOAOsAAvAC2DaMK2fOvuGNBTvAwaBy0BEE28OGAeGDdNaaQmAnU5FgCHgLtBGa1IARoEhw7Ry2gDsdGovMAn0sjPyBrhgmNaHpgDsdOowMAMk2Vn5Cpw2TGvRF4A8+Utt5dEu95v9pQviC9C//SZEnc0ndZWHr9yka2KWrolZwldu6gJIAlNSl7vPtsEhlc3FyfMQanSV3ecuQjgs/y9Q/rTeqM5xKM89qe89JHUNVk0gQ+1dvbeHB67Sce3GPxl+8/49io8fqKLjoGFaq5UbGFSFWsl6SS77+58AlN8uqbrbpM5rITudigOffUmmu4ddx0/pcFb9/VOafw4b34LIKhmW9OrLcKL3GJFbd1o6fXZjg/L8tN9wBDgrJLf7n+PTR69RLOLYtje2mcPZ9AjOsW0oFr32+sdmGE8K4EgggPfLnue8fkX29vVqe2v8IVvjj7wT375O4fUrb+3acjMAR8LyVfOXYqEmrJz1Na+ZzdaCXV8Dx1GvVct+se1JDXDlsvtt7/D+/ea1d9SuCZaY0PLnTEYSQ7j2hAriqZBTdU0TEYDdFEAh36hIpTxojVoyAlhufgWO2iRBfUE35cmKkGlUsP6860yhXa7FnFxjbuHksrVz8gUdAAtC5nDBAOyKD7TJzfMKkPnaObaWD8wJ4KmkRX8AW1vu6drkc1EqNU4qlWvmVNY0yRunhWFaGWBMy2UjkrEdhQ9U+iJRXaYeM0wrUwnDYflE+mCV9o12QmesGuuiJ4noSXoc0RkjFI3WrAlIVoerGZFhWqsyew3kAZFI0DU1h4jHXZ2XBmi/NOCOxePuWCKhwwOjUieiLiNSPt6l1RXdsKqGYGnVtxxYkrr+LikNdffAnoQegB/fcdR5QENSqkrLe4Fn/yEt/wKcqU/LG94Cw7SWgH4/c7QoS/Lki6q3AAWID0AfMBIYHXql2QjQp6qK/ndxOgaMtFycapTn+4GYojyfA2Z0y/M/2KNNLezvpjsAAAAASUVORK5CYII=',
					src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TpSIVh3YQcchQnSxIleKoVShChVArtOpg8tI/aGJIUlwcBdeCgz+LVQcXZ10dXAVB8AfE2cFJ0UVKvC8ptIjxweV9nPfO4b77AKFZY5rVMwFoum1m0ykxX1gRQ68IIUKVREJmljErSRn4rq97BPh+F+dZ/vf+XANq0WJAQCSeYYZpE68TJzdtg/M+cZRVZJX4nHjcpAaJH7muePzGueyywDOjZi47RxwlFstdrHQxq5ga8RRxTNV0yhfyHquctzhrtTpr98lfGC7qy0tcpxpBGgtYhAQRCuqoogYbcdp1Uixk6Tzl4x92/RK5FHJVwcgxjw1okF0/+B/8nq1Vmkx4SeEU0PviOB+jQGgXaDUc5/vYcVonQPAZuNI7/o0mMP1JeqOjxY6AwW3g4rqjKXvA5Q4w9GTIpuxKQSqhVALez+ibCkDkFuhf9ebWPsfpA5CjWWVugINDYKxM2Ws+7+7rntu/d9rz+wHKUnLK2aV6FwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwgBHitISrQAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAACIElEQVRYw+2WTWsTURSGnzszZmgSdzKSgm5cKGjVCmlFaBCl7vQfdGndSVuwXWkqAdeWqosu6kcFoSCCrkRQzELwKxSTSiP4C0pdFdNMnFwX02DmZqKTZsYvemAW99wz8z5c3nPuCALE12OZx8BZOosn8UL+3K+KhCIkgINKTT9wj63FCEIseTJSLscLedlYGsoLT4FhwosFpFRzz4AzjYWmbJ4m+jjVvND4w/HXAXz+DZoeDdWEw5uPHpG4s2lC/zZsasd9qllCiOfxQr7lhI02xQ+AdMgAb4GBoCbsieD4e/6JLtgGaHtlxeZnMR/dR2QG2pbJwaNs3LlBdeYaCBEegDh5Av3IYbS9ezBzWURm0Fe8MjWBk0rx7cB+5E9AOwaQL17hfCi6MMkkZu6KB6IhLhMJt7dXyoiXr8P1gH1hHKdYaoFoES9/wpyaDuyBdpOwCBxq2YjtIDZ3Hb3P3ZLr63xZW/OKT2Zhw/b7bCleyPd11wV2DXt0zHMSAcVDbEO7Ru32AjjOj1y9TmzxYcfiWwIQQ2nMq5dBb7owNY3KxEXk8f5oAcRQGjM3jdiZdO/W0jLGStn1QyJBZXK8YwitG3F7dAzzUrYriGAAvZY7gBRxqjbYNV8Ieq0QJ2HKQiR9xJuMqUJIa1cgACPQJHxfojp7C7HbwpmZ84orEPr5EcTqKmLpY3gAAPW7i4Fa1Lg5v/0/8H8AvItA641f8jtDCMZ/I7Ih8wAAAABJRU5ErkJggg==',
					height : 14,
				}),
			],
		});

		//new-file button
		if (pathIsDir) {
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
							// TODO sort children?
							setEditorFilePath(newpath);			//auto-open?
						}
					},
				},
				appendTo : titleDiv,
				children : [
					Img({
						src : 'data:image/png;base64,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IlhNUCBDb3JlIDQuNC4wLUV4aXYyIj4KIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+CiAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgIHhtbG5zOkdJTVA9Imh0dHA6Ly93d3cuZ2ltcC5vcmcveG1wLyIKICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIgogICB4bXBNTTpEb2N1bWVudElEPSJnaW1wOmRvY2lkOmdpbXA6NzU4NjMwMGYtNjRmYS00MDMyLTlkYWMtN2IxMTdkOGQyYjgyIgogICB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjAwYTExNjRmLWFiNDgtNGVhMy04NzFhLWU2YmQ2ZWNjNGRkYyIKICAgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjI4ZmViYjVjLTRlMWEtNDAzMC1hODIwLTZjZTg0Y2U2MTA2NyIKICAgZGM6Rm9ybWF0PSJpbWFnZS9wbmciCiAgIEdJTVA6QVBJPSIyLjAiCiAgIEdJTVA6UGxhdGZvcm09IkxpbnV4IgogICBHSU1QOlRpbWVTdGFtcD0iMTcyMTM3NTg4NTExNDc2OCIKICAgR0lNUDpWZXJzaW9uPSIyLjEwLjM4IgogICB0aWZmOk9yaWVudGF0aW9uPSIxIgogICB4bXA6Q3JlYXRvclRvb2w9IkdJTVAgMi4xMCIKICAgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNDowNzoxOVQxMzo1ODowMyswNjowMCIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjQ6MDc6MTlUMTM6NTg6MDMrMDY6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJzYXZlZCIKICAgICAgc3RFdnQ6Y2hhbmdlZD0iLyIKICAgICAgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDo3ZDA3YjY4My1mMjMwLTQ1MjUtOWU5Ni0zZDhhZDc4ZjRjYTQiCiAgICAgIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkdpbXAgMi4xMCAoTGludXgpIgogICAgICBzdEV2dDp3aGVuPSIyMDI0LTA3LTE5VDEzOjU4OjA1KzA2OjAwIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Pihzw7IAAAAGYktHRAD/AP8A/6C9p5MAAAAJcEhZcwAALiMAAC4jAXilP3YAAAAHdElNRQfoBxMHOgWWwytdAAAAGXRFWHRDb21tZW50AENyZWF0ZWQgd2l0aCBHSU1QV4EOFwAAAQlJREFUWMPtlz0OgkAQhR/EwphszUk8B0fwAtzAeAYL76OFVlhoYaW3oKHA5FmwBEGQZXf5S5gpaJjZb+btQAYYrRE+iBOIBFT2F4gdiJXp4fsWh1b5HYRnUjlBxCACEEIxzilBPPQg0rYTRKAR+324JkSuuTAA8PQhshR68uWx2hBmAJGMXldA3NSmwwzg0DAd264BlhIiqgF4dgugMqIlc3v5qjr1BbmGlYUgQtv/AHUJLLzbjwR/bGIAqeb8aWdx1MJJdWC+hIMDLAzjr8PeAQt55zswSoC31ExY1F8UcjcAXORzY7HQLNe5u8WkrvI0Ryxz+n2tZlW+11nRji2X07InMoePsdoHHAdgdUB5RO8AAAAASUVORK5CYII=',
						// white version:
						//src : 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9kT1Iw1AUhU9TpSIVh3YQcchQnSxIleKoVShChVArtOpg8tI/aGJIUlwcBdeCgz+LVQcXZ10dXAVB8AfE2cFJ0UVKvC8ptIjxweV9nPfO4b77AKFZY5rVMwFoum1m0ykxX1gRQ68IIUKVREJmljErSRn4rq97BPh+F+dZ/vf+XANq0WJAQCSeYYZpE68TJzdtg/M+cZRVZJX4nHjcpAaJH7muePzGueyywDOjZi47RxwlFstdrHQxq5ga8RRxTNV0yhfyHquctzhrtTpr98lfGC7qy0tcpxpBGgtYhAQRCuqoogYbcdp1Uixk6Tzl4x92/RK5FHJVwcgxjw1okF0/+B/8nq1Vmkx4SeEU0PviOB+jQGgXaDUc5/vYcVonQPAZuNI7/o0mMP1JeqOjxY6AwW3g4rqjKXvA5Q4w9GTIpuxKQSqhVALez+ibCkDkFuhf9ebWPsfpA5CjWWVugINDYKxM2Ws+7+7rntu/d9rz+wHKUnLK2aV6FwAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gHEwc3CSrbGTsAAAAZdEVYdENvbW1lbnQAQ3JlYXRlZCB3aXRoIEdJTVBXgQ4XAAABDUlEQVRYw+2XvQ3CQAxGbUSBkFJnEubICCzABogZKNgHCqhCAQUVbEFDAeLRGBSdEgh3RwgSX5Mm/vL8cxdZpK0CMmABnKmvAzAB+qEfnxKmLZCGZA5wAkZAUjNOHYidF4SVHWDkEVv8uB9EoedJAEDqDXF38GzfI9YbIhDgaOGDEohNrdMRCDB7cTrGnwboGcSxAmDvxmgZgIiIqmrES01F5Frm22niVlXVyop2AjPLgTz2P6D2DMR4t5EWPNNvAVjPccvpHLX8pyrwH8KvA3QD49dfnYEYvv8ZaCXAxXqWROx/UvR+BbCy5zBionev5ccWk6rMzeNknllTq1mZpj4r2vzN5dTV2TwyaatuIK7QHQReoFwAAAAASUVORK5CYII=',
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
			A({
				href : '#',
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

			editorFileNameSpan = Span({
				style : {
					paddingLeft : '5px',
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
	aceEditor.setTheme("ace/theme/tomorrow_night_bright");
	const LuaMode = ace.require("ace/mode/lua").Mode;
	aceEditor.session.setMode(new LuaMode());
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
		titleBarDiv.style.width = (taFrac * w - 2) + 'px';	// minus 1px padding x2
		titleBarDiv.style.height = '20px';

		taDiv.style.display = 'block';
		taDiv.style.left = (fsFrac * w) + 'px';
		taDiv.style.top = '24px';
		taDiv.style.width = (taFrac * w) + 'px';
		taDiv.style.height = (h - 24) + 'px';

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
			window.canvas = canvas;			// global?  do I really need it? debugging?
			resize();	// set our initial size
			return canvas;
		},

		// these functions should have been easy to do in lua ...
		// ... but wasmoon has some kind of lua-syntax within some internally run code for wrappers to js objects ... bleh
		jsglInit : (gl_) => {
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
end)
`);
};
if (runfile && rundir) {
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
