log(DEBUG, "---- SIGNALS TEST BEGIN ----")

local test = {}
Signals.addMethods(test)
assert(type(test.emit) == "function")

log(DEBUG, "Running a callback:")

local test2 = {}
Signals.addMethods(test2)

local xy = 0
local fc = function (self, v)
    log(DEBUG, string.format("Printing value from callback: %f", v))
    xy = v*2
end

test2:connect("meh", fc)
test2:emit("meh", 3.14)
assert(xy == 6.28)
test2:emit("meh", 156)
assert(xy == 312)

log(DEBUG, "---- SIGNALS TEST END ----")
