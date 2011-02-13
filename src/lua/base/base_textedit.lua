---
-- base_textedit.lua, version 1<br/>
-- Text editor interface for Lua<br/>
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

--- Text editor for cC's Lua interface.
-- @class module
-- @name cc.textedit
module("cc.textedit")

---
-- @class function
-- @name textlist
textlist = CAPI.textlist
---
-- @class function
-- @name textshow
textshow = CAPI.textshow
---
-- @class function
-- @name textfocus
textfocus = CAPI.textfocus
---
-- @class function
-- @name textprev
textprev = CAPI.textprev
---
-- @class function
-- @name textmode
textmode = CAPI.textmode
---
-- @class function
-- @name textsave
textsave = CAPI.textsave
---
-- @class function
-- @name textload
textload = CAPI.textload
---
-- @class function
-- @name textinit
textinit = CAPI.textinit
---
-- @class function
-- @name textcopy
textcopy = CAPI.textcopy
---
-- @class function
-- @name textpaste
textpaste = CAPI.textpaste
---
-- @class function
-- @name textmark
textmark = CAPI.textmark
---
-- @class function
-- @name textselectall
textselectall = CAPI.textselectall
---
-- @class function
-- @name textclear
textclear = CAPI.textclear
---
-- @class function
-- @name textcurrentline
textcurrentline = CAPI.textcurrentline
---
-- @class function
-- @name textexec
textexec = CAPI.textexec
