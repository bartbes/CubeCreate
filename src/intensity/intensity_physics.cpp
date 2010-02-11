
/*
 *=============================================================================
 * Copyright (C) 2008 Alon Zakai ('Kripken') kripkensteiner@gmail.com
 *
 * This file is part of the Intensity Engine project,
 *    http://www.intensityengine.com
 *
 * The Intensity Engine is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * The Intensity Engine is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with the Intensity Engine.  If not, see
 *     http://www.gnu.org/licenses/
 *     http://www.gnu.org/licenses/agpl-3.0.html
 *=============================================================================
 */

#include "engine.h"

#include "utility.h"
#include "script_engine_manager.h"

#include "intensity_physics.h"
#include "intensity_physics_realistic.h"

#include "intensity_physics_sauer.h" // Just for line with creation - nothing else
#ifdef INTENSITY_BULLET
    #include "intensity_physics_bullet.h" // Just for line with creation - nothing else
#endif

namespace PhysicsManager
{

PhysicsEngine *engine = NULL;

//

void createEngine()
{
    if (!ScriptEngineManager::hasEngine()) return;

    std::string type = "sauer";

    if (ScriptEngineManager::getGlobal()->getProperty("Global")->hasProperty("physicsEngineType"))
        type = ScriptEngineManager::getGlobal()->getProperty("Global")->getProperty("physicsEngineType")->getString();

    Logging::log(Logging::WARNING, "Physics engine: %s\r\n", type.c_str());

    if (type == "sauer")
    {
        Logging::log(Logging::DEBUG, "Using sauer physics engine\r\n");
        engine = new SauerPhysicsEngine();
    }
#ifdef INTENSITY_BULLET
    else if (type == "bullet")
    {
        Logging::log(Logging::DEBUG, "Using bullet physics engine\r\n");
        engine = new BulletPhysicsEngine();
    }
#endif
    else
    {
        Logging::log(Logging::ERROR, "Invalid physics engine: %s\r\n", type.c_str());
        assert(0);
    }

    engine->init();
}

void destroyEngine()
{
    if (engine != NULL)
    {
        engine->destroy();
        delete engine;
        engine = NULL;
    }
}

bool hasEngine()
{
    return (engine != NULL);
}

PhysicsEngine* getEngine()
{
    assert(engine);
    return engine;
}

#define REQUIRE_ENGINE if (!hasEngine()) return; // Sauer calls physics before the first map even loads

void clearWorldGeometry()
{
    REQUIRE_ENGINE

    engine->clearStaticPolygons();

    renderprogress(0, "generating physics simulation");
}

vec* currVecs = NULL;

void setupWorldGeometryVerts(vector<vertex>& verts)
{
    REQUIRE_ENGINE

    if (!engine->requiresStaticPolygons()) return;

    unsigned int nVertices = verts.length();
    currVecs = new vec[nVertices];

    for (unsigned int i = 0; i < nVertices; i++)
    {
        currVecs[i] = verts[i].tovec();
    }
}


void setupWorldGeometryTriGroup(usvector& data, int tex, int lightmapTex, int orientation)
{
    REQUIRE_ENGINE

    if (!engine->requiresStaticPolygons()) return;

    static int counter = 0;
    renderprogress(-float(counter)/100, "generating physics simulation verts");
    counter++;
    if (counter == 100) counter = 0;

    // Count indexes (three indexes to a triangle)
    unsigned int ibufCount = data.length();
    if (ibufCount == 0)
        return;
    assert(ibufCount % 3 == 0);
    unsigned int numTris = ibufCount/3;

    Logging::log(Logging::DEBUG, "IO: setupWorldGeometryTriGroup: %d\r\n", ibufCount);

    std::vector<vec> currPolygon;
    int base;
    for (unsigned int i = 0; i < numTris; i++)
    {
        base = i*3;
        currPolygon.clear();
        currPolygon.push_back( currVecs[data[base+0]] );
        currPolygon.push_back( currVecs[data[base+1]] );
        currPolygon.push_back( currVecs[data[base+2]] );
        engine->addStaticPolygon(currPolygon);
    }
}


void finishWorldGeometryVerts()
{
    REQUIRE_ENGINE

    delete[] currVecs;
    currVecs = NULL;
}


void finalizeWorldGeometry()
{
    REQUIRE_ENGINE
}


// Simulation

void simulate(float seconds)
{
    REQUIRE_ENGINE

    engine->simulate(seconds);
}

};

