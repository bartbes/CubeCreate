/*
 * luabinds_base.hpp, version 1
 * Base Lua API exports
 *
 * author: q66 <quaker66@gmail.com>
 * license: MIT/X11
 *
 * Copyright (c) 2010 q66
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

namespace lua_binds
{
    /* Logging Lua namespace */

    LUA_BIND_DEF(log, Logging::log((Logging::Level)e.get<int>(1), "%s\n", e.get<const char*>(2));)

    LUA_BIND_DEF(echo, conoutf("\f1%s", e.get<const char*>(1));)

    /* CAPI Lua namespace */

    // General

    LUA_BIND_DEF(currtime, e.push(Utility::SystemInfo::currTime());)

    // Bit math

    LUA_BIND_DEF(lsh, e.push(e.get<int>(1) << e.get<int>(2));)

    LUA_BIND_DEF(rsh, e.push(e.get<int>(1) >> e.get<int>(2));)

    LUA_BIND_DEF(bor, {
        int out = e.get<int>(1);
        int n   = e.gettop();
        for (int i = 2; i <= n; i++) out |= e.get<int>(i);
        e.push(out);
    })

    LUA_BIND_DEF(band, {
        int out = e.get<int>(1);
        int n   = e.gettop();
        for (int i = 2; i <= n; i++) out &= e.get<int>(i);
        e.push(out);
    })

    LUA_BIND_DEF(bnot, e.push(~e.get<int>(1));)
}
