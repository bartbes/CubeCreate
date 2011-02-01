-- CAPI extras for CubeCreate's Lua implementation
-- provides various additional functions, tables etc.

-- setters

function CAPI.setExtent0 (self, vec)
	log(DEBUG, string.format("CAPI.setExtent0: %f,%f,%f", vec.x, vec.y, vec.z))
	CAPI.setExtent0_raw(self, vec.x, vec.y, vec.z)
end

function CAPI.setDynent0 (self, vec)
	log(DEBUG, string.format("CAPI.setDynent0: %f,%f,%f", vec.x, vec.y, vec.z))
	CAPI.setDynent0_raw(self, vec.x, vec.y, vec.z)
end

function CAPI.setDynentVel (self, vec)
	CAPI.setDynentVel_raw(self, vec.x, vec.y, vec.z)
end

function CAPI.setDynentFalling (self, vec)
	CAPI.setDynentFalling_raw(self, vec.x, vec.y, vec.z)
end

-- getters

function CAPI.getExtent0 (self)
	local vec = { CAPI.getExtent0_raw(self, 0),
			CAPI.getExtent0_raw(self, 1),
			CAPI.getExtent0_raw(self, 2) }

	log(INFO, string.format("CAPI.getExtent0: %s", JSON.encode(vec)))

	return vec
end

function CAPI.getDynent0 (self)
	return { CAPI.getDynent0_raw(self, 0),
			 CAPI.getDynent0_raw(self, 1),
			 CAPI.getDynent0_raw(self, 2) }
end

function CAPI.getDynentVel (self)
	return { CAPI.getDynentVel_raw(self, 0),
			 CAPI.getDynentVel_raw(self, 1),
			 CAPI.getDynentVel_raw(self, 2) }
end

function CAPI.getDynentFalling (self)
	return { CAPI.getDynentFalling_raw(self, 0),
			 CAPI.getDynentFalling_raw(self, 1),
			 CAPI.getDynentFalling_raw(self, 2) }
end

function CAPI.setAttachments (self, attachments)
	CAPI.setAttachments_raw(self, table.concat(attachments, '|')) -- give python the format it wants
end

-- DEBUG stuff

local oldSetModelName = CAPI.setModelName
function CAPI.setModelName (self, model)
	log(DEBUG, "CAPI.setModelName: " .. model .. "(" .. type(model) .. "), self=" .. tostring(self))
	oldSetModelName(self, model)
end

-- Mapping

Map = {
	textureReset = CAPI.textureReset,

	texture = function (ttype, _name, rot, xoffset, yoffset, scale)
		local rot = defaultValue(rot, 0)
		local xoffset = defaultValue(xoffset, 0)
		local yoffset = defaultValue(yoffset, 0)
		local scale = defaultValue(scale, 1)
		CAPI.texture(ttype, _name, rot, xoffset, yoffset, scale)
	end,

	mapmodelReset = function (n)
		local n = defaultValue(n, 0)
		CAPI.mapmodelReset(n)
	end,

	mapmodel = CAPI.mapmodel,

	autograss = CAPI.autograss,

	texLayer = CAPI.texLayer,
	texAlpha = CAPI.texAlpha,
	texColor = CAPI.texColor,
	texFFenv = CAPI.texFFenv,
	texScroll = CAPI.texScroll,

	materialReset = CAPI.materialReset,

	preloadSound = function (_name, volume)
		local volume = defaultValue(volume, 100)
		CAPI.preloadSound(_name, volume)
	end,

	preloadModel = CAPI.preloadModel,

	convertPNGtoDDS = function (src, dest)
		local dest = defaultValue(dest, string.gsub(src, '.png', '.dds'))
		return CAPI.convertPNGtoDDS(src, dest)
	end,

	combineImages = CAPI.combineImages
}

-- Shaders

Shader = {
	normal = function (stype, name, vertex, fragment)
		vertex = template(vertex);
		fragment = template(fragment);
		CAPI.shader(stype, name, vertex, fragment)
	end,

	variant = function (stype, name, row, vertex, fragment)
		vertex = template(vertex);
		fragment = template(fragment);
		CAPI.shader(stype, name, row, vertex, fragment)
	end,

	set = CAPI.setShader,

	setParam = function (_name, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.setShaderParam(_name, x, y, z, w)
	end,

	setVertexParam = function (i, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.setVertexParam(i, x, y, z, w)
	end,

	setPixelParam = function (i, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.setPixelParam(i, x, y, z, w)
	end,

	setUniformParam = function (_name, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.setUniformParam(_name, x, y, z, w)
	end,

	defVertexParam = function (_name, i, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.defVertexParam(_name, i, x, y, z, w)
	end,

	defPixelParam = function (_name, i, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.defPixelParam(_name, i, x, y, z, w)
	end,

	defUniformParam = function (_name, x, y, z, w)
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.defUniformParam(_name, x, y, z, w)
	end,

	alt = CAPI.altShader,
	fast = CAPI.fastShader,
	defer = function (stype, name, contents)
		contents = template(contents)
		CAPI.deferShader(stype, name, contents)
	end,
	force = CAPI.forceShader,
	isDefined = CAPI.isShaderDefined,
	isNative = CAPI.isShaderNative
}

-- post-effects

PostFX = {
	add = function (name, bind, scale, inputs, x, y, z, w)
		local bind = defaultValue(bind, 0)
		local scale = defaultValue(scale, 0)
		local inputs = defaultValue(inputs, "")
		local x = defaultValue(x, 0)
		local y = defaultValue(y, 0)
		local z = defaultValue(z, 0)
		local w = defaultValue(w, 0)
		CAPI.addPostFX(name, bind, scale, inputs, x, y, z, w)
	end,
	set = CAPI.setPostFX,
	clear = CAPI.clearPostFX
}

-- World

local World_keys = {}
local World_meta = {
	__index = function (self, key)
		return World_keys[key]
	end,

	__newindex = function (self, key, val)
		if key == "gravity" then
			World_keys[key] = val
			CAPI.setGravity(val)
		else
			World_keys[key] = val
		end
	end
}

World = setmetatable({
	isColliding = function (position, radius, ignore)
		return CAPI.isColliding(position.x, position.y, position.z, radius, ignore and ignore.uniqueId or -1)
	end
}, World_meta)

World.gravity = 200.0

-- Libraries

Library = {
	loadedModules = {},

	include = function (_name, force)
		if string.sub(_name, string.len(_name)) == "/" then
			_name = _name .. "Package.lua"
		elseif string.sub(_name, string.len(_name) - 3) ~= ".lua" then
			_name = _name .. ".lua"
		end

		if force or not Library.loadedModules[_name] then
			Library.loadedModules[_name] = true
			log(DEBUG, "Loading library module: " .. _name)
			loadfile(_name)()
		end
	end
}

-- Models

Model = {
	name = CAPI.mdlName,
	shadow = CAPI.modelShadow,
	collide = CAPI.modelCollide,
	perEntityCollisionBoxes = CAPI.modelPerEntityCollisionBoxes,
	ellipseCollide = CAPI.modelEllipseCollide,

	objLoad = CAPI.objLoad,
	objSkin = CAPI.objSkin,
	objBumpmap = function (meshname, normalmap, skin)
		local skin = defaultValue(skin, '')
		CAPI.objBumpmap(meshname, normalmap, skin)
	end,
	objEnvmap = CAPI.objEnvmap,
	objSpec = CAPI.objSpec,
	objPitch = CAPI.objPitch,
	objAmbient = CAPI.objAmbient,
	objGlow = CAPI.objGlow,
	objGlare = CAPI.objGlare,
	objAlphatest = CAPI.objAlphatest,
	objAlphablend = CAPI.objAlphablend,
	objCullface = CAPI.objCullface,
	objFullbright = CAPI.objFullbright,
	objShader = CAPI.objShader,
	objScroll = CAPI.objScroll,
	objNoclip = CAPI.objNoclip,

	alphatest = CAPI.mdlAlphatest,
	bb = CAPI.mdlBb,
	scale = CAPI.mdlScale,
	spec = CAPI.mdlSpec,
	glow = CAPI.mdlGlow,
	glare = CAPI.mdlGlare,
	ambient = CAPI.mdlAmbient,
	shader = CAPI.mdlShader,
	extendbb = CAPI.mdlExtendbb,
	cullface = CAPI.mdlCullface,
	alphablend = CAPI.mdlAlphablend,
	alphadepth = CAPI.mdlAlphadepth,
	depthoffset = CAPI.mdlDepthoffset,
	fullbright = CAPI.mdlFullbright,
	spin = CAPI.mdlSpin,

	collisionsOnlyForTriggering = CAPI.mdlCollisionsOnlyForTriggering,

	trans = CAPI.mdlTrans,

	md5Dir = CAPI.md5Dir,
	md5Load = CAPI.md5Load,

	md5Skin = function (meshname, tex, masks, envmapmax, envmapmin)
		local masks = defaultValue(masks, '')
		CAPI.md5Skin(meshname, tex, masks, envmapmax, envmapmin)
	end,

	yaw = CAPI.modelYaw,
	pitch = CAPI.modelPitch,

	md5Bumpmap = function (meshname, normalmap, skin)
		local skin = defaultValue(skin, '')
		CAPI.md5Bumpmap(meshname, normalmap, skin)
	end,
	md5Envmap = CAPI.md5Envmap,
	md5Alphatest = CAPI.md5Alphatest,
	md5Alphablend = CAPI.md5Alphablend,

	md5Tag = CAPI.md5Tag,
	md5Anim = CAPI.md5Anim,

	md5Animpart = CAPI.md5Animpart,
	md5Pitch = CAPI.md5Pitch,
	md5Adjust = CAPI.md5Adjust,
	md5Spec = CAPI.md5Spec,
	md5Ambient = CAPI.md5Ambient,
	md5Glow = CAPI.md5Glow,
	md5Glare = CAPI.md5Glare,
	md5Cullface = CAPI.md5Cullface,
	md5Fullbright = CAPI.md5Fullbright,
	md5Shader = CAPI.md5Shader,
	md5Scroll = CAPI.md5Scroll,
	md5Link = CAPI.md5Link,
	md5Noclip = CAPI.md5Noclip,

	iqmDir = CAPI.iqmDir,
	iqmLoad = CAPI.iqmLoad,
	iqmTag = CAPI.iqmTag,
	iqmPitch = CAPI.iqmPitch,
	iqmAdjust = CAPI.iqmAdjust,
	iqmSkin = function (meshname, tex, masks, envmapmax, envmapmin)
		local masks = defaultValue(masks, '')
		CAPI.iqmSkin(meshname, tex, masks, envmapmax, envmapmin)
	end,
	iqmSpec = CAPI.iqmSpec,
	iqmAmbient = CAPI.iqmAmbient,
	iqmGlow = CAPI.iqmGlow,
	iqmGlare = CAPI.iqmGlare,
	iqmAlphatest = CAPI.iqmAlphatest,
	iqmAlphablend = CAPI.iqmAlphablend,
	iqmCullface = CAPI.iqmCullface,
	iqmEnvmap = CAPI.iqmEnvmap,
	iqmBumpmap = function (meshname, normalmap, skin)
		local skin = defaultValue(skin, '')
		CAPI.iqmBumpmap(meshname, normalmap, skin)
	end,
	iqmFullbright = CAPI.iqmFullbright,
	iqmShader = CAPI.iqmShader,
	iqmScroll = CAPI.iqmScroll,
	iqmAnimpart = CAPI.iqmAnimpart,
	iqmAnim = CAPI.iqmAnim,
	iqmLink = CAPI.iqmLink,
	iqmNoclip = CAPI.iqmNoclip,

	smdDir = CAPI.smdDir,
	smdLoad = CAPI.smdLoad,
	smdTag = CAPI.smdTag,
	smdPitch = CAPI.smdPitch,
	smdAdjust = CAPI.smdAdjust,
	smdSkin = function (meshname, tex, masks, envmapmax, envmapmin)
		local masks = defaultValue(masks, '')
		CAPI.smdSkin(meshname, tex, masks, envmapmax, envmapmin)
	end,
	smdSpec = CAPI.smdSpec,
	smdAmbient = CAPI.smdAmbient,
	smdGlow = CAPI.smdGlow,
	smdGlare = CAPI.smdGlare,
	smdAlphatest = CAPI.smdAlphatest,
	smdAlphablend = CAPI.smdAlphablend,
	smdCullface = CAPI.smdCullface,
	smdEnvmap = CAPI.smdEnvmap,
	smdBumpmap = function (meshname, normalmap, skin)
		local skin = defaultValue(skin, '')
		CAPI.smdBumpmap(meshname, normalmap, skin)
	end,
	smdFullbright = CAPI.smdFullbright,
	smdShader = CAPI.smdShader,
	smdScroll = CAPI.smdScroll,
	smdAnimpart = CAPI.smdAnimpart,
	smdAnim = CAPI.smdAnim,
	smdLink = CAPI.smdLink,
	smdNoclip = CAPI.smdNoclip,

	rdVert = CAPI.rdVert,
	rdEye = CAPI.rdEye,
	rdTri = CAPI.rdTri,
	rdJoint = CAPI.rdJoint,
	rdLimitDist = CAPI.rdLimitDist,
	rdLimitRot = CAPI.rdLimitRot,
	rdAnimJoints = CAPI.rdAnimJoints,

	envmap = CAPI.mdlEnvmap
}

-- User interface

UserInterface = {
	showMessage = CAPI.showMessage,

	showInputDialog = function (self, content, callback)
		self.inputDialogCallback = callback
		CAPI.showInputDialog(content)
	end
}

-- Network

Network = {
	connect = CAPI.connect
}

-- Colors
-- HSL/HSV functions taken from http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript
-- converted to Lua

Color = {
	--[[
		Converts an RGB color value to HSL. Conversion formula
		adapted from http://en.wikipedia.org/wiki/HSL_color_space.
		Assumes r, g, and b are contained in the set [0, 255] and
		returns h, s, and l in the set [0, 1].
	--]]
	rgbToHsl = function (r, g, b)
		local r = r / 255
		local g = g / 255
		local b = b / 255
		local max = math.max(r, g, b)
		local min = math.min(r, g, b)
		local h = (max + min) / 2
		local s = (max + min) / 2
		local l = (max + min) / 2

		if max == min then
			h = 0
			s = 0
		else
			local d = max - min
			s = l > 0.5 and d / ( 2 - max - min ) or d / ( max + min )
			if max == r then
				h = ( g - b ) / d + g < b and 6 or 0
			elseif max == g then
				h = ( b - r ) / d + 2
			elseif max == b then
				h = ( r - g ) / d + 4
			end
			h = h / 6
		end

		return { h = h, s = s, l = l }
	end,

	--[[
		Converts an HSL color value to RGB. Conversion formula
		adapted from http://en.wikipedia.org/wiki/HSL_color_space.
		Assumes h, s, and l are contained in the set [0, 1] and
		returns r, g, and b in the set [0, 255].
	--]]
	hslToRgb = function (h, s, l)
		local r
		local g
		local b

		if s == 0 then
			r = l
			g = l
			b = l
		else
			function hue2rgb (p, q, t)
				if t < 0 then t = t + 1 end
				if t > 1 then t = t - 1 end
				if t < ( 1 / 6 ) then return p + ( q - p ) * 6 * t end
				if t < ( 1 / 2 ) then return q end
				if t < ( 2 / 3 ) then return p + ( q - p ) * ( 2 / 3 - t ) * 6 end
				return p
			end

			local q = l < 0.5 and l * ( 1 + s ) or l + s - l * s
			local p = 2 * l - q

			r = hue2rgb(p, q, h + 1 / 3)
			g = hue2rgb(p, q, h)
			b = hue2rgb(p, q, h - 1 / 3)
		end

		return { r = r * 255, g = g * 255, b = b * 255 }
	end,

	--[[
		Converts an RGB color value to HSV. Conversion formula
		adapted from http://en.wikipedia.org/wiki/HSV_color_space.
		Assumes r, g, and b are contained in the set [0, 255] and
		returns h, s, and v in the set [0, 1].
	--]]
	rgbToHsv = function (r, g, b)
		local r = r / 255
		local g = g / 255
		local b = b / 255
		local max = math.max(r, g, b)
		local min = math.min(r, g, b)
		local h = max
		local s = max
		local v = max

		local d = max - min
		s = max == 0 and 0 or d / max

		if max == min then
			h = 0
		else
			if max == r then
				h = ( g - b ) / d + g < b and 6 or 0
			elseif max == g then
				h = ( b - r ) / d + 2
			elseif max == b then
				h = ( r - g ) / d + 4
			end
			h = h / 6
		end

		return { h = h, s = s, v = v }
	end,

	--[[
		Converts an HSV color value to RGB. Conversion formula
		adapted from http://en.wikipedia.org/wiki/HSV_color_space.
		Assumes h, s, and v are contained in the set [0, 1] and
		returns r, g, and b in the set [0, 255].
	--]]
	hsvToRgb = function (h, s, v)
		local r
		local g
		local b

		local i = math.floor(h * 6)
		local f = h * 6 - i
		local p = v * ( 1 - s )
		local q = v * ( 1 - f * s )
		local t = v * ( 1 - ( 1 - f ) * s )

		if ( 1 % 6 ) == 0 then
			r = v
			g = t
			b = p
		elseif ( 1 % 6 ) == 1 then
			r = q
			g = v
			b = p
		elseif ( 1 % 6 ) == 2 then
			r = p
			g = v
			b = t
		elseif ( 1 % 6 ) == 3 then
			r = p
			g = q
			b = v
		elseif ( 1 % 6 ) == 4 then
			r = t
			g = p
			b = v
		elseif ( 1 % 6 ) == 5 then
			r = v
			g = p
			b = q
		end

		return { r = r * 255, g = g * 255, b = b * 255 }
	end,

	--[[
		Converts a hexadecimal value into RGB value.
	--]]
	hexToRgb = function (hex)
		local r
		local g
		local b

		local hex = string.format("%X", hex)
		r = tonumber(string.sub(hex, 1, 2), 16)
		g = tonumber(string.sub(hex, 3, 4), 16)
		b = tonumber(string.sub(hex, 5, 6), 16)

		return { r = r, g = g, b = b }
	end,

	--[[
		Converts an RGB array into hexadecimal value.
	--]]
	rgbToHex = function(r, g, b)
		local rgb = math.bor(b, math.lsh(g, 8), math.lsh(r, 16))
		return string.format("0x%X", rgb)
	end
}

-- HUD
local oldShowHUDRect = CAPI.showHUDRect
local oldShowHUDImage = CAPI.showHUDImage

function CAPI.showHUDRect(x1, y1, x2, y2, color, alpha)
	alpha = defaultValue(alpha, 1.0)
	oldShowHUDRect(x1, y1, x2, y2, color, alpha)
end

function CAPI.showHUDImage(tex, centerx, centery, width, height, color, alpha)
	color = defaultValue(color, 0xFFFFFF)
	alpha = defaultValue(alpha, 1.0)
	oldShowHUDImage(tex, centerx, centery, width, height, color, alpha)
end

-- input functions

console = {
	toggle = CAPI.toggleconsole,
	skip = CAPI.conskip,
	miniskip = CAPI.miniconskip,
	clear = CAPI.clearconsole,
	binds = {
		add = CAPI.bind,
		addspec = CAPI.specbind,
		addedit = CAPI.editbind,
		get = CAPI.getbind,
		getspec = CAPI.getspecbind,
		getedit = CAPI.geteditbind,
		search = CAPI.searchbinds,
		searchspec = CAPI.searchspecbinds,
		searchedit = CAPI.searcheditbinds,
	},
	saycommand = CAPI.saycommand,
	inputcommand = CAPI.inputcommand,
	history = CAPI.history,
	onrelease = CAPI.onrelease,
	complete = CAPI.complete,
	listcomplete = CAPI.listcomplete,
	keymap = CAPI.keymap,
}

-- user interface functions

gui = {
	new = CAPI.newgui,
	button = CAPI.guibutton,
	text = CAPI.guitext,
	clear = CAPI.cleargui,
	show = CAPI.showgui,
	onclear = CAPI.guionclear,
	stayopen = CAPI.guistayopen,
	noautotab = CAPI.guinoautotab,
	list = CAPI.guilist,
	align = CAPI.guialign,
	title = CAPI.guititle,
	bar = CAPI.guibar,
	strut = CAPI.guistrut,
	image = CAPI.guiimage,
	slider = CAPI.guislider,
	listslider = CAPI.guilistslider,
	nameslider = CAPI.guinameslider,
	radio = CAPI.guiradio,
	bitfield = CAPI.guibitfield,
	checkbox = CAPI.guicheckbox,
	tab = CAPI.guitab,
	field = CAPI.guifield,
	keyfield = CAPI.guikeyfield,
	editor = CAPI.guieditor,
	color = CAPI.guicolor,
	textbox = CAPI.guitextbox,
	font = function(name, tex, defaultw, defaulth, offsetx, offsety, offsetw, offseth)
		offsetx = defaultValue(offsetx, 0)
		offsety = defaultValue(offsety, 0)
		offsetw = defaultValue(offsetw, 0)
		offseth = defaultValue(offseth, 0)
		CAPI.font(name, tex, defaultw, defaulth, offsetx, offsety, offsetw, offseth)
	end,

	fontoffset = CAPI.fontoffset,

	fontchar = function(x, y, w, h)
		h = defaultValue(h, 0)
		CAPI.fontchar(x, y, w, h)
	end
}

-- Engine functions

engine = {
	quit = CAPI.quit,
	force_quit = CAPI.force_quit,

	screenres = CAPI.screenres,
	resetgl = CAPI.resetgl,
	getfps = CAPI.getfps,

	ssls = CAPI.ssls,

	recalc = CAPI.recalc,
	glext = CAPI.glext
}

-- Lightmap functions

lightmap = {
	resetmaps = CAPI.resetlightmaps,
	calc = CAPI.calclight,
	patch = CAPI.patchlight,
	clearmaps = CAPI.clearlightmaps,
	dumplms = CAPI.dumplms
}

-- Blending functions

blend = {
	brush = {
		clearall = CAPI.clearblendbrushes,
		del = CAPI.delblendbrush,
		add = CAPI.addblendbrush,
		next = CAPI.nextblendbrush,
		set = CAPI.setblendbrush,
		getname = CAPI.getblendbrushName,
		cur = CAPI.curblendbrush,
		rotate = CAPI.rotateblendbrush
	},
	map = {
		paint = CAPI.paintblendmap,
		clearsel = CAPI.clearblendmapsel,
		invertsel = CAPI.invertblendmapsel,
		invert = CAPI.invertblendmap,
		show = CAPI.showblendmap,
		optimize = CAPI.optimizeblendmap,
		clear = CAPI.claerblendmap
	}
}
