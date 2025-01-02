local Mob = require "src.entities.mob"

local Boss = {}
Boss.__index = Boss
setmetatable(Boss, { __index = Mob })

function Boss:new()
	local boss = setmetatable(Mob:new(), Boss)
	boss.sprite = Sprites.boss
	boss.hp = 5
	boss.size = 60
	boss.smallestSize = 60
	boss.largestSize = 100
	return boss
end

return Boss
