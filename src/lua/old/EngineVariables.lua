-------------------------------------------------------------------------------
-- Engine variable system (Lua part). This manages getting/setting of internal
-- variables. There is a C++ representation of this too to minimize stack
-- manipulation, and the two get sync'd together.
-- Remember, the Lua part won't handle persistency (not required)
--
-- Licensed under MIT/X11 (see the COPYING.txt).
--
-- @author q66 (quaker66@gmail.com)
--
-- @copyright 2010 CubeCreate project
-------------------------------------------------------------------------------

-- Variable types

VAR_I = 0
VAR_F = 1
VAR_S = 2

-- Class storing actual vars and managing getters/setters for them + storage table.
_VARS = class()
_VARS.storage = {}

function _VARS:reg(var)
    if not is_a(var, _VAR) then log(ERROR, "Cannot register variable because wrong class was provided.") return nil end
    if self.storage[var.name] then return nil end -- Do not register registered vars, but do not error either
    self.storage[var.name] = var
    self:__defineGetter(var.name, function (self, var) return var.curv end, var)
    self:__defineSetter(var.name .. "_ns", function (self, var, val)
        local oval = var.curv
        var.curv = val
    end, var)
    self:__defineSetter(var.name, function (self, var, val)
        if var:isInReach(val) then
            local oval = var.curv
            var.curv = val
            CAPI.svfl(var.name, var.type, val)
        end
    end, var)
end

function _VARS:r(vtype, name, ...)
    self:reg(_G[vtype](name, ...))
end

function _VARS:clear()
    self.storage = {} -- simple way to clear the storage, doesn't take care of C++ status (that's done separately)
end

EV = _VARS()

_VAR = class()
function _VAR:__init(name, minv, curv, maxv, readonly, alias)
    assert(name, "Cannot register variable: name is missing.")
    self.name = name
    self.minv = minv
    self.maxv = maxv
    self.curv = curv
    self.read = readonly
    self.alias = alias
end

IVAR = class(_VAR)
function IVAR:__tostring() return "IVAR" end
function IVAR:__init(name, minv, curv, maxv, readonly, alias)
    assert(type(minv) == "number" and type(curv) == "number" and type(maxv) == "number", "Wrong value type provided to IVAR.")
    self[_VAR].__user_init(self, name, minv, curv, maxv, readonly, alias)
    self.type = VAR_I
end
function IVAR:isInReach(v)
    if type(v) ~= "number" then
        log(ERROR, "Wrong value type passed to variable.")
        return false
    end
    if self.alias then return true end
    if self.read then
        log(ERROR, "Variable is read only.")
        return false
    end
    if v < self.minv or v > self.maxv then
        log(ERROR, "Variable accepts only values of range " .. self.minv .. " to " .. self.maxv)
        return false
    end
    return true
end

FVAR = class(IVAR)
function FVAR:__tostring() return "FVAR" end
function FVAR:__init(name, minv, curv, maxv, readonly, alias)
    assert(type(minv) == "number" and type(curv) == "number" and type(maxv) == "number", "Wrong value type provided to FVAR.")
    self[_VAR].__user_init(self, name, minv, curv, maxv, readonly, alias)
    self.type = VAR_F
end

SVAR = class(_VAR)
function SVAR:__tostring() return "SVAR" end
function SVAR:__init(name, curv, readonly, alias)
    assert(type(curv) == "string" or not curv, "Wrong value type provided to SVAR.")
    self[_VAR].__user_init(self, name, nil, curv, nil, readonly, alias)
    self.type = VAR_S
end
function SVAR:isInReach(v)
    if type(v) ~= "string" or v then
        log(ERROR, "Wrong value type passed to variable.")
        return false
    end
    if self.alias then return true end
    if self.read then
        log(ERROR, "Variable is read only.")
        return false
    end
    return true
end

function ivar  (name, ...) EV:r("IVAR",   name, ...) end
function fvar  (name, ...) EV:r("FVAR",   name, ...) end
function svar  (name, ...) EV:r("SVAR",   name, ...) end
