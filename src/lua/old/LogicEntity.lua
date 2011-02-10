assert(Global.CLIENT or Global.SERVER)
assert(not (Global.CLIENT and Global.SERVER))
log(DEBUG, string.format("Generating LogicEntity system with CLIENT = %s", tostring(Global.CLIENT)))

RootLogicEntity = class()

function RootLogicEntity:__tostring ()
    return "LogicEntity"
end

RootLogicEntity.shouldAct = true

function RootLogicEntity:__init ()
    self.tags = StateArray()
    self._persistent = StateBoolean()
end

function RootLogicEntity:_generalSetup ()
    log(DEBUG, "RootLogicEntity._generalSetup")

    if self._generalSetupComplete then return nil end

    Signals.addMethods(self)

    self.actionSystem = ActionSystem(self)

    self.stateVariableValues = {}
    self.stateVariableValueTimestamps = {}

    self.deactivated = false

    self:_setupVariables()

    self._generalSetupComplete = true
end

function RootLogicEntity:_generalDeactivate ()
    self:clearActions()
    CAPI.unregisterLogicEntity(self.uniqueId)
    self.deactivated = true
end

function RootLogicEntity:_getStateDatum (key)
    return self.stateVariableValues[key]
end

function RootLogicEntity:act (seconds)
    self.actionSystem:manageActions(seconds)
end

function RootLogicEntity:queueAction (action)
    self.actionSystem:queue(action)
end

function RootLogicEntity:clearActions ()
    self.actionSystem:clear()
end

function RootLogicEntity:addTag (tag)
    if not self.hasTag(tag) then
        self.tags:push(tag)
    end
end

function RootLogicEntity:removeTag (tag)
    log(DEBUG, "remove")
    self.tags = table.filterarray(self.tags:asArray(), function (_tag) return _tag ~= tag end)
end

function RootLogicEntity:hasTag (tag)
    log(INFO, string.format("I can has %s, looking in %s", tostring(tag), JSON.encode(self.tags)))
    return (table.findarray(self.tags:asArray(), tag) >= 0)
end

function RootLogicEntity:_setupHandlers (handlerNames)
    local prefix = onModifyPrefix()

    for i = 1, #handlerNames do
        self.connect(prefix .. handlerNames[i], self[ "_set_" .. handlerNames[i] ])
    end
end

function RootLogicEntity:_setupVariables ()
    local _names = table.keys(self)

    for i = 1, #_names do
        local variable = self[ _names[i] ]
        if isVariable(variable) then
            variable:_register(_names[i], self)
        end
    end
end

function RootLogicEntity:createStateDataDict (targetClientNumber, kwargs)
    targetClientNumber = defaultValue(targetClientNumber, MessageSystem.ALL_CLIENTS)
    kwargs = defaultValue(kwargs, {})

    log(DEBUG, string.format("createStateDataDict(): %s %i, %i", tostring(self), self.uniqueId, targetClientNumber))

    local ret = {}
    local _names = table.keys(self)
    for i = 1, #_names do
        local variable = self[ _names[i] ]
        if isVariable(variable) and variable.hasHistory then
            if targetClientNumber >= 0 and not variable:shouldSend(self, targetClientNumber) then return nil end

            local value = self[variable._name]
            if value then
                log(INFO, string.format("createStateDataDict() addding %s:%s", variable._name, JSON.encode(value)))
                local _key = variable._name
                if kwargs.compressed then
                    _key = MessageSystem.toProtocolId(tostring(self), variable._name)
                end
                ret[tostring(_key)] = variable:toData(value)
                log(INFO, "createStateDataDict() currently...")
                log(INFO, string.format("createStateDataDict() currently: %s", JSON.encode(ret)))
            end
        end
    end

    log(DEBUG, string.format("createStateDataDict() returns: %s", JSON.encode(ret)))

    if not kwargs.compressed then
        return ret
    end

    _names = table.keys(ret)
    for i = 1, #_names do
        if ret[ _names[i] ] and ret[ _names[i] ] ~= "" then
            if tonumber(ret[ _names[i] ]) then
                ret[ _names[i] ] = tonumber(ret[ _names[i] ])
            elseif ret[ _names[i] ] == "[]" then
                ret[ _names[i] ] = nil
            end
        end
    end

    ret = JSON.encode(ret)
    log(DEBUG, string.format("pre-compression: %s", ret))

    local tmp = {
        function (data) local ret = string.gsub(data, "\", \"", "\",\"") return ret end,
        function (data) local ret = string.gsub(data, "\"(%w+)\":", "\"%1\":") return ret end,
        function (data) local ret = string.gsub(data, ":\"(%d+)\"", ":\"%1\"") return ret end,
        function (data) local ret = string.gsub(data, "\"%[%]\"", "[]") return ret end,
        function (data) local ret = string.gsub(data, ":\"(%d+)%.(%d+)\"", ":\"%1\".\"%2\"") return ret end,
        function (data) local ret = string.gsub(data, ", ", ",") return ret end
    }
    for i = 1, #tmp do
        local nextel = tmp[i](ret)
        if string.len(nextel) < string.len(ret) and JSON.encode(JSON.decode(nextel)) == JSON.encode(JSON.decode(ret)) then
            ret = nextel
        end
    end
    tmp = nil

    log(DEBUG, string.format("compressed: %s", ret))
    return string.sub(ret, 2, string.len(ret) - 1)
end

function RootLogicEntity:_updateCompleteStateData (stateData)
    log(DEBUG, string.format("updating complete state data for %i with %s (%s)", self.uniqueId, stateData, type(stateData)))

    if string.sub(stateData, 1, 1) ~= "{" then
        stateData = "{" .. stateData .. "}"
    end

    local newStateData = JSON.decode(stateData)

    assert(type(newStateData) == "table")

    self.initialized = true

    for a,b in pairs(newStateData) do
        local key = a
        local val = b
        if key then
            key = MessageSystem.fromProtocolId(tostring(self), tonumber(key))
        end

        log(DEBUG, string.format("update of complete state datum: %s = %s", tostring(key), tostring(val)))
        self:_setStateDatum(key, val, nil, true)
        log(DEBUG, "update of complete state datum ok")
    end
end

-----------------------------------------------------------------------------

local ClientLogicEntity = class(RootLogicEntity)

function ClientLogicEntity:clientActivate (kwargs)
    self:_generalSetup()

    if not self._sauerType then
        log(DEBUG, string.format("non-Sauer entity going to be set up: %s,%s", tostring(self), tostring(self._sauerType)))
        CAPI.setupNonSauer(self)
    end

    self.initialized = false
end

function ClientLogicEntity:clientDeactivate ()
    self:_generalDeactivate()
end

function ClientLogicEntity:_setStateDatum (key, value, actorUniqueId)
    log(DEBUG, string.format("Setting state datum: %s = %s for %i", tostring(key), JSON.encode(value), self.uniqueId))

    local variable = self[__SV_PREFIX .. key]

    local customSynchFromHere = variable.customSynch and self._controlledHere
    local clientSet = variable.clientSet

    if actorUniqueId == null and not customSynchFromHere then -- hacky checking for "definition" via string .. FIXME
        log(DEBUG, "Sending request/notification to server")
    
        MessageSystem.send(variable.reliable and CAPI.StateDataChangeRequest or CAPI.UnreliableStateDataChangeRequest,
                           self.uniqueId,
                           MessageSystem.toProtocolId(tostring(self), variable._name),
                           variable:toWire(value))
    end

    if actorUniqueId ~= null or clientSet or customSynchFromHere then
        log(INFO, "Updating locally")
        if actorUniqueId ~= null then
            value = variable:fromWire(value)
        end
        assert(variable:validate(value))
        self:emit("client_onModify_" .. key, value, actorUniqueId ~= null)
        self.stateVariableValues[key] = value
    end
end

function ClientLogicEntity:clientAct (seconds)
    log(INFO, string.format("ClientLogicEntity.clientAct, %i", self.uniqueId))
    self.actionSystem:manageActions(seconds)
end

ClientLogicEntity.renderDynamic = null

-----------------------------------------------------------------------------

local ServerLogicEntity = class(RootLogicEntity)
ServerLogicEntity.sentCompleteNotification = false

function ServerLogicEntity:init (uniqueId, kwargs)
    log(DEBUG, string.format("ServerLogicEntity.init(%i, %s)", uniqueId, tostring(kwargs)))

    assert(uniqueId)
    assert(type(uniqueId) == "number")

    self.uniqueId = uniqueId

    self:_logicEntitySetup()

    self.tags = {}

    kwargs = defaultValue(kwargs, {})
    self._persistent = defaultValue(kwargs._persistent, false)
end

function ServerLogicEntity:activate (kwargs)
    log(DEBUG, string.format("ServerLogicEntity.activate(%s)", tostring(kwargs)))

    self:_logicEntitySetup()

    if not self._sauerType then
        log(DEBUG, string.format("non-Sauer entity going to be set up: %s, %s", tostring(self), tostring(self._sauerType)))
        CAPI.setupNonSauer(self)
        self:_flushQueuedStateVariableChanges()
    end

    if kwargs and kwargs.stateData then
        self:_updateCompleteStateData(kwargs.stateData)
    end

    self:sendCompleteNotification(MessageSystem.ALL_CLIENTS)
    self.sentCompleteNotification = true

    log(DEBUG, "LE activate complete")
end

function ServerLogicEntity:sendCompleteNotification (clientNumber)
    clientNumber = defaultValue(clientNumber, MessageSystem.ALL_CLIENTS)
    local clientNumbers = clientNumber == MessageSystem.ALL_CLIENTS and getClientNumbers() or { clientNumber }

    log(DEBUG, string.format("LE.sendCompleteNotification: %i, %i", self.clientNumber, self.uniqueId))

    for i = 1, #clientNumbers do
        MessageSystem.send(
            clientNumbers[i],
            CAPI.LogicEntityCompleteNotification,
            self.clientNumber and self.clientNumber or -1,
            self.uniqueId,
            tostring(self),
            self:createStateDataDict(currClientNumber, { compressed = true }))
    end

    log(DEBUG, "Le.sendCompleteNotification complete")
end

function ServerLogicEntity:_logicEntitySetup ()
    if not self.initialized then
        log(DEBUG, "LE setup")

        self:_generalSetup()

        self._queuedStateVariableChanges = {}
        self._queuedStateVariableChangesComplete = false

        self.initialized = true

        log(DEBUG, "LE setup complete")
    end
end

function ServerLogicEntity:deactivate ()
    self:_generalDeactivate()

    MessageSystem.send(MessageSystem.ALL_CLIENTS, CAPI.LogicEntityRemoval, self.uniqueId)
end

function ServerLogicEntity:click (button, clicker)
end

function ServerLogicEntity:_setStateDatum (key, value, actorUniqueId, internalOp)
    log(INFO, string.format("Setting state datum: %s = %s (%s) : %s", key, tostring(value), type(value), JSON.encode(value)))

    local _class = tostring(self)

    local variable = self[__SV_PREFIX .. key]

    if not variable then
        log(WARNING, string.format("Ignoring state data setting for unknown (possibly deprecated) variable: %s", key))
        return nil
    end

    if actorUniqueId then
        value = variable:fromWire(value)
        if not variable.clientWrite then
            log(ERROR, string.format("Client %i tried to change %s", actorUniqueId, key))
            return nil
        end
    elseif internalOp then
        value = variable:fromData(value)
    end

    log(DEBUG, string.format("Translated value: %s = %s (%s) : %s", key, tostring(value), type(value), JSON.encode(value)))

    local ret = self:emit("onModify_" .. key, value, actorUniqueId)
    if ret then
        if ret == "CancelStateDataUpdate" then
            return nil
        else
            error(ret)
        end
    end

    self.stateVariableValues[key] = value
    log(INFO, string.format("New state data: %s", tostring(self.stateVariableValues[key])))

    local customSynchFromHere = variable.customSynch and self._controlledHere

    if (not internalOp) and variable.clientRead then
        if not customSynchFromHere then
            if not self.sentCompleteNotification then
                return nil
            end

            local cn = -1
            if variable.clientSet and actorUniqueId then cn = getEntity(actorUniqueId).clientNumber end
            local rel = CAPI.UnreliableStateDataUpdate
            if variable.reliable then rel = CAPI.StateDataUpdate end

            local args = {
                null,
                rel,
                self.uniqueId,
                MessageSystem.toProtocolId(_class, key),
                variable:toWire(value),
                cn
            }

            local _clientNumbers = getClientNumbers()
            for i = 1, #_clientNumbers do
                if not variable:shouldSend(self, _clientNumbers[i]) then return nil end
                args[1] = _clientNumbers[i]
                MessageSystem.send(unpack(args))
            end
        end
    end
end

function ServerLogicEntity:_queueStateVariableChange (key, value)
    log(DEBUG, string.format("Queueing SV change: %s - %s (%s)", key, tostring(value), type(value)))

    self._queuedStateVariableChanges[key] = value
end

function ServerLogicEntity:canCallCFuncs ()
    return (self._queuedStateVariableChanges == null)
end

function ServerLogicEntity:_flushQueuedStateVariableChanges ()
    log(DEBUG, string.format("Flushing Queued SV Changes for %i", self.uniqueId))

    if self:canCallCFuncs() then return nil end

    local changes = self._queuedStateVariableChanges
    self._queuedStateVariableChanges = null
    assert(self:canCallCFuncs())

    local _names = table.keys(changes)
    for i = 1, #_names do
        local value = changes[ _names[i] ]
        local variable = self[ __SV_PREFIX .. _names[i] ]
        log(DEBUG, string.format("(A) Flushing queued SV change: %s - %s (real: %s)", _names[i], tostring(value), tostring(self.stateVariableValues[key])))
        self[ _names[i] ] = self.stateVariableValues[ _names[i] ]
        log(DEBUG, string.format("(B) Flushing of %s - ok", _names[i]))
    end

    self._queuedStateVariableChangesComplete = true
end

-----------------------------------------------------------------------------

if Global.CLIENT then
    LogicEntity = ClientLogicEntity
else
    LogicEntity = ServerLogicEntity
end

