log(DEBUG, "---- CHARACTER TEST BEGIN ----")

Testing.replaceEnvironment()

assert(getEntityClass("Character") == Character)
assert(getEntitySauerType("Character") == "dynent")
assert(getEntityClass("Player") == Player)
assert(getEntitySauerType("Player") == "dynent")

if Global.SERVER then
    local test = Character()
    assert(test._sauerType == "fpsent")
    test:init(1112)
    assert(test.uniqueId == 1112)
    assert(not test:canCallCFuncs())
    local count = 0
    for i = 1, #table.keys(test._queuedStateVariableChanges) do count = count + 1 end
    assert(count > 0)

    test:activate({ clientNumber = 67 })
    assert(test:canCallCFuncs())
    assert(test.clientNumber == 67)

    test.facingSpeed = 80
    assert(test.facingSpeed == 80)
    test.movementSpeed = 81
    assert(test.movementSpeed == 81)
    test.yaw = 82
    assert(test.yaw == 82)
    test.pitch = 83
    assert(test.pitch == 83)
    assert(not CAPI.feedback["setMove"])
    test.move = 84
    assert(test.move == 84)
    assert(CAPI.feedback["setMove"] == 1112)
    test.strafe = 85
    assert(test.strafe == 85)
    test.position = { 8, 9, 11 }
    assert(test.position:asArray()[1] == 8)
    assert(test.position:asArray()[2] == 9)
    assert(test.position:asArray()[3] == 11)
    test.velocity = { 1, 7, 55 }
    assert(test.velocity:asArray()[1] == 1)
    assert(test.velocity:asArray()[2] == 7)
    assert(test.velocity:asArray()[3] == 55)
    test.radius = 87
    assert(test.radius == 87)
    test.aboveEye = 88
    assert(test.aboveEye == 88)
    test.eyeHeight = 89
    assert(test.eyeHeight == 89)
    test.blocked = true
    assert(test.blocked)
    assert(not CAPI.feedback["setJumping"])
    test:jump()
    assert(CAPI.feedback["setJumping"] == 1112)
    removeEntity(1112)
else
    -- TODO: do client tests
end

Testing.restoreEnvironment()

log(DEBUG, "---- CHARACTER TEST END ----")
