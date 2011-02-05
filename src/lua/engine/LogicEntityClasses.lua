_logicEntityClasses = {}

function registerEntityClass (_class, sauerType)
    local _className = _class:__tostring()
    log(DEBUG, string.format("Registering LE class: %s", _className))

    if not sauerType then
        loopBases(
            _class,
            function (parentClass)
                local parentClassName = tostring(parentClass())
                local err = true
                log(DEBUG, string.format("Finding sauertype in ancestor %s", parentClassName))
                err, sauerType = pcall(getEntitySauerType, parentClassName, true) -- give the function info we're calling it via pcall
                -- if getEntitySauerType raised error, then error message is stored in sauerType, log it and purge it.
                if not err then
                    log(DEBUG, sauerType .. " (Caught from protected call, continuing anyway)") -- log it as debug,
                    -- because we're continuing anyway and it probably means just that the parent is not registered and
                    -- right sauerType might be located more deep.
                    sauerType = nil
                end
            end,
            function (parentClass)
                return sauerType ~= nil or tostring(parentClass) == "LogicEntity"
            end
        )
    end

    if not sauerType then sauerType = "" end

    assert(not _logicEntityClasses[_className])
    _logicEntityClasses[_className] = {_class, sauerType}

    local stateVariableNames = {}

    local inst = _class()
    local _names = table.keys(inst)
    for i = 1, #_names do
        local variable = inst[ _names[i] ]
        log(INFO, string.format("Considering %s -- %s", _names[i], type(variable)))
        if isVariable(variable) then
            log(INFO, string.format("Setting up %s", _names[i]))
            table.insert(stateVariableNames, _names[i])
        end
    end

    log(DEBUG, string.format("Generating protocol data for %s", table.concat(stateVariableNames, ",")))

    MessageSystem.generateProtocolData(_className, stateVariableNames)

    return _class
end

-- argument "protected" is optional, used to turn off logging for the function since it's already logged
-- as DEBUG after pcall, somewhere else
function getEntityClass (_className, protected)
    if _logicEntityClasses[_className] then
        return _logicEntityClasses[_className][1]
    else
        if not protected then log(ERROR, "Invalid class: " .. _className) end
        error("Invalid class: " .. _className)
    end
end

function getEntitySauerType (_className, protected)
    if _logicEntityClasses[_className] then
        return _logicEntityClasses[_className][2]
    else
        if not protected then log(ERROR, "Invalid class: " .. _className) end
        error("Invalid class: " .. _className)
    end
end

function listEntityClasses ()
    local keys = table.keys(_logicEntityClasses)
    table.sort(keys)

    return table.filterarray(keys,
        function (_class) return getEntityClass(_class)._sauerType ~= "fpsent" end
    )
end
