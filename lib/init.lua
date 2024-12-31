-- dependencies
local moonshine = require "vendor.moonshine"

Sprites = {}
Sounds = {}

local function loadAssets()
	Sprites.monsters = {
		[1] = love.graphics.newImage("assets/space.png"),
		[2] = love.graphics.newImage("assets/ghost.png"),
		[3] = love.graphics.newImage("assets/cringe.png"),
	}
	Sprites.moneys = {
		[1] = love.graphics.newImage("assets/bag.png"),
		[2] = love.graphics.newImage("assets/dollar.png"),
	}
	Sprites.sword = love.graphics.newImage("assets/sword.png")
	Sprites.heart = love.graphics.newImage("assets/heart.png")
	Sprites.shroom = love.graphics.newImage("assets/shroom.png")
	Sprites.shroomBad = love.graphics.newImage("assets/shroom-bad.png")
	Sprites.boss = love.graphics.newImage("assets/boss-tree.png")
	Sprites.splat = love.graphics.newImage("assets/splat.png")
	local cursor = love.mouse.newCursor("assets/cursor.png")

	love.mouse.setCursor(cursor)

	Sounds.coin = love.audio.newSource("assets/coin-single.wav", "static")
	Sounds.coins = love.audio.newSource("assets/coin-many.wav", "static")
	Sounds.lost = love.audio.newSource("assets/coin-lost.wav", "static")
	Sounds.hit = love.audio.newSource("assets/hit.wav", "static")
	Sounds.hitMob = love.audio.newSource("assets/hit-mob.wav", "static")
	Sounds.mobDie = love.audio.newSource("assets/mob-die.wav", "static")
	Sounds.air = love.audio.newSource("assets/air.wav", "static")
	Sounds.swordGet = love.audio.newSource("assets/sword-get.wav", "static")
	Sounds.heal = love.audio.newSource("assets/heal.wav", "static")
	Sounds.shroomBad = love.audio.newSource("assets/shroom-bad.wav", "static")
end

Effect = moonshine(moonshine.effects.glow)
love.graphics.setNewFont("assets/JetBrainsMono-Bold.ttf", 30)
loadAssets()

SCORE_LENGTH = 4
ATTACK_AFTER = 200
MAX_HP = 5
AGE_AFTER = 500

ATTACK_AFTER_SECONDS = 5
POWERUP_SPAWN_INTERVAL = 10
BOSS_SPAWN_INTERVAL = 10
POWERUP_AGED_AFTER = 5
TAKING_DAMAGE_LASTS = 0.07

Wrap = function(value, lower, upper)
	if value > upper then return lower end
	if value < lower then return upper end
	return value
end

Clamp = function(value, lower, upper)
	if value > upper then return upper end
	if value < lower then return lower end
	return value
end

Bounds = {
	x_upper = 780,
	x_lower = 20,
	y_upper = 580,
	y_lower = 20,
	size_lower = 20,
	size_upper = 40,
}

GameState = {
	powerupTimer = 0,
	bossTimer = 0,
	bosses = {},
	monsters = {},
	powerups = {},
	decals = {},
	player = {
		hp = MAX_HP,
		score = 5,
	}
}

Monsters = {
	{
		name = "space",
		sprite = Sprites.monsters[1],
		hit = Sounds.hitMob,
		miss = Sounds.air
	},
	{
		name = "ghost",
		sprite = Sprites.monsters[2],
		hit = Sounds.hitMob,
		miss = Sounds.air
	},
	{
		name = "cringe",
		sprite = Sprites.monsters[3],
		hit = Sounds.hitMob,
		miss = Sounds.air
	},
}
