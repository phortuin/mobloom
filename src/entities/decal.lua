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
	local w = self.sprite:getWidth()
	local h = self.sprite:getHeight()
	love.graphics.draw(self.sprite, self.x, self.y, math.rad(self.rotation), self.size / w,
		self.size / h,
		w / 2, h / 2)
end

return Decal
