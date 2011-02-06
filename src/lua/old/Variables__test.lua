log(DEBUG, "---- VARIABLES TEST BEGIN ----")

log(DEBUG, "Testing defineGetter / defineSetter first:")

local _x = class()

function _x:__init()
    self.value = 0
    self:__defineGetter("test", function(self) return self.value end)
    self:__defineSetter("test", function(self, v) self.value = v + 100 end)
end

local x = _x()
assert(x.test)
assert(x.test == 0)
x.test = 150
assert(x.test == 250)
x.test = 0
assert(x.test == 100)

log(DEBUG, "Generic array tests:")

local dummy = StateArray()

assert(dummy:toWire({1}) == "[1]")
assert(dummy:toData({1}) == "[1]")
assert(table.concat(dummy:fromWire("[1|2]")) == "12")
assert(table.concat(dummy:fromData("[1|2]")) == "12")

local x = { "a", "4" }
assert(type(dummy:toWire(x)) == "string")
assert(type(dummy:toData(x)) == "string")
assert(table.concat(dummy:fromWire(dummy:toWire(x))) == "a4")
assert(table.concat(dummy:fromData(dummy:toData(x))) == "a4")

log(DEBUG, "Abstract tests:")

local TestVariable = class(StateVariable)
function TestVariable:toData (x) return x end
function TestVariable:fromData (x) return x + 1 end

local BaseClass = class()
function BaseClass:__init ()
    self.initialized = true
    self.stateVariableValues = {}
    self.stateVariableValueTimestamps = {}
    self.var1 = TestVariable()
    self.var2 = TestVariable()
    self.int1 = StateInteger()
    self.float1 = StateFloat()
    self.bool1 = StateBoolean()
    self.string1 = StateString()
    self.arr1 = StateArray()
    self.arr2 = StateArray()
    self.farr1 = StateArrayFloat()
end

function BaseClass:_getStateDatum (key)
    return self.stateVariableValues[key]
end

function BaseClass:_setStateDatum (key, value, origin)
    self.stateVariableValues[key] = value
end

function BaseClass:canCallCFuncs () return true end

local test = BaseClass()

test.initialized = true

assert(isVariable(test.var1))
assert(isVariable(test.int1))
assert(isVariable(test.float1))
assert(isVariable(test.arr1))

test.var1:_register("var1", test)
test.var2:_register("var2", test)

test.var1 = 175

assert(test.stateVariableValues["var1"] == 175)
assert(test.var1 == 175)

test.var2 = 200

assert(test.stateVariableValues["var2"] == 200)
assert(test.var2 == 200)

assert(test.stateVariableValues["var1"] == 175)
assert(test.var1 == 175)

-- Integer
test.int1:_register("int1", test)
test.int1 = 18
assert(test.stateVariableValues["int1"] == 18)
assert(test.int1 == 18)

-- Float
test.float1:_register("float1", test)
test.float1 = 183.2
assert(test.stateVariableValues["float1"] == 183.2)
assert(test.float1 == 183.2)

-- Boolean
test.bool1:_register("bool1", test)
test.bool1 = true
assert(test.stateVariableValues["bool1"] == true)
assert(test.bool1 == true)
test.bool1 = false
assert(test.stateVariableValues["bool1"] == false)
assert(test.bool1 == false)

-- String
test.string1:_register("string1", test)
test.string1 = "foobar"
assert(test.stateVariableValues["string1"] == "foobar")
assert(test.string1 == "foobar")

-- Array surrogate

log(DEBUG, "Array surrogate:")

local surrFeedback = {}

local entityWithSurr = {
    uniqueId = "harrowe",
    itemBase = 8
}

local variableWithSurr = {
    getLength = function (self, entity)
        return entity.uniqueId
    end,
    getItem = function (self, entity, i)
        return entity.itemBase + i
    end,
    setItem = function (self, entity, i, value)
        entity.itemBase = entity.itemBase + i + value
    end
}

local surr = ArraySurrogate(entityWithSurr, variableWithSurr)

assert(surr.length == "harrowe")
assert(surr:get(1) == 9)
assert(surr:get(2) == 10)
assert(surr:get(5) == 13)
assert(surr:get(11) == 19)

surr:set(13, 50)

assert(surr:get(2) == 73)
assert(surr:get(5) == 76)

log(DEBUG, "Array tests:")

test.arr1:_register("arr1", test)
test.arr1 = {'a', 'bcd'}
assert(test[__SV_PREFIX .. "arr1"]:toData(test.stateVariableValues["arr1"]) == "[a|bcd]")
assert(table.concat(test.stateVariableValues["arr1"]) == "abcd")
assert(table.concat(test.arr1:asArray()) == "abcd")

assert(is_a(test.arr1, ArraySurrogate))

assert(table.concat(test.arr1:asArray()) == "abcd")

test.arr2:_register("arr2", test)
test.arr2 = {'a', 'b', 'cd', 'ë́'}
assert(test[__SV_PREFIX .. "arr2"]:toData(test.stateVariableValues["arr2"]) == "[a|b|cd|ë́]")
assert(table.concat(test.stateVariableValues["arr2"]) == "abcdë́")
assert(table.concat(test.arr2:asArray()) == "abcdë́")
test.arr2:set(3, "firgl")
assert(test[__SV_PREFIX .. "arr2"]:toData(test.stateVariableValues["arr2"]) == "[a|b|firgl|ë́]")
assert(table.concat(test.arr2:asArray()) == "abfirglë́")
test.arr2:push("xor")
assert(test[__SV_PREFIX .. "arr2"]:toData(test.stateVariableValues["arr2"]) == "[a|b|firgl|ë́|xor]")
assert(table.concat(test.arr2:asArray()) == "abfirglë́xor")

assert(test[__SV_PREFIX .. "arr1"]:toData(test.stateVariableValues["arr1"]) == "[a|bcd]") -- Ensure that first array is untouched
assert(table.concat(test.stateVariableValues["arr1"]) == "abcd")
assert(table.concat(test.arr1:asArray()) == "abcd")

log(DEBUG, "ArrayFloat tests:")

test.farr1:_register("farr1", test)
test.farr1 = {1, 7.56}
assert(type(test.farr1:get(1)) == "number")
assert(test[__SV_PREFIX .. "farr1"]:toData(test.stateVariableValues["farr1"]) == "[1|7.56]")
assert(table.concat(test.farr1:asArray()) == "17.56")

-- Subclasses, aliases, etc

log(DEBUG, "Subclass tests:")

local SubClass = class(BaseClass)

function SubClass:__init ()
    self.initialized = true
    self[BaseClass].__user_init(self)
    self.subint = StateInteger()
    self.subintalias = VariableAlias("subint")
    self.int1alias = VariableAlias("int1")
end

local sub = SubClass()

sub.int1:_register("int1", sub)
sub.subint:_register("subint", sub)
sub.subintalias:_register("subintalias", sub)
sub.int1alias:_register("int1alias", sub)

sub.int1 = 443
assert(sub.stateVariableValues["int1"] == 443)
assert(sub.int1 == 443)

sub.subint = 1000
assert(sub.stateVariableValues["subint"] == 1000)
assert(sub.subint == 1000)
assert(sub.subintalias == 1000)
sub.subintalias = 6006
assert(sub.stateVariableValues["subint"] == 6006)
assert(sub.subint == 6006)

assert(sub.int1alias == 443)
sub.int1alias = 556
assert(sub.stateVariableValues["int1"] == 556)
assert(sub.int1 == 556)

-- assure that the subclass doesn't change the parent
assert(test.stateVariableValues["int1"] == 18)
assert(test.int1 == 18)

log(DEBUG, "Wrapping tests:")

local testGetter = function (entity)
    return entity.uniqueId + 1
end

local testGetter2 = function (entity)
    return entity.uniqueId + 2
end

local VALS = {}

local testSetter = function (entity, value)
    VALS[entity.uniqueId] = value + 1
end

local testSetter2 = function (entity, value)
    VALS[entity.uniqueId] = value + 2
end

local testVecGetter = function (entity)
    return {entity.uniqueId + 1, entity.uniqueId + 3, entity.uniqueId + 2}
end

local testVecSetter = function (entity, value)
    log(DEBUG, "testVecSetter: " .. tostring(entity.uniqueId) .. "," .. tostring(value))
    VALS[entity.uniqueId] = value
end

local WrappedClass = class(BaseClass)

function WrappedClass:__init ()
    self.initialized = true
    self[BaseClass].__user_init(self)
    self.wrapint1  = WrappedCInteger({ cGetter = testGetter,     cSetter = testSetter     })
    self.wrapint2  = WrappedCInteger({ cGetter = testGetter2,    cSetter = testSetter2    })
    self.wrapfloat = WrappedCFloat  ({ cGetter = testGetter,     cSetter = testSetter     })
    self.wrapvec3  = WrappedCVector3({ cGetter = testVecGetter,  cSetter = testVecSetter  })
    self.wrapvec3b = WrappedCVector3({ cGetter = testVecGetter,  cSetter = testVecSetter  })
end

local wrap = WrappedClass()
wrap.uniqueId = 1330

Signals.addMethods(wrap)

log(DEBUG, "Wrapped ints")

wrap.int1:_register("int1", wrap)
wrap.int1 = 98
assert(wrap.stateVariableValues["int1"] == 98)
assert(wrap.int1 == 98)

wrap.wrapint1:_register("wrapint1", wrap)
assert(not wrap.stateVariableValues["wrapint1"])
assert(wrap.wrapint1 == 1331)
wrap.wrapint1 = 2112
assert(wrap.stateVariableValues["wrapint1"] == 2112)
assert(wrap.wrapint1 == Global.CLIENT and 2112 or 1331) -- when testing on client, stuff is not yet set

wrap.wrapint2:_register("wrapint2", wrap)
assert(not wrap.stateVariableValues["wrapint2"])
assert(wrap.wrapint2 == 1332)
wrap.wrapint2 = 444
assert(wrap.stateVariableValues["wrapint2"] == 444)
assert(wrap.wrapint2 == Global.CLIENT and 444 or 1332)

log(DEBUG, "Wrapped vecs")

wrap.wrapvec3:_register("wrapvec3", wrap)
assert(table.concat(wrap.wrapvec3:asArray()), "133113331332")
wrap.wrapvec3 = {4,1,6}

log(DEBUG, "Final variables test: " .. wrap[__SV_PREFIX .. "wrapvec3"]:toData(wrap.stateVariableValues["wrapvec3"]))
assert(wrap[__SV_PREFIX .. "wrapvec3"]:toData(wrap.stateVariableValues["wrapvec3"]) == "[4|1|6]")

assert(table.concat(wrap.wrapvec3:asArray()) == Global.CLIENT and "416" or "133113331332")
assert(wrap.wrapvec3.x == Global.CLIENT and 4 or 1331)
assert(wrap.wrapvec3.y == Global.CLIENT and 1 or 1333)
assert(wrap.wrapvec3.z == Global.CLIENT and 6 or 1332)

log(DEBUG, "Vector3 functions in WrappedCVector3/Vector3Surrogate:")

local w = wrap.wrapvec3
assert(w.x == Global.CLIENT and 4 or 1331)
assert(w.y == Global.CLIENT and 1 or 1333)
assert(w.z == Global.CLIENT and 6 or 1332)

w = wrap.wrapvec3:copy()
assert(w.x == Global.CLIENT and 4 or 1331)
assert(w.y == Global.CLIENT and 1 or 1333)
assert(w.z == Global.CLIENT and 6 or 1332)

w.x = 17
assert(w.x == 17)
assert(w.y == Global.CLIENT and 1 or 1333)
assert(w.z == Global.CLIENT and 6 or 1332)

log(DEBUG, "---- VARIABLES TEST END ----")
