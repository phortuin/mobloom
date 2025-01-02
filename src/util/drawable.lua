local drawable = {}

function drawable.draw(entity)
	if entity.sprite then
		drawable.drawSprite(entity)
	else
		drawable.drawRectangle(entity)
	end
end

function drawable.drawSprite(entity)
	local w = entity.sprite:getWidth()
	local h = entity.sprite:getHeight()
	love.graphics.draw(entity.sprite, entity.x, entity.y, math.rad(entity.rotation), entity.size / w,
		entity.size / h,
		w / 2, h / 2)
end

-- dit is bedacht door de robot
function drawable.drawRectangle(entity)
	love.graphics.setColor(1, 0, 1, 1)
	love.graphics.rectangle("fill", entity.x - entity.size / 2, entity.y - entity.size / 2, entity.size, entity.size)
	love.graphics.setColor(1, 1, 1, 1)
end

function drawable.drawTakingDamage(entity)
	local w = entity.sprite:getWidth()
	local h = entity.sprite:getHeight()
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.draw(entity.sprite, entity.x, entity.y, math.rad(entity.rotation), (entity.size - 10) / w,
		(entity.size - 10) / h,
		w / 2, h / 2)
	love.graphics.setColor(1, 1, 1, 1)
end

return drawable
