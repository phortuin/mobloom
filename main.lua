-- dependencies
local love = require "love"

-- init
require "lib/init"

-- als je te laat een monster pakt, pakt hij geld van je af, of health
-- een monster moet je 2x klikken
-- een zwaardje zorgt ervoor dat je een monster maar 1x hoeft te klikken, blijft 5 kliks geldig
-- hover over mob verandert cursor
-- paddestoel die te lang blijft, wordt giftig
-- giftige paddestoel spawnt meer paddestoelen (gpt zei "en monsters" :D) en als je daar overheen muist gaat je muis trager. of verlies je health?
-- effect/event triggers en handlers

local SCORE_LENGTH = 4

local bounds = {
	x_upper = 780,
	x_lower = 20,
	y_upper = 580,
	y_lower = 20,
	size_lower = 20,
	size_upper = 40,
}

local mobs = {
	MONSTER = "monster",
	MONEY = "money",
	SWORD = "sword",
}

local monsters = {
	space = {
		name = "space",
		sprite = Sprites.monsters[1],
		hit = Sounds.hit,
		miss = Sounds.air
	},
	ghost = {
		name = "ghost",
		sprite = Sprites.monsters[2],
		hit = Sounds.hit,
		miss = Sounds.air
	},
	cringe = {
		name = "cringe",
		sprite = Sprites.monsters[3],
		hit = Sounds.hit,
		miss = Sounds.air
	},
}

local collectibles = {
	[1] = {
		name = "bag",
		sprite = Sprites.moneys[1],
		hit = Sounds.coins,
		miss = Sounds.lost,
	},
	[2] = {
		name = "dollar",
		sprite = Sprites.moneys[2],
		hit = Sounds.coin,
		miss = Sounds.lost,
	},
}

local monstersIndex = {
	[1] = monsters.space,
	[2] = monsters.ghost,
	[3] = monsters.cringe,
}

local mobState = {
	x = 0,
	y = 0,
	rot = 0,
	size = 0,
	mob = "",
	sprite = {},
	class = "",
	hitbox = {
		x = 0,
		y = 0,
		x2 = 0,
		y2 = 0,
	},
}

local playerState = {
	health = 5,
	score = 5,
}

local winningState = {
	show = false,
	alpha = 255,
	winnings = 0,
	x = 0,
	y = 0,
}

local function setNextMob()
	local rnd = math.ceil(math.random() * 10)
	mobState.x = math.random(bounds.x_lower, bounds.x_upper)
	mobState.y = math.random(bounds.y_lower, bounds.y_upper)
	mobState.rot = 0
	mobState.size = 20
	if rnd < 7 then
		-- monster
		local monster = monstersIndex[math.random(#monstersIndex)]
		mobState.sprite = monster.sprite
		mobState.class = monster.name
		mobState.hit = monster.hit
		mobState.miss = monster.miss
		mobState.mob = mobs.MONSTER
		return
	end
	if rnd < 9 then
		-- money
		local money = collectibles[math.random(#collectibles)]
		mobState.sprite = money.sprite
		mobState.class = money.name
		mobState.hit = money.hit
		mobState.miss = money.miss
		mobState.mob = mobs.MONEY
		return
	end
	if rnd < 11 then
		-- sword
		mobState.sprite = Sprites.sword
		mobState.class = ""
		mobState.hit = Sounds.swordGet
		mobState.miss = Sounds.air
		mobState.mob = mobs.SWORD
		return
	end
end

local function moveMob()
	mobState.x = mobState.x + math.random(-2, 2)
	mobState.y = mobState.y + math.random(-2, 2)
	mobState.size = mobState.size + math.random(-1, 1)
	mobState.rot = mobState.rot + math.random(-2, 2)
	if mobState.x > bounds.x_upper then
		mobState.x = bounds.x_lower
	end
	if mobState.x < bounds.x_lower then
		mobState.x = bounds.x_upper
	end
	if mobState.y > bounds.y_upper then
		mobState.y = bounds.y_lower
	end
	if mobState.y < bounds.y_lower then
		mobState.y = bounds.y_upper
	end
	if mobState.size > bounds.size_upper then
		mobState.size = bounds.size_upper
	end
	if mobState.size < bounds.size_lower then
		mobState.size = bounds.size_lower
	end
	local halfSize = mobState.size / 2
	mobState.hitbox = {
		x = mobState.x - halfSize,
		y = mobState.y - halfSize,
		x2 = mobState.x + halfSize,
		y2 = mobState.y + halfSize,
	}
end

setNextMob()

local function updateWinnings(dt)
	winningState.alpha = winningState.alpha - (dt * (255))
	if winningState.winnings > 0 then
		winningState.y = winningState.y - 1
	else
		winningState.y = winningState.y + 1
	end
	if winningState.alpha < 0 then
		winningState.show = false
	end
end

function love.update(dt)
	moveMob()

	if winningState.show then
		updateWinnings(dt)
	end

	if MonsterDelay == 200 then
		Sounds.hit:play()
		mobState.size = 80
		playerState.health = playerState.health - 1
	end
end

function DrawWinnings()
	if winningState.show then
		if winningState.winnings < 0 then
			love.graphics.setColor(1, 0, 0, winningState.alpha / 255)
		else
			love.graphics.setColor(1, 0.8, 0.2, winningState.alpha / 255)
		end
		love.graphics.print(winningState.winnings, winningState.x - 8, winningState.y - 15)
	end
end

function love.draw()
	Effect(function()
		DrawHealth(playerState.health)
		DrawScore(playerState.score)
		DrawMob()
		DrawWinnings()
	end)
end

function DrawMob()
	if mobState.mob == mobs.MONSTER then
		MonsterDelay = MonsterDelay + 1
	end
	-- draw hitbox
	-- love.graphics.setColor(1, 0, 1, 255)
	-- love.graphics.rectangle("fill", mobState.hitbox.x, mobState.hitbox.y, mobState.size, mobState.size)
	-- love.graphics.setColor(1, 1, 1, 255)
	love.graphics.draw(mobState.sprite, mobState.x, mobState.y, math.rad(mobState.rot), mobState.size / 8,
		mobState.size / 8,
		4, 4)
end

function DrawHealth(health)
	for i = 0, health - 1 do
		love.graphics.draw(Sprites.heart, 50 + (i * 30), 50, 0, 3, 3)
	end
end

function DrawScore(score)
	love.graphics.setColor(1, 0.8, 0.2, 255)
	love.graphics.print("$", 650, 50)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print(string.rep("0", SCORE_LENGTH - #tostring(playerState.score)) .. playerState.score, 680, 50)
end

local function updatePlayerState(winnings)
	playerState.score = playerState.score + winnings
	if playerState.score <= 0 then
		playerState.score = 0
	end
end

function love.mousepressed(x, y, button)
	local winnings = 0
	if button == 1 then
		if x > mobState.hitbox.x
				and x < mobState.hitbox.x2
				and y > mobState.hitbox.y
				and y < mobState.hitbox.y2 then
			-- hit
			if mobState.mob == mobs.MONEY then
				winnings = mobState.class == "bag" and 5 or 1
				winningState = {
					show = true,
					alpha = 255,
					winnings = winnings,
					x = mobState.x,
					y = mobState.y,
				}
			end
			mobState.hit:stop()
			mobState.hit:play()
		else
			-- miss
			if mobState.mob == mobs.MONEY then
				winnings = -5
				winningState = {
					show = true,
					alpha = 255,
					winnings = winnings,
					x = mobState.x - 8, -- 8 is half the width of "-5"
					y = mobState.y + mobState.size,
				}
			end
			mobState.miss:stop()
			mobState.miss:play()
		end
		updatePlayerState(winnings)
		MonsterDelay = 0
		-- pas later?
		setNextMob()
	end
end
