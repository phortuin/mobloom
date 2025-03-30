local spawn = require "src.util.spawn"
local drawable = require "src.util.drawable"
local hit = require "src.util.hit"

local Health = require "src.systems.health"

local Mob = {}
Mob.__index = Mob

function Mob:new()
	local monster = Monsters[math.random(#Monsters)]
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
		attackTimer = 0,
		health = Health:new(1),
		damage = 1,
		sprite = monster.sprite,
		hit = monster.hit,
		coins = 1,
	}
	setmetatable(mob, Mob)
	return mob
end

function Mob:move()
	local dx, dy, ds, dr = math.random(-2, 2), math.random(-2, 2), math.random(-1, 1), math.random(-2, 2)
	self.x = Clamp(self.x + dx, Bounds.x_lower, Bounds.x_upper)
	self.y = Clamp(self.y + dy, Bounds.y_lower, Bounds.y_upper)
	self.size = Clamp(self.size + ds, self.smallestSize, self.largestSize)
	self.rotation = self.rotation + dr
end

function Mob:takeDamage(damage)
	self.health:takeDamage(damage)
	self.takingDamage = true
	if self.health:isDead() then
		Sounds.mobDie:stop()
		Sounds.mobDie:play()
	else
		self.hit:stop()
		self.hit:play()
	end
end

function Mob:buildAttack(dt)
	self.attackTimer = self.attackTimer + dt
end

function Mob:attackIfReady()
	if self.attackTimer >= ATTACK_AFTER_SECONDS then
		self.attackTimer = 0
		Sounds.hit:stop()
		Sounds.hit:play()
		self:attack()
		self.size = 24
		return true
	end
end

function Mob:attack()
	self.size = 96
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("fill", 0, 0, 800, 20)
	love.graphics.rectangle("fill", 0, 0, 20, 600)
	love.graphics.rectangle("fill", 780, 0, 800, 600)
	love.graphics.rectangle("fill", 0, 580, 800, 600)
	self:draw()
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
	local x, y = love.mouse.getPosition()
	if self:checkHit(x, y) then
		drawable.drawTarget(self)
	end
	if self.takingDamageTimer > 0 then
		drawable.drawTakingDamage(self)
	else
		drawable.draw(self)
	end
end

function Mob:checkHit(x, y)
	return hit.checkHit(self, x, y)
end

return Mob
