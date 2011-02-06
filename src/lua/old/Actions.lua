ANIM_DEAD = 0
ANIM_DYING = 1
ANIM_IDLE = 2
ANIM_FORWARD = 3
ANIM_BACKWARD = 4
ANIM_LEFT = 5
ANIM_RIGHT = 6
ANIM_HOLD1 = 7
ANIM_HOLD2 = 8
ANIM_HOLD3 = 9
ANIM_HOLD4 = 10
ANIM_HOLD5 = 11
ANIM_HOLD6 = 12
ANIM_HOLD7 = 13
ANIM_ATTACK1 = 14
ANIM_ATTACK2 = 15
ANIM_ATTACK3 = 16
ANIM_ATTACK4 = 17
ANIM_ATTACK5 = 18
ANIM_ATTACK6 = 19
ANIM_ATTACK7 = 20
ANIM_PAIN = 21
ANIM_JUMP = 22
ANIM_SINK = 23
ANIM_SWIM = 24
ANIM_EDIT = 25
ANIM_LAG = 26
ANIM_TAUNT = 27
ANIM_WIN = 28
ANIM_LOSE = 29
ANIM_GUN_IDLE = 30
ANIM_GUN_SHOOT = 31
ANIM_VWEP_IDLE = 32
ANIM_VWEP_SHOOT = 33
ANIM_SHIELD = 34
ANIM_POWERUP = 35
ANIM_MAPMODEL = 36
ANIM_TRIGGER = 37
NUMANIMS = 38

ANIM_INDEX = 0x7F
ANIM_LOOP = math.lsh(1, 7)
ANIM_START = math.lsh(1, 8)
ANIM_END = math.lsh(1, 9)
ANIM_REVERSE = math.lsh(1, 10)
ANIM_SECONDARY = 11

ANIM_RAGDOLL = math.lsh(1, 27)

-------------------------------------------

Action = class()
function Action:__tostring () return "OVERRIDETHIS" end

function Action:__init (kwargs)
    if not kwargs then
        kwargs = {}
    end

    self.begun = false
    self.sinished = false
    self.startTime = CAPI.currTime()

    if not self.secondsLeft then
        self.secondsLeft = defaultValue(kwargs.secondsLeft, 0)
    end

    if not self.animation then
        self.animation = defaultValue(kwargs.animation, null)
    end

    self.actor = null

    if not self.canBeCancelled then
        self.canBeCancelled = defaultValue(kwargs.canBeCancelled, true)
    end

    if not self.parallelTo then
        self.parallelTo = defaultValue(kwargs.parallelTo, null)
    end
end

function Action:start ()
    self.begun = true
    self:doStart()
end

function Action:doStart ()
end

function Action:execute (seconds)
    if self.actor and self.actor.deactivated then
        self:finish()
        return true
    end

    if not self.begun then
        self:start()

        if self.animation then
            self.lastAnimation = self.actor.animation
            if self.actor.animation ~= self.animation then
                self.actor.animation = self.animation
            end
        end
    end

    if not self.parallelTo then
        log(INFO, string.format("Executing action %s", tostring(self)))

        local finished = self:doExecute(seconds)
        assert(finished == true or finished == false)
        if finished then
            self:finish()
        end

        log(INFO, string.format("                   ...finished: %s", tostring(finished)))

        return finished
    else
        if self.parallelTo.finished then
            self.parallelTo = null
            self:finish()
            return true
        else
            return false
        end
    end
end

function Action:doExecute (seconds)
    self.secondsLeft = self.secondsLeft - seconds
    return (self.secondsLeft <= 0)
end

function Action:getAnimationFrame ()
    return 0
end

function Action:finish ()
    self.finished = true

    if self.animation and self.lastAnimation then
        if self.actor.animation ~= self.lastAnimation then
            self.actor.animation = self.lastAnimation
        end
    end

    self:doFinish()
end

function Action:doFinish ()
end

function Action:cancel ()
    if self.canBeCancelled then
        self:finish()
    end
end

-------------------------------------------

NeverEndingAction = class(Action)
function NeverEndingAction:__tostring () return "NeverEndingAction" end

function NeverEndingAction:doExecute (seconds)
    return false
end

-------------------------------------------

TargetedAction = class(Action)
function TargetedAction:__tostring () return "TargetedAction" end

function TargetedAction:__init (target, kwargs)
    self[Action].__user_init(self, kwargs)
    self.target = target
end

-------------------------------------------

SingleCommandAction = class(Action)
function SingleCommandAction:__tostring () return "SingleCommandAction" end

function SingleCommandAction:__init (command, kwargs)
    self[Action].__user_init(self, kwargs)
    self.command = command
end

function SingleCommandAction:doExecute (seconds)
    self:command()
    return true
end

-------------------------------------------
-------------------------------------------

ActionSystem = class()

function ActionSystem:__init (parent)
    self.parent = parent
    self.actionList = {}
end

function ActionSystem:isEmpty ()
    return (#self.actionList == 0)
end

function ActionSystem:manageActions (seconds)
    if #self.actionList > 0 then
        local tempList = {}
        for i = 1, #self.actionList do
            if not self.actionList[i].finished then
                table.insert(tempList, self.actionList[i])
            end
        end
        self.actionList = tempList

        if #self.actionList > 0 then
            log(INFO, string.format("Executing %s", tostring(self.actionList[1])))
            if self.actionList[1]:execute(seconds) then
                table.remove(self.actionList, 1)
            end
        end
    end
end

function ActionSystem:clear ()
    for i = 1, #self.actionList do
        self.actionList[i]:cancel()
    end
end

function ActionSystem:queue (action)
    if not action.canMultiplyQueue then
        local multiple = false

        for i = 1, #self.actionList do
            if tostring(self.actionList[i]) == tostring(action) then
                log(WARNING, string.format("Trying to multiply queue %s, but that isn't allowed\r\n", tostring(action)))
                multiple = true
                break
            end
        end

        if multiple then
            return nil
        end
    end

    table.insert(self.actionList, action)
    action.actor = self.parent
end

function ActionSystem:getAnimationFrame ()
    if #self.actionList == 0 then
        return 0
    else
        return self.actionList[1]:getAnimationFrame()
    end
end
