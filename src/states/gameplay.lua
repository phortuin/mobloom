local Mob = require "src.entities.mob"
local Boss = require "src.entities.boss"
local Powerup = require "src.entities.powerup"
local Decal = require "src.entities.decal"
local Health = require "src.systems.health"

local Gameplay = {}

local player = {}
local monsters = {}
local powerups = {}
local bosses = {}
local decals = {}
local powerupTimer = 0
local bossTimer = 0

-- Initialize gameplay state
function Gameplay:enter()
	player = {
		health = Health:new(MAX_HP, MAX_HP),
		score = 5
	}
	monsters = {
		Mob:new()
	}
end

function Gameplay:update(dt)
	-- count towards next powerup spawn
	powerupTimer = powerupTimer + dt
	if powerupTimer > POWERUP_SPAWN_INTERVAL
			and #powerups < 1 then
		table.insert(powerups, Powerup:new())
	end

	-- count towards boss arrival. bosses are monsters and
	-- the bossTimer resets after spawning, not after killing
	bossTimer = bossTimer + dt
	if bossTimer > BOSS_SPAWN_INTERVAL then
		bossTimer = 0
		table.insert(monsters, Boss:new())
	end

	-- remove dead monsters
	for m = #monsters, 1, -1 do
		if monsters[m].health:isDead() then
			local decal = Decal:new(monsters[m])
			table.insert(decals, decal)
			table.remove(monsters, m)
		end
	end

	-- monsters upkeep
	for _, monster in ipairs(monsters) do
		monster:move()
		monster:update(dt)
		monster:buildAttack(dt)
	end

	-- age powerups
	for _, powerup in ipairs(powerups) do
		powerup:deprecate(dt)
	end

	-- spawn monsters
	if #monsters < 1 then
		table.insert(monsters, Mob:new())
	end
end

function Gameplay:draw()
	-- draw health
	player.health:draw()

	-- draw score
	love.graphics.setColor(1, 0.8, 0.2, 1)
	love.graphics.print("$", 650, 50)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(string.rep("0", SCORE_LENGTH - #tostring(player.score)) .. player.score, 680,
		50)

	for _, decal in ipairs(decals) do
		decal:draw()
	end
	for _, powerup in ipairs(powerups) do
		powerup:draw()
	end
	for _, monster in ipairs(monsters) do
		monster:draw()
		if (monster:attackIfReady()) then
			player.health:takeDamage(1)
		end
	end
end

function Gameplay:mousepressed(x, y, button)
	if button == 1 then
		local hit = false
		for _, monster in ipairs(monsters) do
			if monster:checkHit(x, y) then
				hit = true
				monster:takeDamage(1)
			end
		end
		for _, powerup in ipairs(powerups) do
			if powerup:checkHit(x, y) then
				hit = true
				powerup:consume()
				player.health:heal(powerup.heal)
				powerupTimer = 0
				powerups = {}
			end
		end
		if not hit then
			-- missed everything? add monster
			Sounds.air:stop()
			Sounds.air:play()
			table.insert(monsters, Mob:new())
		end
	end
end

return Gameplay
