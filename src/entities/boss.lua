local Mob = require "src.entities.mob"
local Health = require "src.systems.health"

local Boss = {}
Boss.__index = Boss
setmetatable(Boss, { __index = Mob })

function Boss:new()
	local boss = setmetatable(Mob:new(), Boss)
	boss.sprite = Sprites.boss
	boss.health = Health:new(5, 5)
	boss.size = 72
	boss.smallestSize = 72
	boss.largestSize = 120
	boss.coins = 3
	boss.damage = 2
	boss.showHealth = true
	boss.targetColor = "red"
	boss.attackAfter = BOSS_ATTACK_AFTER
	return boss
end

return Boss
