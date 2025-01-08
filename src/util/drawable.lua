local drawable = {}

function drawable.draw(entity, opacity)
	opacity = opacity or 1
	if entity.sprite then
		drawable.drawSprite(entity, opacity)
	else
		drawable.drawRectangle(entity, opacity)
	end
end

function drawable.drawSprite(entity, opacity)
	local w = entity.sprite:getWidth()
	local h = entity.sprite:getHeight()
	love.graphics.setColor(1, 1, 1, opacity)
	love.graphics.draw(entity.sprite, entity.x, entity.y, math.rad(entity.rotation), entity.size / w,
		entity.size / h,
		w / 2, h / 2)
	love.graphics.setColor(1, 1, 1, 1)
end

-- dit is bedacht door de robot
function drawable.drawRectangle(entity, opacity)
	love.graphics.setColor(1, 0, 1, opacity)
	love.graphics.rectangle("fill", entity.x - entity.size / 2, entity.y - entity.size / 2, entity.size, entity.size)
	love.graphics.setColor(1, 1, 1, 1)
end

function drawable.drawTarget(entity, color)
	color = color or "red"
	if color == "blue" then
		love.graphics.setColor(0, 0.5, 1, 0.5)
	else
		love.graphics.setColor(1, 0, 0, 0.5)
	end
	love.graphics.circle("fill", entity.x, entity.y, entity.size)
	love.graphics.setColor(1, 1, 1, 1)
end

function drawable.drawTakingDamage(entity)
	local w = entity.sprite:getWidth()
	local h = entity.sprite:getHeight()
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.draw(entity.sprite, entity.x, entity.y, math.rad(entity.rotation), (entity.size - 16) / w,
		(entity.size - 16) / h,
		w / 2, h / 2)
	love.graphics.setColor(1, 1, 1, 1)
end

return drawable
