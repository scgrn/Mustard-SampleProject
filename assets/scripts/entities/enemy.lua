Enemy = Entity:new()
Enemy.type = "enemy"

function Enemy:new(x, y)
	this = {
		frame = gfx.ENEMY,
		
		pos = Vector2d:new(x, y),
		moveTimer = 0,
		moveDuration = 0,
		timer = 0,
		
		vel = Vector2d:new(1, 0),
		waiting = true,
		
		hp = 3,
		flashCountdownTimer = 0
	}
	
	setmetatable(this,self)
	self.__index = self
	return this
end

function Enemy:inflict(damage)
	self.hp = self.hp - damage
	self.flashCountdownTimer = 20
	
	-- ded
	if (self.hp <= 0) then
		local pan = (self.pos.x - CANVAS_CENTER_X) / CANVAS_CENTER_X
		AB.audio.playSound(sfx.SPLODE, 1, pan)
		
		addEntity(Splode:new(self.pos.x, self.pos.y))
		removeEntity(self)
		
		game:score(100)
	end
end

function Enemy:update()
	local ANIMATION_SPEED = 12
	local MOVE_SPEED = 5
	
	self.timer = self.timer + 1
	
	if (currentState == gameOver) then
		-- flee the scene!
		local delta = player.pos - self.pos
		delta:normalize()
		self.pos = self.pos - (delta * 5.0)
		
		return
	end
	
	if (self.timer >= 600) then
		--	move directly toward player
		local delta = player.pos - self.pos
		delta:normalize()
		self.pos = self.pos + (delta * 3.0)
	else
		self.moveTimer = self.moveTimer + 1
		if (self.waiting) then
			if (self.moveTimer >= 30) then
				self.waiting = false
				self.moveTimer = 0

				-- if distance to center is less than distance from player to center,
				-- target player else target center
				if (math.abs(self.vel.x) > 0) then
					self.vel.x = 0
					local targetY = player.pos.y

					if (math.abs(self.pos.y - CANVAS_CENTER_Y) + math.abs(self.pos.x - CANVAS_CENTER_X) > player.distanceFromCenter) then
						targetY = CANVAS_CENTER_Y
					end
					
					if (targetY < self.pos.y) then
						self.vel.y = -MOVE_SPEED
					else
						self.vel.y = MOVE_SPEED
					end
					
					self.moveDuration = math.abs(self.pos.y - targetY) / MOVE_SPEED
					self.moveDuration = math.max(self.moveDuration, 30)
					
					if (AB.math.random() > 0.2) then
						self.moveDuration = self.moveDuration * 0.66
						if (math.random() < 0.3) then
							self.vel.y = -self.vel.y
						end
					end
				else
					self.vel.y = 0
					local targetX = player.pos.x

					if (math.abs(self.pos.y - CANVAS_CENTER_Y) + math.abs(self.pos.x - CANVAS_CENTER_X) > player.distanceFromCenter) then
						targetX = CANVAS_CENTER_X
					end
					
					if (targetX < self.pos.x) then
						self.vel.x = -MOVE_SPEED
					else
						self.vel.x = MOVE_SPEED
					end
					
					self.moveDuration = math.abs(self.pos.x - targetX) / MOVE_SPEED
					self.moveDuration = math.max(self.moveDuration, 30)

					if (AB.math.random() > 0.2) then
						self.moveDuration = self.moveDuration * 0.66
						if (math.random() < 0.3) then
							self.vel.x = -self.vel.x
						end
					end
				end
			end
		else
			if (self.moveTimer >= self.moveDuration) then
				self.moveTimer = 0;
				self.waiting = true
			else
				self.pos = self.pos + self.vel
			end
		end
	end

	--	check for collision with player
	local c = self:collide("player")
	if (c) then
		c[1]:inflict(1)
		addEntity(Splode:new(self.pos.x, self.pos.y))
		removeEntity(self)
		
		game:score(50)
	end
	
	--	animate
	if (self.timer % ANIMATION_SPEED == 0) then
		self.frame = self.frame + 1
		if (self.frame > gfx.ENEMY + 2) then
			self.frame = gfx.ENEMY
		end
	end
	
	--	update flash
	if (self.flashCountdownTimer > 0) then
		self.flashCountdownTimer = self.flashCountdownTimer - 1
	end
end

function Enemy:render()
	AB.graphics.setColor()
	
	local layer = layers.SPRITES
	if (self.flashCountdownTimer > 0 and currentState ~= gameOver) then
		layer = layers.FLASHY
	end
	
	AB.graphics.renderSprite(layer, self.frame, self.pos.x, self.pos.y)
end

