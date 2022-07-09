Vector2d = {}
local mt = {}
local prototype = { x = 0, y = 0 }

function Vector2d:new(x, y)
	local v = {}
	for key, value in pairs(prototype) do
		v[key] = value
	end
	
	x = x or 0
	y = y or 0
	v.x = x
	v.y = y

	setmetatable(v, mt)
	return v
end

local function __index(self, i)
	return self.i or 0
end
mt.__index = __index

local function __eq(u, v)
	return u.x == v.x and u.y == v.y
end
mt.__eq = __eq

local function __add(u, v)
	local a = u:copy()
	a.x = a.x + v.x
	a.y = a.y + v.y
	return a
end
mt.__add = __add

local function __sub(u, v)
	local a = u:copy()
	a.x = a.x - v.x
	a.y = a.y - v.y
	return a
end
mt.__sub = __sub

local function __unm(v)
	local a = v:copy()
	a.x = -a.x
	a.y = -a.y
	return a
end
mt.__unm = __unm

local function __mul(v, scalar)
	local a
	if (type(scalar) == "number") then
		a = Vector2d.new()
		a.x = v.x * scalar
		a.y = v.y * scalar
	elseif (type(v) == "number") then
		a = __mul(scalar, v)
	else
		error("invalid type for vector multiplication")
	end
	return a
end
mt.__mul = __mul

local function __div(v, scalar)
	local a
	if (type(scalar) == "number") then
		a = __mul(v, 1 / scalar)
	else
		error("invalid type for vector division")
	end
	return a
end
mt.__div = __div

local function __tostring(self)
	return "(" .. self.x .. ", " .. self.y .. ")"
end
mt.__tostring = __tostring

--	prototype methods

local function copy(self)
	local v = Vector2d.new()
	v.x = self.x
	v.y = self.y
	return v
end
prototype.copy = copy

local function set(self, x, y)
	self.x = x
	self.y = y
end
prototype.set = set

local function reset(self)
	self.x = 0
	self.y = 0
end
prototype.reset = reset

local function dotProduct(self, v)
	return self.x * v.x + self.y * v.y
end
prototype.dotProduct = dotProduct

local function magnitude(self)
	return math.sqrt(self:dotProduct(self))
end
prototype.magnitude = magnitude

local function normalize(self)
	local l = self:magnitude()
	if l ~= 0 then
		self.x = self.x / l
		self.y = self.y / l
	end
end
prototype.normalize = normalize

local function truncate(self, s)
	local l = self:magnitude()
	if l > s then
		self.x = (self.x / l) * s
		self.y = (self.y / l) * s
	end
end
prototype.truncate = truncate

local function rotate(self, a)
	local tx = self.x
	local ty = self.y
	local ta = math.rad(a)

	self.x = ty * math.sin(ta) + tx * math.cos(ta)
	self.y = ty * math.cos(ta) - tx * math.sin(ta)
end
prototype.rotate = rotate
