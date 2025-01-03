-- init; loads assets and sets globals
require "lib.init"
local Gameplay = require "src.states.gameplay"

-- als je te laat een monster pakt, pakt hij geld van je af, of health
-- een monster moet je 2x klikken
-- een zwaardje zorgt ervoor dat je een monster maar 1x hoeft te klikken, blijft 5 kliks geldig
-- hover over mob verandert cursor
-- paddestoel die te lang blijft, wordt giftig
-- giftige paddestoel spawnt meer paddestoelen (gpt zei "en monsters" :D) en als je daar overheen muist gaat je muis trager. of verlies je health?
-- effect/event triggers en handlers
-- health bars!

local currentState

function love.load()
	currentState = Gameplay
	currentState:enter()
end

function love.update(dt)
	currentState:update(dt)
end

function love.draw()
	Effect(function()
		currentState:draw()
	end)
end

function love.mousepressed(x, y, button)
	currentState:mousepressed(x, y, button)
end
