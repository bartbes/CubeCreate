/*
 * luabinds_entity.hpp, version 1
 * Entity Lua API exports
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
void removeentity(extentity* entity);
void addentity(extentity* entity);

namespace lua_binds
{
    /* Entity management */

    LUA_BIND_DEF(unreglogent, LogicSystem::unregisterLogicEntityByUniqueId(e.get<int>(1));)

    LUA_BIND_DEF(placeinworld, WorldSystem::placeInWorld(e.get<int>(1), e.get<int>(2));)

    LUA_BIND_SE(setupextent, LogicSystem::setupExtent(ref,
        e.get<int>(2),
        e.get<double>(3),
        e.get<double>(4),
        e.get<double>(5),
        e.get<int>(6),
        e.get<int>(7),
        e.get<int>(8),
        e.get<int>(9));
    )
    LUA_BIND_SE(setupcharacter,     LogicSystem::setupCharacter(ref);)

    LUA_BIND_SE(setupnonsauer,      LogicSystem::setupNonSauer(ref);)

    LUA_BIND_SE(dismantleextent,    LogicSystem::dismantleExtent(ref);)

    LUA_BIND_SE(dismantlecharacter, LogicSystem::dismantleCharacter(ref);)

    /* Entity attributes */

    LUA_BIND_LE(setanim, self.get()->setAnimation(e.get<int>(2));)

    LUA_BIND_LE(getstarttime, e.push(self.get()->getStartTime());)

    LUA_BIND_LE(setmodelname, {
        Logging::log(Logging::DEBUG, "setmodelname(%s)\n", e.get<const char*>(2));

        self.get()->setModel(std::string(e.get<const char*>(2)));
    })

    LUA_BIND_LE(setsoundname, {
        Logging::log(Logging::DEBUG, "setsoundname(%s)\n", e.get<const char*>(2));

        self.get()->setSound(std::string(e.get<const char*>(2)));
    })

    LUA_BIND_LE(setsoundvol, {
        Logging::log(Logging::DEBUG, "setsoundvol(%i)\n", e.get<int>(2));

        extentity *ext = self.get()->staticEntity;
        assert(ext);

        if (!WorldSystem::loadingWorld) removeentity(ext);
        ext->attr4 = e.get<int>(2);
        if (!WorldSystem::loadingWorld) addentity(ext);

        // finally reload sound, so everything gets applied
        self.get()->setSound(self.get()->soundName.c_str());
    })

    LUA_BIND_LE(setattachments_raw, self.get()->setAttachments(e.get<const char*>(2));)

    LUA_BIND_LE(getattachmentpos, {
        vec& vp = self->getAttachmentPosition(std::string(e.get<const char*>(2)));
        e.push(vp);
    })

    LUA_BIND_LE(setCanMove, self.get()->setCanMove(e.get<bool>(2));)

    /* Extents */

    #define EXTENT_ACCESSORS(n, an) \
    LUA_BIND_LE(get##n, { \
        extentity *ext = self.get()->staticEntity; \
        assert(ext); \
        \
        e.push(ext->an); \
    }) \
    \
    LUA_BIND_LE(set##n, { \
        extentity *ext = self.get()->staticEntity; \
        assert(ext); \
        \
        /* Need to remove, then add, to the world on each change, if not during load. */ \
        if (!WorldSystem::loadingWorld) removeentity(ext); \
        ext->an = e.get<int>(2); \
        if (!WorldSystem::loadingWorld) addentity(ext); \
    }) \
    \
    LUA_BIND_LE(FAST_set##n, { \
        /* Fast version - no removeentity/addentity. Use with care! */ \
        extentity *ext = self.get()->staticEntity; \
        assert(ext); \
    \
        ext->an = e.get<int>(2); \
    })

    EXTENT_ACCESSORS(a1, attr1)
    EXTENT_ACCESSORS(a2, attr2)
    EXTENT_ACCESSORS(a3, attr3)
    EXTENT_ACCESSORS(a4, attr4)

    #define EXTENT_LE_ACCESSORS(n, an) \
    LUA_BIND_LE(get##n, e.push(self->an);) \
    \
    LUA_BIND_LE(set##n, { \
        Logging::log(Logging::DEBUG, "ACCESSOR: Setting %s to %f\n", #an, e.get<double>(2)); \
        assert(self->staticEntity); \
        \
        /* Need to remove, then add, to the octa world on each change. */ \
        if (!WorldSystem::loadingWorld) removeentity(self->staticEntity); \
        self->an = e.get<double>(2); \
        if (!WorldSystem::loadingWorld) addentity(self->staticEntity); \
    })

    EXTENT_LE_ACCESSORS(collisionradw, collisionRadiusWidth)
    EXTENT_LE_ACCESSORS(collisionradh, collisionRadiusHeight)

    // Add 'FAST' versions of accessors - no addentity/removeentity. Good to change e.g. particle parameters

    LUA_BIND_LE(getextent0_raw, {
        int arg2 = e.get<int>(2);
        extentity *ext = self.get()->staticEntity;
        assert(ext);
        assert(arg2 >= 0 && arg2 <= 2);

        Logging::log(Logging::INFO, "getextent0_raw(%d): %f\n", arg2, ext->o[arg2]);

        e.push(ext->o[arg2]);
    })

    LUA_BIND_LE(setextent0_raw, {
        extentity *ext = self.get()->staticEntity;
        assert(ext);

        removeentity(ext); /* Need to remove, then add, to the octa world on each change. */
        ext->o.x = e.get<double>(2);
        ext->o.y = e.get<double>(3);
        ext->o.z = e.get<double>(4);
        addentity(ext);
    })

    /* Dynents */

    #define DYNENT_ACCESSORS(n, t, an) \
    LUA_BIND_LE(get##n, { \
        fpsent *d = (fpsent*)self.get()->dynamicEntity; \
        assert(d); \
        e.push((t)d->an); \
    }) \
    \
    LUA_BIND_LE(set##n, { \
        fpsent *d = (fpsent*)self.get()->dynamicEntity; \
        assert(d); \
        d->an = e.get<t>(2); \
    })

    DYNENT_ACCESSORS(maxspeed, double, maxspeed)
    DYNENT_ACCESSORS(radius, double, radius)
    DYNENT_ACCESSORS(eyeheight, double, eyeheight)
    DYNENT_ACCESSORS(aboveeye, double, aboveeye)
    DYNENT_ACCESSORS(yaw, double, yaw)
    DYNENT_ACCESSORS(pitch, double, pitch)
    DYNENT_ACCESSORS(move, int, move)
    DYNENT_ACCESSORS(strafe, int, strafe)
    DYNENT_ACCESSORS(yawing, int, turn_move)
    DYNENT_ACCESSORS(pitching, int, look_updown_move)
    DYNENT_ACCESSORS(jumping, bool, jumping)
    DYNENT_ACCESSORS(blocked, bool, blocked)
    DYNENT_ACCESSORS(mapdefinedposdata, int, mapDefinedPositionData) // XXX Should be unsigned
    DYNENT_ACCESSORS(clientstate, int, state);
    DYNENT_ACCESSORS(physstate, int, physstate);
    DYNENT_ACCESSORS(inwater, int, inwater)
    DYNENT_ACCESSORS(timeinair, int, timeinair)

    // For dynents, 'o' is at their head, not their feet like static entities. We make this uniform by
    // letting lua specify a feet position, and we work relative to their height - add to
    // assignments, subtract from readings
    LUA_BIND_LE(getdynent0_raw, {
        int arg2 = e.get<int>(2);
        fpsent *d = (fpsent*)self.get()->dynamicEntity;
        assert(d);
        assert(arg2 >= 0 && arg2 <= 2);

        if (arg2 != 2) e.push(d->o[arg2]);
        else e.push(d->o.z - d->eyeheight);// - d->aboveeye);
    })

    LUA_BIND_LE(setdynent0_raw, {
        fpsent *d = (fpsent*)self.get()->dynamicEntity;
        assert(d);

        d->o.x = e.get<double>(2);
        d->o.y = e.get<double>(3);
        d->o.z = e.get<double>(4) + d->eyeheight;// + d->aboveeye;

        // Also set 'newpos', otherwise this change may get overwritten
        d->newpos = d->o;

        d->resetinterp(); // No need to interpolate to last position - just jump

        Logging::log(Logging::INFO, "(%d).setdynent0(%f, %f, %f)\n", d->uniqueId, d->o.x, d->o.y, d->o.z);
    })

    LUA_BIND_LE(getdynentvel_raw, {
        int arg2 = e.get<int>(2);
        fpsent *d = (fpsent*)self.get()->dynamicEntity;
        assert(d);
        assert(arg2 >= 0 && arg2 <= 2);

        e.push(d->vel[arg2]);
    })

    LUA_BIND_LE(setdynentvel_raw, {
        fpsent *d = (fpsent*)self.get()->dynamicEntity;
        assert(d);

        d->vel.x = e.get<double>(2);
        d->vel.y = e.get<double>(3);
        d->vel.z = e.get<double>(4);
    })

    LUA_BIND_LE(getdynentfalling_raw, {
        int arg2 = e.get<int>(2);
        fpsent *d = (fpsent*)self.get()->dynamicEntity;
        assert(d);
        assert(arg2 >= 0 && arg2 <= 2);

        e.push(d->falling[arg2]);
    })

    LUA_BIND_LE(setdynentfalling_raw, {
        fpsent *d = (fpsent*)self.get()->dynamicEntity;
        assert(d);

        d->falling.x = e.get<double>(2);
        d->falling.y = e.get<double>(3);
        d->falling.z = e.get<double>(4);
    })
}
