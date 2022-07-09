entities = {}
local entityCount = {}

Entity = {}

function Entity:new(o)
	o = o or { pos = Vector2d:new(), theta = 0 }
	setmetatable(o, self)
	self.__index = self
	return o
end

function Entity:collide(t)
	tests = {}
	if (type(t) == "string") then
		table.insert(tests, t)
	else
		tests = t
	end

	collisions = {}
	for key, test in pairs(tests) do
		if (entities[test] ~= nil) then
			for entityKey, entityValue in pairs(entities[test]) do
				if (self.frame == 0 or entityValue.frame == 0 or self.frame == nil or entityValue.frame == nil) then
					error("No frame defined for collision check!")
				else
					if (AB.collision.collides(self.frame, self.pos.x, self.pos.y, self.theta, 1, 1,
						entityValue.frame, entityValue.pos.x, entityValue.pos.y, entityValue.theta, 1, 1)) then

						table.insert(collisions, entityValue)
					end
				end
			end
		end
	end

	if (#collisions == 0) then
		collisions = nil
	end

	return collisions
end

function getEntityCount(t)
	return (entityCount[t] or 0)
end

function addEntity(e)
	if (e.type == nil or type(e.type) ~= "string") then
		error("Entity must name a type!")
	end
	if (e.update == nil or type(e.update) ~= "function") then
		error("Entity must define an update() function!")
	end
	if (e.render == nil or type(e.render) ~= "function") then
		error("Entity must define an render() function!")
	end

	if (entities[e.type] == nil) then
		entities[e.type] = {}
		entityCount[e.type] = 0
	end
	table.insert(entities[e.type], e)
	entityCount[e.type] = entityCount[e.type] + 1
end

function clearEntities()
	for typeKey, typeValue in pairs(entities) do
		for entityKey, entityValue in pairs(typeValue) do
			entityValue = nil
		end
		entityCount[typeKey] = 0
		entities[typeKey] = nil
	end
end

function removeEntity(e)
	if (entities[e.type] ~= nil) then
		for entityKey, entityValue in pairs(entities[e.type]) do
			if (entityValue == e) then
				entities[e.type][entityKey] = nil
				entityCount[e.type] = entityCount[e.type] - 1
			end
		end
	end
end

function updateEntities()
	for typeKey, typeValue in pairs(entities) do
		for entityKey, entityValue in pairs(typeValue) do
			entityValue:update()
		end
	end
end

function renderEntities()
	for typeKey, typeValue in pairs(entities) do
		for entityKey, entityValue in pairs(typeValue) do
			entityValue:render()
		end
	end
end
