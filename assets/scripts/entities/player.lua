Player = Entity:new()
Player.type = "player"

function Player:new()
	this = {
		frame = gfx.PLAYER,
		
		pos = Vector2d:new(CANVAS_CENTER_X, CANVAS_CENTER_Y),
		vel = Vector2d:new(),
		theta = 0,
		
		hp = 10,
		flashCountdownTimer = 0,
		
		laserTimer = 0,
		distanceFromCenter = 0, 	-- for enemy AI
	}
	
	setmetatable(this,self)
	self.__index = self
	return this
end

function Player:inflict(damage)
	--	invincible while flashing from previous damage
	if (self.flashCountdownTimer == 0) then
		self.hp = self.hp - damage
		self.flashCountdownTimer = 45
		if (self.hp <= 0) then
			AB.audio.stopSound(sfx.LASER)
			AB.audio.playSound(sfx.PLAYER_SPLODE)

			-- don't vibrate if there is a gamepad connected but the player is using the keyboard
			if (AB.input.showGamepadControls()) then
				AB.input.vibrate(1.0, 1500)
			end
			setGameState(gameOver)
		else
			local pan = (self.pos.x - CANVAS_CENTER_X) / CANVAS_CENTER_X
			AB.audio.playSound(sfx.OUCH, 1, pan)
			
			-- don't vibrate if there is a gamepad connected but the player is using the keyboard
			if (AB.input.showGamepadControls()) then
				AB.input.vibrate(1.0, 150)
			end
		end
	end
end

function Player:update()
	local MOVE_SPEED = 7
	local ROTATE_SPEED = 0.05
	local LASER_READY = 7
	
	--	movement
	self.vel:reset()
	if (AB.input.keyPressed(AB.input.scancodes.LEFT) or
		AB.input.gamepadPressed(AB.input.gamepadButtons.DPAD_LEFT)) then
		
		self.vel.x = self.vel.x - 1
	end
	if (AB.input.keyPressed(AB.input.scancodes.RIGHT) or
		AB.input.gamepadPressed(AB.input.gamepadButtons.DPAD_RIGHT)) then

		self.vel.x = self.vel.x + 1
	end
	if (AB.input.keyPressed(AB.input.scancodes.UP) or
		AB.input.gamepadPressed(AB.input.gamepadButtons.DPAD_UP)) then

		self.vel.y = self.vel.y - 1
	end
	if (AB.input.keyPressed(AB.input.scancodes.DOWN) or
		AB.input.gamepadPressed(AB.input.gamepadButtons.DPAD_DOWN)) then

		self.vel.y = self.vel.y + 1
	end
	
	self.vel.x = self.vel.x + AB.input.gamepadGetAxis(AB.input.gamepadAxes.LEFT_X)
	self.vel.y = self.vel.y + AB.input.gamepadGetAxis(AB.input.gamepadAxes.LEFT_Y)

	if (self.vel:magnitude() > 1) then
		self.vel:normalize()
	end
	self.vel = self.vel * MOVE_SPEED
	
	self.pos = self.pos + self.vel
	
	--	restrict movement to screen boundaries
	self.pos.x = math.max(math.min(self.pos.x, 800), 0)
	self.pos.y = math.max(math.min(self.pos.y, 480), 0)

	--  rotate
	if (AB.input.keyPressed(AB.input.scancodes.Z)) then
		self.theta = self.theta + ROTATE_SPEED
	end
	if (AB.input.keyPressed(AB.input.scancodes.X)) then
		self.theta = self.theta - ROTATE_SPEED
	end
	self.theta = self.theta - (AB.input.gamepadGetAxis(AB.input.gamepadAxes.RIGHT_X) * ROTATE_SPEED)

	--  fire laser
	self.laserTimer = self.laserTimer + 1
	if (self.laserTimer >= LASER_READY) then
		self.laserTimer = 0
		
		addEntity(Laser:new(self.pos.x, self.pos.y, self.theta + (math.pi / 2)))
		addEntity(Laser:new(self.pos.x, self.pos.y, self.theta + (math.pi / 2) + (math.pi / 1.5)))
		addEntity(Laser:new(self.pos.x, self.pos.y, self.theta + (math.pi / 2) - (math.pi / 1.5)))
	end

	--	manhattan distance from center for enemy AI
	self.distanceFromCenter = math.abs(player.pos.x - 400) + math.abs(player.pos.y - 240)
	
	--	update flash
	if (self.flashCountdownTimer > 0) then
		self.flashCountdownTimer = self.flashCountdownTimer - 1
	end
end

function Player:render()
	AB.graphics.setColor()

	local layer = layers.SPRITES
	if (self.flashCountdownTimer > 0) then
		layer = layers.FLASHY
	end
	
	AB.graphics.renderSprite(layer, self.frame, self.pos.x, self.pos.y, -1, self.theta)
end
