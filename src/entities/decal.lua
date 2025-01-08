local drawable = require "src.util.drawable"

local Decal = {}
Decal.__index = Decal

function Decal:new(mob)
	local decal = {
		x = mob.x,
		y = mob.y,
		sprite = Sprites.splat,
		size = mob.size * 1.25,
		rotation = math.random() * 360,
		opacity = math.random() * 0.2 + 0.2
	}
	setmetatable(decal, Decal)
	return decal
end

function Decal:draw()
	drawable.draw(self, self.opacity)
end

return Decal
