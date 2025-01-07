local Health = {}
Health.__index = Health

function Health:new(hp, maxHp)
	local health = {
		hp = hp or 0,
		maxHp = maxHp or 0,
	}
	setmetatable(health, Health)
	return health
end

function Health:takeDamage(damage)
	self.hp = self.hp - damage
end

function Health:heal(amount)
	self.hp = self.hp + amount
	if self.hp >= self.maxHp then
		self.hp = self.maxHp
	end
end

function Health:isDead()
	return self.hp <= 0
end

-- player only I suppose
function Health:draw()
	for i = 0, self.hp - 1 do
		love.graphics.draw(Sprites.heart, 50 + (i * 30), 50, 0, 3, 3)
	end
end

return Health
