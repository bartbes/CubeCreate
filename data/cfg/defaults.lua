-- these default settings get executed whenever "config.cfg" is not available
-- do not modify anything below, instead change settings in game, or add to autoexec.cfg

echo("CubeCreate defaults")

EV.invmouse = 0

EV.sensitivity = 3      -- similar number to quake
EV.fov = 100            -- 90 is default in other games

EV.musicvol = 60       -- set higher if you want (max 255)
EV.soundvol = 255      -- sounds average volume is actually set per sound, average 100

EV.gamma = 100          -- set to your liking, 100 = default

EV.fullbrightmodels = 60 -- make player models a bit easier to see

EV.sensitivity = 3      -- similar number to quake
EV.fov = 100            -- 90 is default in other games

EV.musicvol = 60       -- set higher if you want (max 255)
EV.soundvol = 255      -- sounds average volume is actually set per sound, average 100

EV.gamma = 100          -- set to your liking, 100 = default

EV.fullbrightmodels = 60 -- make player models a bit easier to see

-- console

EV.consize = 5            -- console is 5 lines
EV.miniconsize = 5        -- mini-console is 5 lines
EV.miniconwidth = 40      -- mini-console is 40% of screen width
EV.fullconsize = 75       -- full console is 75% of screen height
EV.miniconfilter = 0x300  -- display chat and team chat in mini-console
EV.confilter = math.band(0x2FFF, math.bnot(EV.miniconfilter)) -- don't display other player frags or mini-console stuff in console
EV.fullconfilter = 0xFFFF -- display all messages in full console

-- WSAD

console.binds.add("W", [[Movement.forward()]])
console.binds.add("S", [[Movement.backward()]])
console.binds.add("A", [[Movement.left()]])
console.binds.add("D", [[Movement.right()]])

console.binds.add("UP", [[Movement.forward()]])
console.binds.add("DOWN", [[Movement.backward()]])
console.binds.add("LEFT", [[Movement.left()]])
console.binds.add("RIGHT", [[Movement.right()]])

console.binds.add("SPACE", [[Movement.jump()]])
console.binds.add("MOUSE2", [[Movement.jump()]])
console.binds.add("MOUSE1", [[CV:run("attack")]])
console.binds.add("MOUSE3", [[CV:run("weapon")]])

console.binds.addspec("MOUSE1", [[CV:run("nextfollow")]])
console.binds.addspec("MOUSE2", [[CV:run("nextfollow -1")]])
console.binds.addspec("MOUSE3", [[CV:run("follow")]])
console.binds.addspec("SPACE", [[CV:run("follow")]])

console.binds.add("TAB", [[CV:run("showscores")]])

console.binds.add("T", [[console.saycommand()]])
--console.binds.add("T", [[console.sayteamcommand()]])
console.binds.add("BACKQUOTE", [[console.saycommand("/")]])
console.binds.add("SLASH", [[console.saycommand("/")]])

console.binds.add("I", [[CV:run("taunt")]])
console.binds.add("E", [[CV:run([=[ if (< (getmode) 0) [ echo "^f3Please press F1 to enter editmode from a local game" ] [ edittoggle ] ]=])]])
console.binds.add("F1", [[CV:run("edittoggle")]])

