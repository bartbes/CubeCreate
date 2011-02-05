local saveCAPI
local saveMessageSystem

Testing = {}

Testing.replaceEnvironment = function ()
    __entitiesStore = {}

    saveCAPI = CAPI

    CAPI = {
        feedback = {},
        StateDataChangeRequest = "CAPI.StateDataChangeRequest",
        LogicEntityCompleteNotification = "CAPI.LogicEntityCompleteNotification",
        LogicEntityRemoval = "CAPI.LogicEntityRemoval",
        StateDataUpdate = "CAPI.StateDataUpdate",
        currTime = function ()
            return 17001
        end,
        setupNonSauer = function (entity)
            CAPI.feedback['setupNonSauer'] = entity.uniqueId
        end,
        setupCharacter = function (entity)
            CAPI.feedback['setupCharacter'] = entity.uniqueId
        end,
        setupExtent = function (entity)
            CAPI.feedback['setupExtent'] = entity.uniqueId
        end,
        unregisterLogicEntity = function (uniqueId)
            CAPI.feedback.unregisterLogicEntity = uniqueId
        end,
        setAnimation = function (entity)
            CAPI.feedback['setAnimation'] = entity.uniqueId
        end,
        setModelName = function (entity)
            CAPI.feedback['setModelName'] = entity.uniqueId
        end,
        setAttachments = function (entity)
            CAPI.feedback['setAttachments'] = entity.uniqueId
        end,
        setMaxSpeed = function (entity)
            CAPI.feedback['setMaxSpeed'] = entity.uniqueId
        end,
        setYaw = function (entity)
            CAPI.feedback['setYaw'] = entity.uniqueId
        end,
        setPitch = function (entity)
            CAPI.feedback['setPitch'] = entity.uniqueId
        end,
        setMove = function (entity)
            CAPI.feedback['setMove'] = entity.uniqueId
        end,
        setStrafe = function (entity)
            CAPI.feedback['setStrafe'] = entity.uniqueId
        end,
        setDynent0 = function (entity)
            CAPI.feedback['setDynent0'] = entity.uniqueId
        end,
        setDynentVel = function (entity)
            CAPI.feedback['setDynentVel'] = entity.uniqueId
        end,
        setRadius = function (entity)
            CAPI.feedback['setRadius'] = entity.uniqueId
        end,
        setAboveeye = function (entity)
            CAPI.feedback['setAboveeye'] = entity.uniqueId
        end,
        setEyeheight = function (entity)
            CAPI.feedback['setEyeheight'] = entity.uniqueId
        end,
        setBlocked = function (entity)
            CAPI.feedback['setBlocked'] = entity.uniqueId
        end,
        setJumping = function (entity)
            CAPI.feedback['setJumping'] = entity.uniqueId
        end,
        setExtent0 = function (entity)
            CAPI.feedback['setExtent0'] = entity.uniqueId
        end,
        getExtent0 = function (entity)
            return {700,11,5}
        end,
        getAttr1 = function (entity)
            return entity.uniqueId + 11
        end,
        getAttr2 = function (entity)
            return entity.uniqueId + 22
        end,
        getAttr3 = function (entity)
            return entity.uniqueId + 33
        end,
        getAttr4 = function (entity)
            return entity.uniqueId + 44
        end,
        setAttr1 = function (entity)
            CAPI.feedback['attr1'] = entity.uniqueId + 1
        end,
        setAttr2 = function (entity)
            CAPI.feedback['attr2'] = entity.uniqueId + 2
        end,
        setAttr3 = function (entity)
            CAPI.feedback['attr3'] = entity.uniqueId + 3
        end,
        setAttr4 = function (entity)
            CAPI.feedback['attr4'] = entity.uniqueId + 4
        end,
        setCollisionRadiusWidth = function (entity)
        end,
        setCollisionRadiusHeight = function (entity)
        end
    }

    saveMessageSystem = MessageSystem

    MessageSystem = {
        feedback = {},
        ALL_CLIENTS = 9,
        send = function (target, msg, param1, param2, param3)
            local dump = string.format("MSG: %s %s %s,%s,%s", tostring(target), tostring(msg), tostring(param1), tostring(param2), tostring(param3))
            table.insert(MessageSystem.feedback, dump)
        end,
        toProtocolId = function (_class, key)
            return _class .. "|" .. key
        end,
        generateProtocolData = function (_className, stateVariableNames)
            table.insert(MessageSystem.feedback, { _className, stateVariableNames })
        end
    }
end



Testing.restoreEnvironment = function ()
    if saveCAPI then
        CAPI = saveCAPI
    end

    if saveMessageSystem then
        MessageSystem = saveMessageSystem
    end

    __entitiesStore = {}
end
