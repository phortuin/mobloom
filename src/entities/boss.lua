local Mob = require "src.entities.mob"
local Health = require "src.systems.health"

local Boss = {}
Boss.__index = Boss
setmetatable(Boss, { __index = Mob })

function Boss:new()
	local boss = setmetatable(Mob:new(), Boss)
	boss.sprite = Sprites.boss
	boss.health = Health:new(5)
	boss.size = 60
	boss.smallestSize = 60
	boss.largestSize = 100
	return boss
end

return Boss
