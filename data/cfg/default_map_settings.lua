-- default settings for maps

-- on every map load, this file will be executed, followed by mapscript.

Map.mapmodelReset()

if not EV.skybox then
    EV.skybox = "textures/sky/remus/sky01"
end

Map.materialReset()

Map.texture("water", "textures/core/water.png") -- water
Map.texture("1", "textures/core/water.png") -- waterfall
Map.texture("1", "textures/core/watern.png") -- water normalmap
Map.texture("1", "textures/core/waterd.png") -- water dudv
Map.texture("1", "textures/core/watern.png") -- waterfall normalmap
Map.texture("1", "textures/core/waterd.png") -- waterfall dudv

Map.texture("lava", "textures/core/lava.png",  0, 0, 0, 2) -- lava
Map.texture("1",    "textures/core/lava.png", 0, 0, 0, 2) -- falling lava

Map.textureReset() -- let's start at texture slot 0

Shader.set("stdworld") -- default world shader

Map.texture("0", "textures/core/defsky.png") -- fallback sky
Map.texture("0", "textures/core/256.png") -- fallback geometry
Map.texture("0", "textures/core/256.png")
Map.texture("0", "textures/core/256.png")
Map.texture("0", "textures/core/256.png")
Map.texture("0", "textures/core/128.png")
Map.texture("0", "textures/core/64.png")
Map.texture("0", "textures/core/32.png")
Map.texture("0", "textures/core/16.png")
Map.texture("0", "textures/core/8.png")
Map.texture("0", "textures/core/256i.png")
Map.texture("0", "textures/core/128i.png")
Map.texture("0", "textures/core/64i.png")
Map.texture("0", "textures/core/32i.png")
Map.texture("0", "textures/core/16i.png")
Map.texture("0", "textures/core/8i.png")

Shader.set("stdworld")
