/*
 * lua_system_lua_def.hpp, version 1
 * Header file for Lua binding functions
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

using namespace lua;

/*
 * Some prototypes for binds, TODO: remove after headers are properly organized
 */
void removeentity(extentity* entity);
void addentity(extentity* entity);

void startmusic(char *name, char *cmd);
int preload_sound(char *name, int vol);

extern float GRAVITY;

void texturereset(int n);
void texture(const char *type, const char *name, int rot, int xoffset, int yoffset, float scale, int forcedindex);

void mapmodelreset(int *n);
void mmodel(char *name);
extern vector<mapmodelinfo> mapmodels;
void clearmodel(char *name);

void shader(int *type, char *name, char *vs, char *ps);
void variantshader(int *type, char *name, int *row, char *vs, char *ps);
void setshader(char *name);
void addshaderparam(const char *name, int type, int n, float x, float y, float z, float w);
void altshader(char *origname, char *altname);
void fastshader(char *nice, char *fast, int *detail);
void defershader(int *type, const char *name, const char *contents);
Shader *useshaderbyname(const char *name);

void isshaderdefined(char *name);
void isshadernative(char *name);

void addpostfx(const char *name, int bind, int scale, const char *inputs, float x, float y, float z, float w);
void setpostfx(const char *name, float x, float y, float z, float w);
void clearpostfx();

void mdlname();
void mdlalphatest(float *cutoff);
void mdlalphablend(int *blend);
void mdlalphadepth(int *depth);
void mdldepthoffset(int *offset);
void mdlcullface(int *cullface);
void mdlcollide(int *collide);
void mdlellipsecollide(int *collide);
void mdlspec(int *percent);
void mdlambient(int *percent);
void mdlglow(int *percent);
void mdlglare(float *specglare, float *glowglare);
void mdlenvmap(float *envmapmax, float *envmapmin, char *envmap);
void mdlfullbright(float *fullbright);
void mdlshader(char *shader);
void mdlspin(float *yaw, float *pitch);
void mdlscale(int *percent);
void mdltrans(float *x, float *y, float *z);
void mdlyaw(float *angle);
void mdlpitch(float *angle);
void mdlshadow(int *shadow);
void mdlbb(float *rad, float *h, float *eyeheight);
void mdlextendbb(float *x, float *y, float *z);
void mdlcollisionsonlyfortriggering(int *val);
void mdlperentitycollisionboxes(int *val);
void rdvert(float *x, float *y, float *z, float *radius);
void rdeye(int *v);
void rdtri(int *v1, int *v2, int *v3);
void rdjoint(int *n, int *t, char *v1, char *v2, char *v3);
void rdlimitdist(int *v1, int *v2, float *mindist, float *maxdist);
void rdlimitrot(int *t1, int *t2, float *maxangle, float *qx, float *qy, float *qz, float *qw);
void rdanimjoints(int *on);

void objload(char *model, float *smooth);
void objpitch(float *pitchscale, float *pitchoffset, float *pitchmin, float *pitchmax);
void objskin(char *meshname, char *tex, char *masks, float *envmapmax, float *envmapmin);
void objspec(char *meshname, int *percent);
void objambient(char *meshname, int *percent);
void objglow(char *meshname, int *percent);
void objglare(char *meshname, float *specglare, float *glowglare);
void objalphatest(char *meshname, float *cutoff);
void objalphablend(char *meshname, int *blend);
void objcullface(char *meshname, int *cullface);
void objenvmap(char *meshname, char *envmap);
void objbumpmap(char *meshname, char *normalmap, char *skin);
void objfullbright(char *meshname, float *fullbright);
void objshader(char *meshname, char *shader);
void objscroll(char *meshname, float *scrollu, float *scrollv);
void objnoclip(char *meshname, int *noclip);

void setmd5dir(char *name);  
void md5load(char *meshfile, char *skelname, float *smooth);
void md5tag(char *name, char *tagname);        
void md5pitch(char *name, float *pitchscale, float *pitchoffset, float *pitchmin, float *pitchmax);
void md5adjust(char *name, float *yaw, float *pitch, float *roll, float *tx, float *ty, float *tz);
void md5skin(char *meshname, char *tex, char *masks, float *envmapmax, float *envmapmin);
void md5spec(char *meshname, int *percent);
void md5ambient(char *meshname, int *percent);
void md5glow(char *meshname, int *percent);
void md5glare(char *meshname, float *specglare, float *glowglare);
void md5alphatest(char *meshname, float *cutoff);
void md5alphablend(char *meshname, int *blend);
void md5cullface(char *meshname, int *cullface);
void md5envmap(char *meshname, char *envmap);
void md5bumpmap(char *meshname, char *normalmap, char *skin);
void md5fullbright(char *meshname, float *fullbright);
void md5shader(char *meshname, char *shader);
void md5scroll(char *meshname, float *scrollu, float *scrollv);
void md5anim(char *anim, char *animfile, float *speed, int *priority);
void md5animpart(char *maskstr);
void md5link(int *parent, int *child, char *tagname, float *x, float *y, float *z);
void md5noclip(char *meshname, int *noclip);

void setiqmdir(char *name);  
void iqmload(char *meshfile, char *skelname);
void iqmtag(char *name, char *tagname);        
void iqmpitch(char *name, float *pitchscale, float *pitchoffset, float *pitchmin, float *pitchmax);
void iqmadjust(char *name, float *yaw, float *pitch, float *roll, float *tx, float *ty, float *tz);
void iqmskin(char *meshname, char *tex, char *masks, float *envmapmax, float *envmapmin);
void iqmspec(char *meshname, int *percent);
void iqmambient(char *meshname, int *percent);
void iqmglow(char *meshname, int *percent);
void iqmglare(char *meshname, float *specglare, float *glowglare);
void iqmalphatest(char *meshname, float *cutoff);
void iqmalphablend(char *meshname, int *blend);
void iqmcullface(char *meshname, int *cullface);
void iqmenvmap(char *meshname, char *envmap);
void iqmbumpmap(char *meshname, char *normalmap, char *skin);
void iqmfullbright(char *meshname, float *fullbright);
void iqmshader(char *meshname, char *shader);
void iqmscroll(char *meshname, float *scrollu, float *scrollv);
void iqmanim(char *anim, char *animfile, float *speed, int *priority);
void iqmanimpart(char *maskstr);
void iqmlink(int *parent, int *child, char *tagname, float *x, float *y, float *z);
void iqmnoclip(char *meshname, int *noclip);

void setsmddir(char *name);  
void smdload(char *meshfile, char *skelname);
void smdtag(char *name, char *tagname);        
void smdpitch(char *name, float *pitchscale, float *pitchoffset, float *pitchmin, float *pitchmax);
void smdadjust(char *name, float *yaw, float *pitch, float *roll, float *tx, float *ty, float *tz);
void smdskin(char *meshname, char *tex, char *masks, float *envmapmax, float *envmapmin);
void smdspec(char *meshname, int *percent);
void smdambient(char *meshname, int *percent);
void smdglow(char *meshname, int *percent);
void smdglare(char *meshname, float *specglare, float *glowglare);
void smdalphatest(char *meshname, float *cutoff);
void smdalphablend(char *meshname, int *blend);
void smdcullface(char *meshname, int *cullface);
void smdenvmap(char *meshname, char *envmap);
void smdbumpmap(char *meshname, char *normalmap, char *skin);
void smdfullbright(char *meshname, float *fullbright);
void smdshader(char *meshname, char *shader);
void smdscroll(char *meshname, float *scrollu, float *scrollv);
void smdanim(char *anim, char *animfile, float *speed, int *priority);
void smdanimpart(char *maskstr);
void smdlink(int *parent, int *child, char *tagname, float *x, float *y, float *z);
void smdnoclip(char *meshname, int *noclip);

extern bool getkeydown();
extern bool getkeyup();
extern bool getmousedown();
extern bool getmouseup();

void clearmodel(char *name);
void keymap(int *code, char *key);
void newfont(char *name, char *tex, int *defaultw, int *defaulth, int *offsetx, int *offsety, int *offsetw, int *offseth);
void fontoffset(char *c);
void fontchar(int *x, int *y, int *w, int *h);
void registersound(char *name, int *vol);

void run_python(char *code);

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

void force_quit();
void quit();
void screenres(int *w, int *h);
void resetgl();
void getfps_(int *raw);

void resetlightmaps(bool fullclean);
void calclight(int *quality);
void patchlight(int *quality);
void clearlightmaps();
void dumplms();

void clearblendbrushes();
void delblendbrush(const char *name);
void addblendbrush(const char *name, const char *imgname);
void nextblendbrush(int *dir);
void setblendbrush(const char *name);
void getblendbrushname(int *n);
void curblendbrush();
void rotateblendbrush(int *val);
void paintblendmap(bool msg);

extern int paintingblendmap;

void clearblendmapsel();
void invertblendmapsel();
void invertblendmap();
void showblendmap();
void optimizeblendmap();
void resetblendmap();

extern int conskip, miniconskip;
void setconskip(int &skip, int filter, int n);
extern vector<cline> conlines;
void bindkey(char *key, char *action, int state, const char *cmd);
void getbind(char *key, int type);
void searchbinds(char *action, int type);
void inputcommand(char *init, char *action = NULL, char *prompt = NULL);
void addfilecomplete(char *command, char *dir, char *ext);
void addlistcomplete(char *command, char *list);
void history_(int *n);
void onrelease(char *s);

void movie(char *name);
void recalc();
void glext(char *ext);
void loadcrosshair_(const char *name, int *i);
void tabify(const char *str, int *numtabs);
void resetsound();
void trydisconnect();
void printcube();
void remip_();
void phystest();
void clearpvs();
void testpvs(int *vcsize);
void genpvs(int *viewcellsize);
void pvsstats();

extern vector<int> htextures;
extern bool havesel;
extern int orient, reptex;
extern ivec cur;
void cubecancel();
void reorient();
void selextend();
void copy();
void pastehilite();
void paste();
void editundo();
void editredo();
void clearbrush();
void brushvert(int x, int y, int v);
void pushsel(int *dir);
void editface(int *dir, int *mode);
void delcube();
void mpeditvslot(VSlot &ds, int allfaces, selinfo &sel, bool local);
void edittex_(int *dir);
void gettex();
void getcurtex();
void getseltex();
void gettexname(int *tex, int *subslot);
void replace(bool insel);
void flip();
void rotate(int *cw);
void editmat(char *name, char *filtername);
void showtexgui(int *n);

void startlistenserver(int usemaster);
void stoplistenserver();

#ifdef CLIENT
extern MSlot materialslots[MATF_VOLUME+1];
enum
{
    IMG_BMP = 0,
    IMG_TGA = 1,
    IMG_PNG = 2,
    NUMIMG
};

void fixinsidefaces(cube *c, const ivec &o, int size, int tex);
void propagatevslot(VSlot &dst, const VSlot &src, int diff, bool edit = false);
void propagatevslot(VSlot *root, int changed);
void reloadtex(char *name);
void gendds(char *infile, char *outfile);
void screenshot(char *filename);
int guessimageformat(const char *filename, int format = IMG_BMP);
void saveimage(const char *filename, int format, ImageData &image, bool flip = false);
#endif

extern int entlooplevel, efocus, enthover, oldhover;
extern bool undonext;
extern selinfo sel;
void entadd(int id);
bool noentedit();

void printent(extentity &e, char *buf);
void nearestent();
void entset(char *what, int *a1, int *a2, int *a3, int *a4, int *a5);
void addentity(int id);
void removeentity(int id);
void detachentity(extentity &e);
void entautoview(int *dir);
void entflip();
void entrotate(int *cw);
void entpush(int *dir);
void attachent();
void newent(char *what, int *a1, int *a2, int *a3, int *a4, int *a5);
void delent();
void dropent();
void entcopy();
void entpaste();
void intensityentcopy();
void intensitypasteent();
void newmap(int *i);
void mapenlarge();
void shrinkmap();

void writeobj(char *name);

namespace game
{
    void toserver(char *text);
    fpsent *followingplayer();
}
void scorebshow(bool on);

void reloadmodel(char* name);

namespace EditingSystem {
#ifdef CLIENT
    extern int savedMousePosTime;
    extern vec savedMousePos;
#endif
    extern std::vector<std::string> entityClasses;
    void newEntity(std::string _class, std::string stateData);
    void prepareentityclasses();
}
void debugoctree();
void centerent();
#ifdef CLIENT
void listtex();
void massreplacetex(char *filename);

namespace MasterServer { void do_login(char *username, char *password); }
#endif

bool addzip(const char *name, const char *mount = NULL, const char *strip = NULL);
bool removezip(const char *name);

/* Here begin the binds. Close them in C++ namespace */
namespace lua_binds
{

/*
 * Things to go into Logging Lua namespace
 */
LUA_BIND_DEF(log, Logging::log((Logging::Level)e.get<int>(1), "%s\n", e.get<const char*>(2));)
LUA_BIND_DEF(echo, conoutf("\f1%s", e.get<const char*>(1));)

/*
 * Things to go into CAPI Lua namespace
 */

// General
LUA_BIND_DEF(currTime, e.push(Utility::SystemInfo::currTime());)

// Math extensions
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

// Entity management
LUA_BIND_DEF(unregisterLogicEntity, LogicSystem::unregisterLogicEntityByUniqueId(e.get<int>(1));)
LUA_BIND_DEF(placeInWorld, WorldSystem::placeInWorld(e.get<int>(1), e.get<int>(2));)

LUA_BIND_SE(setupExtent, LogicSystem::setupExtent(ref,
    e.get<int>(2),
    e.get<double>(3),
    e.get<double>(4),
    e.get<double>(5),
    e.get<int>(6),
    e.get<int>(7),
    e.get<int>(8),
    e.get<int>(9));
)
LUA_BIND_SE(setupCharacter,     LogicSystem::setupCharacter(ref);)
LUA_BIND_SE(setupNonSauer,      LogicSystem::setupNonSauer(ref);)
LUA_BIND_SE(dismantleExtent,    LogicSystem::dismantleExtent(ref);)
LUA_BIND_SE(dismantleCharacter, LogicSystem::dismantleCharacter(ref);)

// Entity attribs
LUA_BIND_LE(setAnimation, self.get()->setAnimation(e.get<int>(2));)
LUA_BIND_LE(getStartTime, e.push(self.get()->getStartTime());)
LUA_BIND_LE(setModelName, {
    Logging::log(Logging::DEBUG, "setModelName(%s)\r\n", e.get<const char*>(2));
    self.get()->setModel(std::string(e.get<const char*>(2)));
})
LUA_BIND_LE(setSoundName, {
    Logging::log(Logging::DEBUG, "setSoundName(%s)\r\n", e.get<const char*>(2));
    self.get()->setSound(std::string(e.get<const char*>(2)));
})
LUA_BIND_LE(setSoundVolume, {
    Logging::log(Logging::DEBUG, "setSoundVolume(%i)\r\n", e.get<int>(2));
    extentity *ext = self.get()->staticEntity;
    assert(ext);
    if (!WorldSystem::loadingWorld) removeentity(ext);
    ext->attr4 = e.get<int>(2);
    if (!WorldSystem::loadingWorld) addentity(ext);
    // finally reload sound, so everything gets applied
    self.get()->setSound(self.get()->soundName.c_str());
})
LUA_BIND_LE(setAttachments_raw, self.get()->setAttachments(std::string(e.get<const char*>(2)));)
LUA_BIND_LE(getAttachmentPosition, {
    vec& vp = self->getAttachmentPosition(std::string(e.get<const char*>(2)));
    e.push(vp);
})
LUA_BIND_LE(setCanMove, self.get()->setCanMove(e.get<bool>(2));)

// Extents

#define EXTENT_ACCESSORS(name, attribName) \
LUA_BIND_LE(get##name, { \
    extentity *ext = self.get()->staticEntity; \
    assert(ext); \
    e.push(ext->attribName); \
}) \
LUA_BIND_LE(set##name, { \
    extentity *ext = self.get()->staticEntity; \
    assert(ext); \
    if (!WorldSystem::loadingWorld) removeentity(ext); /* Need to remove, then add, to the world on each change, if not during load. */ \
    ext->attribName = e.get<int>(2); \
    if (!WorldSystem::loadingWorld) addentity(ext); \
}) \
LUA_BIND_LE(FAST_set##name, { \
    /* Fast version - no removeentity/addentity. Use with care! */ \
    extentity *ext = self.get()->staticEntity; \
    assert(ext); \
    ext->attribName = e.get<int>(2); \
})

EXTENT_ACCESSORS(Attr1, attr1)
EXTENT_ACCESSORS(Attr2, attr2)
EXTENT_ACCESSORS(Attr3, attr3)
EXTENT_ACCESSORS(Attr4, attr4)

#define EXTENT_LE_ACCESSORS(name, attribName) \
LUA_BIND_LE(get##name, e.push(self->attribName);) \
LUA_BIND_LE(set##name, { \
    Logging::log(Logging::DEBUG, "ACCESSOR: Setting %s to %f\r\n", #attribName, e.get<double>(2)); \
    assert(self->staticEntity); \
    if (!WorldSystem::loadingWorld) removeentity(self->staticEntity); /* Need to remove, then add, to the octa world on each change. */ \
    self->attribName = e.get<double>(2); \
    if (!WorldSystem::loadingWorld) addentity(self->staticEntity); \
})

EXTENT_LE_ACCESSORS(CollisionRadiusWidth, collisionRadiusWidth)
EXTENT_LE_ACCESSORS(CollisionRadiusHeight, collisionRadiusHeight)

// Add 'FAST' versions of accessors - no addentity/removeentity. Good to change e.g. particle parameters

LUA_BIND_LE(getExtent0_raw, {
    int arg2 = e.get<int>(2);
    extentity *ext = self.get()->staticEntity;
    assert(ext);
    assert(arg2 >= 0 && arg2 <= 2);

    Logging::log(Logging::INFO, "getExtentO_raw(%d): %f\r\n", arg2, ext->o[arg2]);

    e.push(ext->o[arg2]);
})

LUA_BIND_LE(setExtent0_raw, {
    extentity *ext = self.get()->staticEntity;
    assert(ext);

    removeentity(ext); /* Need to remove, then add, to the octa world on each change. */
    ext->o.x = e.get<double>(2);
    ext->o.y = e.get<double>(3);
    ext->o.z = e.get<double>(4);
    addentity(ext);
})

// Dynents

#define DYNENT_ACCESSORS(name, type, attribName) \
LUA_BIND_LE(get##name, { \
    fpsent *d = (fpsent*)self.get()->dynamicEntity; \
    assert(d); \
    e.push((type)d->attribName); \
}) \
LUA_BIND_LE(set##name, { \
    fpsent *d = (fpsent*)self.get()->dynamicEntity; \
    assert(d); \
    d->attribName = e.get<type>(2); \
})

DYNENT_ACCESSORS(MaxSpeed, double, maxspeed)
DYNENT_ACCESSORS(Radius, double, radius)
DYNENT_ACCESSORS(EyeHeight, double, eyeheight)
DYNENT_ACCESSORS(Aboveeye, double, aboveeye)
DYNENT_ACCESSORS(Yaw, double, yaw)
DYNENT_ACCESSORS(Pitch, double, pitch)
DYNENT_ACCESSORS(Move, int, move)
DYNENT_ACCESSORS(Strafe, int, strafe)
DYNENT_ACCESSORS(Yawing, int, turn_move)
DYNENT_ACCESSORS(Pitching, int, look_updown_move)
DYNENT_ACCESSORS(Jumping, bool, jumping)
DYNENT_ACCESSORS(Blocked, bool, blocked)
DYNENT_ACCESSORS(MapDefinedPositionData, int, mapDefinedPositionData) // XXX Should be unsigned
DYNENT_ACCESSORS(ClientState, int, state);
DYNENT_ACCESSORS(PhysicalState, int, physstate);
DYNENT_ACCESSORS(InWater, int, inwater)
DYNENT_ACCESSORS(TimeInAir, int, timeinair)

// For dynents, 'o' is at their head, not their feet like static entities. We make this uniform by
// letting lua specify a feet position, and we work relative to their height - add to
// assignments, subtract from readings
LUA_BIND_LE(getDynent0_raw, {
    int arg2 = e.get<int>(2);
    fpsent *d = (fpsent*)self.get()->dynamicEntity;
    assert(d);
    assert(arg2 >= 0 && arg2 <= 2);

    if (arg2 != 2) {
        e.push(d->o[arg2]);
    } else {
        e.push(d->o.z - d->eyeheight);// - d->aboveeye);
    }
})

LUA_BIND_LE(setDynent0_raw, {
    fpsent *d = (fpsent*)self.get()->dynamicEntity;
    assert(d);

    d->o.x = e.get<double>(2);
    d->o.y = e.get<double>(3);
    d->o.z = e.get<double>(4) + d->eyeheight;// + d->aboveeye;

    // Also set 'newpos', otherwise this change may get overwritten
    d->newpos = d->o;

    d->resetinterp(); // No need to interpolate to last position - just jump

    Logging::log(Logging::INFO, "(%d).setDynentO(%f, %f, %f)\r\n", d->uniqueId, d->o.x, d->o.y, d->o.z);
})

LUA_BIND_LE(getDynentVel_raw, {
    int arg2 = e.get<int>(2);
    fpsent *d = (fpsent*)self.get()->dynamicEntity;
    assert(d);
    assert(arg2 >= 0 && arg2 <= 2);

    e.push(d->vel[arg2]);
})

LUA_BIND_LE(setDynentVel_raw, {
    fpsent *d = (fpsent*)self.get()->dynamicEntity;
    assert(d);

    d->vel.x = e.get<double>(2);
    d->vel.y = e.get<double>(3);
    d->vel.z = e.get<double>(4);
})

LUA_BIND_LE(getDynentFalling_raw, {
    int arg2 = e.get<int>(2);
    fpsent *d = (fpsent*)self.get()->dynamicEntity;
    assert(d);
    assert(arg2 >= 0 && arg2 <= 2);

    e.push(d->falling[arg2]);
})

LUA_BIND_LE(setDynentFalling_raw, {
    fpsent *d = (fpsent*)self.get()->dynamicEntity;
    assert(d);

    d->falling.x = e.get<double>(2);
    d->falling.y = e.get<double>(3);
    d->falling.z = e.get<double>(4);
})

// Geometry utilities

LUA_BIND_DEF(rayLos, {
    vec a(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    vec b(e.get<double>(4), e.get<double>(5), e.get<double>(6));
    vec target;

    bool ret = raycubelos(a, b, target);
    e.push(ret);
})

LUA_BIND_DEF(rayPos, {
    vec o(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    vec ray(e.get<double>(4), e.get<double>(5), e.get<double>(6));
    vec hitpos(0);
    e.push(raycubepos(o, ray, hitpos, e.get<double>(7), RAY_CLIPMAT|RAY_POLY));
})

LUA_BIND_DEF(rayFloor, {
    vec o(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    vec floor(0);
    e.push(rayfloor(o, floor, 0, e.get<double>(4)));
})

// World

LUA_BIND_DEF(isColliding, {
    vec pos(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    e.push(PhysicsManager::getEngine()->isColliding(
        pos,
        e.get<double>(4),
        e.get<int>(5) != -1 ? LogicSystem::getLogicEntity(e.get<int>(5)).get() : NULL)
    ); // TODO: Make faster, avoid this lookup
})

LUA_BIND_DEF(setGravity, {
    if (PhysicsManager::hasEngine())
        PhysicsManager::getEngine()->setGravity(e.get<double>(1));
    else
    {
        Logging::log(Logging::DEBUG, "Setting gravity using sauer system, as no physics engine\r\n");
        GRAVITY = e.get<double>(1);
    }
})

LUA_BIND_DEF(getMaterial, e.push(lookupmaterial(vec(e.get<double>(1), e.get<double>(2), e.get<double>(3))));)

// Textures

LUA_BIND_CLIENT(convertPNGtoDDS, {
    std::string arg1 = std::string(e.get<const char*>(1));
    std::string arg2 = std::string(e.get<const char*>(2));
    assert(Utility::validateRelativePath(arg1));
    assert(Utility::validateRelativePath(arg2));
    IntensityTexture::convertPNGtoDDS(arg1, arg2);
})

LUA_BIND_CLIENT(combineImages, {
    std::string arg1 = std::string(e.get<const char*>(1));
    std::string arg2 = std::string(e.get<const char*>(2));
    std::string arg3 = std::string(e.get<const char*>(3));
    assert(Utility::validateRelativePath(arg1));
    assert(Utility::validateRelativePath(arg2));
    assert(Utility::validateRelativePath(arg3));
    IntensityTexture::combineImages(arg1, arg2, arg3);
})

// Sounds

LUA_BIND_CLIENT(playSoundByName, {
    vec loc(e.get<double>(2), e.get<double>(3), e.get<double>(4));
    if (loc.x || loc.y || loc.z)
        playsoundname(e.get<const char*>(1), &loc, e.get<int>(5));
    else
        playsoundname(e.get<const char*>(1));
})
LUA_BIND_STD_CLIENT(stopSoundByName, stopsoundbyid, getsoundid(e.get<const char*>(1), e.get<int>(2)))
LUA_BIND_STD_CLIENT(music, startmusic, (char*)e.get<const char*>(1), (char*)"Sound.musicCallback()")
LUA_BIND_CLIENT(preloadSound, {
    defformatstring(str)("preloading sound '%s'...", e.get<const char*>(1));
    renderprogress(0, str);

    e.push(preload_sound((char*)e.get<const char*>(1), min(e.get<int>(2), 100)));
})

#ifdef CLIENT
LUA_BIND_STD(playSound, playsound, e.get<int>(1)) // TODO: sound position
#else
LUA_BIND_STD(playSound, MessageSystem::send_SoundToClients, -1, e.get<int>(1), -1)
#endif

// Effects

LUA_BIND_CLIENT(addDecal, {
    vec  center(e.get<double>(2), e.get<double>(3), e.get<double>(4));
    vec  surface(e.get<double>(5), e.get<double>(6), e.get<double>(7));
    bvec color(e.get<int>(9), e.get<int>(10), e.get<int>(11));

    adddecal(e.get<int>(1), center, surface, e.get<double>(8), color, e.get<int>(12));
})

LUA_BIND_CLIENT(particleSplash, {
    if (e.get<int>(1) == PART_BLOOD && !GETIV(blood)) return;
    vec p(e.get<double>(4), e.get<double>(5), e.get<double>(6));
    particle_splash(
        e.get<int>(1),
        e.get<int>(2),
        e.get<int>(3),
        p,
        e.get<int>(7),
        e.get<double>(8),
        e.get<int>(9),
        e.get<int>(10),
        e.get<bool>(11),
        e.get<int>(12),
        e.get<bool>(13),
        e.get<int>(14)
    );
})

LUA_BIND_CLIENT(particleSplashRegular, {
    if (e.get<int>(1) == PART_BLOOD && !GETIV(blood)) return;
    vec p(e.get<double>(4), e.get<double>(5), e.get<double>(6));
    regular_particle_splash(
        e.get<int>(1),
        e.get<int>(2),
        e.get<int>(3),
        p,
        e.get<int>(7),
        e.get<double>(8),
        e.get<int>(9),
        e.get<int>(10),
        e.get<int>(11),
        e.get<bool>(12),
        e.get<int>(13)
    );
})

LUA_BIND_CLIENT(particleFireball, {
    vec dest(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    particle_fireball(dest, e.get<double>(4), e.get<int>(5), e.get<int>(6), e.get<int>(7), e.get<double>(8));
})

LUA_BIND_CLIENT(particleExplodeSplash, {
    vec o(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    particle_explodesplash(o, e.get<int>(4), e.get<int>(5), e.get<int>(6), e.get<int>(7), e.get<int>(8), e.get<int>(9));
})

LUA_BIND_CLIENT(particleFlare, {
    vec p(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    vec dest(e.get<double>(4), e.get<double>(5), e.get<double>(6));
    if (e.get<int>(12) < 0)
        particle_flare(p, dest, e.get<int>(7), e.get<int>(8), e.get<int>(9), e.get<double>(10), NULL, e.get<int>(11));
    else
    {
        LogicEntityPtr owner = LogicSystem::getLogicEntity(e.get<int>(12));
        assert(owner.get()->dynamicEntity);
        particle_flare(p, dest, e.get<int>(7), e.get<int>(8), e.get<int>(9), e.get<double>(10), (fpsent*)(owner.get()->dynamicEntity), e.get<int>(11));
    }
})

LUA_BIND_CLIENT(particleFlyingFlare, {
    vec p(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    vec dest(e.get<double>(4), e.get<double>(5), e.get<double>(6));
    particle_flying_flare(p, dest, e.get<int>(7), e.get<int>(8), e.get<int>(9), e.get<double>(10), e.get<int>(11));
})

LUA_BIND_CLIENT(particleTrail, {
    vec from(e.get<double>(3), e.get<double>(4), e.get<double>(5));
    vec to(e.get<double>(6), e.get<double>(7), e.get<double>(8));
    particle_trail(e.get<int>(1), e.get<int>(2), from, to, e.get<int>(9), e.get<double>(10), e.get<int>(11), e.get<bool>(12));
})

LUA_BIND_CLIENT(particleFlame, {
    regular_particle_flame(
        e.get<int>(1),
        vec(e.get<double>(2), e.get<double>(3), e.get<double>(4)),
        e.get<double>(5),
        e.get<double>(6),
        e.get<int>(7),
        e.get<int>(8),
        e.get<double>(9),
        e.get<double>(10),
        e.get<double>(11),
        e.get<int>(12)
    );
})

LUA_BIND_CLIENT(addDynlight, {
    vec o(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    vec color(float(e.get<double>(5))/255.0, float(e.get<double>(6))/255.0, float(e.get<double>(7))/255.0);
    vec initcolor(float(e.get<double>(12))/255.0, float(e.get<double>(13))/255.0, float(e.get<double>(14))/255.0);

    LightControl::queueDynamicLight(o, e.get<double>(4), color, e.get<int>(8), e.get<int>(9), e.get<int>(10), e.get<double>(11), initcolor, NULL);
})

LUA_BIND_CLIENT(spawnDebris, {
    vec v(e.get<double>(2), e.get<double>(3), e.get<double>(4));
    vec debrisvel(e.get<double>(6), e.get<double>(7), e.get<double>(8));

    LogicEntityPtr owner = LogicSystem::getLogicEntity(e.get<int>(9));
    assert(owner->dynamicEntity);
    FPSClientInterface::spawnDebris(e.get<int>(1), v, e.get<int>(5), debrisvel, (dynent*)(owner->dynamicEntity));
})

LUA_BIND_CLIENT(particleMeter, {
    vec s(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    particle_meter(s, e.get<double>(4), e.get<int>(5), e.get<int>(6));
})

LUA_BIND_CLIENT(particleText, {
    vec s(e.get<double>(1), e.get<double>(2), e.get<double>(3));
    particle_textcopy(s, e.get<const char*>(4), e.get<int>(5), e.get<int>(6), e.get<int>(7), e.get<double>(8), e.get<int>(9));
})

LUA_BIND_CLIENT(clientDamageEffect, {
    ((fpsent*)player)->damageroll(e.get<int>(1));
    damageblend(e.get<int>(2));
})

LUA_BIND_CLIENT(showHUDRect,  ClientSystem::addHUDRect (e.get<double>(1), e.get<double>(2), e.get<double>(3), e.get<double>(4), e.get<int>(5), e.get<double>(6));)
LUA_BIND_CLIENT(showHUDImage, ClientSystem::addHUDImage(std::string(e.get<const char*>(1)), e.get<double>(2), e.get<double>(3), e.get<double>(4), e.get<double>(5), e.get<int>(6), e.get<double>(7));)

// text, x, y, scale, color
LUA_BIND_CLIENT(showHUDText, ClientSystem::addHUDText(std::string(e.get<const char*>(1)), e.get<double>(2), e.get<double>(3), e.get<double>(4), e.get<int>(5));)

// Messages

using namespace MessageSystem;

LUA_BIND_DEF(PersonalServerMessage, send_PersonalServerMessage(e.get<int>(1), e.get<int>(2), std::string(e.get<const char*>(3)), std::string(e.get<const char*>(4)));)
LUA_BIND_DEF(ParticleSplashToClients, send_ParticleSplashToClients(e.get<int>(1), e.get<int>(2), e.get<int>(3), e.get<int>(4), e.get<double>(5), e.get<double>(6), e.get<double>(7));)
LUA_BIND_DEF(ParticleSplashRegularToClients, send_ParticleSplashToClients(e.get<int>(1), e.get<int>(2), e.get<int>(3), e.get<int>(4), e.get<double>(5), e.get<double>(6), e.get<double>(7));)
LUA_BIND_DEF(SoundToClientsByName, send_SoundToClientsByName(e.get<int>(1), e.get<double>(2), e.get<double>(3), e.get<double>(4), std::string(e.get<const char*>(5)), e.get<int>(6));)
LUA_BIND_DEF(StateDataChangeRequest, send_StateDataChangeRequest(e.get<int>(1), e.get<int>(2), std::string(e.get<const char*>(3)));)
LUA_BIND_DEF(UnreliableStateDataChangeRequest, send_UnreliableStateDataChangeRequest(e.get<int>(1), e.get<int>(2), std::string(e.get<const char*>(3)));)
LUA_BIND_DEF(NotifyNumEntities, send_NotifyNumEntities(e.get<int>(1), e.get<int>(2));)
LUA_BIND_DEF(LogicEntityCompleteNotification, send_LogicEntityCompleteNotification(e.get<int>(1), e.get<int>(2), e.get<int>(3), std::string(e.get<const char*>(4)), std::string(e.get<const char*>(5)));)
LUA_BIND_DEF(LogicEntityRemoval, send_LogicEntityRemoval(e.get<int>(1), e.get<int>(2));)
LUA_BIND_DEF(StateDataUpdate, send_StateDataUpdate(e.get<int>(1), e.get<int>(2), e.get<int>(3), std::string(e.get<const char*>(4)), e.get<int>(5));)
LUA_BIND_DEF(UnrealiableStateDataUpdate, send_UnreliableStateDataUpdate(e.get<int>(1), e.get<int>(2), e.get<int>(3), std::string(e.get<const char*>(4)), e.get<int>(5));)
LUA_BIND_DEF(DoClick, send_DoClick(e.get<int>(1), e.get<int>(2), e.get<double>(3), e.get<double>(4), e.get<double>(5), e.get<int>(6));)
LUA_BIND_DEF(ExtentCompleteNotification, send_ExtentCompleteNotification(
    e.get<int>(1),
    e.get<int>(2),
    std::string(e.get<const char*>(3)),
    std::string(e.get<const char*>(4)),
    e.get<double>(5),
    e.get<double>(6),
    e.get<double>(7),
    e.get<int>(8),
    e.get<int>(9),
    e.get<int>(10),
    e.get<int>(11)
);)

// File access

LUA_BIND_DEF(readFile, {
    try
    {
        REFLECT_PYTHON( read_file_safely );

        boost::python::object data = read_file_safely(std::string(e.get<const char*>(1)));
        const char *text = boost::python::extract<const char*>(data);

        e.push(text);
    }
    catch(boost::python::error_already_set const &)
    {
        printf("Error in Python execution of embedded read_file_safely\r\n");
        PyErr_Print();
        assert(0 && "Halting on Python error");
    }
})

// Mapping

LUA_BIND_CLIENT(textureReset, {
    texturereset(0);
})
LUA_BIND_CLIENT(texture, {
    // XXX: arg7 may not be given, in which case it is undefined, and turns into 0.
    texture(e.get<const char*>(1), e.get<const char*>(2), e.get<int>(3), e.get<int>(4), e.get<int>(5), (float)e.get<double>(6), e.get<int>(7));
})
LUA_BIND_DEF(mapmodelReset, mapmodelreset(e.get<int*>(1));)
LUA_BIND_DEF(mapmodel, mmodel(e.get<char*>(1));)
LUA_BIND_DEF(numMapModels, e.push(mapmodels.length());)
LUA_BIND_STD(clearModel, clearmodel, e.get<char*>(1))

// shaders

LUA_BIND_STD_CLIENT(shader, shader, e.get<int*>(1), e.get<char*>(2), e.get<char*>(3), e.get<char*>(4))
LUA_BIND_STD_CLIENT(variantShader, variantshader, e.get<int*>(1), e.get<char*>(2), e.get<int*>(3), e.get<char*>(4), e.get<char*>(5))
LUA_BIND_STD_CLIENT(setShader, setshader, e.get<char*>(1))
LUA_BIND_STD_CLIENT(altShader, altshader, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD_CLIENT(fastShader, fastshader, e.get<char*>(1), e.get<char*>(2), e.get<int*>(3))
LUA_BIND_STD_CLIENT(deferShader, defershader, e.get<int*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(forceShader, useshaderbyname, e.get<char*>(1))

LUA_BIND_STD_CLIENT(isShaderDefined, isshaderdefined, e.get<char*>(1))
LUA_BIND_STD_CLIENT(isShaderNative, isshadernative, e.get<char*>(1))

LUA_BIND_STD_CLIENT(setVertexParam, addshaderparam, NULL, SHPARAM_VERTEX, e.get<int>(1), e.get<float>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5))
LUA_BIND_STD_CLIENT(setPixelParam, addshaderparam, NULL, SHPARAM_VERTEX, e.get<int>(1), e.get<float>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5))
LUA_BIND_STD_CLIENT(setUniformParam, addshaderparam, e.get<char*>(1), SHPARAM_UNIFORM, -1, e.get<float>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5))
LUA_BIND_STD_CLIENT(setShaderParam, addshaderparam, e.get<char*>(1), SHPARAM_LOOKUP, -1, e.get<float>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5))
LUA_BIND_STD_CLIENT(defVertexParam, addshaderparam, e.get<char*>(1)[0] ? e.get<char*>(1) : NULL, SHPARAM_VERTEX, e.get<int>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5), e.get<float>(6))
LUA_BIND_STD_CLIENT(defPixelParam, addshaderparam, e.get<char*>(1)[0] ? e.get<char*>(1) : NULL, SHPARAM_PIXEL, e.get<int>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5), e.get<float>(6))
LUA_BIND_STD_CLIENT(defUniformParam, addshaderparam, e.get<char*>(1), SHPARAM_UNIFORM, -1, e.get<float>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5))

LUA_BIND_STD_CLIENT(addPostFX, addpostfx, e.get<const char*>(1), e.get<int>(2), e.get<int>(3), e.get<const char*>(4), e.get<float>(5), e.get<float>(6), e.get<float>(7), e.get<float>(8))
LUA_BIND_STD_CLIENT(setPostFX, setpostfx, e.get<const char*>(1), e.get<float>(2), e.get<float>(3), e.get<float>(4), e.get<float>(5))
LUA_BIND_STD_CLIENT(clearPostFX, clearpostfx)

// Models

LUA_BIND_STD(mdlName, mdlname)

LUA_BIND_STD(mdlAlphatest, mdlalphatest, e.get<float*>(1))
LUA_BIND_STD(mdlAlphablend, mdlalphablend, e.get<int*>(1))
LUA_BIND_STD(mdlAlphadepth, mdlalphadepth, e.get<int*>(1))

LUA_BIND_STD(mdlBb, mdlbb, e.get<float*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(mdlExtendbb, mdlextendbb, e.get<float*>(1), e.get<float*>(2), e.get<float*>(3))

LUA_BIND_STD(mdlScale, mdlscale, e.get<int*>(1))
LUA_BIND_STD(mdlSpec, mdlspec, e.get<int*>(1))
LUA_BIND_STD(mdlGlow, mdlglow, e.get<int*>(1))
LUA_BIND_STD(mdlGlare, mdlglare, e.get<float*>(1), e.get<float*>(2))
LUA_BIND_STD(mdlAmbient, mdlambient, e.get<int*>(1))
LUA_BIND_STD(mdlCullface, mdlcullface, e.get<int*>(1))
LUA_BIND_STD(mdlDepthoffset, mdldepthoffset, e.get<int*>(1))
LUA_BIND_STD(mdlFullbright, mdlfullbright, e.get<float*>(1))
LUA_BIND_STD(mdlSpin, mdlspin, e.get<float*>(1), e.get<float*>(2))
LUA_BIND_STD(mdlEnvmap, mdlenvmap, e.get<float*>(1), e.get<float*>(2), e.get<char*>(3))

LUA_BIND_STD(mdlShader, mdlshader, e.get<char*>(1))

LUA_BIND_STD(mdlCollisionsOnlyForTriggering, mdlcollisionsonlyfortriggering, e.get<int*>(1))

LUA_BIND_STD(mdlTrans, mdltrans, e.get<float*>(1), e.get<float*>(2), e.get<float*>(3))

LUA_BIND_STD(modelYaw, mdlyaw, e.get<float*>(1))
LUA_BIND_STD(modelPitch, mdlpitch, e.get<float*>(1))
LUA_BIND_STD(modelShadow, mdlshadow, e.get<int*>(1))
LUA_BIND_STD(modelCollide, mdlcollide, e.get<int*>(1))
LUA_BIND_STD(modelPerEntityCollisionBoxes, mdlperentitycollisionboxes, e.get<int*>(1))
LUA_BIND_STD(modelEllipseCollide, mdlellipsecollide, e.get<int*>(1))

LUA_BIND_STD(objLoad, objload, e.get<char*>(1), e.get<float*>(2))

LUA_BIND_STD(objSkin, objskin, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(objBumpmap, objbumpmap, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD(objEnvmap, objenvmap, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(objSpec, objspec, e.get<char*>(1), e.get<int*>(2))

LUA_BIND_STD(objPitch, objpitch, e.get<float*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4))
LUA_BIND_STD(objAmbient, objambient, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(objGlow, objglow, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(objGlare, objglare, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(objAlphatest, objalphatest, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(objAlphablend, objalphablend, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(objCullface, objcullface, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(objFullbright, objfullbright, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(objShader, objshader, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(objScroll, objscroll, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(objNoclip, objnoclip, e.get<char*>(1), e.get<int*>(2))

LUA_BIND_STD(md5Dir, setmd5dir, e.get<char*>(1))
LUA_BIND_STD(md5Load, md5load, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3))
LUA_BIND_STD(md5Tag, md5tag, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(md5Pitch, md5pitch, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(md5Adjust, md5adjust, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6), e.get<float*>(7))
LUA_BIND_STD(md5Skin, md5skin, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(md5Spec, md5spec, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(md5Ambient, md5ambient, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(md5Glow, md5glow, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(md5Glare, md5glare, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(md5Alphatest, md5alphatest, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(md5Alphablend, md5alphablend, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(md5Cullface, md5cullface, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(md5Envmap, md5envmap, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(md5Bumpmap, md5bumpmap, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD(md5Fullbright, md5fullbright, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(md5Shader, md5shader, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(md5Scroll, md5scroll, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(md5Animpart, md5animpart, e.get<char*>(1))
LUA_BIND_STD(md5Anim, md5anim, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<int*>(4))
LUA_BIND_STD(md5Link, md5link, e.get<int*>(1), e.get<int*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6))
LUA_BIND_STD(md5Noclip, md5noclip, e.get<char*>(1), e.get<int*>(2))

LUA_BIND_STD(iqmDir, setiqmdir, e.get<char*>(1))
LUA_BIND_STD(iqmLoad, iqmload, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(iqmTag, iqmtag, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(iqmPitch, iqmpitch, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(iqmAdjust, iqmadjust, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6), e.get<float*>(7))
LUA_BIND_STD(iqmSkin, iqmskin, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(iqmSpec, iqmspec, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(iqmAmbient, iqmambient, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(iqmGlow, iqmglow, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(iqmGlare, iqmglare, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(iqmAlphatest, iqmalphatest, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(iqmAlphablend, iqmalphablend, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(iqmCullface, iqmcullface, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(iqmEnvmap, iqmenvmap, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(iqmBumpmap, iqmbumpmap, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD(iqmFullbright, iqmfullbright, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(iqmShader, iqmshader, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(iqmScroll, iqmscroll, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(iqmAnimpart, iqmanimpart, e.get<char*>(1))
LUA_BIND_STD(iqmAnim, iqmanim, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<int*>(4))
LUA_BIND_STD(iqmLink, iqmlink, e.get<int*>(1), e.get<int*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6))
LUA_BIND_STD(iqmNoclip, iqmnoclip, e.get<char*>(1), e.get<int*>(2))

LUA_BIND_STD(smdDir, setsmddir, e.get<char*>(1))
LUA_BIND_STD(smdLoad, smdload, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(smdTag, smdtag, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(smdPitch, smdpitch, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(smdAdjust, smdadjust, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6), e.get<float*>(7))
LUA_BIND_STD(smdSkin, smdskin, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5))
LUA_BIND_STD(smdSpec, smdspec, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(smdAmbient, smdambient, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(smdGlow, smdglow, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(smdGlare, smdglare, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(smdAlphatest, smdalphatest, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(smdAlphablend, smdalphablend, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(smdCullface, smdcullface, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD(smdEnvmap, smdenvmap, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(smdBumpmap, smdbumpmap, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD(smdFullbright, smdfullbright, e.get<char*>(1), e.get<float*>(2))
LUA_BIND_STD(smdShader, smdshader, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD(smdScroll, smdscroll, e.get<char*>(1), e.get<float*>(2), e.get<float*>(3))
LUA_BIND_STD(smdAnimpart, smdanimpart, e.get<char*>(1))
LUA_BIND_STD(smdAnim, smdanim, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<int*>(4))
LUA_BIND_STD(smdLink, smdlink, e.get<int*>(1), e.get<int*>(2), e.get<char*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6))
LUA_BIND_STD(smdNoclip, smdnoclip, e.get<char*>(1), e.get<int*>(2))

LUA_BIND_STD(rdVert, rdvert, e.get<float*>(1), e.get<float*>(2), e.get<float*>(3), e.get<float*>(4));
LUA_BIND_STD(rdEye, rdeye, e.get<int*>(1));
LUA_BIND_STD(rdTri, rdtri, e.get<int*>(1), e.get<int*>(2), e.get<int*>(3));
LUA_BIND_STD(rdJoint, rdjoint, e.get<int*>(1), e.get<int*>(2), e.get<char*>(3), e.get<char*>(4), e.get<char*>(5));
LUA_BIND_STD(rdLimitDist, rdlimitdist, e.get<int*>(1), e.get<int*>(2), e.get<float*>(3), e.get<float*>(4));
LUA_BIND_STD(rdLimitRot, rdlimitrot, e.get<int*>(1), e.get<int*>(2), e.get<float*>(3), e.get<float*>(4), e.get<float*>(5), e.get<float*>(6), e.get<float*>(7));
LUA_BIND_STD(rdAnimJoints, rdanimjoints, e.get<int*>(1));

// Keyboard

LUA_BIND_DEF(isKeyDown, e.push(getkeydown());)
LUA_BIND_DEF(isKeyUp, e.push(getkeyup());)
LUA_BIND_DEF(isMouseDown, e.push(getmousedown());)
LUA_BIND_DEF(isMouseUp, e.push(getmouseup());)

// Components

LUA_BIND_DEF(signalComponent, {
    try
    {
        REFLECT_PYTHON( signal_signal_component );
        boost::python::object data = signal_signal_component(std::string(e.get<const char*>(1)), std::string(e.get<const char*>(2)));
        e.push(boost::python::extract<const char*>(data));
    }
    catch(boost::python::error_already_set const &)
    {
        printf("Error in signalling python component initialization\r\n");
        PyErr_Print();
        assert(0 && "Halting on Python error");
    }
})

// Models

LUA_BIND_STD(preloadModel, preloadmodel, e.get<const char*>(1))
LUA_BIND_DEF(reloadModel, {
    clearmodel(e.get<char*>(1));
    if (!loadmodel(e.get<char*>(1))) e.error("Cannot load model.");
});

// HUD

LUA_BIND_CLIENT(getTargetPosition, {
    TargetingControl::determineMouseTarget(true); // Force a determination, if needed
    e.push(TargetingControl::targetPosition);
})
LUA_BIND_CLIENT(getTargetEntity, {
    TargetingControl::determineMouseTarget(true); // Force a determination, if needed
    LogicEntityPtr target = TargetingControl::targetLogicEntity;
    if (target.get() && !target->isNone() && target->luaRef >= 0)
        e.getref(target->luaRef);
    else
        e.push();
})

// Rendering

#ifdef CLIENT
static int oldThirdperson = -1;

void prepareRagdoll(int& anim, LogicEntityPtr self)
{
    if (anim&ANIM_RAGDOLL)
    {
//        if (!ragdoll || loadmodel(mdl);
        fpsent* fpsEntity = (fpsent*)self->dynamicEntity;

        if (fpsEntity->clientnum == ClientSystem::playerNumber)
        {
            if (oldThirdperson == -1 && GETIV(thirdperson) == 0)
            {
                oldThirdperson = GETIV(thirdperson);
                SETV(thirdperson, 1);
            }
        }

        if (fpsEntity->ragdoll || !GETIV(ragdoll) || !PhysicsManager::getEngine()->prepareRagdoll(self))
        {
            anim &= ~ANIM_RAGDOLL;
            engine.getref(self.get()->luaRef).t_getraw("setLocalAnimation").push_index(-2).push(anim).call(2, 0);
            engine.pop(1);
        }
    }
    else
    {
        if (self->dynamicEntity)
        {
            fpsent* fpsEntity = (fpsent*)self->dynamicEntity;

            if (fpsEntity->clientnum == ClientSystem::playerNumber && oldThirdperson != -1)
            {
                SETV(thirdperson, oldThirdperson);
                oldThirdperson = -1;
            }
        }
    }
}

fpsent* getProxyFpsEntityLua(LogicEntityPtr self)
{
    engine.getref(self.get()->luaRef).t_getraw("renderingHashHint");
    if (!engine.is<void>(-1))
    {
        static bool initialized = false;
        static fpsent* fpsEntitiesForRendering[1024];

        if (!initialized)
        {
            for (int i = 0; i < 1024; i++)
                fpsEntitiesForRendering[i] = new fpsent;

            initialized = true;
        }

        int renderingHashHint = engine.get<int>(-1);
        engine.pop(2);
        renderingHashHint = renderingHashHint & 1023;
        assert(renderingHashHint >= 0 && renderingHashHint < 1024);
        return fpsEntitiesForRendering[renderingHashHint];
    }
    else
    {
        engine.pop(2);
        return NULL;
    }
}

#define PREP_RENDER_MODEL \
    int anim = e.get<int>(3); \
    prepareRagdoll(anim, self); \
    vec o(e.get<float>(4), e.get<float>(5), e.get<float>(6)); \
    fpsent *fpsEntity = NULL; \
    if (self->dynamicEntity) \
        fpsEntity = (fpsent*)self->dynamicEntity; \
    else \
        fpsEntity = getProxyFpsEntityLua(self);

LUA_BIND_LE(renderModel2, {
    PREP_RENDER_MODEL
    rendermodel(NULL,
        e.get<const char*>(2),
        anim, o, self,
        e.get<float>(7),
        e.get<float>(8),
        e.get<float>(9),
        e.get<int>(10),
        fpsEntity,
        self->attachments,
        e.get<int>(11)
    );
})

LUA_BIND_LE(renderModel3, {
    PREP_RENDER_MODEL
    quat rotation(e.get<float>(12), e.get<float>(13), e.get<float>(14), e.get<float>(15));
    rendermodel(NULL,
        e.get<const char*>(2),
        anim, o, self,
        e.get<float>(7),
        e.get<float>(8),
        e.get<float>(9),
        e.get<int>(10),
        fpsEntity,
        self->attachments,
        e.get<int>(11),
        0, 1, rotation
    );
})
#else
LUA_BIND_DUMMY(renderModel2)
LUA_BIND_DUMMY(renderModel3)
#endif

// Network

LUA_BIND_STD_CLIENT(connect, ClientSystem::connect, std::string(e.get<const char*>(1)), e.get<int>(2))

// Camera

LUA_BIND_CLIENT(forceCamera, {
    vec position(e.get<float>(1), e.get<float>(2), e.get<float>(3));
    CameraControl::forceCamera(position, e.get<float>(4), e.get<float>(5), e.get<float>(6), e.get<float>(7));
})
LUA_BIND_CLIENT(forcePosition, {
    vec position(e.get<float>(1), e.get<float>(2), e.get<float>(3));
    CameraControl::forcePosition(position);
})
LUA_BIND_STD_CLIENT(forceYaw, CameraControl::forceYaw, e.get<float>(1))
LUA_BIND_STD_CLIENT(forcePitch, CameraControl::forcePitch, e.get<float>(1))
LUA_BIND_STD_CLIENT(forceRoll, CameraControl::forceRoll, e.get<float>(1))
LUA_BIND_STD_CLIENT(forceFov, CameraControl::forceFov, e.get<float>(1))
LUA_BIND_STD_CLIENT(resetCamera, CameraControl::positionCamera, CameraControl::getCamera())
LUA_BIND_CLIENT(getCamera, {
    physent *camera = CameraControl::getCamera();
    e.t_new()
        .t_set("position", camera->o)
        .t_set("yaw", camera->yaw)
        .t_set("pitch", camera->pitch)
        .t_set("roll", camera->roll);
})
LUA_BIND_CLIENT(getCameraPosition, {
    physent *camera = CameraControl::getCamera();
    e.push(camera->o);
})

// Editing

LUA_BIND_STD(editing_getWorldSize, e.push, EditingSystem::getWorldSize())
LUA_BIND_STD(editing_getGridSize, e.push, 1<<GETIV(gridpower))
LUA_BIND_STD(editing_eraseGeometry, EditingSystem::eraseGeometry)
LUA_BIND_STD(editing_createCube, EditingSystem::createCube, e.get<int>(1), e.get<int>(2), e.get<int>(3), e.get<int>(4))
LUA_BIND_STD(editing_deleteCube, EditingSystem::deleteCube, e.get<int>(1), e.get<int>(2), e.get<int>(3), e.get<int>(4))
LUA_BIND_STD(editing_setCubeTexture, EditingSystem::setCubeTexture,
    e.get<int>(1),
    e.get<int>(2),
    e.get<int>(3),
    e.get<int>(4),
    e.get<int>(5),
    e.get<int>(6)
)
LUA_BIND_STD(editing_setCubeMaterial, EditingSystem::setCubeMaterial,
    e.get<int>(1),
    e.get<int>(2),
    e.get<int>(3),
    e.get<int>(4),
    e.get<int>(5)
)
LUA_BIND_STD(editing_pushCubeCorner, EditingSystem::pushCubeCorner,
    e.get<int>(1),
    e.get<int>(2),
    e.get<int>(3),
    e.get<int>(4),
    e.get<int>(5),
    e.get<int>(6),
    e.get<int>(7)
)
LUA_BIND_DEF(editing_getSelectedEntity, {
    LogicEntityPtr ret = EditingSystem::getSelectedEntity();
    if (ret.get() && !ret->isNone() && ret->luaRef >= 0) e.getref(ret.get()->luaRef);
    else e.push();
})
LUA_BIND_STD(renderProgress, renderprogress, e.get<float>(1), e.get<const char*>(2))
LUA_BIND_STD(getMapversion, e.push, GETIV(mapversion))

// Models

LUA_BIND_DEF(modelBoundingBox, {
    model* theModel = loadmodel(e.get<const char*>(1));
    if (!theModel)
    {
        e.push();
        return;
    }
    vec center;
    vec radius;
    theModel->boundbox(0, center, radius);

    e.t_new().t_set("center", center).t_set("radius", radius);
});

LUA_BIND_DEF(modelCollisionBox, {
    model* theModel = loadmodel(e.get<const char*>(1));
    if (!theModel)
    {
        e.push();
        return;
    }
    vec center;
    vec radius;
    theModel->collisionbox(0, center, radius);

    e.t_new().t_set("center", center).t_set("radius", radius);
});

LUA_BIND_DEF(modelMesh, {
    model* theModel = loadmodel(e.get<const char*>(1));
    if (!theModel)
    {
        e.push();
        return;
    }

    vector<BIH::tri> tris2[2];
    theModel->gentris(0, tris2);
    vector<BIH::tri>& tris = tris2[0];

    e.t_new().t_set("length", tris.length());
    for (int i = 0; i < tris.length(); i++)
    {
        BIH::tri& bt = tris[i];

        e.push(Utility::toString(i).c_str())
            .t_new()
            .t_set("a", bt.a)
            .t_set("b", bt.b)
            .t_set("c", bt.c)
        .t_set();
    }
});

// NPCs/bots

LUA_BIND_SERVER(addNPC, {
    int _ref = NPC::add(std::string(e.get<const char*>(1)));
    if (_ref >= 0)
        e.getref(_ref);
    else
        e.push();
})

#ifdef SERVER
LUA_BIND_LE(removeNPC, {
    fpsent *fpsEntity = (fpsent*)(self.get()->dynamicEntity);
    NPC::remove(fpsEntity->clientnum);
})
#else
LUA_BIND_DUMMY(removeNPC)
#endif

// data/ directory embeds, this is client-only, so we put it in ifdef. For server, they're just dummies
// dummies are needed because we don't want to check further in CAPIExtras.

LUA_BIND_STD_CLIENT(keymap, keymap, e.get<int*>(1), e.get<char*>(2))
LUA_BIND_STD_CLIENT(registerSound, registersound, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(font, newfont, e.get<char*>(1), e.get<char*>(2), e.get<int*>(3), e.get<int*>(4), e.get<int*>(5), e.get<int*>(6), e.get<int*>(7), e.get<int*>(8))
LUA_BIND_STD_CLIENT(fontOffset, fontoffset, e.get<char*>(1))
LUA_BIND_STD_CLIENT(fontChar, fontchar, e.get<int*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4))

// Variable manipulation

LUA_BIND_DEF(syncVariableFromLua, {
    const char *name = e.get<const char*>(1);
    std::string type = std::string(e.get<const char*>(2));
    switch (type[0])
    {
        case 'I':
        {
            var::syncfl(name, e.get<int>(3));
            break;
        }
        case 'F':
        {
            var::syncfl(name, e.get<float>(3));
            break;
        }
        case 'S':
        {
            var::syncfl(name, e.get<const char*>(3));
            break;
        }
        default: break;
    }
})

LUA_BIND_DEF(startStopLocalServer, {
    if (e.is<void>(1))
        run_python((char*)"intensity.components.server_runner.stop_server()");
    else
    {
        defformatstring(cmd)("intensity.components.server_runner.run_server('%s'%s)",
                             e.get<const char*>(1),
                             !GETIV(logged_into_master) ? ", False" : ""
                            );
        run_python((char*)cmd);
    }
})

// GUI

LUA_BIND_STD_CLIENT(showMessage, IntensityGUI::showMessage, "Script message", std::string(e.get<const char*>(1)))
LUA_BIND_STD_CLIENT(showInputDialog, IntensityGUI::showInputDialog, "Script input", std::string(e.get<const char*>(1)))
LUA_BIND_CLIENT(setDefaultThirdpersonMode, {
    // Only allow this to be done once
    if (!lua::engine["setDefaultThirdpersonMode"])
    {
        lua::engine["setDefaultThirdpersonMode"] = "set";
        SETV(thirdperson, e.get<int>(1));
    } else
        Logging::log(Logging::WARNING, "Can only set default thirdperson mode once per map\r\n");
})

LUA_BIND_STD_CLIENT(newGUI, newgui, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(GUIButton, guibutton, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(GUIText, guitext, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD_CLIENT(clearGUI, e.push, cleargui(e.get<int>(1)))
LUA_BIND_STD_CLIENT(showGUI, showgui, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUIOnClear, guionclear, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUIStayOpen, guistayopen, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUINoAutoTab, guinoautotab, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUIList, guilist, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUIAlign, guialign, e.get<int*>(1), e.get<char*>(2))
LUA_BIND_STD_CLIENT(GUITitle, guititle, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUIBar, guibar)
LUA_BIND_STD_CLIENT(GUIStrut, guistrut, e.get<float*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(GUIImage, guiimage, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<int*>(4), e.get<char*>(5))
LUA_BIND_STD_CLIENT(GUISlider, guislider, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<char*>(4))
LUA_BIND_STD_CLIENT(GUIListSlider, guilistslider, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(GUINameSlider, guinameslider, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3), e.get<char*>(4))
LUA_BIND_STD_CLIENT(GUIRadio, guiradio, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<char*>(4))
LUA_BIND_STD_CLIENT(GUIBitfield, guibitfield, e.get<char*>(1), e.get<char*>(2), e.get<int*>(3), e.get<char*>(4))
LUA_BIND_STD_CLIENT(GUICheckBox, guicheckbox, e.get<char*>(1), e.get<char*>(2), e.get<float*>(3), e.get<float*>(4), e.get<char*>(5))
LUA_BIND_STD_CLIENT(GUITab, guitab, e.get<char*>(1))
LUA_BIND_STD_CLIENT(GUIField, guifield, e.get<char*>(1), e.get<int*>(2), e.get<char*>(3), e.get<int*>(4))
LUA_BIND_STD_CLIENT(GUIKeyfield, guikeyfield, e.get<char*>(1), e.get<int*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(GUIEditor, guieditor, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4))
LUA_BIND_STD_CLIENT(GUIColor, guicolor, e.get<int*>(1))
LUA_BIND_STD_CLIENT(GUITextBox, guitextbox, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4))

LUA_BIND_STD_CLIENT(quit, quit)
LUA_BIND_STD_CLIENT(forceQuit, force_quit)
LUA_BIND_STD_CLIENT(screenRes, screenres, e.get<int*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(resetGl, resetgl)
LUA_BIND_STD_CLIENT(getFps, getfps_, e.get<int*>(1))

LUA_BIND_STD_CLIENT(resetLightMaps, resetlightmaps, e.get<bool>(1))
LUA_BIND_STD_CLIENT(calcLight, calclight, e.get<int*>(1))
LUA_BIND_STD_CLIENT(patchLight, patchlight, e.get<int*>(1))
LUA_BIND_STD_CLIENT(clearLightMaps, clearlightmaps)
LUA_BIND_STD_CLIENT(dumpLms, dumplms)

// blendmap

LUA_BIND_STD(clearBlendBrushes, clearblendbrushes)
LUA_BIND_STD(delBlendBrush, delblendbrush, e.get<const char*>(1))
LUA_BIND_STD(addBlendBrush, addblendbrush, e.get<const char*>(1), e.get<const char*>(2))
LUA_BIND_STD(nextBlendBrush, nextblendbrush, e.get<int*>(1))
LUA_BIND_STD(setBlendBrush, setblendbrush, e.get<const char*>(1))
LUA_BIND_STD(getBlendBrushName, getblendbrushname, e.get<int*>(1))
LUA_BIND_STD(curBlendBrush, curblendbrush)
LUA_BIND_STD(rotateBlendBrush, rotateblendbrush, e.get<int*>(1))
LUA_BIND_DEF(paintBlendMap, {
    if (addreleaseaction("paintBlendMap"))
    {
        if (!paintingblendmap)
        {
            paintblendmap(true);
            paintingblendmap = totalmillis;
        }
    }
    else stoppaintblendmap();
})
LUA_BIND_STD(clearBlendMapSel, clearblendmapsel)
LUA_BIND_STD(invertBlendMapSel, invertblendmapsel)
LUA_BIND_STD(invertBlendMap, invertblendmap)
LUA_BIND_STD(showBlendMap, showblendmap)
LUA_BIND_STD(optimizeBlendMap, optimizeblendmap)
LUA_BIND_DEF(clearBlendMap, {
    if(noedit(true) || (GETIV(nompedit) && multiplayer())) return;
    resetblendmap();
    showblendmap();
})

// console

LUA_BIND_STD_CLIENT(toggleConsole, SETV, fullconsole, GETIV(fullconsole) ^ 1)
LUA_BIND_STD_CLIENT(conSkip, setconskip, conskip, GETIV(fullconsole) ? GETIV(fullconfilter) : GETIV(confilter), e.get<int>(1))
LUA_BIND_STD_CLIENT(miniConSkip, setconskip, miniconskip, GETIV(miniconfilter), e.get<int>(1))
LUA_BIND_CLIENT(clearConsole, while(conlines.length()) delete[] conlines.pop().line;)
LUA_BIND_STD_CLIENT(bind, bindkey, e.get<char*>(1), e.get<char*>(2), keym::ACTION_DEFAULT, "bind")
LUA_BIND_STD_CLIENT(specBind, bindkey, e.get<char*>(1), e.get<char*>(2), keym::ACTION_SPECTATOR, "specbind")
LUA_BIND_STD_CLIENT(editBind, bindkey, e.get<char*>(1), e.get<char*>(2), keym::ACTION_EDITING, "editbind")
LUA_BIND_STD_CLIENT(getBind, getbind, e.get<char*>(1), keym::ACTION_DEFAULT)
LUA_BIND_STD_CLIENT(getSpecBind, getbind, e.get<char*>(1), keym::ACTION_SPECTATOR)
LUA_BIND_STD_CLIENT(getEditBind, getbind, e.get<char*>(1), keym::ACTION_EDITING)
LUA_BIND_STD_CLIENT(searchBinds, searchbinds, e.get<char*>(1), keym::ACTION_DEFAULT)
LUA_BIND_STD_CLIENT(searchSpecBinds, searchbinds, e.get<char*>(1), keym::ACTION_SPECTATOR)
LUA_BIND_STD_CLIENT(searchEditBinds, searchbinds, e.get<char*>(1), keym::ACTION_EDITING)
LUA_BIND_CLIENT(sayCommand, {
    int n = e.gettop();
    switch (n)
    {
        case 0: inputcommand((char*)""); break;
        case 1: inputcommand(e.get<char*>(1)); break;
        default:
        {
            char *s = e.get<char*>(1);
            for (int i = 2; i <= n; i++)
            {
                const char *a = e.get<const char*>(i);
                s = (char*)realloc(s, strlen(s) + strlen(a) + 1);
                assert(s);
                strcat(s, a);
            }
            inputcommand(s);
            delete s;
            break;
        }
    }
})
LUA_BIND_STD_CLIENT(inputCommand, inputcommand, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(history, history_, e.get<int*>(1))
LUA_BIND_STD_CLIENT(onRelease, onrelease, e.get<char*>(1))
LUA_BIND_STD_CLIENT(complete, addfilecomplete, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(listComplete, addlistcomplete, e.get<char*>(1), e.get<char*>(2))

// textedit

#define LUA_BIND_TEXT(n, c) \
LUA_BIND_CLIENT(n, { \
    editor *top = currentfocus(); \
    if (!top) return; \
    c \
})
// return list of all editors
LUA_BIND_CLIENT(textList, {
    std::string s;
    loopv(editors)
    {
        if (i > 0) s += ", ";
        s += editors[i]->name;
    }
    e.push(s.c_str());
})
// return the start of the buffer
LUA_BIND_TEXT(textShow, {
    editline line;
    line.combinelines(top->lines);
    e.push(line.text);
    line.clear();
})
// focus on a (or create a persistent) specific editor, else returns current name
LUA_BIND_CLIENT(textFocus, {
    if (e.is<const char*>(1))
    {
        int arg2 = e.get<int>(2);
        useeditor(e.get<const char*>(1), arg2 <= 0 ? EDITORFOREVER : arg2, true);
    }
    else if (editors.length() > 0) e.push(editors.last()->name);
    else e.push();
})
// return to the previous editor
LUA_BIND_TEXT(textPrev, editors.insert(0, top); editors.pop();)
// (1 = keep while focused, 2 = keep while used in gui, 3 = keep forever (i.e. until mode changes)) topmost editor, return current setting if no args
LUA_BIND_TEXT(textMode, {
    int arg1 = e.get<int>(2);
    if (arg1)
    {
        top->mode = arg1;
        e.push();
    }
    else e.push(top->mode);
})
// saves the topmost (filename is optional)
LUA_BIND_TEXT(textSave, {
    const char *arg1 = e.get<const char*>(1);
    if (arg1) top->setfile(path(arg1, true));
    top->save();
})
LUA_BIND_TEXT(textLoad, {
    const char *arg1 = e.get<const char*>(1);
    if (arg1)
    {
        top->setfile(path(arg1, true));
        top->load();
        e.push();
    }
    else if (top->filename) e.push(top->filename);
    else e.push();
})
LUA_BIND_TEXT(textInit, {
    editor *ed = NULL;
    const char *arg2 = e.get<const char*>(2);
    loopv(editors) if(!strcmp(e.get<const char*>(1), editors[i]->name))
    {
        ed = editors[i];
        break;
    }
    if(ed && ed->rendered && !ed->filename && arg2 && (ed->lines.empty() || (ed->lines.length() == 1 && !strcmp(e.get<const char*>(3), ed->lines[0].text))))
    {
        ed->setfile(path(arg2, true));
        ed->load();
    }
})
 
#define PASTEBUFFER "#pastebuffer"

LUA_BIND_TEXT(textCopy, editor *b = useeditor(PASTEBUFFER, EDITORFOREVER, false); top->copyselectionto(b);)
LUA_BIND_TEXT(textPaste, editor *b = useeditor(PASTEBUFFER, EDITORFOREVER, false); top->insertallfrom(b);)
LUA_BIND_TEXT(textMark, {
    editor *b = useeditor(PASTEBUFFER, EDITORFOREVER, false); top->insertallfrom(b);
    int arg1 = e.get<int>(1);
    if (arg1)
    {
        top->mark(arg1 == 1);
        e.push();
    }
    else e.push(top->region() ? 1 : 2);
})
LUA_BIND_TEXT(textSelectAll, top->selectall();)
LUA_BIND_TEXT(textClear, top->clear();)
LUA_BIND_TEXT(textCurrentLine, e.push(top->currentline().text);)
LUA_BIND_TEXT(textExec, e.exec(e.get<int>(1) ? top->selectiontostring() : top->tostring());)

// various commands

LUA_BIND_STD_CLIENT(movie, movie, e.get<char*>(1))
LUA_BIND_STD_CLIENT(recalc, recalc)
LUA_BIND_STD_CLIENT(glExt, glext, e.get<char*>(1))
LUA_BIND_STD_CLIENT(getCamPos, e.push, camera1->o)
LUA_BIND_STD_CLIENT(loadCrosshair, loadcrosshair_, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(tabify, tabify, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(resetSound, resetsound)

LUA_BIND_STD(isConnected, e.push, isconnected(e.get<int>(1) > 0) ? 1 : 0)
LUA_BIND_DEF(connectedIP, {
    const ENetAddress *address = connectedpeer();
    string hostname;
    e.push(address && enet_address_get_host_ip(address, hostname, sizeof(hostname)) >= 0 ? hostname : "");
})
LUA_BIND_DEF(connectedPort, {
    const ENetAddress *address = connectedpeer();
    e.push(address ? address->port : -1);
})
LUA_BIND_STD(connectServ, connectserv, e.get<const char*>(1), e.get<int>(2), e.get<const char*>(3))
LUA_BIND_STD(lanConnect, connectserv, NULL, e.get<int>(1), e.get<const char*>(2))
LUA_BIND_STD(disconnect, trydisconnect)
LUA_BIND_STD(localConnect, if(!isconnected() && !haslocalclients()) localconnect)
LUA_BIND_STD(localDisconnect, if(haslocalclients()) localdisconnect)

LUA_BIND_STD(printCube, printcube)
LUA_BIND_STD(remip, remip_)
LUA_BIND_STD(physTest, phystest)
LUA_BIND_STD(genPvs, genpvs, e.get<int*>(1))
LUA_BIND_STD(testPvs, testpvs, e.get<int*>(1))
LUA_BIND_STD(clearPvs, clearpvs)
LUA_BIND_STD(pvsStats, pvsstats)

LUA_BIND_STD(getmillis, e.push, e.get<bool>(1) ? totalmillis : lastmillis)

LUA_BIND_STD(config_exec_json, Utility::config_exec_json, e.get<const char*>(1), e.get<bool>(2))
LUA_BIND_STD(writecfg, Utility::writecfg, e.get<const char*>(1))

// engine/octaedit.cpp

LUA_BIND_STD(edittoggle, toggleedit, false)
LUA_BIND_STD(entcancel, entcancel)
LUA_BIND_STD(cubecancel, cubecancel)
LUA_BIND_STD(cancelsel, cancelsel)
LUA_BIND_STD(reorient, reorient)
LUA_BIND_STD(selextend, selextend)
LUA_BIND_STD(havesel, e.push, havesel ? selchildcount : 0)
LUA_BIND_STD(clearundos, pruneundos, 0)
LUA_BIND_STD(copy, copy)
LUA_BIND_STD(pastehilite, pastehilite)
LUA_BIND_STD(paste, paste)
LUA_BIND_STD(undo, editundo)
LUA_BIND_STD(redo, editredo)
LUA_BIND_STD(clearbrush, clearbrush)
LUA_BIND_STD(brushvert, brushvert, e.get<int>(1), e.get<int>(2), e.get<int>(3))
LUA_BIND_STD(hmapcancel, htextures.setsize, 0)
LUA_BIND_DEF(hmapselect, {
    int t = lookupcube(cur.x, cur.y, cur.z).texture[orient];
    int i = htextures.find(t);
    if (i < 0)
        htextures.add(t);
    else
        htextures.remove(i);
})
LUA_BIND_STD(pushsel, pushsel, e.get<int*>(1))
LUA_BIND_STD(editface, editface, e.get<int*>(1), e.get<int*>(2))
LUA_BIND_STD(delcube, delcube)
LUA_BIND_DEF(vdelta, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    SETVN(usevdelta, GETIV(usevdelta) + 1);
    e.exec(e.get<const char*>(1));
    SETVN(usevdelta, GETIV(usevdelta) - 1);
})
LUA_BIND_DEF(vrotate, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_ROTATION;
    ds.rotation = GETIV(usevdelta) ? e.get<int>(1) : clamp(e.get<int>(1), 0, 5);
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(voffset, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_OFFSET;
    ds.xoffset = GETIV(usevdelta) ? e.get<int>(1) : max(e.get<int>(1), 0);
    ds.yoffset = GETIV(usevdelta) ? e.get<int>(2) : max(e.get<int>(2), 0);
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(vscroll, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_SCROLL;
    ds.scrollS = e.get<float>(1)/1000.0f;
    ds.scrollT = e.get<float>(2)/1000.0f;
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(vscale, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    float scale = e.get<float>(1);
    VSlot ds;
    ds.changed = 1 << VSLOT_SCALE;
    ds.scale = scale <= 0 ? 1 : (GETIV(usevdelta) ? scale : clamp(scale, 1/8.0f, 8.0f));
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(vlayer, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_LAYER;
    ds.layer = vslots.inrange(e.get<int>(1)) ? e.get<int>(1) : 0;
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(valpha, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_ALPHA;
    ds.alphafront = clamp(e.get<float>(1), 0.0f, 1.0f);
    ds.alphaback  = clamp(e.get<float>(2), 0.0f, 1.0f);
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(vcolor, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_COLOR;
    ds.colorscale = vec(clamp(e.get<float>(1), 0.0f, 1.0f),
                        clamp(e.get<float>(2), 0.0f, 1.0f),
                        clamp(e.get<float>(3), 0.0f, 1.0f));
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(vreset, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_DEF(vshaderparam, {
    if (noedit() || (GETIV(nompedit) && multiplayer())) return;
    VSlot ds;
    ds.changed = 1 << VSLOT_SHPARAM;
    if(e.get<const char*>(1)[0])
    {
        ShaderParam p;
        p.name = getshaderparamname(e.get<const char*>(1));
        p.type = SHPARAM_LOOKUP;
        p.index = -1; p.loc = -1;
        p.val[0] = e.get<float>(2);
        p.val[1] = e.get<float>(3);
        p.val[2] = e.get<float>(4);
        p.val[3] = e.get<float>(5);
        ds.params.add(p);
    }
    mpeditvslot(ds, GETIV(allfaces), sel, true);
})
LUA_BIND_STD(edittex, edittex_, e.get<int*>(1))
LUA_BIND_STD(gettex, gettex)
LUA_BIND_STD(getcurtex, getcurtex)
LUA_BIND_STD(getseltex, getseltex)
LUA_BIND_DEF(getreptex, {
    if (!noedit()) e.push(vslots.inrange(reptex) ? reptex : -1);
})
LUA_BIND_STD(gettexname, gettexname, e.get<int*>(1), e.get<int*>(2))
LUA_BIND_STD(replace, replace, false)
LUA_BIND_STD(replacesel, replace, true)
LUA_BIND_STD(flip, flip)
LUA_BIND_STD(rotate, rotate, e.get<int*>(1))
LUA_BIND_STD(editmat, editmat, e.get<char*>(1), e.get<char*>(2))
// 0/noargs = toggle, 1 = on, other = off - will autoclose if too far away or exit editmode
LUA_BIND_STD(showtexgui, showtexgui, e.get<int*>(1))

// engine/server.cpp

LUA_BIND_STD(startlistenserver, startlistenserver, e.get<int>(1))
LUA_BIND_STD(stoplistenserver, stoplistenserver)

// engine/texture.cpp

LUA_BIND_CLIENT(materialreset, {
    if (!var::overridevars && !game::allowedittoggle()) return;
    loopi(MATF_VOLUME+1) materialslots[i].reset();
})

LUA_BIND_CLIENT(compactvslosts, {
    if (GETIV(nompedit) && multiplayer()) return;
    compactvslots();
    allchanged();
})

LUA_BIND_CLIENT(fixinsidefaces, {
    if (noedit(true) || (GETIV(nompedit) && multiplayer())) return;
    int tex = e.get<int>(1);
    fixinsidefaces(worldroot, ivec(0, 0, 0), GETIV(mapsize)>>1, tex && vslots.inrange(tex) ? tex : DEFAULT_GEOM);
    allchanged();
})

LUA_BIND_CLIENT(autograss, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    DELETEA(s.autograss);
    s.autograss = e.get<char*>(1) ? newstring(makerelpath("data", e.get<char*>(1))) : NULL;
})

LUA_BIND_CLIENT(texscroll, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    s.variants->scrollS = e.get<float>(1)/1000.0f;
    s.variants->scrollT = e.get<float>(2)/1000.0f;
    propagatevslot(s.variants, 1<<VSLOT_SCROLL);
})

LUA_BIND_CLIENT(texoffset, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    s.variants->xoffset = max(e.get<int>(1), 0);
    s.variants->yoffset = max(e.get<int>(2), 0);
    propagatevslot(s.variants, 1<<VSLOT_OFFSET);
})

LUA_BIND_CLIENT(texrotate, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    s.variants->rotation = clamp(e.get<int>(1), 0, 5);
    propagatevslot(s.variants, 1<<VSLOT_ROTATION);
})

LUA_BIND_CLIENT(texscale, {
    if(slots.empty()) return;
    Slot &s = *slots.last();
    s.variants->scale = e.get<float>(1) <= 0 ? 1 : e.get<float>(1);
    propagatevslot(s.variants, 1<<VSLOT_SCALE);
})

LUA_BIND_CLIENT(texlayer, {
    if (slots.empty()) return;
    Slot &s = *slots.last();

    int layer = e.get<int>(1);
    char *name = e.get<char*>(2);
    float scale = e.get<float>(4);

    s.variants->layer = layer < 0 ? max(slots.length()-1+layer, 0) : layer;
    s.layermaskname = name[0] ? newstring(path(makerelpath("data", name))) : NULL; 
    s.layermaskmode = e.get<int>(3);
    s.layermaskscale = scale <= 0 ? 1 : scale;
    propagatevslot(s.variants, 1<<VSLOT_LAYER);

    delete name;
})

LUA_BIND_CLIENT(texalpha, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    s.variants->alphafront = clamp(e.get<float>(1), 0.0f, 1.0f);
    s.variants->alphaback = clamp(e.get<float>(2), 0.0f, 1.0f);
    propagatevslot(s.variants, 1<<VSLOT_ALPHA);
})

LUA_BIND_CLIENT(texcolor, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    s.variants->colorscale = vec(clamp(e.get<float>(1), 0.0f, 1.0f),
                                 clamp(e.get<float>(2), 0.0f, 1.0f),
                                 clamp(e.get<float>(3), 0.0f, 1.0f));
    propagatevslot(s.variants, 1<<VSLOT_COLOR);
})

LUA_BIND_CLIENT(texffenv, {
    if (slots.empty()) return;
    Slot &s = *slots.last();
    s.ffenv = (e.get<int>(1) > 0);
})

LUA_BIND_STD_CLIENT(reloadtex, reloadtex, e.get<char*>(1))
LUA_BIND_STD_CLIENT(gendds, gendds, e.get<char*>(1), e.get<char*>(2))
LUA_BIND_STD_CLIENT(screenshot, screenshot, e.get<char*>(1))

// TODO: REMOVE
#define readwritetex(t, s, body) \
    { \
        uchar *dstrow = t.data; \
        uchar *srcrow = s.data; \
        loop(y, t.h) \
        { \
            for(uchar *dst = dstrow, *src = srcrow, *end = &srcrow[s.w*s.bpp]; src < end; dst += t.bpp, src += s.bpp) \
            { \
                body; \
            } \
            dstrow += t.pitch; \
            srcrow += s.pitch; \
        } \
    }

#define read2writetex(t, s1, src1, s2, src2, body) \
    { \
        uchar *dstrow = t.data; \
        uchar *src1row = s1.data; \
        uchar *src2row = s2.data; \
        loop(y, t.h) \
        { \
            for(uchar *dst = dstrow, *end = &dstrow[t.w*t.bpp], *src1 = src1row, *src2 = src2row; dst < end; dst += t.bpp, src1 += s1.bpp, src2 += s2.bpp) \
            { \
                body; \
            } \
            dstrow += t.pitch; \
            src1row += s1.pitch; \
            src2row += s2.pitch; \
        } \
    }

LUA_BIND_CLIENT(flipnormalmapy, {
    ImageData ns;
    if(!loadimage(e.get<char*>(2), ns)) return;
    ImageData d(ns.w, ns.h, 3);
    readwritetex(d, ns,
        dst[0] = src[0];
        dst[1] = 255 - src[1];
        dst[2] = src[2];
    );
    saveimage(e.get<char*>(1), guessimageformat(e.get<char*>(1), IMG_TGA), d);
})

LUA_BIND_CLIENT(mergenormalmaps, {
    char *normalfile = e.get<char*>(2);
    ImageData hs;
    ImageData ns;

    if(!loadimage(e.get<char*>(1), hs) || !loadimage(normalfile, ns) || hs.w != ns.w || hs.h != ns.h) return;
    ImageData d(ns.w, ns.h, 3);
    read2writetex(d, hs, srch, ns, srcn,
        *(bvec *)dst = bvec(((bvec *)srcn)->tovec().mul(2).add(((bvec *)srch)->tovec()).normalize());
    );
    saveimage(normalfile, guessimageformat(normalfile, IMG_TGA), d);

    delete normalfile;
})

// engine/world.cpp

// TODO: REMOVE THESE
#define addimplicit(f)  { if(entgroup.empty() && enthover>=0) { entadd(enthover); undonext = (enthover != oldhover); f; entgroup.drop(); } else f; }
#define entfocus(i, f)  { int n = efocus = (i); if(n>=0) { extentity &ent = *entities::getents()[n]; f; } }
#define entedit(i, f) \
{ \
    entfocus(i, \
    int oldtype = ent.type; \
    removeentity(n);  \
    f; \
    if(oldtype!=ent.type) detachentity(ent); \
    if(ent.type!=ET_EMPTY) { addentity(n); if(oldtype!=ent.type) attachentity(ent); } \
    entities::editent(n, true)); \
}
#define addgroup(exp)   { loopv(entities::getents()) entfocus(i, if(exp) entadd(n)); }
#define setgroup(exp)   { entcancel(); addgroup(exp); }
#define groupeditloop(f){ entlooplevel++; int _ = efocus; loopv(entgroup) entedit(entgroup[i], f); efocus = _; entlooplevel--; }
#define groupeditpure(f){ if(entlooplevel>0) { entedit(efocus, f); } else groupeditloop(f); }
#define groupeditundo(f){ makeundoent(); groupeditpure(f); }
#define groupedit(f)    { addimplicit(groupeditundo(f)); }

LUA_BIND_STD(entautoview, entautoview, e.get<int*>(1))
LUA_BIND_STD(entflip, entflip)
LUA_BIND_STD(entrotate, entrotate, e.get<int*>(1))
LUA_BIND_STD(entpush, entpush, e.get<int*>(1))
LUA_BIND_STD(attachent, attachent)
LUA_BIND_STD(newent, newent, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4), e.get<int*>(5), e.get<int*>(6))
LUA_BIND_STD(delent, delent)
LUA_BIND_STD(dropent, dropent)
LUA_BIND_STD(entcopy, entcopy)
LUA_BIND_STD(entpaste, entpaste)
LUA_BIND_STD(enthavesel, addimplicit, e.push(entgroup.length()))
LUA_BIND_DEF(entselect, if (!noentedit()) addgroup(ent.type != ET_EMPTY && entgroup.find(n)<0 && e.exec<bool>(e.get<const char*>(1)) == true);)
LUA_BIND_DEF(entloop, if(!noentedit()) addimplicit(groupeditloop(((void)ent, e.exec(e.get<const char*>(1)))));)
LUA_BIND_DEF(insel, entfocus(efocus, e.push(pointinsel(sel, ent.o)));)
LUA_BIND_DEF(entget, entfocus(efocus, string s; printent(ent, s); e.push(s));)
LUA_BIND_STD(entindex, e.push, efocus)
LUA_BIND_STD(entset, entset, e.get<char*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4), e.get<int*>(5), e.get<int*>(6))
LUA_BIND_STD(nearestent, nearestent)
LUA_BIND_STD(intensityentcopy, intensityentcopy)
LUA_BIND_STD(intensitypasteent, intensitypasteent)
LUA_BIND_STD(newmap, newmap, e.get<int*>(1))
LUA_BIND_STD(mapenlarge, mapenlarge)
LUA_BIND_STD(shrinkmap, shrinkmap)
LUA_BIND_STD(mapname, e.push, game::getclientmap())
// In our new system, this is called when dragging concludes. Only then do we update the server.
// This facilitates smooth dragging on the client, and a single bandwidth use at the end.
LUA_BIND_DEF(finish_dragging, {
    groupeditpure(
        defformatstring(c)("getEntity(%i).position = {%f,%f,%f}", LogicSystem::getUniqueId(&ent), ent.o[0], ent.o[1], ent.o[2]);
        e.exec(c);
    );
})

// engine/worldio.cpp

LUA_BIND_DEF(mapcfgname, {
    const char *mname = game::getclientmap();
    if(!*mname) mname = "untitled";

    string pakname;
    string mapname;
    string mcfgname;
    getmapfilenames(mname, NULL, pakname, mapname, mcfgname);
    defformatstring(cfgname)("data/%s/%s.lua", pakname, mcfgname);
    path(cfgname);
    e.push(cfgname);
})

LUA_BIND_STD(writeobj, writeobj, e.get<char*>(1))

// fpsgame/client.cpp

LUA_BIND_DEF(say, {
    int n = e.gettop();
    switch (n)
    {
        case 0: game::toserver((char*)""); break;
        case 1: game::toserver(e.get<char*>(1)); break;
        default:
        {
            char *s = e.get<char*>(1);
            for (int i = 2; i <= n; i++)
            {
                const char *a = e.get<const char*>(i);
                s = (char*)realloc(s, strlen(s) + strlen(a) + 1);
                assert(s);
                strcat(s, a);
            }
            game::toserver(s);
            delete s;
            break;
        }
    }
})

// fpsgame/fps.cpp

LUA_BIND_DEF(getfollow, {
    fpsent *f = game::followingplayer();
    e.push(f ? f->clientnum : -1);
})

// fpsgame/scoreboard.cpp

LUA_BIND_CLIENT(showscores, {
    bool on = (addreleaseaction("showscores") != 0);
    SETV(scoreboard, on);
    scorebshow(on);
})

// intensity/client_engine_additions.cpp

LUA_BIND_STD_CLIENT(inc_camera, CameraControl::incrementCameraDist, +1)
LUA_BIND_STD_CLIENT(dec_camera, CameraControl::incrementCameraDist, -1)
LUA_BIND_STD_CLIENT(mouselook, GuiControl::toggleMouselook)
LUA_BIND_STD_CLIENT(characterview, GuiControl::toggleCharacterViewing)
LUA_BIND_STD_CLIENT(menu_key_click_trigger, GuiControl::menuKeyClickTrigger)
// Sets up a GUI for editing an entity's state data. TODO: get rid of ugly ass STL shit
LUA_BIND_CLIENT(prepare_entity_gui, {
    GuiControl::EditedEntity::stateData.clear();
    GuiControl::EditedEntity::sortedKeys.clear();

    GuiControl::EditedEntity::currEntity = TargetingControl::targetLogicEntity;
    if (GuiControl::EditedEntity::currEntity->isNone())
    {
        Logging::log(Logging::DEBUG, "No entity to show the GUI for\r\n");
        return;
    }

    int uniqueId = GuiControl::EditedEntity::currEntity->getUniqueId();

    // we get this beforehand because of further re-use
    e.getg("getEntity").push(uniqueId).call(1, 1);
    // we've got the entity here now (popping getEntity out)
    e.t_getraw("createStateDataDict").push_index(-2).call(1, 1);
    // ok, state data are on stack, popping createStateDataDict out, let's ref it so we can easily get it later
    int _tempRef = e.ref();
    e.pop(1);

    e.getg("table").t_getraw("keys").getref(_tempRef).call(1, 1);
    // we've got keys on stack. let's loop the table now.
    LUA_TABLE_FOREACH(e, {
        // we have array of keys, so the original key is a value in this case
        const char *key = e.get<const char*>(-1);

        e.getg("__getVariableGuiName").push(uniqueId).push(key).call(2, 1);
        const char *guiName = e.get<const char*>(-1);
        e.pop(1);

        e.getref(_tempRef);
        const char *value = e.t_get<const char*>(key);
        e.pop(1);

        GuiControl::EditedEntity::stateData.insert(
            GuiControl::EditedEntity::StateDataMap::value_type(
                key,
                std::pair<std::string, std::string>(
                    guiName,
                    value
                )
            )
        );

        GuiControl::EditedEntity::sortedKeys.push_back(key);
        SETVN(num_entity_gui_fields, GETIV(num_entity_gui_fields) + 1); // increment for later loop
    });
    e.pop(2).unref(_tempRef);

    // So order is always the same
    sort(GuiControl::EditedEntity::sortedKeys.begin(), GuiControl::EditedEntity::sortedKeys.end());

    for (int i = 0; i < GETIV(num_entity_gui_fields); i++)
    {
        std::string key = GuiControl::EditedEntity::sortedKeys[i];
        std::string guiName = GuiControl::EditedEntity::stateData[key].first;
        std::string value = GuiControl::EditedEntity::stateData[key].second;

        std::string fieldName = "entity_gui_field_" + Utility::toString(i);
        std::string labelName = "entity_gui_label_" + Utility::toString(i);

        var::get(fieldName.c_str())->s(value.c_str(), true, true, true);
        var::get(labelName.c_str())->s(guiName.c_str(), true, true, true);
    }

    // Title
    e.getg("tostring").getref(GuiControl::EditedEntity::currEntity->luaRef).call(1, 1);
    std::string title = e.get(-1, "Unknown");
    e.pop(1);
    title = Utility::toString(uniqueId) + ": " + title;

    SETVF(entity_gui_title, title.c_str());

    // Create the gui
    std::string command =
    "GUI.new(\"entity\", [[\n"
    "    GUI.text(EV.entity_gui_title)\n"
    "    GUI.bar()\n";

    for (int i = 0; i < GETIV(num_entity_gui_fields); i++)
    {
        std::string sI = Utility::toString(i);
        std::string key = GuiControl::EditedEntity::sortedKeys[i];
        std::string value = GuiControl::EditedEntity::stateData[key].second;

        if (value.size() > 50)
        {
            Logging::log(Logging::WARNING, "Not showing field '%s' as it is overly large for the GUI\r\n", key.c_str());
            continue; // Do not even try to show overly-large items
        }

        command +=
    "    GUI.list([[\n"
    "        GUI.text(CE.get_gui_label(" + sI + "))\n"
    "        CV:run(\"new_entity_gui_field_" + sI + " = \" .. CE.get_gui_value(" + sI + "))\n"
    "        GUI.field(\"new_entity_gui_field_" + sI + "\", " + Utility::toString((int)value.size()+25) + ", [[ CE.set_gui_value(" + sI + ", CV.new_entity_gui_field_" + sI + ") ]], 0)\n"
    "    ]])\n";

        if ((i+1) % 10 == 0)
        {
            command +=
    "   GUI.tab(" + Utility::toString(i) + ")\n";
        }
    }

    command +=
    "]])\n";

//  printf("Command: %s\r\n", command.c_str());
    e.exec(command.c_str());
})
LUA_BIND_CLIENT(get_entity_gui_label, {
    std::string ret = GuiControl::EditedEntity::stateData[GuiControl::EditedEntity::sortedKeys[e.get<int>(1)]].first + ": ";
    e.push(ret.c_str());
})
LUA_BIND_CLIENT(get_entity_gui_value, {
    std::string ret = GuiControl::EditedEntity::stateData[GuiControl::EditedEntity::sortedKeys[e.get<int>(1)]].second;
    e.push(ret.c_str());
})
LUA_BIND_CLIENT(set_entity_gui_value, {
    const char *key = GuiControl::EditedEntity::sortedKeys[e.get<int>(1)].c_str();
    const char *ov = GuiControl::EditedEntity::stateData[key].second.c_str();
    const char *nv = e.get<const char*>(2);

    if (strcmp(ov, nv))
    {
        GuiControl::EditedEntity::stateData[key].second = e.get<const char*>(2);

        int uniqueId = GuiControl::EditedEntity::currEntity->getUniqueId();
        e.getg("__getVariable").push(uniqueId).push(key).call(2, 1);
        e.t_getraw("fromData").push_index(-2).push(nv).call(2, 1);
        e.getg("encodeJSON").shift().call(1, 1);
        const char *nav = e.get(-1, "[]");
        e.pop(2);

        defformatstring(c)("getEntity(%i).%s = '%s'", uniqueId, key, nav);
        e.exec(c);
    }
})

// Mouse clicks

#define QUOT(arg) #arg

#define MOUSECLICK(num) \
LUA_BIND_CLIENT(mouse##num##click, { \
    bool down = (addreleaseaction(QUOT(mouse##num##click)) != 0); \
\
    Logging::log(Logging::INFO, "mouse click: %d (down: %d)\r\n", num, down); \
    if (!(e.hashandle() && ClientSystem::scenarioStarted())) return; \
\
    /* A click forces us to check for clicking on entities */ \
    TargetingControl::determineMouseTarget(true); \
    vec pos = TargetingControl::targetPosition; \
\
    e.getg("ApplicationManager").t_getraw("instance").t_getraw("performClick"); \
    e.push_index(-2).push(num).push(down).push(pos); \
    if (TargetingControl::targetLogicEntity.get() && !TargetingControl::targetLogicEntity->isNone()) \
        e.getref(TargetingControl::targetLogicEntity->luaRef); \
    else e.push(); \
    float x; \
    float y; \
    g3d_cursorpos(x, y); \
    e.push(x).push(y).call(7, 0).pop(2); \
})
MOUSECLICK(1)
MOUSECLICK(2)
MOUSECLICK(3)

// Other client actions - bind these to keys using cubescript (for things like a 'reload' key, 'crouch' key, etc. -
// specific to each game). TODO: Consider overlap with mouse buttons
#define ACTIONKEY(num) \
LUA_BIND_CLIENT(actionkey##num, { \
    if (e.hashandle()) \
    { \
        e.getg("ApplicationManager").t_getraw("instance"); \
        e.t_getraw("actionKey") \
         .push_index(-2) \
         .push(num) \
         .push(addreleaseaction(QUOT(actionkey##num)) != 0) \
         .call(3, 0); \
        e.pop(2); \
    } \
})

ACTIONKEY(0);
ACTIONKEY(1);
ACTIONKEY(2);
ACTIONKEY(3);
ACTIONKEY(4);
ACTIONKEY(5);
ACTIONKEY(6);
ACTIONKEY(7);
ACTIONKEY(8);
ACTIONKEY(9);
ACTIONKEY(10);
ACTIONKEY(11);
ACTIONKEY(12);
ACTIONKEY(13);
ACTIONKEY(14);
ACTIONKEY(15);
ACTIONKEY(16);
ACTIONKEY(17);
ACTIONKEY(18);
ACTIONKEY(19);
ACTIONKEY(20);
ACTIONKEY(21);
ACTIONKEY(22);
ACTIONKEY(23);
ACTIONKEY(24);
ACTIONKEY(25);
ACTIONKEY(26);
ACTIONKEY(27);
ACTIONKEY(28);
ACTIONKEY(29);
// 30 action keys should be enough for everybody (TODO: consider speed issues)

// physics
// Extra player movements
bool k_turn_left, k_turn_right, k_look_up, k_look_down;

#define DIR(name, v, d, s, os) \
LUA_BIND_CLIENT(name, { \
    if (ClientSystem::scenarioStarted()) \
    { \
        PlayerControl::flushActions(); /* stop current actions */ \
        s = addreleaseaction(#name)!=0; \
        ((fpsent*)player)->v = s ? d : (os ? -(d) : 0); \
    } \
})

DIR(turn_left,  turn_move, -1, k_turn_left,  k_turn_right); // New turning motion
DIR(turn_right, turn_move, +1, k_turn_right, k_turn_left);  // New pitching motion
DIR(look_down, look_updown_move, -1, k_look_down, k_look_up);
DIR(look_up,   look_updown_move, +1, k_look_up,   k_look_down);

#define SCRIPT_DIR(name, v, d, s, os) \
LUA_BIND_CLIENT(name, { \
    if (ClientSystem::scenarioStarted()) \
    { \
        PlayerControl::flushActions(); /* stop current actions */ \
        s = addreleaseaction(#name)!=0; \
        e.getg("ApplicationManager").t_getraw("instance"); \
        e.t_getraw(#v).push_index(-2).push(s ? d : (os ? -(d) : 0)).push(s).call(3, 0); \
        e.pop(2); \
    } \
})

//SCRIPT_DIR(turn_left,  performYaw, -1, k_turn_left,  k_turn_right); // New turning motion
//SCRIPT_DIR(turn_right, performYaw, +1, k_turn_right, k_turn_left);  // New pitching motion
// TODO: Enable these. But they do change the protocol (see Character.lua), so forces everyone and everything to upgrade
//SCRIPT_DIR(look_down, performPitch, -1, k_look_down, k_look_up);
//SCRIPT_DIR(look_up,   performPitch, +1, k_look_up,   k_look_down);

// Old player movements
SCRIPT_DIR(backward, performMovement, -1, player->k_down,  player->k_up);
SCRIPT_DIR(forward,  performMovement,  1, player->k_up,    player->k_down);
SCRIPT_DIR(left,     performStrafe,    1, player->k_left,  player->k_right);
SCRIPT_DIR(right,    performStrafe,   -1, player->k_right, player->k_left);

LUA_BIND_CLIENT(jump, {
    if (ClientSystem::scenarioStarted())
    {
        PlayerControl::flushActions(); /* stop current actions */
        e.getg("ApplicationManager").t_getraw("instance");
        e.t_getraw("performJump").push_index(-2).push(addreleaseaction("jump") ? true : false).call(2, 0);
        e.pop(2);
    }
})

// intensity/client_system.cpp

LUA_BIND_CLIENT(connect_to_instance, {
    REFLECT_PYTHON(login_to_instance);
    login_to_instance(e.get<const char*>(1));
})

LUA_BIND_CLIENT(connect_to_lobby, {
    REFLECT_PYTHON(connect_to_lobby);
    connect_to_lobby();
})

LUA_BIND_CLIENT(connect_to_selected_instance, {
    REFLECT_PYTHON(connect_to_selected_instance);
    connect_to_selected_instance();
})

LUA_BIND_CLIENT(show_instances, {
    REFLECT_PYTHON(get_possible_instances);
    boost::python::object instances = get_possible_instances();
    REFLECT_PYTHON(None);

    if (instances == None)
    {
        SETVF(error_message, "Could not get the list of instances");
        showgui("error");
        return;
    }

    char buf[1024];
    snprintf(buf, sizeof(buf),
        "GUI.new(\"instances\", [[\n"
        "    GUI.text(\"Pick an instance to enter:\")\n"
        "    GUI.bar()\n");
    char *command = (char*)malloc(strlen(buf) + 1);
    strcpy(command, buf);

    int ninst = boost::python::extract<int>(instances.attr("__len__")());
    for (int i = 0; i < ninst; i++)
    {
        boost::python::object instance = instances[i];
        const char *instance_id = boost::python::extract<const char*>(instance.attr("__getitem__")("instance_id"));
        const char *event_name = boost::python::extract<const char*>(instance.attr("__getitem__")("event_name"));

        assert( Utility::validateAlphaNumeric(instance_id) );
        assert( Utility::validateAlphaNumeric(event_name, " (),.;") ); // XXX: Allow more than alphanumeric+spaces: ()s, .s, etc.

        snprintf(buf, sizeof(buf), "    GUI.button(\"%s\", \"CE.connect_to_instance(%s)\")\n", event_name, instance_id);
        command = (char*)realloc(command, strlen(command) + strlen(buf) + 1);
        assert(command);
        strcat(command, buf);
    }

    snprintf(buf, sizeof(buf), "]])\nGUI.show(\"instances\")\n");
    command = (char*)realloc(command, strlen(command) + strlen(buf) + 1);
    assert(command);
    strcat(command, buf);

    Logging::log(Logging::DEBUG, "Instances GUI: %s\r\n", command);
    engine.exec(command);

    command = NULL;
    free(command);
})

LUA_BIND_CLIENT(do_upload, {
    renderprogress(0.1, "compiling scripts ..");

    REFLECT_PYTHON(get_map_script_filename);
    const char *fname = boost::python::extract<const char*>(get_map_script_filename());
    if (!engine.load(Utility::readFile(fname).c_str()))
    {
        IntensityGUI::showMessage("Compilation failed", engine.geterror_last());
        return;
    }

    renderprogress(0.3, "generating map ..");
    save_world(game::getclientmap());

    renderprogress(0.4, "exporting entities ..");
    REFLECT_PYTHON(export_entities);
    export_entities("entities.json");

    renderprogress(0.5, "uploading map ..");
    REFLECT_PYTHON(upload_map);
    upload_map();

    REFLECT_PYTHON(get_curr_map_asset_id);
    const char *aid = boost::python::extract<const char*>(get_curr_map_asset_id());
    SETVF(last_uploaded_map_asset, aid);
})

/* Reuploads asset - doesn't save world and doesn't require one running - useful
 * for reuploading stuff crashing etc
 */
LUA_BIND_CLIENT(repeat_upload, {
    const char *lumasset = GETSV(last_uploaded_map_asset);

    renderprogress(0.2, "getting map asset info ..");
    REFLECT_PYTHON(AssetManager);
    boost::python::object ainfo = AssetManager.attr("get_info")(lumasset);

    REFLECT_PYTHON(set_curr_map_asset_id);
    set_curr_map_asset_id(lumasset);

    REFLECT_PYTHON(World);
    World.attr("asset_info") = ainfo;

    renderprogress(0.5, "compiling scripts ..");
    REFLECT_PYTHON(get_map_script_filename);
    const char *fname = boost::python::extract<const char*>(get_map_script_filename());
    if (!engine.load(Utility::readFile(fname).c_str()))
    {
        IntensityGUI::showMessage("Compilation failed", engine.geterror_last());
        return;
    }

    renderprogress(0.7, "uploading map ..");
    REFLECT_PYTHON(upload_map);
    upload_map();

    conoutf("Upload complete.");
})

LUA_BIND_STD_CLIENT(restart_map, MessageSystem::send_RestartMap)

// intensity/editing_system.cpp

LUA_BIND_CLIENT(save_mouse_pos, {
    EditingSystem::savedMousePosTime = Utility::SystemInfo::currTime();
    EditingSystem::savedMousePos = TargetingControl::worldPosition;
    Logging::log(Logging::DEBUG,
                 "Saved mouse pos: %f,%f,%f (%d)\r\n",
                 EditingSystem::savedMousePos.x,
                 EditingSystem::savedMousePos.y,
                 EditingSystem::savedMousePos.z,
                 EditingSystem::savedMousePosTime
                );
})

LUA_BIND_STD(prepareentityclasses, EditingSystem::prepareentityclasses)
LUA_BIND_STD(numentityclasses, e.push, (int)EditingSystem::entityClasses.size())
LUA_BIND_STD(spawnent, EditingSystem::newEntity, e.get<const char*>(1))
LUA_BIND_STD_CLIENT(listtex, listtex)
LUA_BIND_STD_CLIENT(massreplacetex, massreplacetex, e.get<char*>(1))
LUA_BIND_STD(debugoctree, debugoctree)
LUA_BIND_STD(centerent, centerent)

// intensity/engine_additions.h
LUA_BIND_STD(reloadmodel, reloadmodel, e.get<char*>(1))

// intensity/intensity_gui.cpp

// Entity classes dialog support
LUA_BIND_CLIENT(getentityclass, {
    std::string ret = EditingSystem::entityClasses[e.get<int>(1)];
    assert( Utility::validateAlphaNumeric(ret, "_") ); // Prevent injections
    e.push(ret.c_str());
})
// Private edit mode stuff
LUA_BIND_STD_CLIENT(request_private_edit_mode, MessageSystem::send_RequestPrivateEditMode)
LUA_BIND_STD_CLIENT(private_edit_mode, e.push, ClientSystem::editingAlone)
// Plugins
LUA_BIND_CLIENT(show_plugins, {
    REFLECT_PYTHON(signal_show_components);
    signal_show_components();
})

// intensity/master.cpp

LUA_BIND_STD_CLIENT(do_login, MasterServer::do_login, e.get<char*>(1), e.get<char*>(2))

// intensity/targeting.cpp

LUA_BIND_STD_CLIENT(mouse_targeting, TargetingControl::setMouseTargeting, e.get<int>(1))
LUA_BIND_CLIENT(set_mouse_targeting_entity, {
    TargetingControl::targetLogicEntity = LogicSystem::getLogicEntity(e.get<int>(1));
    e.push((int)(TargetingControl::targetLogicEntity.get() != NULL));
})
LUA_BIND_CLIENT(set_mouse_target_client, {
    dynent *client = FPSClientInterface::getPlayerByNumber(e.get<int>(1));
    if (client)
        TargetingControl::targetLogicEntity = LogicSystem::getLogicEntity(client);
    else
        TargetingControl::targetLogicEntity.reset();

    e.push((int)(TargetingControl::targetLogicEntity.get() != NULL));
})

// intensity/utility.cpp
LUA_BIND_STD(get_config, e.push, Utility::Config::getString(e.get<const char*>(1), e.get<const char*>(2), "?").c_str())

// shared/zip.cpp
LUA_BIND_STD(addzip, addzip, e.get<const char*>(1), e.get<const char*>(2)[0] ? e.get<const char*>(2) : NULL, e.get<const char*>(3)[0] ? e.get<const char*>(3) : NULL)
LUA_BIND_STD(removezip, removezip, e.get<const char*>(1))

} // namespace lua_binds
