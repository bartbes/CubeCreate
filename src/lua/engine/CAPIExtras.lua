-- CAPI extras for CubeCreate's Lua implementation
-- provides various additional functions, tables etc.

-- Mapping

map = {
    texturereset = CAPI.texturereset,

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


-- World

local World_keys = {}
local World_meta = {
    __index = function (self, key)
        return World_keys[key]
    end,

    __newindex = function (self, key, val)
        if key == "gravity" then
            World_keys[key] = val
            CAPI.setgravity(val)
        else
            World_keys[key] = val
        end
    end
}

World = setmetatable({
}, World_meta)

World.gravity = 200.0

-- Network

Network = {
    connect = CAPI.connect
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
