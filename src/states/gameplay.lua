local Mob = require "src.entities.mob"
local Boss = require "src.entities.boss"
local Powerup = require "src.entities.powerup"
local Bolt = require "src.entities.bolt"
local Decal = require "src.entities.decal"
local Coin = require "src.entities.coin"
local Health = require "src.systems.health"
local drawable = require "src.util.drawable"
local spawn = require "src.util.spawn"

local Gameplay = {}

local player
local monsters
local powerups
local bolts
local decals
local coins
local powerupTimer
local boltTimer
local bossTimer
local grass

local flash

local function makeGrass()
	local _grass = {}
	for i = 1, 30 do
		local spawnPoint = spawn.getSpawnPoint()
		table.insert(_grass, {
			x = spawnPoint.x,
			y = spawnPoint.y,
			sprite = Sprites.grass,
			size = (math.random() * 10) + 20,
			rotation = (math.random() * 20) - 10,
			opacity = (math.random() / 2) + 0.5
		})
	end
	return _grass
end

-- Initialize gameplay state
function Gameplay:enter()
	player = {
		health = Health:new(MAX_HP, MAX_HP),
		score = 0
	}
	monsters = {
		Mob:new()
	}
	grass = makeGrass()
	powerups = {}
	bolts = {}
	decals = {}
	coins = {}
	powerupTimer = 0
	boltTimer = 0
	bossTimer = 0
end

function Gameplay:update(dt)
	-- count towards next powerup spawn
	powerupTimer = powerupTimer + dt
	if powerupTimer > POWERUP_SPAWN_INTERVAL
			and #powerups < 1 then
		table.insert(powerups, Powerup:new())
	end

	-- count towards next bolt spawn
	boltTimer = boltTimer + dt
	if boltTimer > BOLT_SPAWN_INTERVAL
			and #bolts < 1 then
		table.insert(bolts, Bolt:new())
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
			for _ = 1, monsters[m].coins do
				table.insert(coins, Coin:new(monsters[m]))
			end
			table.insert(decals, Decal:new(monsters[m]))
			table.remove(monsters, m)
		end
	end

	-- coins upkeep
	for _, coin in ipairs(coins) do
		coin:move(dt)
		if coin:hit() then
			player.score = player.score + 1
			Sounds.coinDing:stop()
			Sounds.coinDing:play()
			coin:die()
		end
	end

	-- remove expired coins
	for c = #coins, 1, -1 do
		if coins[c].age >= COIN_LASTS then
			table.remove(coins, c)
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

	-- age bolts
	for _, bolt in ipairs(bolts) do
		bolt:deprecate(dt)
		if bolt.age >= BOLT_AGED_AFTER then
			bolts = {}
			boltTimer = 0
		end
	end

	-- spawn monsters
	if #monsters < 1 then
		table.insert(monsters, Mob:new())
	end
end

function Gameplay:draw()
	local mouseOver = false
	local x, y = love.mouse.getPosition()
	for _, powerup in ipairs(powerups) do
		if powerup:checkHit(x, y) then mouseOver = true end
	end
	for _, bolt in ipairs(bolts) do
		if bolt:checkHit(x, y) then mouseOver = true end
	end
	for _, monster in ipairs(monsters) do
		if monster:checkHit(x, y) then mouseOver = true end
	end

	if mouseOver == false then
		drawable.drawTarget({
			x = x, y = y, size = 40
		}, "faint-grey")
	end
	-- draw health
	player.health:drawPlayerHealth()

	-- draw score
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(string.rep(" ", SCORE_LENGTH - #tostring(player.score)) .. player.score, 710,
		30)

	-- draw sprites
	for _, decal in ipairs(decals) do
		decal:draw()
	end
	for _, _grass in ipairs(grass) do
		drawable.draw(_grass, _grass.opacity)
	end
	for _, powerup in ipairs(powerups) do
		powerup:draw()
	end
	for _, bolt in ipairs(bolts) do
		bolt:draw()
	end
	for _, coin in ipairs(coins) do
		coin:draw()
	end
	for _, monster in ipairs(monsters) do
		monster:draw()
		if (monster:attackIfReady()) then
			player.health:takeDamage(1)
		end
	end

	-- draw sfx
	if flash then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		flash = false
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
		for _, bolt in ipairs(bolts) do
			if bolt:checkHit(x, y) then
				hit = true
				-- kills all monsters
				for _, monster in ipairs(monsters) do
					monster:takeDamage(10)
				end
				-- deprecates shrooms to rotten shrooms
				-- or kills rotten shrooms
				for _, powerup in ipairs(powerups) do
					if powerup.heal < 0 then
						powerupTimer = 0
						powerups = {}
					end
					powerup:deprecate(100)
				end

				bolt:consume()
				boltTimer = 0
				flash = true
				bolts = {}
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
