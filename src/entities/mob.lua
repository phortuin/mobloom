local spawn = require "src.util.spawn"

local Mob = {}
Mob.__index = Mob

function Mob:new()
	local spawnPoint = spawn.getSpawnPoint()
	local mob = {
		x = spawnPoint.x,
		y = spawnPoint.y,
		rotation = spawnPoint.rotation,
		size = spawnPoint.size,
		smallestSize = Bounds.size_lower,
		largestSize = Bounds.size_upper,
		takingDamage = false,
		takingDamageTimer = 0,
		attackingTimer = 0
	}
	setmetatable(mob, Mob)
	return mob
end

function Mob:move()
	local dx, dy, ds, dr = math.random(-2, 2), math.random(-2, 2), math.random(-1, 1), math.random(-2, 2)
	self.x = Wrap(self.x + dx, Bounds.x_lower, Bounds.x_upper)
	self.y = Wrap(self.y + dy, Bounds.y_lower, Bounds.y_upper)
	self.size = Clamp(self.size + ds, self.smallestSize, self.largestSize)
	self.rotation = self.rotation + dr
end

function Mob:update(dt)
	if self.takingDamage then
		self.takingDamageTimer = self.takingDamageTimer + dt
	end
	if self.takingDamageTimer > TAKING_DAMAGE_LASTS then
		self.takingDamage = false
		self.takingDamageTimer = 0
	end
end

function Mob:draw()
	local w = self.sprite:getWidth()
	local h = self.sprite:getHeight()
	-- draw hitbox
	-- love.graphics.setColor(1, 0, 1, 1)
	-- love.graphics.rectangle("fill", self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
	-- love.graphics.setColor(1, 1, 1, 1)
	if self.takingDamageTimer > 0 then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.draw(self.sprite, self.x, self.y, math.rad(self.rotation), (self.size - 10) / w,
			(self.size - 10) / h,
			w / 2, h / 2)
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.draw(self.sprite, self.x, self.y, math.rad(self.rotation), self.size / w,
			self.size / h,
			w / 2, h / 2)
	end
end

function Mob:checkHit(x, y)
	local halfSize = self.size / 2
	return x > self.x - halfSize
			and x < self.x + halfSize
			and y > self.y - halfSize
			and y < self.y + halfSize
end

return Mob
