-- init; loads assets and sets globals
require "lib.init"
local Gameplay = require "src.states.gameplay"

--[x] als je te laat een monster pakt, pakt hij geld van je af, of health
--[ ] een zwaardje maakt je hits sterker, blijft 5 kliks geldig
--[ ] hover over mob verandert cursor
--[x] paddestoel die te lang blijft, wordt giftig
--[ ] giftige paddestoel spawnt meer paddestoelen (gpt zei "en monsters" :D) en als je daar overheen muist gaat je muis trager. of verlies je health?
--[ ] effect/event triggers en handlers
--[x] health bars!
--[ ] als boss een monster raakt, healt hij. of het andere monster wordt ook een boss
--[ ] als boss te lang blijft, wordt hij een giftige boss (of een boss die monsters spawnt)
--[x] powerup die alle monsters doodt
--[ ] levels, na verloop van tijd, x mobs of x punten wordt het moeilijker: minimaal 2 mobs in het scherm, snellere aanvalstijd, boss is sterker
--[x] bolt maakt goede shroom rot, of haalt rotte shroom weg
--[x] coins moeten naar je pijl toe trekken
--[ ] monsters die je niet aan mag raken (ze houden je pijl vast)
--[ ] monsters in het donker; hoe verder af van het midden, hoe donkerder

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
