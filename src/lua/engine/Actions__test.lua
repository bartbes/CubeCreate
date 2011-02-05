log(DEBUG, "---- ACTIONS TEST BEGIN ----")

Testing.replaceEnvironment()

local parent = {}

parent.actionSystem = ActionSystem(parent)

assert(parent.actionSystem:isEmpty())

local feedback = 0

local TestAction = class(Action)
function TestAction:__tostring () return "TestAction" end
TestAction.secondsLeft = 6
function TestAction:doExecute (seconds)
    feedback = feedback + seconds
    return self[Action].doExecute(self, seconds)
end

local act = TestAction()

assert(not act.begun)
assert(not act.finished)
assert(act.startTime == 17001)
assert(act.secondsLeft == 6)

parent.actionSystem:queue(act)

assert(not parent.actionSystem:isEmpty())

parent.actionSystem:manageActions(2)

assert(act.begun)
assert(not act.finished)
assert(act.secondsLeft == 4)
assert(feedback == 2)
assert(not parent.actionSystem:isEmpty())

local act2 = Action({ secondsLeft = 1000 })

parent.actionSystem:queue(act2)
parent.actionSystem:manageActions(3)

assert(act.begun)
assert(not act.finished)
assert(act.secondsLeft == 1)
assert(feedback == 5)
assert(not parent.actionSystem:isEmpty())

parent.actionSystem:manageActions(3)

assert(act.begun)
assert(act.finished)
assert(feedback >= 6)
assert(not parent.actionSystem:isEmpty())

assert(not act2.finished)

parent.actionSystem:manageActions(3000)

assert(act2.finished)
assert(parent.actionSystem:isEmpty())

Testing.restoreEnvironment()

log(DEBUG, "---- ACTIONS TEST END ----")
