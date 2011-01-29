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

Console.binds.add("W", [[CV:run("forward")]])
Console.binds.add("S", [[CV:run("backward")]])
Console.binds.add("A", [[CV:run("left")]])
Console.binds.add("D", [[CV:run("right")]])

Console.binds.add("UP", [[CV:run("forward")]])
Console.binds.add("DOWN", [[CV:run("backward")]])
Console.binds.add("LEFT", [[CV:run("left")]])
Console.binds.add("RIGHT", [[CV:run("right")]])

Console.binds.add("SPACE", [[CV:run("jump")]])
Console.binds.add("MOUSE2", [[CV:run("jump")]])
Console.binds.add("MOUSE1", [[CV:run("attack")]])
Console.binds.add("MOUSE3", [[CV:run("weapon")]])

Console.binds.addSpec("MOUSE1", [[CV:run("nextfollow")]])
Console.binds.addSpec("MOUSE2", [[CV:run("nextfollow -1")]])
Console.binds.addSpec("MOUSE3", [[CV:run("follow")]])
Console.binds.addSpec("SPACE", [[CV:run("follow")]])

Console.binds.add("TAB", [[CV:run("showscores")]])

Console.binds.add("T", [[Console.sayCommand()]])
--Console.binds.add("T", [[Console.sayTeamCommand()]])
Console.binds.add("BACKQUOTE", [[Console.sayCommand("/")]])
Console.binds.add("SLASH", [[Console.sayCommand("/")]])

Console.binds.add("I", [[CV:run("taunt")]])
Console.binds.add("E", [[CV:run([=[ if (< (getmode) 0) [ echo "^f3Please press F1 to enter editmode from a local game" ] [ edittoggle ] ]=])]])
Console.binds.add("F1", [[CV:run("edittoggle")]])

CV:run([[
bind KP_MINUS "conskip 5"
bind KP_PLUS "conskip -1000"

bindvar PAUSE paused

bind F11 "toggleconsole"
bind F12 "screenshot"

bind INSERT "addbot"
bind DELETE "delbot"

//////////////////////////////////
// universal scrollwheel + modifier commands:

defaultmodifier = 0
modifier = $defaultmodifier
domodifier = [ modifier = $arg1; onrelease [ modifier = $defaultmodifier ] ]

universaldelta = [
  do [delta_@(if $editing [ result edit ] [ result game ])_@modifier @arg1]
]

bind MOUSE4 [ universaldelta 1 ]	// also used for editing, see below
bind MOUSE5 [ universaldelta -1 ]

//////////////////////////////////

delta_game_0 = [ if (= $arg1 1) [ weapon 2 3 5 4 1 6 0 ] [ weapon 4 1 6 2 3 5 0 ] ]

//zfov = 120
//delta_game_1 = [
//  zfov = (+ $zfov (* $arg1 (div $zfov -5)))
//  if (< $zfov 10)  [ zfov = 10 ]
//  if (> $zfov 120) [ zfov = 120 ]
//  fov $zfov
//]

//bind G [ domodifier 1 ]

bind G [ togglezoom ]
bind Z [ togglezoom ]

//////////////////////////////////
// Sauerbraten Editing related bindings
// found in autoexec.cfg in your sauerbraten directory

editbind SPACE  [ cancelsel ]
editbind MOUSE1 [ if $blendpaintmode [paintblendmap] [editdrag] ]
editbind MOUSE3 [ selcorners ]
editbind MOUSE2 [ if $blendpaintmode [rotateblendbrush] [editextend] ]

//editbind J [ gotosel ]

editbind KP_ENTER [ entselect insel ]
editbind N        [ selentfindall ]

editbind    LSHIFT  [ editcut ]
editbindmod LCTRL   [ passthrough ]
editbindmod LALT    [ hmapedit ]
editbind DELETE     [ editdel ]

editbind T [ saycommand ]
editbind X [ editflip ]
editbind C [ editcopy ]
editbind V [ editpaste ]
editbind Z [ undo; passthroughsel 0]
editbind U [ undo; passthroughsel 0]
editbind I [ redo ]
editbind H [ if $hmapedit [ editface 1 -1 ] [ hmapedit 1 ] ]

editbindvar 5 hidehud
editbindvar 6 entselsnap
editbindvar 7 outline
editbindvar 8 wireframe
bindvar 9 thirdperson
editbindvar 0 allfaces
editbind K calclight
editbindvar L fullbright
editbindvar M showmat

editbind PERIOD selentedit

editbind F2 showtexgui
editbind F3 [if (cleargui 1) [] [showentgui] ]
editbind F4 [if (cleargui 1) [] [showgui mapmodels] ]
editbind F5 savemap
editbind F6 [ notepad (mapcfgname) ]
editbind F9 [echo (getseltex) : (gettexname (getseltex))]

// commands below are used with scroll wheel (and universaldelta).
// if you have no scroll wheel or don't want to use it,
// you can either change the binds of universaldelta
// ex:  bind MOUSE4 [ universaldelta 1 ]
//      bind MOUSE5 [ universaldelta -1 ]
// can be changed to:
//      bind PAGEUP [ universaldelta 1 ]
//      bind PAGEDOWN [ universaldelta -1 ]
// so that the PAGEUP and PAGEDOWN key act just like a scroll wheel
//
// or you can rebind all the commands to seperate keys
// ex:  bind T [ domodifier 6 ]
// can be changed to:
//      bind HOME [ edittex 1 ]
//      bind END [ edittex -1 ]


editbind G [ domodifier 1 ] // domodifier 1 -> executes delta_edit_1
editbind F [ domodifier 2 ] // etc...
editbind Q [ domodifier 3 ]
editbind R [ domodifier 4 ]
editbind Y [ domodifier 6 ]
editbind B [ domodifier 9; brushcopy = 0; ]
editbind COMMA  [ domodifier 10; onrelease entautoview ]

delta_edit_0 = [
    if $blendpaintmode [
        scrollblendbrush $arg1
    ] [
        editfacewentpush $arg1 1 // Fill and Empty cube
    ]
]
delta_edit_1 = [ gridpower (+ $arg1 $gridpower) ]
delta_edit_2 = [ editfacewentpush $arg1 0 ] // push face/corners selected
delta_edit_3 = [ editfacewentpush $arg1 2 ] // push corner pointed at by cursor
delta_edit_4 = [ editrotate $arg1 ] // rotate 90 degrees
delta_edit_5 = [ entproperty 0 $arg1 ]  // and the others
delta_edit_6 = [ edittex $arg1 ] // change textures
delta_edit_9 = [ selectbrush $arg1 ] // change heightmap brushes
delta_edit_10 = [ entautoview $arg1 ]

editbind 1 [ domodifier 11 ]
editbind 2 [ domodifier 12 ]
editbind 3 [ domodifier 13 ]
editbind 4 [ domodifier 14 ]

editbind 5 [ domodifier 15 ] // vSlot: offset H
editbind 6 [ domodifier 16 ] // vSlot: offset V
editbind 7 [ domodifier 17 ] // vSlot: rotate
editbind 8 [ domodifier 18 ] // vSlot: scale

delta_edit_11 = [ entproperty 0 (* $arg1 $multiplier) ]
delta_edit_12 = [ entproperty 1 (* $arg1 $multiplier) ]
delta_edit_13 = [ entproperty 2 (* $arg1 $multiplier) ]
delta_edit_14 = [ entproperty 3 (* $arg1 $multiplier) ]

delta_edit_15 = [ vdelta [voffset (* $arg1 $multiplier2) 0] ] // vSlot: offset H
delta_edit_16 = [ vdelta [voffset 0 (* $arg1 $multiplier2)] ] // vSlot: offset V
delta_edit_17 = [ vdelta [vrotate $arg1] ] // vSlot: rotate
delta_edit_18 = [ vdelta [vscale (if (< $arg1 0) 0.5 2)] ] // vSlot: scale
 
editbind LALT [multiplier = 10;onrelease [multiplier = 1] ]
editbind RALT [multiplier2 = 32;onrelease [multiplier2 = 1] ]
multiplier = 1
multiplier2 = 1

//Blendmap Painting
editbind KP0 [setblendpaintmode 0]
editbind KP1 [setblendpaintmode 1]
editbind KP2 [setblendpaintmode 2]
editbind KP3 [setblendpaintmode 3]
editbind KP4 [setblendpaintmode 4]
editbind KP5 [setblendpaintmode 5]

editbind KP8 [scrollblendbrush -1]
editbind KP9 [scrollblendbrush 1]

bind MOUSE1 [ mouse1click ]
bind MOUSE2 [ mouse2click ]
bind MOUSE3 [ mouse3click ]

bind H [ actionkey0 ] // By convention, a 'help' dialog should appear

bind 1 [ actionkey1 ]
bind 2 [ actionkey2 ]
bind 3 [ actionkey3 ]
bind 4 [ actionkey4 ]
bind 5 [ actionkey5 ]
bind 6 [ actionkey6 ]
bind 7 [ actionkey7 ]
bind 8 [ actionkey8 ]

bind Y [ actionkey9 ]
bind U [ actionkey10 ]
bind I [ actionkey11 ]
bind O [ actionkey12 ]
bind P [ actionkey13 ]
bind J [ actionkey14 ]
bind K [ actionkey15 ]
bind L [ actionkey16 ]

bind F [ actionkey17 ]
// etc.;

bind M mouselook // for an rpg-style control system
editbind M mouselook // for an rpg-style control system
editbindvar O showmat // Move showmat to 'O'

//bind V characterview // view character, for editing appearance etc. // No need - use thirdperson 2

//bind LEFT turn_left
//bind RIGHT turn_right
bind PAGEDOWN look_up
bind PAGEUP look_down

delta_game_0 = [ if (= $arg1 1) [ dec_camera ] [ inc_camera ] ]

editbind MOUSE2 [ editextend_intensity ]

//Blendmap Painting integration with / movement - overrides for sauer defaults
editbind KP0 [ if $blendpaintmode [setblendpaintmode 0] [setblendpaintmode 1] ] // Toggle blend mode

bind KP1 [ if $blendpaintmode [setblendpaintmode 0] [left] ]
bind KP2 [ if $blendpaintmode [setblendpaintmode 1] [backward] ]
bind KP3 [ if $blendpaintmode [setblendpaintmode 2] [right] ]
bind KP4 [ if $blendpaintmode [setblendpaintmode 3] [turn_left] ]
bind KP6 turn_right
bind KP8 [ if $blendpaintmode [scrollblendbrush -1] [forward] ]

editbind KP1 [ if $blendpaintmode [setblendpaintmode 0] [left] ]
editbind KP2 [ if $blendpaintmode [setblendpaintmode 1] [backward] ]
editbind KP3 [ if $blendpaintmode [setblendpaintmode 2] [right] ]
editbind KP4 [ if $blendpaintmode [setblendpaintmode 3] [turn_left] ]
editbind KP6 turn_right
editbind KP8 [ if $blendpaintmode [scrollblendbrush -1] [forward] ]

editbind F7 [ actionkey0 ]

sayteamcommand = [ echo "Team chat not yet implemented" ]

grassheight 10

editbind P [ centerent ]
]])
