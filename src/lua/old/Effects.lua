-- Particle system exports for Lua

-- substitutes for enumeration

-- decals, in sync with iengine.h
DECAL = {
    SCORCH = 0,
    BLOOD = 1,
    BULLET = 2,
    DECAL = 3,
    CIRCLE = 4
}

-- particles, in sync with iengine.h
PARTICLE = {
    BLOOD = 0,
    WATER = 1,
    SMOKE = 2,
    SOFTSMOKE = 3,
    STEAM = 4,
    FLAME = 5,
    FIREBALL1 = 6,
    FIREBALL2 = 7,
    FIREBALL3 = 8,
    STREAK = 9,
    LIGHTNING = 10,
    EXPLOSION = 11,
    EXPLOSION_NO_GLARE = 12,
    SPARK = 13,
    EDIT = 14,
    MUZZLE_FLASH1 = 15,
    MUZZLE_FLASH2 = 16,
    MUZZLE_FLASH3 = 17,
    MUZZLE_FLASH4A = 18,
    MUZZLE_FLASH4B = 19,
    MUZZLE_FLASH5 = 20,
    TEXT = 21,
    METER = 22,
    METER_VS = 23,
    LENS_FLARE = 24,
    FLAME1 = 25,
    FLAME2 = 26,
    FLAME3 = 27,
    FLAME4 = 28,
    SNOW = 29,
    RAIN = 30,
    BULLET = 31,
    GLOW = 32,
    GLOW_TRACK = 33,
    LIGHTFLARE = 34,
    BUBBLE = 35,
    EXPLODE = 36,
    SMOKETRAIL = 37
}

BOUNCER = {
    GRENADE = 0,
    GIBS = 1,
    DEBRIS = 2,
    BARRELDEBRIS = 3
}


Effect = {
    addDecal = function (_type, position, direction, radius, color, info)
        color = defaultValue(color, 0xFFFFFF)
        info = defaultValue(info, 0)
        local rgb = Color.hexToRgb(color)

        CAPI.addDecal(_type, position.x, position.y, position.z, direction.x, direction.y, direction.z, radius, rgb.r, rgb.g, rgb.b, info)
    end,

    addDynamicLight = function (position, radius, color, fade, peak, flags, initradius, initcolor)
        fade = defaultValue(fade, 0)
        peak = defaultValue(peak, 0)
        flags = defaultValue(flags, 0)
        initradius = defaultValue(initradius, 0)
        initcolor = defaultValue(initcolor, 0xFFFFFF)
        local rgbColor = Color.hexToRgb(color)
        local rgbInitcolor = Color.hexToRgb(initcolor)
        CAPI.addDynlight(position.x, position.y, position.z, radius, rgbColor.r, rgbColor.g, rgbColor.b, fade * 1000, peak * 1000, flags, initradius, rgbInitcolor.r, rgbInitcolor.g, rgbInitcolor.b)
    end,

    splash = function (_type, num, fade, position, color, size, radius, gravity, regfade, flag, fastsplash, grow)
        if Global.CLIENT then
            color = defaultValue(color, 0xFFFFFF)
            size = defaultValue(size, 1.0)
            radius = defaultValue(radius, 150)
            gravity = defaultValue(gravity, 2)
            regfade = defaultValue(regfade, false)
            flag = defaultValue(flag, 0)
            fastsplash = defaultValue(fastsplash, false)
            grow = defaultValue(grow, 0)
            CAPI.particleSplash(_type, num, fade * 1000, position.x, position.y, position.z, color, size, radius, gravity, regfade, flag, fastsplash, grow)
        else
            -- On server, send message to clients
            MessageSystem.send(MessageSystem.ALL_CLIENTS, CAPI.ParticleSplashToClients, _type, num, fade * 1000, position.x, position.y, position.z) -- TODO = last 4 parameters
        end
    end,

    splashRegular = function (_type, num, fade, position, color, size, radius, gravity, delay, hover, grow)
        if Global.CLIENT then
            color = defaultValue(color, 0xFFFFFF)
            size = defaultValue(size, 1.0)
            radius = defaultValue(radius, 150)
            gravity = defaultValue(gravity, 2)
            delay = defaultValue(delay, 0)
            hover = defaultValue(hover, false)
            grow = defaultValue(grow, 0)
            CAPI.particleSplashRegular(_type, num, fade * 1000, position.x, position.y, position.z, color, size, radius, gravity, delay)
        else
            -- On server, send message to clients
            MessageSystem.send(MessageSystem.ALL_CLIENTS, CAPI.ParticleSplashRegularToClients, _type, num, fade * 1000, position.x, position.y, position.z) -- TODO = last 5 parameters
        end
    end,

    explodeSplash = function (_type, position, fade, color, size, gravity, _num)
        if fade ~= nil then
            fade = fade * 1000
        else
            fade = -1
        end
        color = defaultValue(color, 0xFFFFFF)
        size = defaultValue(size, 1)
        gravity = defaultValue(gravity, -20)
        _num = defaultValue(_num, 16)

        CAPI.particleFireball(position.x, position.y, position.z, fade, _type, color, size, gravity, _num)
    end,

    fireball = function (_type, position, _max, fade, color, size)
        if fade ~= nil then
            fade = fade * 1000
        else
            fade = -1
        end
        color = defaultValue(color, 0xFFFFFF)
        size = defaultValue(size, 4.0)

        CAPI.particleFireball(position.x, position.y, position.z, _max, _type, fade, color, size)
    end,

    flare = function (_type, endp, start, fade, color, size, grow, owner)
        if fade == nil then
            fade = 0
        else
            fade = fade * 1000
        end
        color = defaultValue(color, 0xFFFFFF)
        size = defaultValue(size, 0.28)
        grow = defaultValue(grow, 0)
        if owner == nil then
            local ownerid = -1
        else
            local ownerid = owner.uniqueId
        end
        CAPI.particleFlare(start.x, start.y, start.z, endp.x, endp.y, endp.z, fade, _type, color, size, grow, ownerid)
    end,

    flyingFlare = function (_type, endp, start, fade, color, size, gravity)
        if fade == nil then
            fade = 0
        else
            fade = fade * 1000
        end
        gravity = defaultValue(gravity, 0)
        CAPI.particleFlyingFlare(start.x, start.y, start.z, endp.x, endp.y, endp.z, fade, _type, color, size, gravity)
    end,

    trail = function (_type, fade, from, to, color, size, gravity, bubbles)
        color = defaultValue(color, 0xFFFFFF)
        size = defaultValue(size, 1.0)
        gravity = defaultValue(gravity, 20)
        bubbles = defaultValue(bubbles, false)
        CAPI.particleTrail(_type, fade * 1000, from.x, from.y, from.z, to.x, to.y, to.z, color, size, gravity, bubbles)
    end,

    flame = function(_type, position, radius, height, color, density, scale, speed, fade, gravity)
        density = defaultValue(density, 3)
        scale = defaultValue(scale, 2.0)
        speed = defaultValue(speed, 200.0)
        if fade == nil then
            fade = 600.0
        else
            fade = fade * 1000
        end
        gravity = defaultValue(gravity, -15)

        CAPI.particleFlame(_type, position.x, position.y, position.z, radius, height, color, density, scale, speed, fade, gravity)
    end,

    lightning = function (start, endp, fade, color, size)
        Effect.flare(PARTICLE.LIGHTNING, start, endp, fade, color, size)
    end,

    text = function(position, text, fade, color, size, gravity)
        fade = defaultValue(fade, 2.0)
        color = defaultValue(color, 0xFFFFFF)
        size = defaultValue(size, 2.0)
        gravity = defaultValue(gravity, 0)
        CAPI.particleText(position.x, position.y, position.z, text, PARTICLE.TEXT, integer(fade*1000), color, size, gravity)
    end,

    clientDamage = function(roll, color)
        if not Global.SERVER then
            CAPI.clientDamageEffect(roll, color)
        end
    end
}

