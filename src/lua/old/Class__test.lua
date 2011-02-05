log(DEBUG, "---- CLASS TEST BEGIN ----")

A = class()
function A:__tostring() return "A" end
function A:__init()
    self.xyz = 156
    log(DEBUG, "Initializing A class or class inherited from A without its own constructor.")
end

B = class(A)
function B:__tostring() return "B" end

C = class(B)
function C:__tostring() return "C" end

D = class(C)
function D:__init() log(DEBUG, "D has its own constructor.") end
function D:__tostring() return "D" end

E = class(D)
function E:__init() log(DEBUG, "E has its own constructor.") end
function E:__tostring() return "E" end

F = class(E)
function F:__init() log(DEBUG, "meh") end
function F:__tostring() return "F" end

local a = A()
local b = B()
local c = C()
local d = D()
local e = E()
local f = F()

assert(a.xyz == 156)
assert(b.xyz == 156)
assert(c.xyz == 156)
assert(not d.xyz)

log(DEBUG, string.format("A: %s", tostring(a)))
log(DEBUG, string.format("B: %s", tostring(b)))
log(DEBUG, string.format("C: %s", tostring(c)))
log(DEBUG, string.format("D: %s", tostring(d)))
log(DEBUG, string.format("E: %s", tostring(e)))
log(DEBUG, string.format("F: %s", tostring(f)))

log(DEBUG, string.format("Ep: %s", tostring(f[A])))
log(DEBUG, string.format("Ep: %s", tostring(f[B])))
log(DEBUG, string.format("Ep: %s", tostring(f[C])))
log(DEBUG, string.format("Ep: %s", tostring(f[D])))
log(DEBUG, string.format("Ep: %s", tostring(f[E])))

log(DEBUG, string.format("Epp: %s", tostring(e[A])))
log(DEBUG, string.format("Epp: %s", tostring(e[B])))
log(DEBUG, string.format("Epp: %s", tostring(e[C])))
log(DEBUG, string.format("Epp: %s", tostring(e[D])))

log(DEBUG, string.format("Eppp: %s", tostring(d[A])))
log(DEBUG, string.format("Eppp: %s", tostring(d[B])))
log(DEBUG, string.format("Eppp: %s", tostring(d[C])))

log(DEBUG, string.format("Epppp: %s", tostring(c[A])))
log(DEBUG, string.format("Epppp: %s", tostring(c[B])))

log(DEBUG, string.format("Eppppp: %s", tostring(b[A])))


log(DEBUG, "---- CLASS TEST END ----")
