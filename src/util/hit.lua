local hit = {}

function hit.checkHit(entity, x, y)
	local halfSize = entity.size / 2
	return x > entity.x - halfSize
			and x < entity.x + halfSize
			and y > entity.y - halfSize
			and y < entity.y + halfSize
end

return hit
