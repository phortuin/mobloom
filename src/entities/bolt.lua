local spawn = require "src.util.spawn"
local drawable = require "src.util.drawable"
local hit = require "src.util.hit"

local Bolt = {}
Bolt.__index = Bolt

function Bolt:new()
	local spawnPoint = spawn.getSpawnPoint()
	local bolt = {
		x = spawnPoint.x,
		y = spawnPoint.y,
		rotation = 0,
		size = 24,
		sprite = Sprites.bolt,
		hit = Sounds.bolt,
		age = 0
	}
	setmetatable(bolt, Bolt)
	return bolt
end

function Bolt:consume()
	self.hit:stop()
	self.hit:play()
	self.age = 9999; -- this is a hack
end

function Bolt:deprecate(dt)
	self.age = self.age + dt
end

function Bolt:draw()
	local x, y = love.mouse.getPosition()
	if self.age > 9999 then
		self:drawEffect()
	else
		if self:checkHit(x, y) then
			drawable.drawTarget(self, "blue")
		end
		drawable.draw(self)
	end
end

function Bolt:checkHit(x, y)
	return hit.checkHit(self, x, y)
end

return Bolt
