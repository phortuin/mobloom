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
function Health:drawPlayerHealth()
	for i = 1, self.maxHp / 2 do
		if i * 2 > self.hp then
			if (i - 1) * 2 < self.hp then
				love.graphics.draw(Sprites.heartHalf, i * 30, 30, 0, 3, 3)
			else
				love.graphics.draw(Sprites.heartEmpty, i * 30, 30, 0, 3, 3)
			end
		else
			love.graphics.draw(Sprites.heart, i * 30, 30, 0, 3, 3)
		end
	end
end

function Health:drawMobHealth(entity)
	local halfSize = entity.smallestSize / 2
	love.graphics.setColor(1, 1, 1, 0.2)
	love.graphics.rectangle("fill", entity.x - halfSize, entity.y - halfSize - 20, entity.smallestSize, 4)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("fill", entity.x - halfSize, entity.y - halfSize - 20,
		self.hp / self.maxHp * entity.smallestSize, 4)
end

return Health
