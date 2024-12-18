-- audio https://github.com/vrld/slam
local moonshine = require "vendor/moonshine"
local love = require "love"

Money = 0;

function love.load()
	-- Effect = moonshine(moonshine.effects.crt)
	-- .chain(moonshine.effects.glow)
	Effect = moonshine(moonshine.effects.glow)

	Coin = love.audio.newSource("assets/coin-single.wav", "static")
	Coins = love.audio.newSource("assets/coin-many.wav", "static")
	Lost = love.audio.newSource("assets/coin-lost.wav", "static")
	love.graphics.setNewFont("assets/JetBrainsMono-Bold.ttf", 30)
	MoneyX = math.random(0, 790)
	MoneyY = math.random(0, 590)
	Size = 20
	Winnings = 0
	WinningsX = 0
	WinningsY = 0
	WinningsAlpha = 255
	ShowWinnings = false
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
	Size = Size + math.random(-1, 1)
	if Size > 40 then Size = 40 end
	if Size < 20 then Size = 20 end
	if ShowWinnings then
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
		PrintRandomMoney()
		if ShowWinnings then
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
	love.graphics.rectangle("fill", MoneyX, MoneyY, Size, Size, 8, 8)
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		if x > MoneyX and x < MoneyX + Size and y > MoneyY and y < MoneyY + Size then
			Winnings = math.ceil(((40 - Size) / 5) + 1)
		else
			Winnings = -5
		end
		if Winnings > 3 then
			Coins:stop()
			Coins:play()
		elseif Winnings > 0 then
			Coin:stop()
			Coin:play()
		else
			Lost:stop()
			Lost:play()
		end
		Size = 30
		Money = Money + Winnings
		ShowWinnings = true
		WinningsAlpha = 255
		WinningsX = x
		WinningsY = y
		MoneyX = math.random(0, 790)
		MoneyY = math.random(0, 590)
	end
end
