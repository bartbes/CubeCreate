/*
 * scripting_system_lua_def.hpp, version 1
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

void resetlightmaps(bool fullclean);
void calclight(int *quality);
void patchlight(int *quality);
void clearlightmaps();
void dumplms();

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

void startlistenserver(int usemaster);
void stoplistenserver();

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
#include "luabind_tex.hpp"
#include "luabind_shaders.hpp"
#include "luabind_parthud.hpp"
#include "luabind_gui.hpp"
#include "luabind_edit.hpp"
#include "luabind_blend.hpp"
#include "luabind_messages.hpp"
#include "luabind_input.hpp"

/* Here begin the binds. Close them in C++ namespace */
namespace lua_binds
{

/*
 * Things to go into CAPI Lua namespace
 */

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

// data/ directory embeds, this is client-only, so we put it in ifdef. For server, they're just dummies
// dummies are needed because we don't want to check further in CAPIExtras.

LUA_BIND_STD_CLIENT(resetlightmaps, resetlightmaps, e.get<bool>(1))
LUA_BIND_STD_CLIENT(calclight, calclight, e.get<int*>(1))
LUA_BIND_STD_CLIENT(patchlight, patchlight, e.get<int*>(1))
LUA_BIND_STD_CLIENT(clearlightmaps, clearlightmaps)
LUA_BIND_STD_CLIENT(dumplms, dumplms)

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

// engine/server.cpp

LUA_BIND_STD(startlistenserver, startlistenserver, e.get<int>(1))
LUA_BIND_STD(stoplistenserver, stoplistenserver)

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
