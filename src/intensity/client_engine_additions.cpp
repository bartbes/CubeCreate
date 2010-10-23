
// Copyright 2010 Alon Zakai ('kripken'). All rights reserved.
// This file is part of Syntensity/the Intensity Engine, an open source project. See COPYING.txt for licensing.

#include "cube.h"
#include "engine.h"
#include "game.h"

#include "client_system.h"
#include "client_engine_additions.h"
#include "utility.h"
#include "targeting.h"
#include "message_system.h"


//=========================
// Camera stuff
//=========================

#define MIN_CAMERA_MOVE_ITERS 8
VAR(CameraControl::cameraMoveDist, 5, 10, 200);                 // Distance camera moves per iteration
//VAR(CameraControl::cameraMoveIters, MIN_CAMERA_MOVE_ITERS, 14, 18); // Number of iterations to move camera DEPRECATED

VAR(cam_dist, 0, 50, 200);

void CameraControl::incrementCameraDist(int inc_dir)
{
    Logging::log(Logging::DEBUG, "changing camera increment: %d\r\n", inc_dir);

    cam_dist += (inc_dir * CameraControl::cameraMoveDist);

    if (LuaEngine::exists())
    {
        LuaEngine::getGlobal("Global");
        LuaEngine::setTable("cameraDistance", cam_dist);
        LuaEngine::pop(1);
    }
}

void inc_camera()
    { CameraControl::incrementCameraDist (+1); };
void dec_camera()
    { CameraControl::incrementCameraDist (-1); };

COMMAND(inc_camera, "");
COMMAND(dec_camera, "");


int saved_cam_dist; // Saved from before characterviewing, restored right after

void CameraControl::prepareCharacterViewing()
{
    player->pitch  = 0;
    camera1->pitch = 0;
    camera1->yaw   = camera1->yaw;

    saved_cam_dist = cam_dist;
    cam_dist = MIN_CAMERA_MOVE_ITERS*3;
}

void CameraControl::stopCharacterViewing()
{
    cam_dist = saved_cam_dist;
}

FVARP(cameraheight, 0, 10, 50); // How much higher than the player to set the camera
FVAR(smoothcamera, 0, 0.2, 100.0); // Smoothing factor for the smooth camera. 0 means no smoothing
FVARP(cameraavoid, 0, 0.33, 1); // 1 means the camera is 100% away from the closest obstacle (and therefore on the player). 0 means it is on that obstacle. 0.5 means it is midway between them.

physent forcedCamera;
bool useForcedCamera = false;
float forcedCameraFov = -1;
int savedThirdperson = -1;

bool useForcedPosition = false;
bool useForcedYaw = false;
bool useForcedPitch = false;
bool useForcedRoll = false;

void CameraControl::forcePosition(vec& position)
{
    useForcedPosition = true;
    forcedCamera.o = position;

    // If we just switched to forced camera mode, save thirdperson state and go to third person
    // (We need third person so that we show the player's avatar as the camera moves. There is
    // currently no support for forcing the camera in first person mode, which would be tricky to do.)
    if (!thirdperson && savedThirdperson == -1)
    {
        savedThirdperson = thirdperson;
        thirdperson = 1;
    }
}

void CameraControl::forceYaw(float yaw)
{
    useForcedYaw = true;
    forcedCamera.yaw = yaw;
    if (!thirdperson && savedThirdperson == -1)
    {
        savedThirdperson = thirdperson;
        thirdperson = 1;
    }
}

void CameraControl::forcePitch(float pitch)
{
    useForcedPitch = true;
    forcedCamera.pitch = pitch;
    if (!thirdperson && savedThirdperson == -1)
    {
        savedThirdperson = thirdperson;
        thirdperson = 1;
    }
}

void CameraControl::forceRoll(float roll)
{
    useForcedRoll = true;
    forcedCamera.roll = roll;
    if (!thirdperson && savedThirdperson == -1)
    {
        savedThirdperson = thirdperson;
        thirdperson = 1;
    }
}

void CameraControl::forceFov(float fov)
{
    forcedCameraFov = fov;
    if (!thirdperson && savedThirdperson == -1)
    {
        savedThirdperson = thirdperson;
        thirdperson = 1;
    }
}

void CameraControl::forceCamera(vec& position, float yaw, float pitch, float roll, float fov)
{
    useForcedCamera = true;
    CameraControl::forcePosition(position);
    CameraControl::forceYaw(yaw);
    CameraControl::forcePitch(pitch);
    CameraControl::forceRoll(roll);
    CameraControl::forceFov(fov);
}

physent* CameraControl::getCamera()
{
    return camera1;
}

void CameraControl::positionCamera(physent* camera1)
{
    Logging::log(Logging::INFO, "CameraControl::positionCamera\r\n");
    INDENT_LOG(Logging::INFO);

    if (useForcedCamera || useForcedPosition || useForcedYaw || useForcedPitch || useForcedRoll)
    {
        if (useForcedPosition) { camera1->o = forcedCamera.o; useForcedPosition = false; };
        if (useForcedYaw) { camera1->yaw = forcedCamera.yaw; useForcedYaw = false; };
        if (useForcedPitch) { camera1->pitch = forcedCamera.pitch; useForcedPitch = false; };
        if (useForcedRoll) { camera1->roll = forcedCamera.roll; useForcedRoll = false; };

        if (useForcedCamera)
        {
            useForcedCamera = false; // Prepare for next frame
            return;
        }
    }

    // Sync camera height to scripts, if necessary
    static float lastCameraHeight = -1;
    if (LuaEngine::exists() && lastCameraHeight != cameraheight)
    {
        lastCameraHeight = cameraheight;
        LuaEngine::getGlobal("Global");
        LuaEngine::setTable("cameraHeight", cameraheight);
        LuaEngine::pop(1);
    }

    // If we just left forced camera mode, restore thirdperson state
    if (savedThirdperson != -1)
    {
        thirdperson = savedThirdperson;
        savedThirdperson = -1;
    }

    float saved_camera_speed = camera1->maxspeed; // Kripken: need to save this, because camera1 =?= player1
    camera1->maxspeed = 50; // This speed determines the distance of the camera, so the Sauer way of tying it to the 
                            // player's speed is not completely general

    vec dir;
    vecfromyawpitch(camera1->yaw, camera1->pitch, -1, 0, dir);

    if (GuiControl::isCharacterViewing())
        camera1->o = player->o; // Start from player

    if(game::collidecamera()) 
    {
        vec cameraOrigin = camera1->o;
        if (thirdperson)
        {
            vec up(0, 0, 1);
            movecamera(camera1, up, cameraheight, 1);
            movecamera(camera1, up, clamp(cameraheight- camera1->o.dist(cameraOrigin), 0.0f, 1.0f), 0.1f); // Find distance to obstacle
        }

        vec cameraOrigin2 = camera1->o;
        movecamera(camera1, dir, cam_dist, 1);
        movecamera(camera1, dir, clamp(cam_dist - camera1->o.dist(cameraOrigin2), 0.0f, 1.0f), 0.1f); // Find distance to obstacle

        if (smoothcamera) {
            float intendedDist = camera1->o.dist(cameraOrigin2)*(1.0f-cameraavoid);
            static float lastDist = 5;
            float ACTUAL_DISTANCE_FACTOR = clamp(1.0f - (curtime/1000.0f)/smoothcamera, 0.0f, 1.0f);
            float actualDist = ACTUAL_DISTANCE_FACTOR*lastDist + (1-ACTUAL_DISTANCE_FACTOR)*intendedDist;

            // Start again, move to current distance
            camera1->o = cameraOrigin2;
            movecamera(camera1, dir, actualDist, 1);
            movecamera(camera1, dir, clamp(actualDist - camera1->o.dist(cameraOrigin2), 0.0f, 1.0f), 0.1f);
            lastDist = actualDist;
        }
    } else {
        camera1->o.z += cameraheight;
        camera1->o.add(vec(dir).mul(cam_dist));
    }

    camera1->maxspeed = saved_camera_speed;

    // Kripken: Smooth camera movement: We interpolate our the new calculated position with the old one, smoothly

    static fpsent actualCamera; // Need fpsent for new normalization functions
    static vec lastPlayerPosition;

    vec temp(actualCamera.o);
    temp.sub(camera1->o);

    actualCamera.normalize_yaw(camera1->yaw);
    actualCamera.normalize_pitch(camera1->pitch);

    float yawDelta = camera1->yaw - actualCamera.yaw;
    float pitchDelta = camera1->pitch - actualCamera.pitch;

    // Only interpolate if we are fairly close, otherwise this might be a new map, or we teleported, etc.
    if (smoothcamera && !GuiControl::isMouselooking() && temp.magnitude() < 50*player->radius && fabs(yawDelta) < 30.0f && fabs(pitchDelta) < 30.0f)
    {
        float ACTUAL_CAMERA_FACTOR = clamp(1.0f - (curtime/1000.0f)/smoothcamera, 0.0f, 1.0f);

        vec temp = player->o;
        temp.sub(lastPlayerPosition);
        actualCamera.o.add(temp); // Prevent camera stutter

        actualCamera.o.mul(ACTUAL_CAMERA_FACTOR);
        temp = camera1->o;
        temp.mul(1-ACTUAL_CAMERA_FACTOR);
        actualCamera.o.add(temp);

        actualCamera.yaw = ACTUAL_CAMERA_FACTOR*actualCamera.yaw + (1-ACTUAL_CAMERA_FACTOR)*camera1->yaw;
        actualCamera.pitch = ACTUAL_CAMERA_FACTOR*actualCamera.pitch + (1-ACTUAL_CAMERA_FACTOR)*camera1->pitch;

        camera1->o = actualCamera.o;
        camera1->yaw = actualCamera.yaw;
        camera1->pitch = actualCamera.pitch;

//        camera1->o.z += player->aboveeye + player->eyeheight;

    } else {
        actualCamera.o = camera1->o;
        actualCamera.yaw = camera1->yaw;
        actualCamera.pitch = camera1->pitch;
    }

    lastPlayerPosition = player->o;
}


//=========================
// GUI stuff
//=========================

bool _isMouselooking = true; // Default like sauer

bool GuiControl::isMouselooking()
    { return _isMouselooking; };


void GuiControl::toggleMouselook()
{
    if (_isMouselooking)
    {
        _isMouselooking = false;

        // Restore cursor to center
        g3d_resetcursor();
    } else {
        _isMouselooking = true;
    };
};

void mouselook() { GuiControl::toggleMouselook(); };

COMMAND(mouselook, "");

bool _isCharacterViewing = false;

bool GuiControl::isCharacterViewing()
    { return _isCharacterViewing; };

void GuiControl::toggleCharacterViewing()
{
    if (!_isCharacterViewing)
        CameraControl::prepareCharacterViewing();
    else
        CameraControl::stopCharacterViewing();

    _isCharacterViewing = !_isCharacterViewing;
}

void characterview() { GuiControl::toggleCharacterViewing(); };

COMMAND(characterview, "");

void GuiControl::menuKeyClickTrigger()
{
    playsound(S_MENUCLICK);
}

void menu_key_click_trigger() { GuiControl::menuKeyClickTrigger(); };

COMMAND(menu_key_click_trigger, "");


// Editing GUI statics
LogicEntityPtr GuiControl::EditedEntity::currEntity;
GuiControl::EditedEntity::StateDataMap GuiControl::EditedEntity::stateData;
std::vector<std::string> GuiControl::EditedEntity::sortedKeys;

SVAR(entity_gui_title, "");

VAR(num_entity_gui_fields, 0, 0, 13);

// Sets up a GUI for editing an entity's state data
void prepare_entity_gui()
{
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
    LuaEngine::getGlobal("getEntity");
    LuaEngine::pushValue(uniqueId);
    LuaEngine::call(1, 1);
    // we've got the entity here now (popping getEntity out)
    LuaEngine::getTableItem("createStateDataDict");
    LuaEngine::pushValueFromIndex(-2); // let's push first argument as self
    LuaEngine::call(1, 1);
    // ok, state data are on stack, popping createStateDataDict out, let's ref it so we can easily get it later
    int _tempRef = LuaEngine::ref();
    LuaEngine::pop(1);

    LuaEngine::getGlobal("table");
    // we've got "table" on stack
    LuaEngine::getTableItem("keys");
    // we've got "keys" on stack, now we push a copy of state data as argument
    LuaEngine::getRef(_tempRef);
    // we call the keys function with stateData copy as argument, the call pops the stateData out
    LuaEngine::call(1, 1);
    // we've got keys on stack. let's loop the table now.
    LUA_TABLE_LOOP({
        std::string key = LuaEngine::getString(-1);
        LuaEngine::getGlobal("__getVariableGuiName");
        LuaEngine::pushValue(uniqueId);
        LuaEngine::pushValue(key);
        LuaEngine::call(2, 1);
        std::string guiName = LuaEngine::getString(-1);
        LuaEngine::pop(1);

        LuaEngine::getRef(_tempRef);
        std::string value = LuaEngine::getTableString(key);
        LuaEngine::pop(1);

        GuiControl::EditedEntity::stateData.insert(
            GuiControl::EditedEntity::StateDataMap::value_type(
                key,
                std::pair<std::string, std::string>(
                    guiName,
                    value
                )
            )
        );

        GuiControl::EditedEntity::sortedKeys.push_back( key );
        num_entity_gui_fields++; // increment for later loop
    });

    LuaEngine::pop(2);
    LuaEngine::unref(_tempRef);

    sort( GuiControl::EditedEntity::sortedKeys.begin(), GuiControl::EditedEntity::sortedKeys.end() ); // So order is always the same

    for (int i = 0; i < num_entity_gui_fields; i++)
    {
        std::string key = GuiControl::EditedEntity::sortedKeys[i];
        std::string guiName = GuiControl::EditedEntity::stateData[key].first;
        std::string value = GuiControl::EditedEntity::stateData[key].second;

        std::string fieldName = "entity_gui_field_" + Utility::toString(i);
        std::string labelName = "entity_gui_label_" + Utility::toString(i);

        setsvar((char*)fieldName.c_str(), (char*)value.c_str());
        setsvar((char*)labelName.c_str(), (char*)guiName.c_str());
    }

    // Title
    std::string title;
    LuaEngine::getGlobal("tostring");
    LuaEngine::getRef(GuiControl::EditedEntity::currEntity->luaRef);
    LuaEngine::call(1, 1);
    title = LuaEngine::getString(-1, "Unknown");
    LuaEngine::pop(1);
    title = Utility::toString(uniqueId) + ": " + title;

    setsvar((char*)"entity_gui_title", (char*)title.c_str());

    // Create the gui
    std::string command =
    "newgui entity [\n"
    "    guitext $entity_gui_title\n"
    "    guibar\n";

    for (int i = 0; i < num_entity_gui_fields; i++)
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
    "    guilist [\n"
    "        guitext (get_entity_gui_label " + sI + ")\n"
    "        new_entity_gui_field_" + sI + " = (get_entity_gui_value " + sI + ")\n"
    "        guifield new_entity_gui_field_" + sI + " " + Utility::toString((int)value.size()+25) + " [set_entity_gui_value " + sI + " $new_entity_gui_field_" + sI + "] 0\n"
    "    ]\n";

        if ((i+1) % 10 == 0)
        {
            command +=
    "   guitab " + Utility::toString(i) + "\n";
        }
    }

    command +=
    "]";

//    printf("Command: %s\r\n", command.c_str());
    execute(command.c_str());
}

COMMAND(prepare_entity_gui, "");

void get_entity_gui_label(int *index)
{
    std::string ret = GuiControl::EditedEntity::stateData[GuiControl::EditedEntity::sortedKeys[*index]].first + ": ";
    result(ret.c_str());
}

COMMAND(get_entity_gui_label, "i");

void get_entity_gui_value(int *index)
{
    std::string ret = GuiControl::EditedEntity::stateData[GuiControl::EditedEntity::sortedKeys[*index]].second;
    result(ret.c_str());
}

COMMAND(get_entity_gui_value, "i");

void set_entity_gui_value(int *index, char *newValue)
{
    std::string key = GuiControl::EditedEntity::sortedKeys[*index];
    std::string oldValue = GuiControl::EditedEntity::stateData[key].second;

    if (oldValue != newValue)
    {
        GuiControl::EditedEntity::stateData[key].second = newValue;

        int uniqueId = GuiControl::EditedEntity::currEntity->getUniqueId();
        // getting args for future encodeJSON first
        LuaEngine::getGlobal("__getVariable");
        // __getVariable on stack
        LuaEngine::pushValue(uniqueId);
        LuaEngine::pushValue(key);
        // call it with those arguments
        LuaEngine::call(2, 1);
        // the variable on stack now, call its fromData
        LuaEngine::getTableItem("fromData");
        // fromData on stack
        LuaEngine::pushValueFromIndex(-2); // self argument
        LuaEngine::pushValue(std::string(newValue)); // value argument
        // call it
        LuaEngine::call(2, 1);
        // value here on stack. It's an argument of encodeJSON. now get encodeJSON and shift the values.
        LuaEngine::getGlobal("encodeJSON");
        LuaEngine::shift();
        // call encodeJSON finally.
        LuaEngine::call(1, 1);
        // string on stack now
        std::string naturalValue = LuaEngine::getString(-1, "[]");
        LuaEngine::pop(2); // return stack into original state - get rid of the string and the variable.

        LuaEngine::runScript("getEntity(" + Utility::toString(uniqueId) + ")." + key + " = (" + naturalValue + ")");
    }
}

COMMAND(set_entity_gui_value, "is");


//
///
//// Physics
///
//

// Extra player movements
bool k_turn_left, k_turn_right, k_look_up, k_look_down;

#define dir(name,v,d,s,os) ICOMMAND(name, "D", (int *down),      \
    if (ClientSystem::scenarioStarted()) \
    { \
        PlayerControl::flushActions(); /* Stop current actions */         \
        s = *down!=0;                                                \
        dynamic_cast<fpsent*>(player)->v = s ? d : (os ? -(d) : 0);  \
    } \
);

dir(turn_left,  turn_move, -1, k_turn_left,  k_turn_right); // New turning motion
dir(turn_right, turn_move, +1, k_turn_right, k_turn_left);  // New pitching motion

dir(look_down, look_updown_move, -1, k_look_down, k_look_up);
dir(look_up,   look_updown_move, +1, k_look_up,   k_look_down);

#define script_dir(name,v,d,s,os) ICOMMAND(name, "D", (int *down),      \
    if (ClientSystem::scenarioStarted()) \
    { \
        PlayerControl::flushActions(); /* Stop current actions */         \
        s = *down!=0;                                                \
        LuaEngine::getGlobal("ApplicationManager"); \
        LuaEngine::getTableItem("instance"); \
        LuaEngine::getTableItem(#v); \
        LuaEngine::pushValueFromIndex(-2); \
        LuaEngine::pushValue(s ? d : (os ? -(d) : 0)); \
        LuaEngine::pushValue(s); \
        LuaEngine::call(3, 0); \
        LuaEngine::pop(2); \
    } \
);

//script_dir(turn_left,  performYaw, -1, k_turn_left,  k_turn_right); // New turning motion
//script_dir(turn_right, performYaw, +1, k_turn_right, k_turn_left);  // New pitching motion
// TODO: Enable these. But they do change the protocol (see Character.js), so forces everyone and everything to upgrade
//script_dir(look_down, performPitch, -1, k_look_down, k_look_up);
//script_dir(look_up,   performPitch, +1, k_look_up,   k_look_down);

// Old player movements
script_dir(backward, performMovement, -1, player->k_down,  player->k_up);
script_dir(forward,  performMovement,  1, player->k_up,    player->k_down);
script_dir(left,     performStrafe,    1, player->k_left,  player->k_right);
script_dir(right,    performStrafe,   -1, player->k_right, player->k_left);

ICOMMAND(jump, "D", (int *down), {
  if (ClientSystem::scenarioStarted())
  {
    PlayerControl::flushActions(); /* Stop current actions */
    LuaEngine::getGlobal("ApplicationManager");
    LuaEngine::getTableItem("instance");
    LuaEngine::getTableItem("performJump");
    LuaEngine::pushValueFromIndex(-2);
    LuaEngine::pushValue((bool)*down);
    LuaEngine::call(2, 0);
    LuaEngine::pop(2);
  }
});


// Player movements control - keyboard stuff

void PlayerControl::handleExtraPlayerMovements(int millis)
{
    float delta = float(millis)/1000.0f;

    physent *mover;
//    if (GuiControl::isCharacterViewing()) // Buggy. Commenting this out gives a good enough result, actually:
//                                          // keys move *player*, and do mouseMove mode if you want to use the mouse to look around
//        mover = camera1;
//    else
        mover = player;

    // Turn if mouse is at borders

    float x, y;
    g3d_cursorpos(x, y);
    if (g3d_windowhit(true, false)) x = y = 0.5; // Do not scroll with mouse

    // Turning

    fpsent* fpsPlayer = dynamic_cast<fpsent*>(player);

    LuaEngine::getRef(ClientSystem::playerLogicEntity.get()->luaRef);
    float _facingSpeed = LuaEngine::getTableDouble("facingSpeed");

    if (fpsPlayer->turn_move || fabs(x - 0.5) > 0.45)
        mover->yaw += _facingSpeed * (
                fpsPlayer->turn_move ? fpsPlayer->turn_move : (x > 0.5 ? 1 : -1)
            ) * delta;

    if (fpsPlayer->look_updown_move || fabs(y - 0.5) > 0.45)
        mover->pitch += _facingSpeed * (
                fpsPlayer->look_updown_move ? fpsPlayer->look_updown_move : (y > 0.5 ? -1 : 1)
            ) * delta;

    LuaEngine::pop(1);

    extern void fixcamerarange();
    fixcamerarange(); // Normalize and limit the yaw and pitch values to appropriate ranges
}

bool PlayerControl::handleKeypress(SDLKey sym, int unicode, bool isdown)
{
    assert(0);
    return false;
}

bool PlayerControl::handleClick(int button, bool up)
{
    assert(0);
    return false;
}

void PlayerControl::flushActions()
{
    LuaEngine::getRef(ClientSystem::playerLogicEntity.get()->luaRef);
    LuaEngine::getTableItem("actionSystem");
    LuaEngine::getTableItem("clear");
    LuaEngine::pushValueFromIndex(-2);
    LuaEngine::call(1, 0);
    LuaEngine::pop(2);
}

void PlayerControl::toggleMainMenu()
{
    assert(0);
}


//==============================
// Light Control
//==============================

namespace LightControl
{

void addHoverLight()
{
    if (GuiControl::isMouselooking())
        return; // We don't need to mark anything if we are mouselooking. There is no cursor anyhow.

    vec color;

    if (!TargetingControl::targetLogicEntity.get())
    {
        Logging::log(Logging::WARNING, "targetLogicEntity is NULL\r\n");
        return;
    }

    switch (TargetingControl::targetLogicEntity.get()->getType())
    {
        case CLogicEntity::LE_DYNAMIC: color = vec(0.25f, 1.0f, 0.25f);  break;
        case CLogicEntity::LE_STATIC:  color = vec(0.25f, 0.25f, 1.0f);  break;
        case CLogicEntity::LE_NONE:    color = vec(1.0f, 1.0f, 0.5f);
    }

    vec   location;
    float radius;
    bool  needDecal;

    if (!TargetingControl::targetLogicEntity.get()->isNone())
    {    
        location = TargetingControl::targetLogicEntity.get()->getOrigin();
        radius   = TargetingControl::targetLogicEntity.get()->getRadius();
        needDecal = true;
    } else {
        location  = TargetingControl::worldPosition;
        radius    = 0; // 3
        needDecal = false;
    }

    // Add some light to mark the mouse - probably a bad idea for production though though TODO: Consider
    adddynlight(location, radius*2, color);

    if (needDecal)
    {
        // Calculate floor position, and draw a decal there
        vec floorNorm;
        float floorDist = rayfloor(location, floorNorm);
        adddecal(DECAL_CIRCLE, location.sub(vec(0,0,floorDist)), floorNorm, radius);
    }
}

// Queued dynamic lights - to be added for the next frame.
// We should really just create dynamic lights only during the
// weapon::addynlights() code, but this makes writing scripts
// somewhat messier. This approach might lead to lag of 1 frame,
// so livable for now.
struct queuedDynamicLight
{
    vec o;
    float radius;
    vec color;
    int fade, peak, flags;
    float initradius;
    vec initcolor;
    physent *owner;
};

std::vector<queuedDynamicLight> queuedDynamicLights;

void queueDynamicLight(const vec &o, float radius, const vec &color, int fade, int peak, int flags, float initradius, const vec &initcolor, physent *owner)
{
    queuedDynamicLight q;
    q.o = o;
    q.radius = radius;
    q.color = color;
    q.fade = fade;
    q.peak = peak;
    q.flags = flags;
    q.initradius = initradius;
    q.initcolor = initcolor;
    q.owner = owner;
    queuedDynamicLights.push_back(q);
}

void showQueuedDynamicLights()
{
    for (unsigned int i = 0; i < queuedDynamicLights.size(); i++)
    {
        queuedDynamicLight& q = queuedDynamicLights[i];
        adddynlight(q.o, q.radius, q.color, q.fade, q.peak, q.flags, q.initradius, q.initcolor, q.owner);
    }

    queuedDynamicLights.clear();
}

}

// Additional Rendering

std::vector<extentity*> ExtraRendering::currShadowingMapmodels;

void ExtraRendering::renderShadowingMapmodels()
{
    assert(0);
#if 0
    loopstdv(currShadowingMapmodels)
    {
        extentity *mapmodel = currShadowingMapmodels[i];
        model *theModel = LogicSystem::getLogicEntity(*mapmodel).get()->getModel();
        if(!theModel) continue;
        const char *mdlname = theModel->name(); //mapmodelname(mapmodel->attr2);

        int flags = MDL_LIGHT | MDL_CULL_VFC | MDL_CULL_DIST | MDL_CULL_OCCLUDED;

        if (theModel->translucent)
            flags |= MDL_TRANSLUCENT;
        else
            flags |= MDL_SHADOW; // flags |= MDL_DYNSHADOW; ?

        rendermodel(NULL,
                    mdlname,
                    ANIM_MAPMODEL | ANIM_LOOP, // FIXME: Shadowing mapmodels aren't generally per-frame calculated, but who knows,fix this
                    mapmodel->o,
                    LogicSystem::getLogicEntity(*mapmodel),
                    mapmodel->attr1,
                    0,
                    flags);
    }
#endif
}


// Mouse clicks

void mouseclick(int button, bool down)
{
    Logging::log(Logging::INFO, "mouse click: %d (down: %d)\r\n", button, down);

    if (! (LuaEngine::exists() && ClientSystem::scenarioStarted()) )
        return;

    TargetingControl::determineMouseTarget(true); // A click forces us to check for clicking on entities

    vec pos = TargetingControl::targetPosition;

    LuaEngine::getGlobal("ApplicationManager");
    LuaEngine::getTableItem("instance");
    LuaEngine::getTableItem("performClick");
    LuaEngine::pushValueFromIndex(-2); // self argument
    // pushing arguments themselves
    LuaEngine::pushValue(button);
    LuaEngine::pushValue(down);
    LuaEngine::getGlobal("Vector3");
    LuaEngine::pushValue(pos.x);
    LuaEngine::pushValue(pos.y);
    LuaEngine::pushValue(pos.z);
    // after call, vec is on stack
    LuaEngine::call(3, 1);
    if (TargetingControl::targetLogicEntity.get() && !TargetingControl::targetLogicEntity->isNone())
        LuaEngine::getRef(TargetingControl::targetLogicEntity->luaRef);
    else
        LuaEngine::pushValue();
    float x, y;
    g3d_cursorpos(x, y);
    LuaEngine::pushValue(x);
    LuaEngine::pushValue(y);
    // call now
    LuaEngine::call(7, 0);
    LuaEngine::pop(2);
}

ICOMMAND(mouse1click, "D", (int *down), { mouseclick(1, *down!=0); });
ICOMMAND(mouse2click, "D", (int *down), { mouseclick(2, *down!=0); });
ICOMMAND(mouse3click, "D", (int *down), { mouseclick(3, *down!=0); });


// Other client actions - bind these to keys using cubescript (for things like a 'reload' key, 'crouch' key, etc. -
// specific to each game). TODO: Consider overlap with mouse buttons

void actionKey(int index, bool down)
{
    if (LuaEngine::exists())
    {
        LuaEngine::getGlobal("ApplicationManager");
        LuaEngine::getTableItem("instance");
        LuaEngine::getTableItem("actionKey");
        LuaEngine::pushValueFromIndex(-2); // self argument
        // pushing arguments themselves
        LuaEngine::pushValue(index);
        LuaEngine::pushValue(down);
        // call now
        LuaEngine::call(3, 0);
        LuaEngine::pop(2);
    }
}

#define ACTIONKEY(i) ICOMMAND(actionkey##i, "D", (int *down), { actionKey(i, *down!=0); });
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
ACTIONKEY(29); // 30 action keys should be enough for everybody (TODO: consider speed issues)

