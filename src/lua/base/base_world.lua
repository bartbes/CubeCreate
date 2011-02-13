---
-- base_world.lua, version 1<br/>
-- World (map, entity interface, vslots, ..) interface for Lua<br/>
-- <br/>
-- @author q66 (quaker66@gmail.com)<br/>
-- license: MIT/X11<br/>
-- <br/>
-- @copyright 2011 CubeCreate project<br/>
-- <br/>
-- Permission is hereby granted, free of charge, to any person obtaining a copy<br/>
-- of this software and associated documentation files (the "Software"), to deal<br/>
-- in the Software without restriction, including without limitation the rights<br/>
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell<br/>
-- copies of the Software, and to permit persons to whom the Software is<br/>
-- furnished to do so, subject to the following conditions:<br/>
-- <br/>
-- The above copyright notice and this permission notice shall be included in<br/>
-- all copies or substantial portions of the Software.<br/>
-- <br/>
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR<br/>
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,<br/>
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE<br/>
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER<br/>
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,<br/>
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN<br/>
-- THE SOFTWARE.
--

local CAPI = require("CAPI")

--- World module (map, entities, vslots etc.) for cC's Lua interface.
-- @class module
-- @name cc.world
module("cc.world")

---
-- @class function
-- @name iscolliding
iscolliding = CAPI.iscolliding
---
-- @class function
-- @name setgravity
setgravity = CAPI.setgravity
---
-- @class function
-- @name getmat
getmat = CAPI.getmat
---
-- @class function
-- @name entautoview
entautoview = CAPI.entautoview
---
-- @class function
-- @name entflip
entflip = CAPI.entflip
---
-- @class function
-- @name entrotate
entrotate = CAPI.entrotate
---
-- @class function
-- @name entpush
entpush = CAPI.entpush
---
-- @class function
-- @name attachent
attachent = CAPI.attachent
---
-- @class function
-- @name newent
newent = CAPI.newent
---
-- @class function
-- @name delent
delent = CAPI.delent
---
-- @class function
-- @name dropent
dropent = CAPI.dropent
---
-- @class function
-- @name entcopy
entcopy = CAPI.entcopy
---
-- @class function
-- @name entpaste
entpaste = CAPI.entpaste
---
-- @class function
-- @name enthavesel
enthavesel = CAPI.enthavesel
---
-- @class function
-- @name entselect
entselect = CAPI.entselect
---
-- @class function
-- @name entloop
entloop = CAPI.entloop
---
-- @class function
-- @name insel
insel = CAPI.insel
---
-- @class function
-- @name entget
entget = CAPI.entget
---
-- @class function
-- @name entindex
entindex = CAPI.entindex
---
-- @class function
-- @name entset
entset = CAPI.entset
---
-- @class function
-- @name nearestent
nearestent = CAPI.nearestent
---
-- @class function
-- @name intensityentcopy
intensityentcopy = CAPI.intensityentcopy
---
-- @class function
-- @name intensitypasteent
intensitypasteent = CAPI.intensitypasteent
---
-- @class function
-- @name newmap
newmap = CAPI.newmap
---
-- @class function
-- @name mapenlarge
mapenlarge = CAPI.mapenlarge
---
-- @class function
-- @name shrinkmap
shrinkmap = CAPI.shrinkmap
---
-- @class function
-- @name mapname
mapname = CAPI.mapname
---
-- @class function
-- @name finish_dragging
finish_dragging = CAPI.finish_dragging
---
-- @class function
-- @name mapcfgname
mapcfgname = CAPI.mapcfgname
---
-- @class function
-- @name writeobj
writeobj = CAPI.writeobj
---
-- @class function
-- @name getmapversion
getmapversion = CAPI.getmapversion
---
-- @class function
-- @name edittoggle
edittoggle = CAPI.edittoggle
---
-- @class function
-- @name entcancel
entcancel = CAPI.entcancel
---
-- @class function
-- @name cubecancel
cubecancel = CAPI.cubecancel
---
-- @class function
-- @name cancelsel
cancelsel = CAPI.cancelsel
---
-- @class function
-- @name reorient
reorient = CAPI.reorient
---
-- @class function
-- @name selextend
selextend = CAPI.selextend
---
-- @class function
-- @name havesel
havesel = CAPI.havesel
---
-- @class function
-- @name clearundos
clearundos = CAPI.clearundos
---
-- @class function
-- @name copy
copy = CAPI.copy
---
-- @class function
-- @name pastehilite
pastehilite = CAPI.pastehilite
---
-- @class function
-- @name paste
paste = CAPI.paste
---
-- @class function
-- @name undo
undo = CAPI.undo
---
-- @class function
-- @name redo
redo = CAPI.redo
---
-- @class function
-- @name clearbrush
clearbrush = CAPI.clearbrush
---
-- @class function
-- @name brushvert
brushvert = CAPI.brushvert
---
-- @class function
-- @name hmapcancel
hmapcancel = CAPI.hmapcancel
---
-- @class function
-- @name hmapselect
hmapselect = CAPI.hmapselect
---
-- @class function
-- @name pushsel
pushsel = CAPI.pushsel
---
-- @class function
-- @name editface
editface = CAPI.editface
---
-- @class function
-- @name delcube
delcube = CAPI.delcube
---
-- @class function
-- @name compactvslosts
compactvslosts = CAPI.compactvslosts
---
-- @class function
-- @name fixinsidefaces
fixinsidefaces = CAPI.fixinsidefaces
---
-- @class function
-- @name vdelta
vdelta = CAPI.vdelta
---
-- @class function
-- @name vrotate
vrotate = CAPI.vrotate
---
-- @class function
-- @name voffset
voffset = CAPI.voffset
---
-- @class function
-- @name vscroll
vscroll = CAPI.vscroll
---
-- @class function
-- @name vscale
vscale = CAPI.vscale
---
-- @class function
-- @name vlayer
vlayer = CAPI.vlayer
---
-- @class function
-- @name valpha
valpha = CAPI.valpha
---
-- @class function
-- @name vcolor
vcolor = CAPI.vcolor
---
-- @class function
-- @name vreset
vreset = CAPI.vreset
---
-- @class function
-- @name vshaderparam
vshaderparam = CAPI.vshaderparam
---
-- @class function
-- @name replace
replace = CAPI.replace
---
-- @class function
-- @name replacesel
replacesel = CAPI.replacesel
---
-- @class function
-- @name flip
flip = CAPI.flip
---
-- @class function
-- @name rotate
rotate = CAPI.rotate
---
-- @class function
-- @name editmat
editmat = CAPI.editmat
---
-- @class function
-- @name npcadd
npcadd = CAPI.npcadd
---
-- @class function
-- @name npcdel
npcdel = CAPI.npcdel
---
-- @class function
-- @name save_mouse_pos
save_mouse_pos = CAPI.save_mouse_pos
---
-- @class function
-- @name getentclass
getentclass = CAPI.getentclass
---
-- @class function
-- @name prepareentityclasses
prepareentityclasses = CAPI.prepareentityclasses
---
-- @class function
-- @name numentityclasses
numentityclasses = CAPI.numentityclasses
---
-- @class function
-- @name spawnent
spawnent = CAPI.spawnent
---
-- @class function
-- @name debugoctree
debugoctree = CAPI.debugoctree
---
-- @class function
-- @name centerent
centerent = CAPI.centerent
---
-- @class function
-- @name requestprivedit
requestprivedit = CAPI.requestprivedit
---
-- @class function
-- @name hasprivedit
hasprivedit = CAPI.hasprivedit
---
-- @class function
-- @name resetlightmaps
resetlightmaps = CAPI.resetlightmaps
---
-- @class function
-- @name calclight
calclight = CAPI.calclight
---
-- @class function
-- @name patchlight
patchlight = CAPI.patchlight
---
-- @class function
-- @name clearlightmaps
clearlightmaps = CAPI.clearlightmaps
---
-- @class function
-- @name dumplms
dumplms = CAPI.dumplms
---
-- @class function
-- @name recalc
recalc = CAPI.recalc
---
-- @class function
-- @name printcube
printcube = CAPI.printcube
---
-- @class function
-- @name remip
remip = CAPI.remip
---
-- @class function
-- @name phystest
phystest = CAPI.phystest
---
-- @class function
-- @name genpvs
genpvs = CAPI.genpvs
---
-- @class function
-- @name testpvs
testpvs = CAPI.testpvs
---
-- @class function
-- @name clearpvs
clearpvs = CAPI.clearpvs
---
-- @class function
-- @name pvsstats
pvsstats = CAPI.pvsstats
---
-- @class function
-- @name editing_getworldsize
editing_getworldsize = CAPI.editing_getworldsize
---
-- @class function
-- @name editing_getgridsize
editing_getgridsize = CAPI.editing_getgridsize
---
-- @class function
-- @name editing_erasegeometry
editing_erasegeometry = CAPI.editing_erasegeometry
---
-- @class function
-- @name editing_createcube
editing_createcube = CAPI.editing_createcube
---
-- @class function
-- @name editing_deletecube
editing_deletecube = CAPI.editing_deletecube
---
-- @class function
-- @name editing_setcubetex
editing_setcubetex = CAPI.editing_setcubetex
---
-- @class function
-- @name editing_setcubemat
editing_setcubemat = CAPI.editing_setcubemat
---
-- @class function
-- @name editing_pushcubecorner
editing_pushcubecorner = CAPI.editing_pushcubecorner
---
-- @class function
-- @name editing_getselent
editing_getselent = CAPI.editing_getselent
---
-- @class function
-- @name restart_map
restart_map = CAPI.restart_map
