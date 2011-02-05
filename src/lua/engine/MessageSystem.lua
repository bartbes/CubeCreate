-- Lua table for making message system simpler to use

MessageSystem = {
    ALL_CLIENTS = -1,

    protocolNamesToIds = {},
    protocolIdsToNames = {},

    send = function (...)
        log(DEBUG, "MessageSystem.send")

        local args = { ... }

        local server
        local clientNumber

        if is_a(args[1], LogicEntity) then
            server = true
            clientNumber = args[1].clientNumber
        elseif type(args[1]) == "number" then
            server = true
            clientNumber = args[1]
        else
            server = false
        end

        if server then table.remove(args, 1) end

        local messageType = args[1]
        table.remove(args, 1)

        if server then table.insert(args, 1, clientNumber) end

        log(DEBUG, string.format("Scripting MessageSystem: Sending %s with [%s]", tostring(messageType), table.concat(table.map(args, function (x) return tostring(x) end), ",")))

        messageType(unpack(args))
    end,

    generateProtocolData = function (className, stateVariableNames)
        log(DEBUG, string.format("Generating protocol names for %s", className))

        table.sort(stateVariableNames)

        local namesToIds = {}
        local idsToNames = {}
        for i = 1, #stateVariableNames do
            namesToIds[stateVariableNames[i]] = i
            idsToNames[i] = stateVariableNames[i]
        end

        MessageSystem.protocolNamesToIds[className] = namesToIds;
        MessageSystem.protocolIdsToNames[className] = idsToNames;
    end,

    toProtocolId = function (className, stateVariableName)
        log(DEBUG, string.format("Retrieving protocol ID for %s/%s", className, stateVariableName))
        return MessageSystem.protocolNamesToIds[className][stateVariableName]
    end,

    fromProtocolId = function (className, protocol_id)
        log(DEBUG, string.format("Retrieving state variable name for %s/%i", className, protocol_id))
        return MessageSystem.protocolIdsToNames[className][protocol_id]
    end,

    removeClassInfo = function (className)
        MessageSystem.protocolNamesToIds[className] = nil
        MessageSystem.protocolIdsToNames[className] = nil
    end,

    showClientMessage = function (clientNumber, title, text)
        if tostring(clientNumber) == "LogicEntity" then
            clientNumber = clientNumber.clientNumber
        end
        MessageSystem.send(clientNumber, CAPI.PersonalServerMessage, -1, title, text)
    end
}
