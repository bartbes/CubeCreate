---
-- base_console.lua, version 1<br/>
-- Console, bindings etc<br/>
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
-- console commands and others.
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
