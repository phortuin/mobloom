local Vector = require "lib.vector"
local drawable = require "src.util.drawable"
local hit = require "src.util.hit"

local Coin = {}
Coin.__index = Coin

local INVULN = 0.8
local ROTATION_FACTOR = 6

function Coin:new(mob)
	local coin = {
		x = mob.x,
		y = mob.y,
		position = Vector:new(mob.x, mob.y),
		velocity = Vector:new(),
		acceleration = Vector:new(),
		topSpeed = 5,
		sprite = Sprites.coin,
		size = 16,
		rotation = 90,
		age = 0,
		dx = (math.random() * 2) - 1
	}
	setmetatable(coin, Coin)
	return coin
end

function Coin:draw()
	local opacity = 1 - (self.age / COIN_LASTS)
	drawable.drawTarget(self, "magenta", opacity)
	drawable.draw(self, opacity)
end

function Coin:move(dt)
	self.age = self.age + dt

	if self.age > INVULN then
		-- follow mouse
		local direction = Vector:new(love.mouse.getX(), love.mouse.getY())
		direction:subtract(self.position)
		direction:normalize()
		direction:multiply(0.2)
		self.acceleration = direction
		self.velocity:add(self.acceleration)
		self.velocity:limit(self.topSpeed)
		self.position:add(self.velocity)
	else
		-- fountain effect
		self.position.x = self.position.x + self.dx
		self.position.y = self.position.y - 4 + (self.age * 5)
	end

	if self.velocity.x > 0 then
		self.rotation = self.rotation + (ROTATION_FACTOR * self.age)
	else
		self.rotation = self.rotation - (ROTATION_FACTOR * self.age)
	end

	self.x = self.position.x
	self.y = self.position.y
end

function Coin:hit()
	if self.age > INVULN then
		local x, y = love.mouse.getPosition()
		return self:checkHit(x, y)
	end
	return false
end

function Coin:die()
	self.age = COIN_LASTS
end

function Coin:checkHit(x, y)
	return hit.checkHit(self, x, y)
end

return Coin
