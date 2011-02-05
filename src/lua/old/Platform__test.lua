log(DEBUG, "---- PLATFORM TEST BEGIN ----")

assert(type(Global) == "table")
assert(type(Global.initAsClient) == "function")
assert(type(Global.initAsServer) == "function")

assert(not Global.CLIENT)
assert(not Global.SERVER)

Global:initAsClient()
assert(Global.CLIENT)
assert(not Global.SERVER)

Global:initAsServer()
assert(not Global.CLIENT)
assert(Global.SERVER)

Global.CLIENT = false
Global.SERVER = false

log(DEBUG, "---- PLATFORM TEST END ----")
