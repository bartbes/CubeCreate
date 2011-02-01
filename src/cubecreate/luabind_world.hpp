/*
 * luabinds_world.hpp, version 1
 * Geometry utilities and world methods
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
extern float GRAVITY;

namespace lua_binds
{
    /* Geometry utilities */

    LUA_BIND_DEF(raylos, {
        vec a(e.get<double>(1), e.get<double>(2), e.get<double>(3));
        vec b(e.get<double>(4), e.get<double>(5), e.get<double>(6));
        vec target;

        bool ret = raycubelos(a, b, target);
        e.push(ret);
    })

    LUA_BIND_DEF(raypos, {
        vec o(e.get<double>(1), e.get<double>(2), e.get<double>(3));
        vec ray(e.get<double>(4), e.get<double>(5), e.get<double>(6));
        vec hitpos(0);

        e.push(raycubepos(o, ray, hitpos, e.get<double>(7), RAY_CLIPMAT|RAY_POLY));
    })

    LUA_BIND_DEF(rayfloor, {
        vec o(e.get<double>(1), e.get<double>(2), e.get<double>(3));
        vec floor(0);

        e.push(rayfloor(o, floor, 0, e.get<double>(4)));
    })

    /* World */

    LUA_BIND_DEF(iscolliding, {
        vec pos(e.get<double>(1), e.get<double>(2), e.get<double>(3));

        // TODO: Make faster, avoid this lookup
        e.push(PhysicsManager::getEngine()->isColliding(
            pos,
            e.get<double>(4),
            e.get<int>(5) != -1 ? LogicSystem::getLogicEntity(e.get<int>(5)).get() : NULL)
        );
    })

    LUA_BIND_DEF(setgravity, {
        if (PhysicsManager::hasEngine())
            PhysicsManager::getEngine()->setGravity(e.get<double>(1));
        else
        {
            Logging::log(Logging::DEBUG, "Setting gravity using sauer system, as no physics engine\r\n");
            GRAVITY = e.get<double>(1);
        }
    })

    LUA_BIND_DEF(getmat, e.push(lookupmaterial(vec(e.get<double>(1), e.get<double>(2), e.get<double>(3))));)
}
