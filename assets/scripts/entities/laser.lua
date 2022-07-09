Laser = Entity:new()
Laser.type = "laser"

function Laser:new(x, y, theta)
	local SPEED = 12.5
	
	this = {
		frame = gfx.LASER,
		
		pos = Vector2d:new(x, y),
		vel = Vector2d:new(math.cos(theta) * SPEED, -math.sin(theta) * SPEED),
		theta = theta - (math.pi / 2),
	}
	
	setmetatable(this,self)
	self.__index = self
	return this
end

function Laser:update()
	self.pos = self.pos + self.vel

	if (self.pos.x < -20 or self.pos.x > CANVAS_WIDTH + 20 or self.pos.y < -20 or self.pos.y > CANVAS_HEIGHT + 20) then
		removeEntity(self)
		return
	end

	local c = self:collide("enemy")
	if (c) then
		for i = 1, #c do
			c[i]:inflict(1)
		end
		removeEntity(self)
	end
end

function Laser:render()
	AB.graphics.setColor()
	AB.graphics.renderSprite(layers.SPRITES, self.frame, self.pos.x, self.pos.y, -1, self.theta)
end

