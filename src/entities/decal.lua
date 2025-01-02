local drawable = require 'src.util.drawable'

local Decal = {}
Decal.__index = Decal

function Decal:new(mob)
	local decal = {
		x = mob.x,
		y = mob.y,
		sprite = Sprites.splat,
		size = mob.size,
		rotation = mob.rotation * 90
	}
	setmetatable(decal, Decal)
	return decal
end

function Decal:draw()
	drawable.draw(self)
end

return Decal
