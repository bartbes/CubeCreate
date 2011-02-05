BUTTON_LEFT = 1
BUTTON_MIDDLE = 2
BUTTON_RIGHT = 3

RepeatingTimer = class()

function RepeatingTimer:__init (interval, carryover)
    self.interval = interval
    self.carryover = defaultValue(carryover, false)
    self.sum = 0
end

function RepeatingTimer:tick (seconds)
    self.sum = self.sum + seconds
    if self.sum >= self.interval then
        if not self.carryover then
            self.sum = 0
        else
            self.sum = self.sum - self.interval
        end

        return true
    else
        return false
    end
end

function RepeatingTimer:prime ()
    self.sum = self.interval
end

-------------------------------

function math.clamp (v, l, h)
    return math.max(l, math.min(v, h))
end

-------------------------------

Vector3 = class()

function Vector3:__tostring ()
    return "Vector3"
end

function Vector3:__itemConditional(key)
    if key == "x" or key == "y" or key == "z" or key == "length" then
        return true
    else
        return false
    end
end

function Vector3:__init (x, y, z)
    if type(x) == "table" and tostring(x) == "Vector3" then
        self.x = tonumber(x.x)
        self.y = tonumber(x.y)
        self.z = tonumber(x.z)
    elseif type(x) == "table" and #x == 3 then
        self.x = tonumber(x[1])
        self.y = tonumber(x[2])
        self.z = tonumber(x[3])
    else
        x = defaultValue(x, 0)
        y = defaultValue(y, 0)
        z = defaultValue(z, 0)
        self.x = tonumber(x)
        self.y = tonumber(y)
        self.z = tonumber(z)
    end
    self.length = 3
end

function Vector3:magnitude ()
    return math.sqrt(self.x*self.x +
                     self.y*self.y +
                     self.z*self.z)
end

function Vector3:normalize ()
    local mag = self:magnitude()
    if mag ~= 0 then
        self:mul(1 / mag)
    else
        log(ERROR, "Can't normalize Vector3 of null length.")
    end
    return self
end

function Vector3:cap (size)
    local mag = self:magnitude()
    if mag > size then self:mul(size / mag) end
    return self
end

function Vector3:subNew (other)
    return Vector3(self.x - other.x,
                   self.y - other.y,
                   self.z - other.z)
end

function Vector3:addNew (other)
    return Vector3(self.x + other.x,
                   self.y + other.y,
                   self.z + other.z)
end

function Vector3:mulNew (other)
    return Vector3(self.x * other,
                   self.y * other,
                   self.z * other)
end

function Vector3:sub (other)
    self.x = self.x - other.x
    self.y = self.y - other.y
    self.z = self.z - other.z
    return self
end

function Vector3:add (other)
    self.x = self.x + other.x
    self.y = self.y + other.y
    self.z = self.z + other.z
    return self
end

function Vector3:mul (other)
    self.x = self.x * other
    self.y = self.y * other
    self.z = self.z * other
    return self
end

function Vector3:copy ()
    return Vector3(self.x, self.y, self.z)
end

function Vector3:asArray ()
    return { self.x, self.y, self.z }
end

function Vector3:fromYawPitch (yaw, pitch)
    self.x = -math.sin(math.RAD * yaw)
    self.y = math.cos(math.RAD * yaw)

    if pitch ~= 0 then
        self.x = self.x * math.cos(math.RAD * pitch)
        self.y = self.y * math.cos(math.RAD * pitch)
        self.z = math.sin(math.RAD * pitch)
    else
        self.z = 0
    end

    return self
end

function Vector3:toYawPitch ()
    local size = self:magnitude()
    if size < 0.001 then
        return { yaw = 0, pitch = 0 }
    end
    return {
        yaw = -math.atan2(self.x, self.y) / math.RAD,
        pitch = math.asin(self.z / size) / math.RAD
    }
end

function Vector3:isCloseTo (other, dist)
    dist = dist * dist
    local temp, sum

    -- note order: we expect z to be less important, as most maps are 'flat'
    temp = self.x - other.x
    sum = temp * temp
    if sum > dist then return false end

    temp = self.y - other.y
    sum = sum + temp * temp
    if sum > dist then return false end

    temp = self.z - other.z
    sum = sum + temp * temp
    return (sum <= dist)
end

function Vector3:toString ()
    return "<" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. ">"
end

function Vector3:scalarProduct (other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end

function Vector3:cosineAngleWith (other)
    return self:scalarProduct(other) / (self:magnitude() * other:magnitude())
end

Vector3.zero = Vector3(0, 0, 0)

-------------------------------

Vector4 = class(Vector3)

function Vector4:__tostring ()
    return "Vector4"
end

function Vector4:__itemConditional(key)
    if key == "x" or key == "y" or key == "z" or key == "w" or key == "length" then
        return true
    else
        return false
    end
end

function Vector4:__init (x, y, z, w)
    if type(x) == "table" and tostring(x) == "Vector4" then
        self.x = tonumber(x.x)
        self.y = tonumber(x.y)
        self.z = tonumber(x.z)
        self.w = tonumber(x.w)
    elseif type(x) == "table" and #x == 4 then
        self.x = tonumber(x[1])
        self.y = tonumber(x[2])
        self.z = tonumber(x[3])
        self.w = tonumber(x[4])
    else
        x = defaultValue(x, 0)
        y = defaultValue(y, 0)
        z = defaultValue(z, 0)
        w = defaultValue(w, 0)
        self.x = tonumber(x)
        self.y = tonumber(y)
        self.z = tonumber(z)
        self.w = tonumber(w)
    end
    self.length = 4
end

function Vector4:toString ()
    return "<" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. "," .. tostring(self.w) .. ">"
end

function Vector4:asArray ()
    return { self.x, self.y, self.z, self.w }
end

function Vector4:quatFromAxisAngle (axis, angle)
    angle = angle * math.RAD
    self.w = math.cos(angle / 2)
    local s = math.sin(angle / 2)
    self.x = s * axis.x
    self.y = s * axis.y
    self.z = s * axis.z
    return self
end

-- TODO: test and fix possible bugs
function Vector4:toYawPitchRoll ()
    --local ret = self:toYawPitch()
    --ret.roll = 0
    --return ret

    if math.abs(self.z) < 0.99 then
        local ret = self:toYawPitch()
        ret.roll = self.w / math.RAD
        return ret
    else
        return {
            yaw = self.w / math.RAD * (self.z < 0 and 1 or -1),
            pitch = self.z > 0 and -90 or 90,
            roll = 0
        }
    end
end

function Vector4:subNew (other)
    return Vector4(self.x - other.x,
                   self.y - other.y,
                   self.z - other.z,
                   self.w - other.w)
end

function Vector4:addNew (other)
    return Vector4(self.x + other.x,
                   self.y + other.y,
                   self.z + other.z,
                   self.w + other.w)
end

function Vector4:mulNew (other)
    return Vector4(self.x * other,
                   self.y * other,
                   self.z * other,
                   self.w * other)
end

function Vector4:sub (other)
    self.x = self.x - other.x
    self.y = self.y - other.y
    self.z = self.z - other.z
    self.w = self.w - other.w
    return self
end

function Vector4:add (other)
    self.x = self.x + other.x
    self.y = self.y + other.y
    self.z = self.z + other.z
    self.w = self.w + other.w
    return self
end

function Vector4:mul (other)
    self.x = self.x * other
    self.y = self.y * other
    self.z = self.z * other
    self.w = self.w * other
    return self
end

function Vector4:copy ()
    return Vector4(self.x, self.y, self.z, self.w)
end

function Vector4:magnitude ()
    return math.sqrt(self.x*self.x +
                     self.y*self.y +
                     self.z*self.z +
                     self.w*self.w)
end

Vector4.zero = Vector4(0, 0, 0, 0)


-------------------------------

function tovec3 (x)
    if tostring(x) == "Vector3" then
        return x
    end

    return Vector3(x[1], x[2], x[3])
end

function tovec4 (x)
    if tostring(x) == "Vector4" then
        return x
    end

    return Vector4(x[1], x[2], x[3], x[4])
end

-------------------------------

function sign (x)
    if x < 0 then
        return -1
    elseif x > 0 then
        return 1
    else
        return 0
    end
end

function distance (a, b)
    return math.sqrt(math.pow(a.x - b.x, 2) +
                     math.pow(a.y - b.y, 2) +
                     math.pow(a.z - b.z, 2))
end

function normalizeAngle (angle, relativeTo)
    while angle < (relativeTo - 180.0) do
        angle = angle + 360.0
    end
    while angle > (relativeTo + 180.0) do
        angle = angle - 360.0
    end
    return angle
end

function angleDirectionChange (angle, other)
    angle = normalizeAngle(angle, other)
    return sign(angle - other)
end

function yawTo (origin, target, _reverse)
    _reverse = defaultValue(_reverse, false)
    if not _reverse then
        return (-(math.atan2(target.x - origin.x, target.y - origin.y)) / math.RAD)
    else
        return yawTo (target, origin)
    end
end

function pitchTo (origin, target, _reverse)
    _reverse = defaultValue(_reverse, false)
    if not _reverse then
        local radians = math.asin((target.z - origin.z) / distance(origin, target))
        return 360.0 * radians / (2.0 * math.pi)
    else
        return pitchTo (target, origin)
    end
end

function compareYaw (origin, target, currentYaw, acceptableError)
    local targetYaw = yawTo(origin, target)
    targetYaw = normalizeAngle(targetYaw, currentYaw)
    return (math.abs(targetYaw - currentYaw) <= acceptableError)
end

function comparePitch (origin, target, currentPitch, acceptableError)
    local targetPitch = pitchTo(origin, target)
    targetPitch = normalizeAngle(targetPitch, currentPitch)
    return (math.abs(targetPitch - currentPitch) <= acceptableError)
end

function hasLineOfSight (a, b)
    return CAPI.rayLos(a.x, a.y, a.z,
                       b.x, b.y, b.z)
end

function rayCollisionDistance (origin, ray)
    local rayMag = ray:magnitude()
    return CAPI.rayPos(origin.x,
                       origin.y,
                       origin.z,
                       ray.x / rayMag,
                       ray.y / rayMag,
                       ray.z / rayMag)
end


function floorDistance (origin, distance)
    return CAPI.rayFloor(origin.x, origin.y, origin.z, distance)
end

function highestFloorDistance (origin, distance, radius)
    local ret = floorDistance(origin, distance)

    local tbl = { -(radius) / 2, 0, radius / 2 }
    for x = 1, #tbl do
        for y = 1, #tbl do
            ret = math.min(ret, floorDistance(origin + Vector3(tbl[x], tbl[y], 0), distance))
        end
    end

    return ret
end

function lowestFloorDistance (origin, distance, radius)
    local ret = floorDistance(origin, distance)

    local tbl = { -(radius) / 2, 0, radius / 2 }
    for x = 1, #tbl do
        for y = 1, #tbl do
            ret = math.max(ret, floorDistance(origin + Vector3(tbl[x], tbl[y], 0), distance))
        end
    end

    return ret
end
