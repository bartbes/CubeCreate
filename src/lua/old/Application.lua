ApplicationManager = {
    setApplicationClass = function(_class)
        log(DEBUG, "ApplicationManager: setting ApplicationClass to " .. tostring(_class))

        ApplicationManager.instance = _class()
        if Global.SERVER then
            ApplicationManager.instance:init()
        end

        log(DEBUG, "ApplicationManager: instance is " .. tostring(ApplicationManager.instance))
    end
}

Application = class()

function Application:init ()
    log(WARNING, "Application.init: You should override this, and there is no need to call the ancestor. This should never run.")
end

function Application:getPcClass ()
    return "Player"
end

function Application:clientOnDisconnect ()
    log(WARNING, "Application.clientOnDisconnect: You should override this, and there is no need to call the ancestor. This should never run.")
end

function Application:onEntityOffMap (entity)
    log(WARNING, string.format("%i has fallen off the map.", entity.uniqueId))
end

function Application:clientOnEntityOffMap (entity)
    log(WARNING, string.format("%i has fallen off the map.", entity.uniqueId))
end

function Application:onPlayerLogin (player)
end

function Application:performMovement (move, down)
    getPlayerEntity().move = move
end

function Application:performStrafe (strafe, down)
    getPlayerEntity().strafe = strafe
end

function Application:performJump (down)
    if down then getPlayerEntity():jump() end
end

function Application:performYaw (yaw, down)
    getPlayerEntity().yawing = yaw
end

function Application:performPitch (pitch, down)
    getPlayerEntity().pitching = pitch
end

function Application:performMousemove (yaw, pitch)
    return { yaw = yaw, pitch = pitch }
end

function Application:performClick (button, down, position, entity, x, y)
    if self:clientClick(button, down, position, entity, x, y) ~= true then
        local uniqueId = -1
        if entity then
            uniqueId = entity.uniqueId
        end
        MessageSystem.send(CAPI.DoClick, button, down, position.x, position.y, position.z, uniqueId)
    end
end

function Application:clientClick (button, down, position, entity, x, y)
    if entity and entity.clientClick then
        return entity:clientClick(button, down, position, x, y)
    end
    return false
end

function Application:click (button, down, position, entity)
    if entity and entity.click then
        return entity:click(button, down, position)
    end
    return false
end

function Application:actionKey (index, down)
    self:emit(table.concat({'actionKey', index, tostring(down)}, ','))
end

function Application:getScoreboardText ()
    return {{-1, "No scoreboard text defined"}, {-1, "This should be done in the Application"}}
end

function Application:getCrosshair ()
    return "data/crosshair.png"
end

function Application:handleTextMessage (uniqueId, text)
    return false
end

Signals.addMethods(Application)


---------------------------------
-- DUMMY APPLICATION INTERFACE --
---------------------------------

__DummyApplication = class(Application)

function __DummyApplication:init ()
    log(WARNING, "(init) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].init(self)
end

function __DummyApplication:getPcClass ()
    log(WARNING, "(getPcClass) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    return "Player"
end

function __DummyApplication:clientOnDisconnect ()
    log(WARNING, "(clientOnDisconnect) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].clientOnDisconnect(self)
end

function __DummyApplication:onEntityOffMap (entity)
    log(WARNING, "(onEntityOffMap) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].onEntityOffMap(self, entity)
end

function __DummyApplication:clientOnEntityOffMap (entity)
    log(WARNING, "(clientOnEntityOffMap) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].clientOnEntityOffMap(self, entity)
end

function __DummyApplication:onPlayerLogin (player)
    log(WARNING, "(onPlayerLogin) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].onPlayerLogin(self, player)
end

function __DummyApplication:performClick (...)
    log(WARNING, "(performClick) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].performClick(self, ...)
end

function __DummyApplication:clientClick (...)
    log(WARNING, "(clientClick) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].clientClick(self, ...)
end

function __DummyApplication:click (...)
    log(WARNING, "(click) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].click(self, ...)
end

function __DummyApplication:actionKey (index, down)
    log(WARNING, "(actionKey) ApplicationManager.setApplicationClass was not called, this is the DummyApplication running.")
    self[Application].actionKey(self, index, down)
end

log(DEBUG, "Setting dummy application")

ApplicationManager.setApplicationClass(__DummyApplication)

