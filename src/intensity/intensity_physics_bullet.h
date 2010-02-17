
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


#include "btBulletDynamicsCommon.h"


#define BULLET_STATIC_POLYGONS 1

class BulletPhysicsEngine : public RealisticPhysicsEngine
{
    btBroadphaseInterface*	m_overlappingPairCache;
	btCollisionDispatcher*	m_dispatcher;
    btDbvtBroadphase* m_broadPhase;
	btConstraintSolver*	m_constraintSolver;
	btDefaultCollisionConfiguration* m_collisionConfiguration;
    btDynamicsWorld *m_dynamicsWorld;
    #ifdef CLIENT
        btIDebugDraw* m_debugDrawer;
    #endif

    //! Adds a bullet body. Takes ownership of 'shape'.
    physicsHandle addBody(btCollisionShape *shape, float mass);

public:
    virtual void init();

    virtual void destroy();

    virtual void clearStaticGeometry();
#ifdef BULLET_STATIC_POLYGONS
    virtual bool requiresStaticPolygons() { return true; };
#else
    virtual bool requiresStaticPolygons() { return false; };
#endif
    virtual void addStaticPolygon(std::vector<vec> vertexes);

#ifdef BULLET_STATIC_POLYGONS
    virtual bool requiresStaticCubes() { return false; };
#else
    virtual bool requiresStaticCubes() { return true; };
#endif
    virtual void addStaticCube(vec o, vec r);
    virtual void addStaticConvex(std::vector<vec>& vecs);

    virtual void removeBody(physicsHandle handle);

    virtual physicsHandle addSphere(float mass, float radius);
    virtual physicsHandle addBox(float mass, float rx, float ry, float rz);
    virtual void setBodyPosition(physicsHandle handle, const vec& position);
    virtual void setBodyVelocity(physicsHandle handle, const vec& velocity);
    virtual void getBodyPosition(physicsHandle handle, vec& position);
    virtual void getBodyRotation(physicsHandle handle, quat& rotation);
    virtual void getBodyVelocity(physicsHandle handle, vec& velocity);

    virtual void simulate(float seconds);
};

