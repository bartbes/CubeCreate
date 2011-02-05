log(DEBUG, "---- LOGIC ENTITY CLASSES TEST BEGIN ----")

Testing.replaceEnvironment()

assert(table.concat(table.keys(_logicEntityClasses)) == "")

local tc1 = class(LogicEntity)
function tc1:__tostring () return "tc1" end
function tc1:__init ()
    self[RootLogicEntity].__user_init(self)
    self.var1a = StateVariable()
    self.var1b = StateVariable()
end

local tc2 = class(LogicEntity)
function tc2:__tostring () return "tc2" end

log(DEBUG, "tc1")
registerEntityClass(tc1, "nada")

assert(getEntityClass("tc1") == tc1)
assert(getEntitySauerType("tc1") == "nada")

log(DEBUG, "MI: " .. JSON.encode(MessageSystem.feedback))

log(DEBUG, "tc2")
registerEntityClass(tc2, "wak")
assert(getEntityClass("tc2") == tc2)
assert(getEntitySauerType("tc2") == "wak")

-- Child types with sauerType from ancestor

local tc2_1 = class(tc2)
function tc2_1:__tostring () return "tc2_1" end

local tc2_1_1 = class(tc2_1)
function tc2_1_1:__tostring () return "tc2_1_1" end

registerEntityClass(tc2_1, nil)
assert(getEntitySauerType("tc2_1") == "wak")

registerEntityClass(tc2_1_1, nil)
assert(getEntitySauerType("tc2_1_1") == "wak")

-- Child classes with sauerType from ancestor with skipping

local tc1_1 = class(tc1)
function tc1_1:__tostring () return "tc1_1" end
function tc1_1:__init ()
    self[tc1].__user_init(self)
    self.var1_1a = StateVariable()
end

local tc1_1_1 = class(tc1_1)
function tc1_1_1:__tostring () return "tc1_1_1" end
function tc1_1_1:__init ()
    self[tc1_1].__user_init(self)
    self.var1_1_1a = StateVariable()
end

MessageSystem.feedback = {}

registerEntityClass(tc1_1_1, nil)

assert(getEntitySauerType("tc1_1_1") == "nada")

-- restore all

_logicEntityClasses = {}
assert(table.concat(table.keys(_logicEntityClasses)) == "")

Testing.restoreEnvironment()

log(DEBUG, "---- LOGIC ENTITY CLASSES TEST END ----")
