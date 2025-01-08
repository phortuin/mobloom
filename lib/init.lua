-- dependencies
local moonshine = require "vendor.moonshine"

Sprites = {}
Sounds = {}

local function loadAssets()
	Sprites.monsters = {
		[1] = love.graphics.newImage("assets/sprites/space.png"),
		[2] = love.graphics.newImage("assets/sprites/ghost.png"),
		[3] = love.graphics.newImage("assets/sprites/cringe.png"),
	}
	Sprites.moneys = {
		[1] = love.graphics.newImage("assets/sprites/bag.png"),
		[2] = love.graphics.newImage("assets/sprites/dollar.png"),
	}
	Sprites.sword = love.graphics.newImage("assets/sprites/sword.png")
	Sprites.heart = love.graphics.newImage("assets/sprites/heart.png")
	Sprites.shroom = love.graphics.newImage("assets/sprites/shroom.png")
	Sprites.shroomBad = love.graphics.newImage("assets/sprites/shroom-bad.png")
	Sprites.boss = love.graphics.newImage("assets/sprites/boss-tree.png")
	Sprites.splat = love.graphics.newImage("assets/sprites/splat.png")
	Sprites.coin = love.graphics.newImage("assets/sprites/coin.png")
	local cursor = love.mouse.newCursor("assets/sprites/cursor.png")

	love.mouse.setCursor(cursor)

	Sounds.coin = love.audio.newSource("assets/sounds/coin-single.wav", "static")
	Sounds.coinDing = love.audio.newSource("assets/sounds/coin-ding.wav", "static")
	Sounds.coins = love.audio.newSource("assets/sounds/coin-many.wav", "static")
	Sounds.lost = love.audio.newSource("assets/sounds/coin-lost.wav", "static")
	Sounds.hit = love.audio.newSource("assets/sounds/hit.wav", "static")
	Sounds.hitMob = love.audio.newSource("assets/sounds/hit-mob.wav", "static")
	Sounds.mobDie = love.audio.newSource("assets/sounds/mob-die.wav", "static")
	Sounds.air = love.audio.newSource("assets/sounds/air.wav", "static")
	Sounds.swordGet = love.audio.newSource("assets/sounds/sword-get.wav", "static")
	Sounds.heal = love.audio.newSource("assets/sounds/heal.wav", "static")
	Sounds.shroomBad = love.audio.newSource("assets/sounds/shroom-bad.wav", "static")
end

Effect = moonshine(moonshine.effects.glow)
love.graphics.setNewFont("assets/fonts/JetBrainsMono-Bold.ttf", 30)
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

COIN_LASTS = 3

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
	size_lower = 24,
	size_upper = 48,
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
