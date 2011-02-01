-- default settings for maps

-- on every map load, this file will be executed, followed by mapscript.

map.mapmodelreset()

if not EV.skybox then
    EV.skybox = "textures/sky/remus/sky01"
end

map.materialreset()

map.texture("water", "textures/core/water.png") -- water
map.texture("1", "textures/core/water.png") -- waterfall
map.texture("1", "textures/core/watern.png") -- water normalmap
map.texture("1", "textures/core/waterd.png") -- water dudv
map.texture("1", "textures/core/watern.png") -- waterfall normalmap
map.texture("1", "textures/core/waterd.png") -- waterfall dudv

map.texture("lava", "textures/core/lava.png",  0, 0, 0, 2) -- lava
map.texture("1",    "textures/core/lava.png", 0, 0, 0, 2) -- falling lava

map.texturereset() -- let's start at texture slot 0

shader.set("stdworld") -- default world shader

map.texture("0", "textures/core/defsky.png") -- fallback sky
map.texture("0", "textures/core/256.png") -- fallback geometry
map.texture("0", "textures/core/256.png")
map.texture("0", "textures/core/256.png")
map.texture("0", "textures/core/256.png")
map.texture("0", "textures/core/128.png")
map.texture("0", "textures/core/64.png")
map.texture("0", "textures/core/32.png")
map.texture("0", "textures/core/16.png")
map.texture("0", "textures/core/8.png")
map.texture("0", "textures/core/256i.png")
map.texture("0", "textures/core/128i.png")
map.texture("0", "textures/core/64i.png")
map.texture("0", "textures/core/32i.png")
map.texture("0", "textures/core/16i.png")
map.texture("0", "textures/core/8i.png")

shader.set("stdworld")
