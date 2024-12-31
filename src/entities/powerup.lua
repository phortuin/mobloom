local Mob = require 'src.entities.mob'

local Powerup = {}
Powerup.__index = Powerup

function Powerup:new()
	local powerup = Mob:new()
	powerup.sprite = Sprites.shroom
	powerup.hit = Sounds.heal
	powerup.age = 0
	powerup.heal = 1
	setmetatable(powerup, Powerup)
	return powerup
end

function Powerup:consume()
	self.hit:stop()
	self.hit:play()
	GameState.player.hp = GameState.player.hp + self.heal
	GameState.powerupTimer = 0
	GameState.powerups = {}
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
	local w = self.sprite:getWidth()
	local h = self.sprite:getHeight()
	love.graphics.draw(self.sprite, self.x, self.y, math.rad(self.rotation), self.size / w,
		self.size / h,
		w / 2, h / 2)
end

function Powerup:checkHit(x, y)
	local halfSize = self.size / 2
	return x > self.x - halfSize
			and x < self.x + halfSize
			and y > self.y - halfSize
			and y < self.y + halfSize
end

return Powerup
