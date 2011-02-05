MODEL = {
    CULL_VFC = math.lsh(1, 0),
    CULL_DIST = math.lsh(1, 1),
    CULL_OCCLUDED = math.lsh(1, 2),
    CULL_QUERY = math.lsh(1, 3),
    SHADOW = math.lsh(1, 4),
    DYNSHADOW = math.lsh(1, 5),
    LIGHT = math.lsh(1, 6),
    DYNLIGHT = math.lsh(1, 7),
    FULLBRIGHT = math.lsh(1, 8),
    NORENDER = math.lsh(1, 9)
}

AnimatableLogicEntity = class(LogicEntity)

function AnimatableLogicEntity:__tostring ()
    return "AnimatableLogicEntity"
end

function AnimatableLogicEntity:__init ()
    self[RootLogicEntity].__user_init(self)
    self.animation = WrappedCInteger({ cSetter = "CAPI.setAnimation", clientSet = true })
    self.startTime = WrappedCInteger({ cGetter = "CAPI.getStartTime" })
    self.modelName = WrappedCInteger({ cSetter = "CAPI.setModelName" })
    self.attachments = WrappedCArray({ cSetter = "CAPI.setAttachments" })
end

function AnimatableLogicEntity:init (uniqueId, kwargs)
    if self[LogicEntity].init then self[LogicEntity].init(self, uniqueId, kwargs) end
    self._attachmentsDict = {}
    self.modelName = ""
    self.attachments = {}
    self.animation = math.bor(ANIM_IDLE, ANIM_LOOP)
    log(DEBUG, "Animatable.init done")
end

function AnimatableLogicEntity:activate (kwargs)
    log(DEBUG, "Animatable.activate:")
    self[LogicEntity].activate(self, kwargs)
    log(DEBUG, "Animatable.activate (2)")
    self.modelName = self.modelName -- Workaround
    log(DEBUG, "Animatable.activate complete")
end

function AnimatableLogicEntity:setAttachment (tag, modelName)
    if not modelName then
        if self._attachmentsDict[tag] then
            self._attachmentsDict[tag] = nil
        end
    else
        self._attachmentsDict[tag] = modelName
    end

    local result = {}
    for k,v in pairs(self._attachmentsDict) do
        table.insert(result, modelAttachment(k, v))
    end
    self.attachments = result
end

function AnimatableLogicEntity:getAnimationFrame ()
    return self.actionSystem:getAnimationFrame()
end

function AnimatableLogicEntity:setLocalAnimation (animation)
    CAPI.setAnimation(self, animation)
    self.stateVariableValues['animation'] = animation
end

function AnimatableLogicEntity:setLocalModelName (modelName)
    CAPI.setModelName(self, modelName)
    self.stateVariableValues['modelName'] = modelName
end

function AnimatableLogicEntity:_generalSetup (...)
    self[LogicEntity]._generalSetup(self, ...)
    self:__defineGetter("center", self.getCenter)
end

LocalAnimationAction = class(Action)
function LocalAnimationAction:__tostring () return "LocalAnimationAction" end

function LocalAnimationAction:doStart ()
    self.oldAnimation = self.actor.animation
    self.actor:setLocalAnimation(self.localAnimation)
end

function LocalAnimationAction:doFinish ()
    if self.actor.animation == self.localAnimation then
        self.actor:setLocalAnimation(self.oldAnimation)
    end
end
