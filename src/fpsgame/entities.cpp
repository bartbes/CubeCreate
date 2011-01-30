#include "cube.h"
#include "engine.h"
#include "game.h"


namespace entities
{
    using namespace game;
    
    vector<extentity *> ents;

    vector<extentity *> &getents() { return ents; }

    bool mayattach(extentity &e) { return false; }
    bool attachent(extentity &e, extentity &a) { return false; }
    
    const char *entmodel(const entity &e)
    {
        return NULL;
    }

    void preloadentities()
    {
    }

    void renderent(extentity &e, const char *mdlname, float z, float yaw)
    {
        assert(0);
    }

    void renderent(extentity &e, int type, float z, float yaw)
    {
        assert(0);
    }

    void renderentities()
    {
        loopv(ents)
        {
            extentity &e = *ents[i];
            if(e.type==CARROT || e.type==RESPAWNPOINT)
            {
                renderent(e, e.type, (float)(1+sin(lastmillis/100.0+e.o.x+e.o.y)/20), lastmillis/(e.attr2 ? 1.0f : 10.0f));
                continue;
            }
            if(e.type==TELEPORT)
            {
                if(e.attr2 < 0) continue;
                if(e.attr2 > 0)
                {
                    renderent(e, mapmodelname(e.attr2), (float)(1+sin(lastmillis/100.0+e.o.x+e.o.y)/20), lastmillis/10.0f);        
                    continue;
                }
            }
            else
            {
                if(!e.spawned) continue;
                if(e.type<I_SHELLS || e.type>I_QUAD) continue;
            }
            renderent(e, e.type, (float)(1+sin(lastmillis/100.0+e.o.x+e.o.y)/20), lastmillis/10.0f);
        }
    }

    void rumble(const extentity &e)
    {
    }

    void trigger(extentity &e)
    {
    }

    void addammo(int type, int &v, bool local)
    {
    }

    void repammo(fpsent *d, int type, bool local)
    {
        addammo(type, d->ammo[type-I_SHELLS+GUN_SG], local);
    }

    // these two functions are called when the server acknowledges that you really
    // picked up the item (in multiplayer someone may grab it before you).

    void pickupeffects(int n, fpsent *d)
    {
    }

    // these functions are called when the client touches the item

    void teleport(int n, fpsent *d)     // also used by monsters
    {
    }

    void trypickup(int n, fpsent *d)
    {
    }

    void checkitems(fpsent *d)
    {
    }

    void checkquad(int time, fpsent *d)
    {
    }

    void putitems(ucharbuf &p)            // puts items in network stream and also spawns them locally
    {
    }

    void resetspawns() { loopv(ents) ents[i]->spawned = false; }

    void spawnitems()
    {
    }

    void setspawn(int i, bool on) { if(ents.inrange(i)) ents[i]->spawned = on; }

    extentity *newentity() { return new fpsentity(); }
    void deleteentity(extentity *e) { delete (fpsentity *)e; }

    void clearents()
    {
        while(ents.length()) deleteentity(ents.pop());
    }

    enum
    {
        TRIG_COLLIDE    = 1<<0,
        TRIG_TOGGLE     = 1<<1,
        TRIG_ONCE       = 0<<2,
        TRIG_MANY       = 1<<2,
        TRIG_DISAPPEAR  = 1<<3,
        TRIG_AUTO_RESET = 1<<4,
        TRIG_RUMBLE     = 1<<5,
        TRIG_LOCKED     = 1<<6
    };

    static const int NUMTRIGGERTYPES = 32;

    int triggertypes[NUMTRIGGERTYPES] =
    {
        0,
        TRIG_ONCE,                    // 1
        TRIG_RUMBLE,                  // 2
        TRIG_TOGGLE,                  // 3
        TRIG_TOGGLE | TRIG_RUMBLE,    // 4
        TRIG_MANY,                    // 5
        TRIG_MANY | TRIG_RUMBLE,      // 6
        TRIG_MANY | TRIG_TOGGLE,      // 7
        TRIG_MANY | TRIG_TOGGLE | TRIG_RUMBLE,    // 8
        TRIG_COLLIDE | TRIG_TOGGLE | TRIG_RUMBLE, // 9
        TRIG_COLLIDE | TRIG_TOGGLE | TRIG_AUTO_RESET | TRIG_RUMBLE, // 10
        TRIG_COLLIDE | TRIG_TOGGLE | TRIG_LOCKED | TRIG_RUMBLE,     // 11
        TRIG_DISAPPEAR,               // 12
        TRIG_DISAPPEAR | TRIG_RUMBLE, // 13
        TRIG_DISAPPEAR | TRIG_COLLIDE | TRIG_LOCKED, // 14
        0 /* reserved 15 */,
        0 /* reserved 16 */,
        0 /* reserved 17 */,
        0 /* reserved 18 */,
        0 /* reserved 19 */,
        0 /* reserved 20 */,
        0 /* reserved 21 */,
        0 /* reserved 22 */,
        0 /* reserved 23 */,
        0 /* reserved 24 */,
        0 /* reserved 25 */,
        0 /* reserved 26 */,
        0 /* reserved 27 */,
        0 /* reserved 28 */,
        0 /* reserved 29 */,
        0 /* reserved 30 */,
        0 /* reserved 31 */,
    };

    #define validtrigger(type) (triggertypes[(type) & (NUMTRIGGERTYPES-1)]!=0)
    #define checktriggertype(type, flag) (triggertypes[(type) & (NUMTRIGGERTYPES-1)] & (flag))

    static inline void setuptriggerflags(fpsentity &e)
    {
        e.flags = extentity::F_ANIM;
        if(checktriggertype(e.attr3, TRIG_COLLIDE|TRIG_DISAPPEAR)) e.flags |= extentity::F_NOSHADOW;
        if(!checktriggertype(e.attr3, TRIG_COLLIDE)) e.flags |= extentity::F_NOCOLLIDE;
        switch(e.triggerstate)
        {
            case TRIGGERING:
                if(checktriggertype(e.attr3, TRIG_COLLIDE) && lastmillis-e.lasttrigger >= 500) e.flags |= extentity::F_NOCOLLIDE;
                break;
            case TRIGGERED:
                if(checktriggertype(e.attr3, TRIG_COLLIDE)) e.flags |= extentity::F_NOCOLLIDE;
                break;
            case TRIGGER_DISAPPEARED:
                e.flags |= extentity::F_NOVIS | extentity::F_NOCOLLIDE;
                break;
        }
    }

    void resettriggers()
    {
        loopv(ents)
        {
            fpsentity &e = *(fpsentity *)ents[i];
            if(e.type != ET_MAPMODEL || !validtrigger(e.attr3)) continue;
            e.triggerstate = TRIGGER_RESET;
            e.lasttrigger = 0;
            setuptriggerflags(e);
        }
    }

    void unlocktriggers(int tag, int oldstate = TRIGGER_RESET, int newstate = TRIGGERING)
    {
        loopv(ents)
        {
            fpsentity &e = *(fpsentity *)ents[i];
            if(e.type != ET_MAPMODEL || !validtrigger(e.attr3)) continue;
            if(e.attr4 == tag && e.triggerstate == oldstate && checktriggertype(e.attr3, TRIG_LOCKED))
            {
                if(newstate == TRIGGER_RESETTING && checktriggertype(e.attr3, TRIG_COLLIDE) && overlapsdynent(e.o, 20)) continue;
                e.triggerstate = newstate;
                e.lasttrigger = lastmillis;
                if(checktriggertype(e.attr3, TRIG_RUMBLE)) entities::rumble(e);
            }
        }
    }

    void doleveltrigger(int trigger, int state)
    {
        defformatstring(aliasname)("level_trigger_%d", trigger);
        if(identexists(aliasname))
        {
            SETV(triggerstate, state);
            execute(aliasname);
        }
    }

    void checktriggers()
    {
        if(player1->state != CS_ALIVE) return;
        vec o = player1->feetpos();
        loopv(ents)
        {
            fpsentity &e = *(fpsentity *)ents[i];
            if(e.type != ET_MAPMODEL || !validtrigger(e.attr3)) continue;
            switch(e.triggerstate)
            {
                case TRIGGERING:
                case TRIGGER_RESETTING:
                    if(lastmillis-e.lasttrigger>=1000)
                    {
                        if(e.attr4)
                        {
                            if(e.triggerstate == TRIGGERING) unlocktriggers(e.attr4);
                            else unlocktriggers(e.attr4, TRIGGERED, TRIGGER_RESETTING);
                        }
                        if(checktriggertype(e.attr3, TRIG_DISAPPEAR)) e.triggerstate = TRIGGER_DISAPPEARED;
                        else if(e.triggerstate==TRIGGERING && checktriggertype(e.attr3, TRIG_TOGGLE)) e.triggerstate = TRIGGERED;
                        else e.triggerstate = TRIGGER_RESET;
                    }
                    setuptriggerflags(e);
                    break;
                case TRIGGER_RESET:
                    if(e.lasttrigger)
                    {
                        if(checktriggertype(e.attr3, TRIG_AUTO_RESET|TRIG_MANY|TRIG_LOCKED) && e.o.dist(o)-player1->radius>=(checktriggertype(e.attr3, TRIG_COLLIDE) ? 20 : 12))
                            e.lasttrigger = 0;
                        break;
                    }
                    else if(e.o.dist(o)-player1->radius>=(checktriggertype(e.attr3, TRIG_COLLIDE) ? 20 : 12)) break;
                    else if(checktriggertype(e.attr3, TRIG_LOCKED))
                    {
                        if(!e.attr4) break;
                        doleveltrigger(e.attr4, -1);
                        e.lasttrigger = lastmillis;
                        break;
                    }
                    e.triggerstate = TRIGGERING;
                    e.lasttrigger = lastmillis;
                    setuptriggerflags(e);
                    if(checktriggertype(e.attr3, TRIG_RUMBLE)) rumble(e);
                    if(e.attr4) doleveltrigger(e.attr4, 1);
                    break;
                case TRIGGERED:
                    if(e.o.dist(o)-player1->radius<(checktriggertype(e.attr3, TRIG_COLLIDE) ? 20 : 12))
                    {
                        if(e.lasttrigger) break;
                    }
                    else if(checktriggertype(e.attr3, TRIG_AUTO_RESET))
                    {
                        if(lastmillis-e.lasttrigger<6000) break;
                    }
                    else if(checktriggertype(e.attr3, TRIG_MANY))
                    {
                        e.lasttrigger = 0;
                        break;
                    }
                    else break;
                    if(checktriggertype(e.attr3, TRIG_COLLIDE) && overlapsdynent(e.o, 20)) break;
                    e.triggerstate = TRIGGER_RESETTING;
                    e.lasttrigger = lastmillis;
                    setuptriggerflags(e);
                    if(checktriggertype(e.attr3, TRIG_RUMBLE)) rumble(e);
                    if(e.attr4) doleveltrigger(e.attr4, 0);
                    break;
            }
        }
    }

    void animatemapmodel(const extentity &e, int &anim, int &basetime)
    {
        const fpsentity &f = (const fpsentity &)e;
        if(validtrigger(f.attr3)) switch(f.triggerstate)
        {
            case TRIGGER_RESET: anim = ANIM_TRIGGER|ANIM_START; break;
            case TRIGGERING: anim = ANIM_TRIGGER; basetime = f.lasttrigger; break;
            case TRIGGERED: anim = ANIM_TRIGGER|ANIM_END; break;
            case TRIGGER_RESETTING: anim = ANIM_TRIGGER|ANIM_REVERSE; basetime = f.lasttrigger; break;
        }
    }

    void fixentity(extentity &e)
    {
        switch(e.type)
        {
            case FLAG:
            case BOX:
            case BARREL:
            case PLATFORM:
            case ELEVATOR:
                e.attr5 = e.attr4;
                e.attr4 = e.attr3;
                e.attr3 = e.attr2;
            case MONSTER:
            case TELEDEST:
                e.attr2 = e.attr1;
            case RESPAWNPOINT:
                e.attr1 = (int)player1->yaw;
                break;
        }
    }

    void entradius(extentity &e, bool color)
    {
        switch(e.type)
        {
            case TELEPORT:
                loopv(ents) if(ents[i]->type == TELEDEST && e.attr1==ents[i]->attr2)
                {
                    renderentarrow(e, vec(ents[i]->o).sub(e.o).normalize(), e.o.dist(ents[i]->o));
                    break;
                }
                break;

            case JUMPPAD:
                renderentarrow(e, vec((int)(char)e.attr3*10.0f, (int)(char)e.attr2*10.0f, e.attr1*12.5f).normalize(), 4);
                break;

            case FLAG:
            case MONSTER:
            case TELEDEST:
            case RESPAWNPOINT:
            case BOX:
            case BARREL:
            case PLATFORM:
            case ELEVATOR:
            {
                vec dir;
                vecfromyawpitch(e.attr1, 0, 1, 0, dir);
                renderentarrow(e, dir, 4);
                break;
            }
            case MAPMODEL:
                if(validtrigger(e.attr3)) renderentring(e, checktriggertype(e.attr3, TRIG_COLLIDE) ? 20 : 12);
                break;
        }
    }

    const char *entnameinfo(entity &e) { return ""; }
    const char *entname(int i)
    {
        static const char *entnames[] =
        {
            "none?", "light", "mapmodel", "playerstart", "envmap", "particles", "sound", "spotlight",
            "shells", "bullets", "rockets", "riflerounds", "grenades", "cartridges",
            "health", "healthboost", "greenarmour", "yellowarmour", "quaddamage",
            "teleport", "teledest",
            "monster", "carrot", "jumppad",
            "base", "respawnpoint",
            "box", "barrel",
            "platform", "elevator",
            "flag",
            "", "", "", "",
        };
        return i>=0 && size_t(i)<sizeof(entnames)/sizeof(entnames[0]) ? entnames[i] : "";
    }
    
    int extraentinfosize() { return 0; }       // size in bytes of what the 2 methods below read/write... so it can be skipped by other games

    void writeent(entity &e, char *buf)   // write any additional data to disk (except for ET_ ents)
    {
    }

    void readent(entity &e, char *buf)     // read from disk, and init
    {
        int ver = getmapversion();
        if(ver <= 30) switch(e.type)
        {
            case FLAG:
            case MONSTER:
            case TELEDEST:
            case RESPAWNPOINT:
            case BOX:
            case BARREL:
            case PLATFORM:
            case ELEVATOR:
                e.attr1 = (int(e.attr1)+180)%360;
                break;
        }
    }

    void editent(int i, bool local)
    {
        // We use our own protocol for this sort of thing - StateVariable updates, normally
    }

    float dropheight(entity &e)
    {
        if(e.type==MAPMODEL || e.type==BASE || e.type==FLAG) return 0.0f;
        return 4.0f;
    }

    bool printent(extentity &e, char *buf)
    {
        return false;
    }
}

