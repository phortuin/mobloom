local spawn = require "src.util.spawn"
local drawable = require "src.util.drawable"
local hit = require "src.util.hit"

local Powerup = {}
Powerup.__index = Powerup

function Powerup:new()
	local spawnPoint = spawn.getSpawnPoint()
	local powerup = {
		x = spawnPoint.x,
		y = spawnPoint.y,
		rotation = 0,
		size = 24,
		sprite = Sprites.shroom,
		hit = Sounds.heal,
		age = 0,
		heal = 1
	}
	setmetatable(powerup, Powerup)
	return powerup
end

function Powerup:consume()
	self.hit:stop()
	self.hit:play()
end

function Powerup:deprecate(dt)
	self.age = self.age + dt
	if self.age > POWERUP_AGED_AFTER then
		self.hit = Sounds.shroomBad
		self.sprite = Sprites.shroomBad
		self.heal = -1
	end
end

function Powerup:draw()
	local x, y = love.mouse.getPosition()
	if self:checkHit(x, y) then
		if self.heal > 0 then
			drawable.drawTarget(self, "blue")
		else
			drawable.drawTarget(self, "red")
		end
	end
	drawable.draw(self)
end

function Powerup:checkHit(x, y)
	return hit.checkHit(self, x, y)
end

return Powerup
