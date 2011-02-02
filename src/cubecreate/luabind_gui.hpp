/*
 * luabind_gui.hpp, version 1
 * GUI methods for Lua
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

    LUA_BIND_STD_CLIENT(menukeyclicktrig, GuiControl::menuKeyClickTrigger)

    // Sets up a GUI for editing an entity's state data. TODO: get rid of ugly ass STL shit
    LUA_BIND_CLIENT(prepentgui, {
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
                "        GUI.field(\"new_entity_gui_field_" + sI + "\", "
                + Utility::toString((int)value.size()+25)
                + ", [[ CE.set_gui_value(" + sI + ", CV.new_entity_gui_field_" + sI + ") ]], 0)\n"
                "    ]])\n";

            if ((i+1) % 10 == 0)
            {
                command +=
                    "   GUI.tab(" + Utility::toString(i) + ")\n";
            }
        }

        command +=
            "]])\n";

//      printf("Command: %s\r\n", command.c_str());
        e.exec(command.c_str());
    })

    LUA_BIND_CLIENT(getentguilabel, {
        std::string ret = GuiControl::EditedEntity::stateData[GuiControl::EditedEntity::sortedKeys[e.get<int>(1)]].first + ": ";
        e.push(ret.c_str());
    })

    LUA_BIND_CLIENT(getentguival, {
        std::string ret = GuiControl::EditedEntity::stateData[GuiControl::EditedEntity::sortedKeys[e.get<int>(1)]].second;
        e.push(ret.c_str());
    })

    LUA_BIND_CLIENT(setentguival, {
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

    LUA_BIND_CLIENT(show_plugins, {
        REFLECT_PYTHON(signal_show_components);
        signal_show_components();
    })
}
