
// Copyright 2010 Alon Zakai ('kripken'). All rights reserved.
// This file is part of Syntensity/the Intensity Engine, an open source project. See COPYING.txt for licensing.

#include "cube.h"
#include "engine.h"
#include "game.h"

#include "client_system.h"
#include "utility.h"
#include "editing_system.h"
#include "message_system.h"

#include "intensity_gui.h"


extern float cursorx, cursory;

namespace EditingSystem
{
    extern std::vector<std::string> entityClasses;
}

namespace IntensityGUI
{
int keyRepeatDelay, keyRepeatInterval;

void setKeyRepeat(int delay, int interval)
{
    keyRepeatDelay = delay;
    keyRepeatInterval = interval;
    SDL_EnableKeyRepeat(keyRepeatDelay, keyRepeatInterval);
}

void showCubeGuiMessage(std::string title, std::string content)
{
    SETVF(message_title, title);
    SETVF(message_content, content);
    showgui("message");
}

void showMessage(std::string title, std::string content, int originClientNumber)
{
    if (title == "")
        conoutf(content.c_str());
    else
    {
//        if (originClientNumber == ClientSystem::playerNumber)
//            content = "Me: " + content;

        showCubeGuiMessage(title, content);
    } 
}

void showInputDialog(std::string title, std::string content)
{
    SETVF(input_title, title);
    SETVF(input_content, content);
    SETVF(input_data, "");
    showgui("input_dialog");
}

void input_callback(char *input)
{
    LuaEngine::getGlobal("UserInterface");
    LuaEngine::getTableItem("inputDialogCallback");
    LuaEngine::pushValue(std::string(input));
    LuaEngine::call(1, 0);
    LuaEngine::pop(1);
}

COMMAND(input_callback, "s");


// Entity classes dialog support

ICOMMAND(getentityclass, "i", (int *index), {
    std::string ret = EditingSystem::entityClasses[*index];
    assert( Utility::validateAlphaNumeric(ret, "_") ); // Prevent injections
    result(ret.c_str());
});

    bool canQuit()
    {
        if ( !EditingSystem::madeChanges )
            return true;

        // Changes were made, show a warning dialog
        showgui("can_quit");
        return false;
    }

    void injectMousePosition(float x, float y, bool immediate)
    {
        if (immediate)
        {
            float curr_x, curr_y;
            g3d_cursorpos(curr_x, curr_y);
            float xrel = x - curr_x;
            float yrel = y - curr_y;
            xrel *= max(screen->w, screen->h);
            yrel *= max(screen->w, screen->h);
//printf("curr: %f, %f\r\n", curr_x, curr_y);
//printf("next: %f, %f\r\n", x, y);
//printf("RELS: %f, %f       \r\n", xrel, yrel);
            if(!g3d_movecursor(0, 0))
            {
                mousemove(xrel, yrel);
                SDL_WarpMouse(screen->w / 2, screen->h / 2);
            }
            cursorx = x;
            cursory = y;
            return;
        }

/*
            float curr_x, curr_y;
            g3d_cursorpos(curr_x, curr_y);
            float xrel = x - curr_x;
            float yrel = y - curr_y;
            xrel *= 1000;
            yrel *= 1000;
printf("rels: %f, %f        %f,%f\r\n", xrel, yrel, x, curr_x);
            if(!g3d_movecursor(xrel, yrel))
                mousemove(xrel, yrel);
*/

        g3d_resetcursor(); // now at 0.5,0.5
        float curr_x, curr_y;
        float factor = 400;
        int iters = 0;
        do
        {
            g3d_cursorpos(curr_x, curr_y);
            //printf("A %d : (%f,%f) vs (%f,%f): %f,%f\r\n", iters, x, y, curr_x, curr_y, factor*(x - curr_x), factor*(y - curr_y));
            g3d_movecursor(factor*(x - curr_x), factor*(y - curr_y));
            iters++;
            //printf("B %d : (%f,%f) vs (%f,%f)\r\n", iters, x, y, curr_x, curr_y);
        } while (fabs(x-curr_x) + fabs(y-curr_y) > 0.005 && iters < 1000);
        assert(iters < 1000);
    }

    void injectMouseClick(int button, bool down)
    {
        SDL_Event event;
        event.type = down ? SDL_MOUSEBUTTONDOWN : SDL_MOUSEBUTTONUP;
        event.button.button = button;
        event.button.state = down;
        pushevent(event);
    }

    void injectKeyPress(int sym, int unicode, bool down, bool isRepeat)
    {
        if (isRepeat && keyRepeatDelay == 0) return; // Suppress repeat

        SDL_Event event;
        event.type = down ? SDL_KEYDOWN : SDL_KEYUP;
        event.key.keysym.sym = (SDLKey)sym;
        event.key.state = down ? SDL_PRESSED : !SDL_PRESSED;
        event.key.keysym.unicode = unicode;
        pushevent(event);
    }
}


// Private edit mode stuff

void request_private_edit_mode()
{
    MessageSystem::send_RequestPrivateEditMode();
}

COMMAND(request_private_edit_mode, "");

void private_edit_mode()
{
    intret(ClientSystem::editingAlone);
}

COMMAND(private_edit_mode, "");


// Plugins

void show_plugins()
{
    REFLECT_PYTHON( signal_show_components );
    signal_show_components();
}

COMMAND(show_plugins, "");

