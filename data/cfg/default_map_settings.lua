-- default settings for maps

-- on every map load, this file will be executed, followed by mapscript.

Map.mapmodelReset()
Map.materialReset()

Map.texture("water", "golgotha/watr1.jpg") -- water surface
Map.texture("1", "golgotha/watr1.jpg")
Map.texture("1", "golgotha/watr1.jpg")
Map.texture("1", "golgotha/watr1.jpg")
Map.texture("1", "golgotha/watr1.jpg")
Map.texture("1", "golgotha/watr1.jpg") -- Need all these, to fill as 'dummies' it appears.

Map.texture("lava", "yo_frankie/generic_lava.png", 0, 0, 0, 2) -- lava surface
Map.texture("1", "yo_frankie/generic_lava.png", 0, 0, 0, 2) -- falling lava

-- texture definitions for the map:
-- texture 0 is hardcoded as the sky

Map.textureReset() -- let's start at texture slot 0
Shader.set("stdworld") -- default world shader
Map.texture("0", "golgotha/watr1.jpg") -- Dummy
Shader.set("stdworld") 
