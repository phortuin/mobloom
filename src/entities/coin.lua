local drawable = require "src.util.drawable"
local hit = require "src.util.hit"

local Coin = {}
Coin.__index = Coin

local INVULN = 0.4
local ROTATION_FACTOR = 6

function Coin:new(mob)
	local coin = {
		x = mob.x,
		y = mob.y,
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
	drawable.draw(self)
end

function Coin:move(dt)
	self.age = self.age + dt
	self.rotation = self.rotation + (ROTATION_FACTOR * self.age)
	self.y = self.y - 1 + self.age
	self.x = self.x + self.dx
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
