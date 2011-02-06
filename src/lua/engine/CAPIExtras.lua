-- CAPI extras for CubeCreate's Lua implementation
-- provides various additional functions, tables etc.

-- setters

function CAPI.setextent0(self, vec)
    log(DEBUG, string.format("CAPI.setExtent0: %f,%f,%f", vec.x, vec.y, vec.z))
    CAPI.setextent0_raw(self, vec.x, vec.y, vec.z)
end

function CAPI.setdynent0(self, vec)
    log(DEBUG, string.format("CAPI.setDynent0: %f,%f,%f", vec.x, vec.y, vec.z))
    CAPI.setdynent0_raw(self, vec.x, vec.y, vec.z)
end

function CAPI.setdynentvel(self, vec)
    CAPI.setdynentvel_raw(self, vec.x, vec.y, vec.z)
end

function CAPI.setdynentfalling(self, vec)
    CAPI.setdynentfalling_raw(self, vec.x, vec.y, vec.z)
end

-- getters

function CAPI.getextent0(self)
    local vec = { CAPI.getextent0_raw(self, 0),
            CAPI.getextent0_raw(self, 1),
            CAPI.getextent0_raw(self, 2) }

    log(INFO, string.format("CAPI.getExtent0: %s", JSON.encode(vec)))

    return vec
end

function CAPI.getdynent0(self)
    return { CAPI.getdynent0_raw(self, 0),
             CAPI.getdynent0_raw(self, 1),
             CAPI.getdynent0_raw(self, 2) }
end

function CAPI.getdynentvel(self)
    return { CAPI.getdynentvel_raw(self, 0),
             CAPI.getdynentvel_raw(self, 1),
             CAPI.getdynentvel_raw(self, 2) }
end

function CAPI.getdynentfalling(self)
    return { CAPI.getdynentfalling_raw(self, 0),
             CAPI.getdynentfalling_raw(self, 1),
             CAPI.getdynentfalling_raw(self, 2) }
end

function CAPI.setattachments(self, attachments)
    CAPI.setattachments_raw(self, table.concat(attachments, '|')) -- give python the format it wants
end

-- DEBUG stuff

local osetmodeln = CAPI.setmodelname;
function CAPI.setmodelname(self, model)
    log(DEBUG, "CAPI.setmodelname: " .. model .. "(" .. type(model) .. "), self=" .. tostring(self))
    osetmodeln(self, model)
end

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
    isColliding = function (position, radius, ignore)
        return CAPI.isColliding(position.x, position.y, position.z, radius, ignore and ignore.uniqueId or -1)
    end
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
