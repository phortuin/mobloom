-- audio https://github.com/vrld/slam
local moonshine = require "vendor/moonshine"
local love = require "love"

-- als je te laat een monster pakt, pakt hij geld van je af, of health
-- een monster moet je 2x klikken
-- een zwaardje zorgt ervoor dat je een monster maar 1x hoeft te klikken, blijft 5 kliks geldig

Money = 0;

function love.load()
	-- Effect = moonshine(moonshine.effects.crt)
	-- .chain(moonshine.effects.glow)
	Effect = moonshine(moonshine.effects.glow)

	Monsters = {}
	Monsters[1] = love.graphics.newImage("assets/space.png")
	Monsters[2] = love.graphics.newImage("assets/ghost.png")
	Monsters[3] = love.graphics.newImage("assets/cringe.png")

	Bag = love.graphics.newImage("assets/bag.png")
	Dollar = love.graphics.newImage("assets/dollar.png")

	Sword = love.graphics.newImage("assets/sword.png")

	Coin = love.audio.newSource("assets/coin-single.wav", "static")
	Coins = love.audio.newSource("assets/coin-many.wav", "static")
	Lost = love.audio.newSource("assets/coin-lost.wav", "static")
	Hit = love.audio.newSource("assets/hit.wav", "static")
	Air = love.audio.newSource("assets/air.wav", "static")
	SwordGet = love.audio.newSource("assets/sword-get.wav", "static")

	love.graphics.setNewFont("assets/JetBrainsMono-Bold.ttf", 30)
	MoneyX = math.random(0, 790)
	MoneyY = math.random(0, 590)
	Size = 20
	Winnings = 0
	WinningsX = 0
	WinningsY = 0
	WinningsAlpha = 255
	ShowWinnings = false
	Rot = 0
	Monster = Monsters[math.random(#Monsters)]
	DrawMoney = math.random() > 0.8
	DrawBag = math.random() > 0.5
	DrawSword = math.random() > 0.8
end

function love.update(dt)
	if MoneyX > 790 then
		MoneyX = -10
	end
	if MoneyX < 10 then
		MoneyX = 790
	end
	if MoneyY > 590 then
		MoneyY = -10
	end
	if MoneyY < 10 then
		MoneyY = 590
	end
	MoneyX = MoneyX + math.random(-2, 2)
	MoneyY = MoneyY + math.random(-2, 2)
	Rot = Rot + math.random(-2, 2)
	Size = Size + math.random(-1, 1)
	if Size > 40 then Size = 40 end
	if Size < 20 then Size = 20 end
	if ShowWinnings and DrawMoney then
		WinningsAlpha = WinningsAlpha - (dt * (255))
		if Winnings > 0 then
			WinningsY = WinningsY - 1
		else
			WinningsY = WinningsY + 1
		end
		if WinningsAlpha < 0 then
			ShowWinnings = false
			WinningsAlpha = 255
		end
	end
end

function love.draw()
	Effect(function()
		love.graphics.setColor(1, 0.8, 0.2, 255)
		love.graphics.print("$", 700, 50)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print(Money, 730, 50)
		if DrawSword then
			PrintRandomSword()
		elseif DrawMoney then
			PrintRandomMoney()
		else
			PrintRandomMonster()
		end
		-- showwinnings werkt niet goed meer want hij timet verkeerd; in mousepressed wordt showwinnings gezet
		-- en dan in de update wordt iets anders gerenderd. dus je krijgt bij een -5 nooit meer die dalende 5 want
		-- hij denkt dat hij een monster aan het renderen is
		if ShowWinnings and DrawMoney then
			if Winnings < 0 then
				love.graphics.setColor(1, 0, 0, WinningsAlpha / 255)
			else
				love.graphics.setColor(1, 0.8, 0.2, WinningsAlpha / 255)
			end
			love.graphics.print(Winnings, WinningsX - 8, WinningsY - 15)
		end
	end)
end

function PrintRandomMoney()
	local offset = Size / 2
	love.graphics.setColor(1, 1, 1)
	if DrawBag then
		love.graphics.draw(Bag, MoneyX + offset, MoneyY + offset, math.rad(Rot), Size / 8, Size / 8, 4, 4)
	else
		love.graphics.draw(Dollar, MoneyX + offset, MoneyY + offset, math.rad(Rot), Size / 8, Size / 8, 4, 4)
	end
end

function PrintRandomMonster()
	local offset = Size / 2
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Monster, MoneyX + offset, MoneyY + offset, math.rad(Rot), Size / 8, Size / 8, 4, 4)
end

function PrintRandomSword()
	local offset = Size / 2
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Sword, MoneyX + offset, MoneyY + offset, math.rad(Rot), Size / 8, Size / 8, 4, 4)
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if DrawMoney and not DrawSword then
			if x > MoneyX and x < MoneyX + Size and y > MoneyY and y < MoneyY + Size then
				Winnings = DrawBag and 3 or 1
				ShowWinnings = true
			else
				Winnings = -5
			end
			if Winnings == 3 then
				Coins:stop()
				Coins:play()
			elseif Winnings == 1 then
				Coin:stop()
				Coin:play()
			else
				Lost:stop()
				Lost:play()
			end
		elseif DrawSword then
			Winnings = 0
			if x > MoneyX and x < MoneyX + Size and y > MoneyY and y < MoneyY + Size then
				SwordGet:stop()
				SwordGet:play()
			else
				Air:stop()
				Air:play()
			end
		else
			Winnings = 0
			if x > MoneyX and x < MoneyX + Size and y > MoneyY and y < MoneyY + Size then
				Hit:stop()
				Hit:play()
			else
				Air:stop()
				Air:play()
			end
		end
		Monster = Monsters[math.random(#Monsters)]
		DrawMoney = math.random() > 0.8
		DrawBag = math.random() > 0.5
		DrawSword = math.random() > 0.8
		Size = 30
		Rot = 0
		Money = Money + Winnings
		WinningsAlpha = 255
		WinningsX = x
		WinningsY = y
		MoneyX = math.random(0, 790)
		MoneyY = math.random(0, 590)
	end
end
