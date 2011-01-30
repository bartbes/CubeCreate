CLIENTSTATE = {
	ALIVE = 0,
	DEAD = 1,
	SPAWNING = 2,
	LAGGED = 3,
	EDITING = 4,
	SPECTATOR = 5
}

PHYSICALSTATE = {
	FLOAT = 0,
	FALL = 1,
	SLIDE = 2,
	SLOPE = 3,
	FLOOR = 4,
	STEP_UP = 5,
	STEP_DOWN = 6,
	BOUNCE = 7
}

Character = class(AnimatableLogicEntity)

function Character:__tostring ()
	return "Character"
end

Character._sauerType = "fpsent"

function Character:__init ()
	self[AnimatableLogicEntity].__user_init(self)
	self._name = StateString()
	self.facingSpeed = StateInteger()
	self.movementSpeed = WrappedCFloat({ cGetter = "CAPI.getMaxSpeed", cSetter = "CAPI.setMaxSpeed" })
	self.yaw = WrappedCFloat({ cGetter = "CAPI.getYaw", cSetter = "CAPI.setYaw", customSynch = true })
	self.pitch = WrappedCFloat({ cGetter = "CAPI.getPitch", cSetter = "CAPI.setPitch", customSynch = true })

	self.move = WrappedCInteger({ cGetter = "CAPI.getMove", cSetter = "CAPI.setMove", customSynch = true })
	self.strafe = WrappedCInteger({ cGetter = "CAPI.getStrafe", cSetter = "CAPI.setStrafe", customSynch = true })
	self.yawing = WrappedCInteger({ cGetter = "CAPI.getYawing", cSetter = "CAPI.setYawing", customSynch = true })
	self.pitching = WrappedCInteger({ cGetter = "CAPI.getPitching", cSetter = "CAPI.setPitching", customSynch = true })

	self.position = WrappedCVector3({ cGetter = "CAPI.getDynent0", cSetter = "CAPI.setDynent0", customSynch = true })
	self.velocity = WrappedCVector3({ cGetter = "CAPI.getDynentVel", cSetter = "CAPI.setDynentVel", customSynch = true })
	self.falling = WrappedCVector3({ cGetter = "CAPI.getDynentFalling", cSetter = "CAPI.setDynentFalling", customSynch = true })

	self.radius = WrappedCFloat({ cGetter = "CAPI.getRadius", cSetter = "CAPI.setRadius" })
	self.aboveEye = WrappedCFloat({ cGetter = "CAPI.getAboveeye", cSetter = "CAPI.setAboveeye" })
	self.eyeHeight = WrappedCFloat({ cGetter = "CAPI.getEyeHeight", cSetter = "CAPI.setEyeHeight" })

	self.blocked = WrappedCBoolean({ cGetter = "CAPI.getBlocked", cSetter = "CAPI.setBlocked" })
	self.canMove = WrappedCBoolean({ cSetter = "CAPI.setCanMove", clientSet = true })

	self.mapDefinedPositionData = WrappedCInteger({ cGetter = "CAPI.getMapDefinedPositionData", cSetter = "CAPI.setMapDefinedPositionData", customSynch = true })
	self.clientState = WrappedCInteger({ cGetter = "CAPI.getClientState", cSetter = "CAPI.setClientState", customSynch = true })
	self.physicalState = WrappedCInteger({ cGetter = "CAPI.getPhysicalState", cSetter = "CAPI.setPhysicalState", customSynch = true })
	self.inWater = WrappedCInteger({ cGetter = "CAPI.getInWater", cSetter = "CAPI.setInWater", customSynch = true })
	self.timeInAir = WrappedCInteger({ cGetter = "CAPI.getTimeInAir", cSetter = "CAPI.setTimeInAir", customSynch = true })
end

function Character:jump ()
	CAPI.setJumping(self, true)
end

function Character:init (uniqueId, kwargs)
	log(DEBUG, "Character.init")

	self[AnimatableLogicEntity].init(self, uniqueId, kwargs)

	self._name = "-?-"

	self.clientNumber = kwargs and (kwargs.clientNumber and kwargs.clientNumber or -1) or -1

	self.modelName = "stromar"
	self.eyeHeight = 14
	self.aboveEye = 1
	self.movementSpeed = 50
	self.facingSpeed = 120
	self.position = { 512, 512, 550 }
	self.radius = 3.0
	self.canMove = true
end

function Character:activate (kwargs)
	log(DEBUG, "Character.activate")

	self.clientNumber = kwargs and (kwargs.clientNumber and kwargs.clientNumber or -1) or -1
	assert(self.clientNumber >= 0)

	CAPI.setupCharacter(self)

	self[AnimatableLogicEntity].activate(self, kwargs)

	self:_flushQueuedStateVariableChanges()

	log(DEBUG, "Character.activate complete")
end

function Character:clientActivate (kwargs)
	self[AnimatableLogicEntity].clientActivate(self, kwargs)

	self.clientNumber = kwargs and (kwargs.clientNumber and kwargs.clientNumber or -1) or -1

	CAPI.setupCharacter(self)

	self.renderingArgsTimestamp = -1
end

function Character:deactivate ()
	CAPI.dismantleCharacter(self)
	self[AnimatableLogicEntity].deactivate(self)
end

function Character:clientDeactivate ()
	CAPI.dismantleCharacter(self)
	self[AnimatableLogicEntity].clientDeactivate(self)
end

function Character:act (seconds)
	if self.actionSystem:isEmpty() then
		self:defaultAction(seconds)
	else
		self[AnimatableLogicEntity].act(self, seconds)
	end
end

function Character:defaultAction (seconds)
end

function Character:renderDynamic (HUDPass, needHUD)
	if not self.initialized then
		return nil
	end

	if not HUDPass and needHUD then
		return nil
	end

	if self.renderingArgsTimestamp ~= currTimestamp then
		local state = self.clientState
		if state == CLIENTSTATE.SPECTATOR or state == CLIENTSTATE.SPAWNING then
			return nil
		end

		local mdlname = self.modelName
		if HUDPass and needHUD then
			mdlname = self.HUDModelName
		end
		local yaw = self.yaw + 90
		local pitch = self.pitch
		local o = self.position:copy()
		if HUDPass and needHUD and self.HUDModelOffset then o:add(self.HUDModelOffset) end
		local basetime = self.startTime
		local physstate = self.physicalState
		local inwater = self.inWater
		local move = self.move
		local strafe = self.strafe
		local vel = self.velocity:copy()
		local falling = self.falling:copy()
		local timeinair = self.timeInAir
		local anim = self:decideAnimation(state, physstate, move, strafe, vel, falling, inwater, timeinair)
		local flags = self:getRenderingFlags()

		self.renderingArgs = self:createRenderingArgs(mdlname, anim, o, yaw, pitch, flags, basetime)
		self.renderingArgsTimestamp = currTimestamp
	end
	self:getRenderModelFunc()(unpack(self.renderingArgs))
end

function Character:getRenderModelFunc ()
	return CAPI.renderModel2
end

function Character:createRenderingArgs (mdlname, anim, o, yaw, pitch, flags, basetime)
	return {self, mdlname, anim, o.x, o.y, o.z, yaw, pitch, flags, basetime}
end

function Character:getRenderingFlags ()
	local flags = math.bor(MODEL.LIGHT, MODEL.DYNSHADOW)
	if self ~= getPlayerEntity() then
		flags = math.bor(flags, MODEL.CULL_VFC, MODEL.CULL_OCCLUDED, MODEL.CULL_QUERY)
	end
	return flags
end

function Character:decideAnimation (state, physstate, move, strafe, vel, falling, inwater, timeinair)
	local anim = self:decideActionAnimation()

	if state == CLIENTSTATE.EDITING or state == CLIENTSTATE.SPECTATOR then
		anim = math.bor(ANIM_EDIT, ANIM_LOOP)
	elseif state == CLIENTSTATE.LAGGED then
		anim = math.bor(ANIM_LAG, ANIM_LOOP)
	else
		if inwater and physstate <= PHYSICALSTATE.FALL then
			anim = math.bor(anim, math.lsh(math.bor(((move or strafe) or (vel.z + falling.z) > 0) and ANIM_SWIM or ANIM_SINK, ANIM_LOOP), ANIM_SECONDARY))
		elseif timeinair > 250 then
			anim = math.bor(anim, math.lsh(math.bor(ANIM_JUMP, ANIM_END), ANIM_SECONDARY))
		elseif move or strafe then
			if move > 0 then
				anim = math.bor(anim, math.lsh(math.bor(ANIM_FORWARD, ANIM_LOOP), ANIM_SECONDARY))
			elseif strafe then
				anim = math.bor(anim, math.lsh(math.bor(strafe > 0 and ANIM_LEFT or ANIM_RIGHT, ANIM_LOOP), ANIM_SECONDARY))
			elseif move < 0 then
				anim = math.bor(anim, math.lsh(math.bor(ANIM_BACKWARD, ANIM_LOOP), ANIM_SECONDARY))
			end
		end

		if math.band(anim, ANIM_INDEX) == ANIM_IDLE and math.band(math.rsh(anim, ANIM_SECONDARY), ANIM_INDEX) then
			anim = math.rsh(anim, ANIM_SECONDARY)
		end
	end

	if not math.band(math.rsh(anim, ANIM_SECONDARY), ANIM_INDEX) then
		anim = math.bor(anim, math.lsh(math.bor(ANIM_IDLE, ANIM_LOOP), ANIM_SECONDARY))
	end

	return anim
end

function Character:decideActionAnimation ()
	return self.animation
end

function Character:getCenter ()
	local ret = self.position:copy()
	ret.z = ret.z + (self.eyeHeight * 0.75)
	return ret
end

function Character:getTargetingOrigin (origin)
	return origin
end

function Character:isOnFloor ()
	if floorDistance(self.position, 1024) < 1 then return true end
	if self.velocity.z < -1 or self.falling.z < -1 then return false end
	return World.isColliding(self.position, self.radius + 2, self)
end

------------------------------------------------

Player = class(Character)

function Player:__tostring ()
	return "Player"
end

function Player:__init ()
	self[Character].__user_init(self)
	self._canEdit = StateBoolean()
	self.HUDModelName = StateString()
end

function Player:init (uniqueId, kwargs)
	log(DEBUG, "Player.init")
	self[Character].init(self, uniqueId, kwargs)

	self._canEdit = false
	self.HUDModelName = ""
end

function Player:clientActivate (kwargs)
	self[Character].clientActivate (self, kwargs)
end

------------------------------------------------

registerEntityClass(Character, "dynent")
registerEntityClass(Player, "dynent")

------------------------------------------------

Character.plugins = {
	effectiveCameraHeight = {
		effectiveCameraHeight = StateFloat({ reliable = false }),

		clientActivate = function (self)
			self.effectiveCameraHeightTimer = RepeatingTimer(1.0)
			self.effectiveCameraHeightTimer:prime()
			self.effectiveCameraHeightSent = false
		end,

		clientAct = function (self, seconds)
			if self == getPlayerEntity() and self.effectiveCameraHeightTimer:tick(seconds) and not isPlayerEditing(self) then
				if math.abs(math.cos(self.pitch * math.RAD)) < 0.05 then return nil end

				local target = CAPI.getTargetPosition()
				local xyDist = 0
				local tempDist

				tempDist = self.position.x - target.x
				xyDist = xyDist + tempDist * tempDist
				tempDist = self.position.y - target.y
				xyDist = xyDist + tempDist * tempDist
				xyDist = math.sqrt(xyDist)

				local upperHeight = math.tan(-(self.pitch) * math.RAD) * xyDist
				local effectiveCameraHeight = upperHeight + target.z - self.position.z

				if not self.effectiveCameraHeightSent or math.abs(effectiveCameraHeight - self.effectiveCameraHeight) >= 1 then
					self.effectiveCameraHeight = effectiveCameraHeight
					self.effectiveCameraHeightSent = true
				end
			end
		end,

		getTargetingOrigin = function (self, fallback)
			if not self.effectiveCameraHeight then
				return fallback
			else
				return self.position:addNew(Vector3(0, 0, self.effectiveCameraHeight))
			end
		end
	},

	jumpWhilePressingSpace = {
		performJump = function (down)
			local player = getPlayerEntity()
			local water = (World.getMaterial(player.position) == MATERIAL.WATER)
			getPlayerEntity().isPressingJumpSeconds = (down and (player:isOnFloor() or water)) and (not water and 0.25 or 0.175) or 1
		end,

		plugin = {
			clientActivate = function (self)
				self.isPressingJumpSeconds = -1
			end,

			clientAct = function (self, seconds)
				if self.isPressingJumpSeconds > 0 and Health.isActiveEntity(self) then
					self.velocity.z = self.velocity.z + (1500 + World.gravity) * seconds * self.isPressingJumpSeconds / 0.25
					self.isPressingJumpSeconds = self.isPressingJumpSeconds - seconds
				end
			end
		}
	},

	footsteps = {
		footsteps = {
			floorHeight = 0.5,
			readyHeight = 2.5,
			delay = 1 / 2,
			tags = {"tag_foot_l", "tag_foot_r"},
			delays = {-1, -1},
			sounds = {"swarm/footstep1.ogg", "swarm/footstep2.ogg"}
		},

		activate = function (self)
			table.insert(self.attachments, "*tag_foot_l")
			table.insert(self.attachments, "*tag_foot_r")
		end,

		clientAct = function (self, seconds)
			if not self.move and not self.strafe then return nil end
			if isPlayerEditing(self) then return nil end

			local baseHeight = self.position.z
			for i = 1, #self.footsteps.tags do
				local footHeight = CAPI.getAttachmentPosition(self, self.footsteps.tags[i]).z - baseHeight
				if self.footsteps.delays[i] == 0 then
					if footHeight <= self.footsteps.floorHeight then
						Sound.play(self.footsteps.sounds[i], self.position:copy())
						self.footsteps.delays[i] = -1
					end
				elseif self.footsteps.delays[i] == -1 then
					if footHeight >= self.footsteps.readyHeight then
						self.footsteps.delays[i] = self.footsteps.delay
					end
				else
					self.footsteps.delays[i] = math.max(self.footsteps.delays[i] - seconds, 0)
				end
			end
		end
	}
}

Movement = {
    turn_left = CAPI.turn_left,
    turn_right = CAPI.turn_right,
    look_down = CAPI.look_down,
    look_up = CAPI.look_up,
    backward = CAPI.backward,
    forward = CAPI.forward,
    left = CAPI.left,
    right = CAPI.right,
    jump = CAPI.jump
}
