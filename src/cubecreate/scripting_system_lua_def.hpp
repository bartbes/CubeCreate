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

void texturereset(int n);
void texture(const char *type, const char *name, int rot, int xoffset, int yoffset, float scale, int forcedindex);

extern bool getkeydown();
extern bool getkeyup();
extern bool getmousedown();
extern bool getmouseup();

void keymap(int *code, char *key);
void newfont(char *name, char *tex, int *defaultw, int *defaulth, int *offsetx, int *offsety, int *offsetw, int *offseth);
void fontoffset(char *c);
void fontchar(int *x, int *y, int *w, int *h);
void registersound(char *name, int *vol);

void run_python(char *code);

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

#include "luabind_base.hpp"
#include "luabind_entity.hpp"
#include "luabind_world.hpp"
#include "luabind_sound.hpp"
#include "luabind_model.hpp"
#include "luabind_shaders.hpp"
#include "luabind_parthud.hpp"
#include "luabind_gui.hpp"

/* Here begin the binds. Close them in C++ namespace */
namespace lua_binds
{

/*
 * Things to go into CAPI Lua namespace
 */

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
LUA_BIND_STD_CLIENT(registersound, registersound, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(font, newfont, e.get<char*>(1), e.get<char*>(2), e.get<int*>(3), e.get<int*>(4), e.get<int*>(5), e.get<int*>(6), e.get<int*>(7), e.get<int*>(8))
LUA_BIND_STD_CLIENT(fontoffset, fontoffset, e.get<char*>(1))
LUA_BIND_STD_CLIENT(fontchar, fontchar, e.get<int*>(1), e.get<int*>(2), e.get<int*>(3), e.get<int*>(4))

// Variable manipulation

LUA_BIND_DEF(resetvar, var::get(e.get<const char*>(1))->r();)

LUA_BIND_DEF(svfl, {
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

LUA_BIND_DEF(ssls, {
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

LUA_BIND_STD_CLIENT(quit, quit)
LUA_BIND_STD_CLIENT(force_quit, force_quit)
LUA_BIND_STD_CLIENT(screenres, screenres, e.get<int*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(resetgl, resetgl)
LUA_BIND_STD_CLIENT(getfps, getfps_, e.get<int*>(1))

LUA_BIND_STD_CLIENT(resetlightmaps, resetlightmaps, e.get<bool>(1))
LUA_BIND_STD_CLIENT(calclight, calclight, e.get<int*>(1))
LUA_BIND_STD_CLIENT(patchlight, patchlight, e.get<int*>(1))
LUA_BIND_STD_CLIENT(clearlightmaps, clearlightmaps)
LUA_BIND_STD_CLIENT(dumplms, dumplms)

// blendmap

LUA_BIND_STD(clearblendbrushes, clearblendbrushes)
LUA_BIND_STD(delblendbrush, delblendbrush, e.get<const char*>(1))
LUA_BIND_STD(addblendbrush, addblendbrush, e.get<const char*>(1), e.get<const char*>(2))
LUA_BIND_STD(nextblendbrush, nextblendbrush, e.get<int*>(1))
LUA_BIND_STD(setblendbrush, setblendbrush, e.get<const char*>(1))
LUA_BIND_STD(getblendbrushname, getblendbrushname, e.get<int*>(1))
LUA_BIND_STD(curblendbrush, curblendbrush)
LUA_BIND_STD(rotateblendbrush, rotateblendbrush, e.get<int*>(1))
LUA_BIND_DEF(paintblendmap, {
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
LUA_BIND_STD(clearblendmapsel, clearblendmapsel)
LUA_BIND_STD(invertblendmapsel, invertblendmapsel)
LUA_BIND_STD(invertblendmap, invertblendmap)
LUA_BIND_STD(showblendmap, showblendmap)
LUA_BIND_STD(optimizeblendmap, optimizeblendmap)
LUA_BIND_DEF(clearblendmap, {
    if(noedit(true) || (GETIV(nompedit) && multiplayer())) return;
    resetblendmap();
    showblendmap();
})

// console

LUA_BIND_STD_CLIENT(toggleconsole, SETV, fullconsole, GETIV(fullconsole) ^ 1)
LUA_BIND_STD_CLIENT(conskip, setconskip, conskip, GETIV(fullconsole) ? GETIV(fullconfilter) : GETIV(confilter), e.get<int>(1))
LUA_BIND_STD_CLIENT(miniconskip, setconskip, miniconskip, GETIV(miniconfilter), e.get<int>(1))
LUA_BIND_CLIENT(clearconsole, while(conlines.length()) delete[] conlines.pop().line;)
LUA_BIND_STD_CLIENT(bind, bindkey, e.get<char*>(1), e.get<char*>(2), keym::ACTION_DEFAULT, "bind")
LUA_BIND_STD_CLIENT(specbind, bindkey, e.get<char*>(1), e.get<char*>(2), keym::ACTION_SPECTATOR, "specbind")
LUA_BIND_STD_CLIENT(editbind, bindkey, e.get<char*>(1), e.get<char*>(2), keym::ACTION_EDITING, "editbind")
LUA_BIND_STD_CLIENT(getbind, getbind, e.get<char*>(1), keym::ACTION_DEFAULT)
LUA_BIND_STD_CLIENT(getspecbind, getbind, e.get<char*>(1), keym::ACTION_SPECTATOR)
LUA_BIND_STD_CLIENT(geteditbind, getbind, e.get<char*>(1), keym::ACTION_EDITING)
LUA_BIND_STD_CLIENT(searchbinds, searchbinds, e.get<char*>(1), keym::ACTION_DEFAULT)
LUA_BIND_STD_CLIENT(searchspecbinds, searchbinds, e.get<char*>(1), keym::ACTION_SPECTATOR)
LUA_BIND_STD_CLIENT(searcheditbinds, searchbinds, e.get<char*>(1), keym::ACTION_EDITING)
LUA_BIND_CLIENT(saycommand, {
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
LUA_BIND_STD_CLIENT(inputcommand, inputcommand, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(history, history_, e.get<int*>(1))
LUA_BIND_STD_CLIENT(onrelease, onrelease, e.get<char*>(1))
LUA_BIND_STD_CLIENT(complete, addfilecomplete, e.get<char*>(1), e.get<char*>(2), e.get<char*>(3))
LUA_BIND_STD_CLIENT(listcomplete, addlistcomplete, e.get<char*>(1), e.get<char*>(2))

// textedit

#define LUA_BIND_TEXT(n, c) \
LUA_BIND_CLIENT(n, { \
    editor *top = currentfocus(); \
    if (!top) return; \
    c \
})
// return list of all editors
LUA_BIND_CLIENT(textlist, {
    std::string s;
    loopv(editors)
    {
        if (i > 0) s += ", ";
        s += editors[i]->name;
    }
    e.push(s.c_str());
})
// return the start of the buffer
LUA_BIND_TEXT(textshow, {
    editline line;
    line.combinelines(top->lines);
    e.push(line.text);
    line.clear();
})
// focus on a (or create a persistent) specific editor, else returns current name
LUA_BIND_CLIENT(textfocus, {
    if (e.is<const char*>(1))
    {
        int arg2 = e.get<int>(2);
        useeditor(e.get<const char*>(1), arg2 <= 0 ? EDITORFOREVER : arg2, true);
    }
    else if (editors.length() > 0) e.push(editors.last()->name);
    else e.push();
})
// return to the previous editor
LUA_BIND_TEXT(textprev, editors.insert(0, top); editors.pop();)
// (1 = keep while focused, 2 = keep while used in gui, 3 = keep forever (i.e. until mode changes)) topmost editor, return current setting if no args
LUA_BIND_TEXT(textmode, {
    int arg1 = e.get<int>(2);
    if (arg1)
    {
        top->mode = arg1;
        e.push();
    }
    else e.push(top->mode);
})
// saves the topmost (filename is optional)
LUA_BIND_TEXT(textsave, {
    const char *arg1 = e.get<const char*>(1);
    if (arg1) top->setfile(path(arg1, true));
    top->save();
})
LUA_BIND_TEXT(textload, {
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
LUA_BIND_TEXT(textinit, {
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

LUA_BIND_TEXT(textcopy, editor *b = useeditor(PASTEBUFFER, EDITORFOREVER, false); top->copyselectionto(b);)
LUA_BIND_TEXT(textpaste, editor *b = useeditor(PASTEBUFFER, EDITORFOREVER, false); top->insertallfrom(b);)
LUA_BIND_TEXT(textmark, {
    editor *b = useeditor(PASTEBUFFER, EDITORFOREVER, false); top->insertallfrom(b);
    int arg1 = e.get<int>(1);
    if (arg1)
    {
        top->mark(arg1 == 1);
        e.push();
    }
    else e.push(top->region() ? 1 : 2);
})
LUA_BIND_TEXT(textselectall, top->selectall();)
LUA_BIND_TEXT(textclear, top->clear();)
LUA_BIND_TEXT(textcurrentline, e.push(top->currentline().text);)
LUA_BIND_TEXT(textexec, e.exec(e.get<int>(1) ? top->selectiontostring() : top->tostring());)

// various commands

LUA_BIND_STD_CLIENT(movie, movie, e.get<char*>(1))
LUA_BIND_STD_CLIENT(recalc, recalc)
LUA_BIND_STD_CLIENT(glext, glext, e.get<char*>(1))
LUA_BIND_STD_CLIENT(getcampos, e.push, camera1->o)
LUA_BIND_STD_CLIENT(loadcrosshair, loadcrosshair_, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(tabify, tabify, e.get<char*>(1), e.get<int*>(2))
LUA_BIND_STD_CLIENT(resetsound, resetsound)

LUA_BIND_STD(isconnected, e.push, isconnected(e.get<int>(1) > 0) ? 1 : 0)
LUA_BIND_DEF(connectedip, {
    const ENetAddress *address = connectedpeer();
    string hostname;
    e.push(address && enet_address_get_host_ip(address, hostname, sizeof(hostname)) >= 0 ? hostname : "");
})
LUA_BIND_DEF(connectedport, {
    const ENetAddress *address = connectedpeer();
    e.push(address ? address->port : -1);
})
LUA_BIND_STD(connectserv, connectserv, e.get<const char*>(1), e.get<int>(2), e.get<const char*>(3))
LUA_BIND_STD(lanconnect, connectserv, NULL, e.get<int>(1), e.get<const char*>(2))
LUA_BIND_STD(disconnect, trydisconnect)
LUA_BIND_STD(localconnect, if(!isconnected() && !haslocalclients()) localconnect)
LUA_BIND_STD(localdisconnect, if(haslocalclients()) localdisconnect)

LUA_BIND_STD(printcube, printcube)
LUA_BIND_STD(remip, remip_)
LUA_BIND_STD(phystest, phystest)
LUA_BIND_STD(genpvs, genpvs, e.get<int*>(1))
LUA_BIND_STD(testpvs, testpvs, e.get<int*>(1))
LUA_BIND_STD(clearpvs, clearpvs)
LUA_BIND_STD(pvsstats, pvsstats)

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
