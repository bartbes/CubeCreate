/*
 * variable_system.cpp, version 1
 * Source file for engine varsystem
 *
 * author: q66 <quaker66@gmail.com>
 * license: MIT/X11
 *
 * Copyright (c) 2011 q66
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

/*
 * ENGINE INCLUDES
 */

#include "cube.h"
#include "engine.h"
#include "game.h"

/*
 * CUBECREATE INCLUDES
 */

#include "world_system.h"
#include "message_system.h"
#include "fpsclient_interface.h"
#ifdef CLIENT
    #include "client_system.h"
    #include "targeting.h"
#endif

// declare the variables
#ifdef _EV_NODEF
#undef _EV_NODEF
#endif
#ifdef DEFVAR
#undef DEFVAR
#endif
#define DEFVAR(name) cvar *_EV_##name = NULL;
#include "variable_system_proto.hpp"

namespace var
{
    /*
     * ENGINE VARIABLE
     */

    cvar::cvar(
        const char *vname,
        int minvi,
        int curvi,
        int maxvi,
        void (*cb)(int),
        bool persist,
        bool overridable
    ) : persistent(persist),
        name(vname),
        type(VAR_I),
        override(overridable),
        alias(false)
    {
        vcb.i = cb;
        if (minvi > maxvi)
        {
            readonly = true;
            minv.i = maxvi; curv.i = curvi; maxv.i = minvi;
        }
        else
        {
            readonly = false;
            minv.i = minvi; curv.i = curvi; maxv.i = maxvi;
        }
        hascb = cb ? true : false;
    }

    cvar::cvar(
        const char *vname,
        float minvf,
        float curvf,
        float maxvf,
        void (*cb)(float),
        bool persist,
        bool overridable
    ) : persistent(persist),
        name(vname),
        type(VAR_F),
        override(overridable),
        alias(false)
    {
        vcb.f = cb;
        if (minvf > maxvf)
        {
            readonly = true;
            minv.f = maxvf; curv.f = curvf; maxv.f = minvf;
        }
        else
        {
            readonly = false;
            minv.f = minvf; curv.f = curvf; maxv.f = maxvf;
        }
        hascb = cb ? true : false;
    }

    cvar::cvar(
        const char *vname,
        const char *curvs,
        void (*cb)(const char*),
        bool persist,
        bool overridable
    ) : persistent(persist),
        name(vname),
        type(VAR_S),
        readonly(false),
        override(overridable),
        alias(false) { vcb.s = cb; hascb = cb ? true : false; curv.s = (curvs ? newstring(curvs) : NULL); }

    cvar::cvar(
        const char *aname,
        int val,
        bool reglua
    ) : persistent(false),
        hascb(false),
        name(aname),
        type(VAR_I),
        readonly(false),
        override(false),
        alias(true)
    {
        vcb.i = NULL;
        minv.i = maxv.i = -1;
        curv.i = val;
        if (reglua && lua::engine.hashandle()) regliv();
    }

    cvar::cvar(
        const char *aname,
        float val,
        bool reglua
    ) : persistent(false),
        hascb(false),
        name(aname),
        type(VAR_F),
        readonly(false),
        override(false),
        alias(true)
    {
        vcb.f = NULL;
        minv.f = maxv.f = -1.0f;
        curv.f = val;
        if (reglua && lua::engine.hashandle()) reglfv();
    }

    cvar::cvar(
        const char *aname,
        const char *val,
        bool reglua
    ) : persistent(false),
        hascb(false),
        name(aname),
        type(VAR_S),
        readonly(false),
        override(false),
        alias(true)
    {
        vcb.s = NULL;
        curv.s = (val ? newstring(val) : NULL);
        if (reglua && lua::engine.hashandle()) reglsv();
    }

    cvar::~cvar() { if (type == VAR_S) DELETEA(curv.s); }

    const char *cvar::gn()   { return name;   }
    int         cvar::gt()   { return type;   }
    int         cvar::gi()   { return curv.i; }
    int         cvar::gmni() { return minv.i; }
    int         cvar::gmxi() { return maxv.i; }
    float       cvar::gf()   { return curv.f; }
    float       cvar::gmnf() { return minv.f; }
    float       cvar::gmxf() { return maxv.f; }
    const char *cvar::gs()   { return curv.s; }

    void cvar::s(int val, bool luasync, bool forcecb, bool clamp)
    {
        if (clamp && (val < minv.i || val > maxv.i) && !alias) curv.i = clamp(val, minv.i, maxv.i);
        else curv.i = val;
        callcb(luasync, forcecb);
    }

    void cvar::s(float val, bool luasync, bool forcecb, bool clamp)
    {
        if (clamp && (val < minv.f || val > maxv.f) && !alias) curv.f = clamp(val, minv.f, maxv.f);
        else curv.f = val;
        callcb(luasync, forcecb);
    }

    void cvar::s(const char *val, bool luasync, bool forcecb, bool clamp)
    {
        (void)clamp;
        curv.s = (val ? newstring(val) : NULL);
        callcb(luasync, forcecb);
    }

    bool cvar::ispersistent()  { return persistent; }
    bool cvar::isreadonly()    { return readonly;   }
    bool cvar::isoverridable() { return override;   }
    bool cvar::isalias()       { return alias;      }

    void cvar::regliv()
    {
        lua::engine.getg("ivar")
                   .push(name)
                   .push(minv.i)
                   .push(curv.i)
                   .push(maxv.i)
                   .push(readonly)
                   .push(alias)
                   .call(6);
    }

    void cvar::reglfv()
    {
        lua::engine.getg("fvar")
                   .push(name)
                   .push(minv.f)
                   .push(curv.f)
                   .push(maxv.f)
                   .push(readonly)
                   .push(alias)
                   .call(6);
    }

    void cvar::reglsv()
    {
        lua::engine.getg("svar")
                   .push(name)
                   .push(curv.s)
                   .push(readonly)
                   .push(alias)
                   .call(4);
    }

    /*
     * PRIVATES
     */

    void cvar::callcb(bool luasync, bool forcecb)
    {
        #define SYNCV(v) \
        if ((luasync || alias) && lua::engine.hashandle()) \
        { \
            defformatstring(buf)("%s_ns", name); \
            lua::engine.getg("EV").t_set(buf, v).pop(1); \
        }

        switch (type)
        {
            case VAR_I:
            {
                if (hascb && (!luasync || forcecb) && !alias) vcb.i(curv.i);
                SYNCV(curv.i)
                break;
            }
            case VAR_F:
            {
                if (hascb && (!luasync || forcecb) && !alias) vcb.f(curv.f);
                SYNCV(curv.f)
                break;
            }
            case VAR_S:
            {
                if (hascb && (!luasync || forcecb) && !alias) vcb.s(curv.s);
                SYNCV(curv.s)
                break;
            }
            default: break;
        }
    }

    /*
     * STORAGE FOR VARIABLES
     */

    vartable *vars = NULL, *pvars = NULL;
    bool persistvars = false, overridevars = false;

    cvar *reg(const char *name, cvar *var)
    {
        if (!vars) vars = new vartable;
        vars->access(name, var);
        return var;
    }

    void fill()
    {
        fillfp();
        #include "variable_system_def.hpp"
    }

    void filllua()
    {
        enumerate(*vars, cvar*, v, {
            switch (v->gt())
            {
                case VAR_I:
                {
                    v->regliv();
                    break;
                }
                case VAR_F:
                {
                    v->reglfv();
                    break;
                }
                case VAR_S:
                {
                    v->reglsv();
                    break;
                }
                default: break;
            }
        });
    }

    void clear()
    {
        if (!vars) return;
        if (!pvars) pvars = new vartable;
        enumerate(*vars, cvar*, v, {
            if (v->isalias() || !v->isoverridable())
                pvars->access(v->gn(), v);
            else delete v;
        });
        delete vars;
    }

    void flush()
    {
        if (vars)
        {
            enumerate(*vars,  cvar*, v, { if (v) delete v; });
            delete vars;
        }
        if (pvars)
        {
            enumerate(*pvars, cvar*, v, { if (v) delete v; });
            delete pvars;
        }
    }

    void fillfp()
    {
        if (!vars) return;
        if (!pvars) pvars = new vartable;
        enumerate(*pvars, cvar*, v, { vars->access(v->gn(), v); });
    }

    void syncfl(const char *name, int         val) { (*vars->access(name))->s(val, false); }
    void syncfl(const char *name, float       val) { (*vars->access(name))->s(val, false); }
    void syncfl(const char *name, const char *val) { (*vars->access(name))->s(val, false); }

    cvar *get(const char *name) { if (vars && vars->access(name)) return *vars->access(name); else return NULL; }
}
// end namespace var
