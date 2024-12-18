-- dependencies
local love = require "love"
local moonshine = require "vendor/moonshine"

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
	local cursor = love.mouse.newCursor("assets/cursor.png")

	love.mouse.setCursor(cursor)

	Sounds.coin = love.audio.newSource("assets/coin-single.wav", "static")
	Sounds.coins = love.audio.newSource("assets/coin-many.wav", "static")
	Sounds.lost = love.audio.newSource("assets/coin-lost.wav", "static")
	Sounds.hit = love.audio.newSource("assets/hit.wav", "static")
	Sounds.air = love.audio.newSource("assets/air.wav", "static")
	Sounds.swordGet = love.audio.newSource("assets/sword-get.wav", "static")
end

Effect = moonshine(moonshine.effects.glow)
love.graphics.setNewFont("assets/JetBrainsMono-Bold.ttf", 30)
loadAssets()
