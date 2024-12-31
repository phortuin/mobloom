local spawn = {}

function spawn.getSpawnPoint()
	return {
		x = math.random(Bounds.x_lower, Bounds.x_upper),
		y = math.random(Bounds.y_lower, Bounds.y_upper),
		rotation = 0,
		size = 20
	}
end

return spawn
