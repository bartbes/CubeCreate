/*
 * luabinds_gui.hpp, version 1
 * GUI methods for Lua
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

/* PROTOTYPES */
void showgui(const char *name);
int cleargui(int n);
void guionclear(char *action);
void guistayopen(char *contents);
void guinoautotab(char *contents);
void guibutton(char *name, char *action, char *icon);
void guiimage(char *path, char *action, float *scale, int *overlaid, char *alt);
void guicolor(int *color);
void guitextbox(char *text, int *width, int *height, int *color);
void guitext(char *name, char *icon);
void guititle(char *name);
void guitab(char *name);
void guibar();
void guistrut(float *strut, int *alt);
void guislider(char *var, int *min, int *max, char *onchange);
void guilistslider(char *var, char *list, char *onchange);
void guinameslider(char *var, char *names, char *list, char *onchange);
void guicheckbox(char *name, char *var, float *on, float *off, char *onchange);
void guiradio(char *name, char *var, float *n, char *onchange);
void guibitfield(char *name, char *var, int *mask, char *onchange);
void guifield(char *var, int *maxlength, char *onchange, int *password);
void guieditor(char *name, int *maxlength, int *height, int *mode);
void guikeyfield(char *var, int *maxlength, char *onchange);
void guilist(char *contents);
void guialign(int *align, char *contents);
void newgui(char *name, char *contents, char *header);

namespace lua_binds
{
    LUA_BIND_STD_CLIENT(showmessage, IntensityGUI::showMessage, "Script message", e.get<const char*>(1))
    LUA_BIND_STD_CLIENT(showinputdialog, IntensityGUI::showInputDialog, "Script input", e.get<const char*>(1))
    LUA_BIND_CLIENT(setdeftpm, {
        // Only allow this to be done once
        if (!lua::engine["setdeftpm"])
        {
            lua::engine["setdeftpm"] = "set";
            SETV(thirdperson, e.get<int>(1));
        } else
            Logging::log(Logging::WARNING, "Can only set default thirdperson mode once per map\r\n");
    })

    LUA_BIND_STD_CLIENT(newgui, newgui, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
    LUA_BIND_STD_CLIENT(guibutton, guibutton, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
    LUA_BIND_STD_CLIENT(guitext, guitext, e.get<char*>(1), e.get<char*>(2))
    LUA_BIND_STD_CLIENT(cleargui, e.push, cleargui(e.get<int>(1)))
    LUA_BIND_STD_CLIENT(showgui, showgui, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guionclear, guionclear, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guistayopen, guistayopen, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guinoautotab, guinoautotab, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guilist, guilist, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guialign, guialign, e.get<int*>(1), e.get<char*>(2))
    LUA_BIND_STD_CLIENT(guititle, guititle, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guibar, guibar)
    LUA_BIND_STD_CLIENT(guistrut, guistrut, e.get<float*>(1), e.get<int*>(2))
    LUA_BIND_STD_CLIENT(guiimage, guiimage, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<int*>(4), e.get<char*>(5))
    LUA_BIND_STD_CLIENT(guislider, guislider, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<char*>(4))
    LUA_BIND_STD_CLIENT(guilistslider, guilistslider, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
    LUA_BIND_STD_CLIENT(guinameslider, guinameslider, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3), e.get<char*>(4))
    LUA_BIND_STD_CLIENT(guiradio, guiradio, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<char*>(4))
    LUA_BIND_STD_CLIENT(guibitfield, guibitfield, e.get<char*>(1), e.get<char*>(2), e.get<int*>(3), e.get<char*>(4))
    LUA_BIND_STD_CLIENT(guicheckbox, guicheckbox, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<float*>(4), e.get<char*>(5))
    LUA_BIND_STD_CLIENT(guitab, guitab, e.get<char*>(1))
    LUA_BIND_STD_CLIENT(guifield, guifield, e.get<char*>(1), e.get<int*>(2), e.get<char*>(3), e.get<int*>(4))
    LUA_BIND_STD_CLIENT(guikeyfield, guikeyfield, e.get<char*>(1), e.get<int*>(2), e.get<char*>(3))
    LUA_BIND_STD_CLIENT(guieditor, guieditor, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4))
    LUA_BIND_STD_CLIENT(guicolor, guicolor, e.get<int*>(1))
    LUA_BIND_STD_CLIENT(guitextbox, guitextbox, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4))
}
