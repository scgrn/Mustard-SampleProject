Splode = Entity:new()
Splode.type = "splode"

local MAX_RADIUS = 75

function Splode:new(x, y)
	this = {
		pos = Vector2d:new(x, y),
		radius = 5,
	}
	
	setmetatable(this,self)
	self.__index = self
	return this
end

function Splode:update()
	self.radius = self.radius * 1.2
	if (self.radius > MAX_RADIUS) then
		removeEntity(self)
	end
end

function Splode:render()
	AB.graphics.setColor(0, 1, 0, 1, 1)
	AB.graphics.renderArc(layers.SPRITES, self.pos.x, self.pos.y, self.radius, 0, 360, 16)

	local innerRadius = ((self.radius / MAX_RADIUS) ^ 4) * (MAX_RADIUS * 2.0)
	
	AB.graphics.setColor(0, 0, 0, 1, 0)
	AB.graphics.renderArc(layers.SPRITES, self.pos.x, self.pos.y, innerRadius / 2, 0, 360, 16)
end

