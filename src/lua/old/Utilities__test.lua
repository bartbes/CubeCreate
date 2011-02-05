log(DEBUG, "---- UTILITIES TEST BEGIN ----")

log(DEBUG, "Testing vector3")

local v = Vector3(1, 5, 3)
assert(v.x == 1 and v.y == 5 and v.z == 3)

log(DEBUG, "Testing vector4")

v = Vector4(1, 5, 3, 6)
assert(v.x == 1 and v.y == 5 and v.z == 3 and v.w == 6)

log(DEBUG, "Testing tovec3")
v = tovec3({ 5, 10, 15 })
assert(v.x == 5 and v.y == 10 and v.z == 15)

log(DEBUG, "Testing tovec4")
v = tovec4({ 5, 10, 15, 20 })
assert(v.x == 5 and v.y == 10 and v.z == 15 and v.w == 20)

log(DEBUG, "Testing sign")
assert(sign(-0.1) == -1)
assert(sign(0.2) == 1)
assert(sign(0) == 0)

log(DEBUG, "Testing angle normalization")
assert(normalizeAngle(370, 180) == 10)

log(DEBUG, "---- UTILITIES TEST END ----")
