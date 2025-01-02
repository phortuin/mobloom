-- init; loads assets and sets globals
require "lib.init"
local Mob = require "src.entities.mob"
local Boss = require "src.entities.boss"
local Decal = require "src.entities.decal"
local Powerup = require "src.entities.powerup"

-- als je te laat een monster pakt, pakt hij geld van je af, of health
-- een monster moet je 2x klikken
-- een zwaardje zorgt ervoor dat je een monster maar 1x hoeft te klikken, blijft 5 kliks geldig
-- hover over mob verandert cursor
-- paddestoel die te lang blijft, wordt giftig
-- giftige paddestoel spawnt meer paddestoelen (gpt zei "en monsters" :D) en als je daar overheen muist gaat je muis trager. of verlies je health?
-- effect/event triggers en handlers
-- health bars!

function love.update(dt)
	-- count towards next powerup spawn
	GameState.powerupTimer = GameState.powerupTimer + dt
	if GameState.powerupTimer > POWERUP_SPAWN_INTERVAL
			and #GameState.powerups < 1 then
		table.insert(GameState.powerups, Powerup:new())
	end

	-- count towards boss arrival. bosses are monsters and
	-- the bossTimer resets after spawning, not after killing
	GameState.bossTimer = GameState.bossTimer + dt
	if GameState.bossTimer > BOSS_SPAWN_INTERVAL then
		GameState.bossTimer = 0
		table.insert(GameState.monsters, Boss:new())
	end

	-- remove dead monsters
	for m = #GameState.monsters, 1, -1 do
		if GameState.monsters[m].hp <= 0 then
			local decal = Decal:new(GameState.monsters[m])
			table.insert(GameState.decals, decal)
			table.remove(GameState.monsters, m)
		end
	end

	-- monsters upkeep
	for _, monster in ipairs(GameState.monsters) do
		monster:move()
		monster:update(dt)
		monster:buildAttack(dt)
	end

	-- age powerups
	for _, powerup in ipairs(GameState.powerups) do
		powerup:deprecate(dt)
	end

	-- spawn monsters
	if #GameState.monsters < 1 then
		table.insert(GameState.monsters, Mob:new())
	end
end

function love.draw()
	Effect(function()
		DrawHealth(GameState.player.hp)
		DrawScore(GameState.player.score)

		for _, decal in ipairs(GameState.decals) do
			decal:draw()
		end
		for _, powerup in ipairs(GameState.powerups) do
			powerup:draw()
		end
		for _, monster in ipairs(GameState.monsters) do
			monster:draw()
			monster:attackIfReady()
		end
	end)
end

function DrawHealth(health)
	for i = 0, health - 1 do
		love.graphics.draw(Sprites.heart, 50 + (i * 30), 50, 0, 3, 3)
	end
end

function DrawScore(score)
	love.graphics.setColor(1, 0.8, 0.2, 1)
	love.graphics.print("$", 650, 50)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(string.rep("0", SCORE_LENGTH - #tostring(GameState.player.score)) .. GameState.player.score, 680,
		50)
end

function love.mousepressed(x, y, button)
	if button == 1 then
		local hit = false
		for _, monster in ipairs(GameState.monsters) do
			if monster:checkHit(x, y) then
				hit = true
				monster:takeDamage(1)
			end
		end
		for _, powerup in ipairs(GameState.powerups) do
			if powerup:checkHit(x, y) then
				hit = true
				powerup:consume()
			end
		end
		if not hit then
			-- missed everything? add monster
			Sounds.air:stop()
			Sounds.air:play()
			table.insert(GameState.monsters, Mob:new())
		end
	end
end
