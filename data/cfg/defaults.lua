-- these default settings get executed whenever "config.cfg" is not available
-- do not modify anything below, instead change settings in game, or add to autoexec.cfg

echo("CubeCreate defaults")

invmouse = 0

sensitivity = 3      -- similar number to quake
fov = 100            -- 90 is default in other games

musicvol = 60       -- set higher if you want (max 255)
soundvol = 255      -- sounds average volume is actually set per sound, average 100

gamma = 100          -- set to your liking, 100 = default

fullbrightmodels = 60 -- make player models a bit easier to see

sensitivity = 3      -- similar number to quake
fov = 100            -- 90 is default in other games

musicvol = 60       -- set higher if you want (max 255)
soundvol = 255      -- sounds average volume is actually set per sound, average 100

gamma = 100          -- set to your liking, 100 = default

fullbrightmodels = 60 -- make player models a bit easier to see

-- console

consize = 5            -- console is 5 lines
miniconsize = 5        -- mini-console is 5 lines
miniconwidth = 40      -- mini-console is 40% of screen width
fullconsize = 75       -- full console is 75% of screen height
miniconfilter = 0x300  -- display chat and team chat in mini-console
confilter = math.band(0x2FFF, math.bnot(miniconfilter)) -- don't display other player frags or mini-console stuff in console
fullconfilter = 0xFFFF -- display all messages in full console

-- WSAD

cc.console.binds.add("W", [[cc.console.forward()]])
cc.console.binds.add("S", [[cc.console.backward()]])
cc.console.binds.add("A", [[cc.console.left()]])
cc.console.binds.add("D", [[cc.console.right()]])

cc.console.binds.add("UP", [[cc.console.forward()]])
cc.console.binds.add("DOWN", [[cc.console.backward()]])
cc.console.binds.add("LEFT", [[cc.console.left()]])
cc.console.binds.add("RIGHT", [[cc.console.right()]])

cc.console.binds.add("SPACE", [[cc.console.jump()]])
cc.console.binds.add("MOUSE2", [[cc.console.jump()]])
cc.console.binds.add("MOUSE1", [[CV:run("attack")]])
cc.console.binds.add("MOUSE3", [[CV:run("weapon")]])

cc.console.binds.addspec("MOUSE1", [[CV:run("nextfollow")]])
cc.console.binds.addspec("MOUSE2", [[CV:run("nextfollow -1")]])
cc.console.binds.addspec("MOUSE3", [[CV:run("follow")]])
cc.console.binds.addspec("SPACE", [[CV:run("follow")]])

cc.console.binds.add("TAB", [[CV:run("showscores")]])

cc.console.binds.add("T", [[cc.console.saycommand()]])
--cc.console.binds.add("T", [[cc.console.sayteamcommand()]])
cc.console.binds.add("BACKQUOTE", [[cc.console.saycommand("/")]])
cc.console.binds.add("SLASH", [[cc.console.saycommand("/")]])

cc.console.binds.add("I", [[CV:run("taunt")]])
cc.console.binds.add("E", [[cc.world.edittoggle()]])
cc.console.binds.add("F1", [[cc.world.edittoggle()]])

