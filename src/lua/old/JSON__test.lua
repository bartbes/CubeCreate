log(DEBUG, "---- JSON TEST BEGIN ----")

JSON.register(function (val) return (type(val) == "table" and val.uniqueId ~= nil) end, function (val) return val.uniqueId end)

local arr = { 1, 2, 3, "blah", xyz = 15, false, true, { 5, 10, 15, 20 } }

local encoded = JSON.encode(arr)
log(DEBUG, encoded)
assert(type(encoded) == "string")
assert(type(JSON.decode(encoded)["xyz"]) == "number")
assert(type(JSON.decode(encoded)["4"]) == "string")
assert(JSON.decode(encoded)["xyz"] == arr["xyz"])

arr = { 5, 10, 15, 20, 25, 30, 31 }
encoded = JSON.encode(arr)
log(DEBUG, encoded)
assert(type(encoded) == "string")
assert(type(JSON.decode(encoded)[0]) == "nil")
assert(type(JSON.decode(encoded)[1]) == "number")
assert(type(JSON.decode(encoded)[2]) == "number")
assert(type(JSON.decode(encoded)[3]) == "number")
assert(type(JSON.decode(encoded)[4]) == "number")
assert(type(JSON.decode(encoded)[5]) == "number")
assert(type(JSON.decode(encoded)[6]) == "number")
assert(type(JSON.decode(encoded)[7]) == "number")
assert(JSON.decode(encoded)[7] == 31)

log(DEBUG, "Testing JSON.register")
arr = { x = 5, y = 10, z = { uniqueId = 156, xy = 14 } }
encoded = JSON.encode(arr)
log(DEBUG, encoded)
assert(type(encoded) == "string")
assert(JSON.decode(encoded).x == 5)
assert(JSON.decode(encoded).y == 10)
assert(JSON.decode(encoded).z == 156)

log(DEBUG, "---- JSON TEST END ----")
