---
-- base_console.lua, version 1<br/>
-- Console, bindings, input etc<br/>
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

--- Console Lua interface. Provides methods for bindings,
-- console commands, input and others.
-- @class module
-- @name cc.console
module("cc.console")

--- Toggle the console.
-- @class function
-- @name toggle
toggle = CAPI.toggleconsole
---
-- @class function
-- @name skip
skip = CAPI.conskip
---
-- @class function
-- @name miniskip
miniskip = CAPI.miniconskip
---
-- @class function
-- @name clear
clear = CAPI.clearconsole
---
-- @class table
-- @name binds
binds = {}
---
-- @class function
-- @name binds.add
binds.add = CAPI.bind
---
-- @class function
-- @name binds.addspec
binds.addspec = CAPI.specbind
---
-- @class function
-- @name binds.addedit
binds.addedit = CAPI.editbind
---
-- @class function
-- @name binds.get
binds.get = CAPI.getbind
---
-- @class function
-- @name binds.getspec
binds.getspec = CAPI.getspecbind
---
-- @class function
-- @name binds.getedit
binds.getedit = CAPI.geteditbind
---
-- @class function
-- @name binds.search
binds.search = CAPI.searchbinds
---
-- @class function
-- @name binds.searchspec
binds.searchspec = CAPI.searchspecbinds
---
-- @class function
-- @name binds.searchedit
binds.searchedit = CAPI.searcheditbinds
---
-- @class function
-- @name say
say = CAPI.say
---
-- @class function
-- @name saycommand
saycommand = CAPI.saycommand
---
-- @class function
-- @name inputcommand
inputcommand = CAPI.inputcommand
---
-- @class function
-- @name history
history = CAPI.history
---
-- @class function
-- @name onrelease
onrelease = CAPI.onrelease
---
-- @class function
-- @name complete
complete = CAPI.complete
---
-- @class function
-- @name listcomplete
listcomplete = CAPI.listcomplete
---
-- @class function
-- @name keymap
keymap = CAPI.keymap
---
-- @class function
-- @name actionkey0
actionkey0 = CAPI.actionkey0
---
-- @class function
-- @name actionkey1
actionkey1 = CAPI.actionkey1
---
-- @class function
-- @name actionkey2
actionkey2 = CAPI.actionkey2
---
-- @class function
-- @name actionkey3
actionkey3 = CAPI.actionkey3
---
-- @class function
-- @name actionkey4
actionkey4 = CAPI.actionkey4
---
-- @class function
-- @name actionkey5
actionkey5 = CAPI.actionkey5
---
-- @class function
-- @name actionkey6
actionkey6 = CAPI.actionkey6
---
-- @class function
-- @name actionkey7
actionkey7 = CAPI.actionkey7
---
-- @class function
-- @name actionkey8
actionkey8 = CAPI.actionkey8
---
-- @class function
-- @name actionkey9
actionkey9 = CAPI.actionkey9
---
-- @class function
-- @name actionkey10
actionkey10 = CAPI.actionkey10
---
-- @class function
-- @name actionkey11
actionkey11 = CAPI.actionkey11
---
-- @class function
-- @name actionkey12
actionkey12 = CAPI.actionkey12
---
-- @class function
-- @name actionkey13
actionkey13 = CAPI.actionkey13
---
-- @class function
-- @name actionkey14
actionkey14 = CAPI.actionkey14
---
-- @class function
-- @name actionkey15
actionkey15 = CAPI.actionkey15
---
-- @class function
-- @name actionkey16
actionkey16 = CAPI.actionkey16
---
-- @class function
-- @name actionkey17
actionkey17 = CAPI.actionkey17
---
-- @class function
-- @name actionkey18
actionkey18 = CAPI.actionkey18
---
-- @class function
-- @name actionkey19
actionkey19 = CAPI.actionkey19
---
-- @class function
-- @name actionkey20
actionkey20 = CAPI.actionkey20
---
-- @class function
-- @name actionkey21
actionkey21 = CAPI.actionkey21
---
-- @class function
-- @name actionkey22
actionkey22 = CAPI.actionkey22
---
-- @class function
-- @name actionkey23
actionkey23 = CAPI.actionkey23
---
-- @class function
-- @name actionkey24
actionkey24 = CAPI.actionkey24
---
-- @class function
-- @name actionkey25
actionkey25 = CAPI.actionkey25
---
-- @class function
-- @name actionkey26
actionkey26 = CAPI.actionkey26
---
-- @class function
-- @name actionkey27
actionkey27 = CAPI.actionkey27
---
-- @class function
-- @name actionkey28
actionkey28 = CAPI.actionkey28
---
-- @class function
-- @name actionkey29
actionkey29 = CAPI.actionkey29
---
-- @class function
-- @name iskeydown
iskeydown = CAPI.iskeydown
---
-- @class function
-- @name iskeyup
iskeyup = CAPI.iskeyup
---
-- @class function
-- @name ismousedown
ismousedown = CAPI.ismousedown
---
-- @class function
-- @name ismouseup
ismouseup = CAPI.ismouseup
---
-- @class function
-- @name mouse1click
mouse1click = CAPI.mouse1click
---
-- @class function
-- @name mouse2click
mouse2click = CAPI.mouse2click
---
-- @class function
-- @name mouse3click
mouse3click = CAPI.mouse3click
---
-- @class function
-- @name turn_left
turn_left = CAPI.turn_left
---
-- @class function
-- @name turn_right
turn_right = CAPI.turn_right
---
-- @class function
-- @name look_down
look_down = CAPI.look_down
---
-- @class function
-- @name look_up
look_up = CAPI.look_up
---
-- @class function
-- @name backward
backward = CAPI.backward
---
-- @class function
-- @name forward
forward = CAPI.forward
---
-- @class function
-- @name left
left = CAPI.left
---
-- @class function
-- @name right
right = CAPI.right
---
-- @class function
-- @name jump
jump = CAPI.jump
