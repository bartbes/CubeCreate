function cacheByTimeDelay (func, delay)
    func.lastTime = -(delay) * 2
    return function (...)
        if (Global.time - func.lastTime) >= delay then
            func.lastCachedvalue = func(...)
            func.lastTime = Global.time
        end
        return func.lastCachedValue
    end
end

__entitiesStore = {}
__entitiesStoreByClass = {}

function getEntity (uniqueId)
    log(INFO, "getEntity " .. tostring(uniqueId))
    local ret = __entitiesStore[uniqueId]
    if ret then
        log(INFO, string.format("getEntity found entity %i (%i)", uniqueId, ret.uniqueId))
        return ret
    else
        log(INFO, string.format("getEntity could not find entity %s", tostring(uniqueId)))
        return null
    end
end

function getEntitiesByTag (withTag)
    local ret = {}
    local _values = table.values(__entitiesStore)
    for i = 1, #_values do
        if _values[i]:hasTag(withTag) then
            table.insert(ret, _values[i])
        end
    end
    return ret
end

function getEntityByTag (withTag)
    local ret = getEntitiesByTag(withTag)
    if #ret == 1 then
        return ret[1]
    elseif #ret > 1 then
        log(WARNING, string.format("Attempting to get a single entity with tag '%s', but several exist", withTag))
        return null
    else
        log(WARNING, string.format("Attempting to get a single entity with tag '%s', but no such entity exists", withTag))
        return null
    end
end

function getEntitiesByClass (_class)
    if type(_class) == "table" then
        _class = tostring(_class)
    end

    if __entitiesStoreByClass[_class] then
        return __entitiesStoreByClass[_class]
    else
        return {}
    end
end

function getClientEntities ()
    return getEntitiesByClass("Player")
end

function getClientNumbers ()
    return table.map(getClientEntities(), function (client) return client.clientNumber end)
end

function isPlayerEditing (player)
    if Global.CLIENT then
        player = defaultValue(player, getPlayerEntity())
    end
    return (player and player.clientState == CLIENTSTATE.EDITING)
end

function getCloseEntities (origin, maxDistance, _class, withTag, unsorted)
    local ret = {}
    local entities = _class and getEntitiesByClass(_class) or table.values(__entitiesStore)

    for i = 1, #entities do
        local otherEntity = entities[i]
        if not (withTag and not entity:hasTag(withTag)) or otherEntity.position then
            local distance = origin:subNew(otherEntity.position):magnitude()
            if distance <= maxDistance then
                table.insert(ret, {otherEntity, distance})
            end
        end
    end

    if not unsorted then
        table.sort(ret, function (a, b) return (a[2] < b[2]) end)
    end

    return ret
end

function addEntity (_className, uniqueId, kwargs, _new)
    uniqueId = defaultValue(uniqueId, 1331)
    log(DEBUG, string.format("Adding new Scripting LogicEntity of type %s with uniqueId %i", _className, uniqueId))
    log(DEBUG, string.format("   with arguments: %s, %s", JSON.encode(kwargs), tostring(_new)))

    assert(getEntity(uniqueId) == null)

    local _class = getEntityClass(_className)
    local ret = _class()

    if Global.CLIENT then
        ret.uniqueId = uniqueId
    else
        if _new then
            ret:init(uniqueId, kwargs)
        else
            ret.uniqueId = uniqueId
        end
    end

    __entitiesStore[ret.uniqueId] = ret
    assert(getEntity(uniqueId) == ret)

    for k,v in pairs(_logicEntityClasses) do
        local className = k
        local classClass = v[1]
        if classof(ret) == classClass then
            if not __entitiesStoreByClass[className] then
                __entitiesStoreByClass[className] = {}
            end
            table.insert(__entitiesStoreByClass[className], ret)
        end
    end

    log(DEBUG, "Activating")

    if Global.CLIENT then
        ret:clientActivate(kwargs)
    else
        ret:activate(kwargs)
    end

    return ret
end

function removeEntity (uniqueId)
    uniqueId = tonumber(uniqueId)
    log(DEBUG, string.format("Removing Scripting LogicEntity: %i", uniqueId))

    if not __entitiesStore[uniqueId] then
        log(WARNING, string.format("Cannot remove entity %i as it does not exist", uniqueId))
        return nil
    end

    __entitiesStore[uniqueId]:emit("preDeactivate")

    if Global.CLIENT then
        __entitiesStore[uniqueId]:clientDeactivate()
    else
        __entitiesStore[uniqueId]:deactivate()
    end

    local entity = __entitiesStore[uniqueId]
    for k,v in pairs(_logicEntityClasses) do
        local className = k
        local classClass = v[1]
        if classof(entity) == classClass then
            table.remove(__entitiesStoreByClass[className],
                table.find(__entitiesStoreByClass[className], entity))
        end
    end

    __entitiesStore[uniqueId] = nil
end

function removeAllEntities ()
    log(DEBUG, "Clearing up logic entities")
    local _keys = table.keys(__entitiesStore)
    for i = 1, #_keys do
        removeEntity(_keys[i])
    end
end

currTimestamp = 0
Global.currTimestamp = currTimestamp

function startFrame ()
    currTimestamp = currTimestamp + 1
    Global.currTimestamp = currTimestamp
end

Global.time = 0
Global.currTimeDelta = 1.0
Global.lastmillis = 0
Global.profiling = null
Global.queuedActions = {}

function manageActions (seconds, lastmillis)
    log(INFO, "manageActions: queued")

    local currentActions = Global.queuedActions
    Global.queuedActions = {}
    for i = 1, #currentActions do
        currentActions[i]()
    end

    Global.time = Global.time + seconds
    Global.currTimeDelta = seconds
    Global.lastmillis = lastmillis

    log(INFO, string.format("manageActions: %i", seconds))

    if Global.profiling then
        if not Global.profiling.counter then
            Global.profiling.data = {}
            Global.profiling.counter = seconds
        else
            Global.profiling.counter = Global.profiling.counter + seconds
            if Global.profiling.interval and Global.profiling.counter >= Global.profiling.interval then
                Global.profiling.counter = 0
            end
        end
    end

    local ltime

    local entities = table.values(__entitiesStore)
    for i = 1, #entities do
        local entity = entities[i]
        if not entity.deactivated and entity.shouldAct == true and
            (entity.shouldAct ~= true and (
                (Global.CLIENT and not entity.shouldAct.client) or
                (Global.SERVER and not entity.shouldAct.server)
            ))
        then
            if Global.profiling then
                ltime = CAPI.currTime()
            end

            if Global.CLIENT then
                entity:clientAct(seconds)
            else
                entity:act(seconds)
            end

            if Global.profiling then
                ltime = CAPI.currTime() - ltime
                if not Global.profiling.data[tostring(entity)] then Global.profiling.data[tostring(entity)] = 0 end
                Global.profiling.data[tostring(entity)] = Global.profiling.data[tostring(entity)] + ltime
            end
        end
    end

    if Global.profiling and Global.profiling.counter == 0 then
        log(ERROR, "---------------profiling (time per second)---------------")
        local sortedKeys = table.keys(Global.profiling.data)
        table.sort(sortedKeys, function (a, b) return (Global.profiling.data[b] < Global.profiling.data[a]) end)
        for i = 1, #sortedKeys do
            log(ERROR, string.format("profiling: %s: %i", sortedKeys[i], (Global.profiling.data[ sortedKeys[i] ] / (1000 * Global.profiling.interval))))
        end
        log(ERROR, "---------------profiling (time per second)---------------")
    end
end

manageTriggeringCollisions = cacheByTimeDelay(tocalltable(function ()
    local ltime
    if Global.profiling and Global.profiling.data then
        ltime = CAPI.currTime()
    end

    local entities = getEntitiesByClass("AreaTrigger")

    local _clientents = getClientEntities()
    for i = 1, #_clientents do
        if isPlayerEditing(_clientents[i]) then return nil end
        for j = 1, #entities do
            local entity = entities[j]
            if World.isPlayerCollidingEntity(_clientents[i], entity) then
                if Global.CLIENT then
                    entity:clientOnCollision(_clientents[i])
                else
                    entity:onCollision(_clientents[i])
                end
            end
        end
    end

    if Global.profiling and Global.profiling.data then
        local _class = "__TriggeringCollisions__"
        ltime = CAPI.currTime() - ltime
        if not Global.profiling.data[_class] then Global.profiling.data[_class] = 0 end
        Global.profiling.data[_class] = Global.profiling.data[_class] + ltime
    end
end), defaultValue(Global.triggeringCollisionsDelay, 1 / 10))

function renderDynamic (thirdperson)
    log(INFO, "renderDynamic")

    local ltime
    local continue = false

    local player = getPlayerEntity()
    if not player then return nil end

    local entities = table.values(__entitiesStore)
    for i = 1, #entities do
        local entity = entities[i]
        log(INFO, string.format("renderDynamic for: %i", entity.uniqueId))

        if entity.deactivated or entity.renderDynamic == null then continue = true end

        if not continue then
            if Global.profiling and Global.profiling.data then
                ltime = CAPI.currTime()
            end

            if entity.useRenderDynamicTest then
                if not entity.renderDynamicTest then
                    Rendering.setupDynamicTest(entity)
                end

                if not entity:renderDynamicTest() then continue = true end
            end

            if not continue then
                entity:renderDynamic(false, (not thirdperson) and entity == player)

                if Global.profiling and Global.profiling.data then
                    local _class = tostring(entity) .. "::renderDynamic"
                    ltime = CAPI.currTime() - ltime
                    if not Global.profiling.data[_class] then Global.profiling.data[_class] = 0 end
                    Global.profiling.data[_class] = Global.profiling.data[_class] + ltime
                end
            end
        end
    end
end

function renderHUDModels ()
    local player = getPlayerEntity()
    if player.HUDModelName and player.clientState ~= CLIENTSTATE.EDITING then
        player:renderDynamic(true, true)
    end
end

if Global.CLIENT then
    playerLogicEntity = null

    function setPlayerUniqueId (uniqueId)
        log(DEBUG, string.format("Setting player unique ID to %i", uniqueId))

        if uniqueId ~= null then
            playerLogicEntity = getEntity(uniqueId)
            playerLogicEntity._controlledHere = true

            assert(uniqueId == null or playerLogicEntity ~= null)
        else
            playerLogicEntity = null
        end
    end

    function getPlayerEntity ()
        return playerLogicEntity
    end

    function setStateDatum (uniqueId, keyProtocolId, value)
        entity = getEntity(uniqueId)
        if entity ~= null then
            local key = MessageSystem.fromProtocolId(tostring(entity), tonumber(keyProtocolId))
            log(DEBUG, string.format("setStateDatum: %i, %i, %s", uniqueId, keyProtocolId, key))
            entity:_setStateDatum(key, value)
        end
    end

    function testScenarioStarted ()
        log(INFO, "Testing whether the scenario started")
        if getPlayerEntity() == null then
            log(INFO, "...no, player logic entity not created yet")
            return false
        end

        log(INFO, "...player entity created")
        if playerLogicEntity.uniqueId < 0 then
            log(INFO, "...no, player not unique ID-ed")
            return false
        end

        log(INFO, "...player entity unique ID-ed")
        local _values = table.values(__entitiesStore)
        for i = 1, #_values do
            if not _values[i].initialized then
                log(INFO, string.format("...no, %i is not initialized", _values[i].uniqueId))
                return false
            end
        end

        log(INFO, "...yes")
        return true
    end
end

if Global.SERVER then
    function getNewUniqueId ()
        local ret = 0
        local _keys = table.keys(__entitiesStore)
        for i = 1, #_keys do
            ret = math.max(ret, _keys[i])
        end
        ret = ret + 1
        log(DEBUG, string.format("Generating new unique ID: %i", ret))
        return ret
    end

    function newEntity (_className, kwargs, forceUniqueId, returnUniqueId)
        log(DEBUG, string.format("New logic entity: %i", forceUniqueId))

        if not forceUniqueId then
            forceUniqueId = getNewUniqueId()
        end

        local ret = addEntity(_className, forceUniqueId, kwargs, true)

        if returnUniqueId then
            return ret.uniqueId
        else
            return ret
        end
    end

    function newNPC (_className)
        local npc = CAPI.addNPC(_className)
        if npc then
            npc._controlledHere = true
            return npc
        else
            return nil
        end
    end

    function sendEntities (clientNumber)
        log(DEBUG, string.format("Sending active logic entities to %i", clientNumber))
        local numEntities = #__entitiesStore

        MessageSystem.send(clientNumber, CAPI.NotifyNumEntities, numEntities)

        for k, v in pairs(__entitiesStore) do
            v:sendCompleteNotification(clientNumber)
        end
    end

    function setStateDatum (uniqueId, keyProtocolId, value, actorUniqueId)
        local entity = getEntity(uniqueId)
        if entity ~= null then
            local key = MessageSystem.fromProtocolId(tostring(entity), tonumber(keyProtocolId))
            entity:_setStateDatum(key, value, actorUniqueId)
        end
    end

    function loadEntities (serializedEntities)
        log(DEBUG, string.format("Loading entities... %s %s", tostring(serializedEntities), type(serializedEntities)))

        local entities = JSON.decode(serializedEntities)
        for i = 1, #entities do
            log(DEBUG, string.format("loadEntities: %s", JSON.encode(entities[i])))
            local uniqueId = entities[i][1]
            local _class = entities[i][2]
            local stateData = entities[i][3]
            log(DEBUG, string.format("loadEntities: %i,%s,%s", uniqueId, _class, tostring(stateData)))

            if _class == "PlayerStart" then _class = "WorldMarker" end

            log(DEBUG, tostring(CAPI.getMapversion()))
            if CAPI.getMapversion() <= 30 and stateData.attr1 then
                if not (_class == "Light" or _class == "FlickeringLight" or _class == "ParticleEffect" or _class == "Envmap") then
                    stateData.attr1 = (tonumber(stateData.attr1) + 180) % 360
                end
            end

            addEntity(_class, uniqueId, { stateData = JSON.encode(stateData) })
        end

        log(DEBUG, "Loading entities complete")
    end
end

function saveEntities ()
    local ret = {}

    log(DEBUG, "Saving entities...:")
    local _values = table.values(__entitiesStore)
    for i = 1, #_values do
        if _values[i].persistent then
            log(DEBUG, string.format("Saving entity %i", _values[i].uniqueId))
            local uniqueId = _values[i].uniqueId
            local _class = tostring(_values[i])
            local stateData = _values[i]:createStateDataDict()
            table.insert(ret, JSON.encode({uniqueId, _class, stateData}))
        end
    end

    log(DEBUG, "Saving entities complete")
    return "[\n" .. table.concat(ret, ",\n") .. "\n]\n\n"
end 

function cacheByGlobalTimestamp (func)
    return function (...)
        if func.lastTimestamp ~= Global.currTimestamp then
            func.lastCachedValue = func(...)
            func.lastTimestamp = Global.currTimestamp
        end
        return func.lastCachedValue
    end
end

CAPI.getTargetPosition = cacheByGlobalTimestamp(tocalltable(CAPI.getTargetPosition))
CAPI.getTargetEntity = cacheByGlobalTimestamp(tocalltable(CAPI.getTargetEntity))

Rendering = {
    setupDynamicTest = function (entity)
        local currEntity = entity
        entity.renderDynamicTest = cacheByTimeDelay(tocalltable(function(self)
            local playerCenter = getPlayerEntity().center
            if currEntity.position:subNew(playerCenter):magnitude() > 256 then
                if not hasLineOfSight(playerCenter, currEntity.position) then return false end
            end
            return true
        end), 1/3)
    end,
}
