gameOver = GameState:new()

local timer = 0

function gameOver:start()
	timer = 0
	removeEntity(player)
	AB.graphics.resetColorTransforms(layers.FLASHY)
end

function gameOver:update()
	timer = timer + 1
	if (timer > 180) then
		setGameState(title)
	end

	--	add player splodes
	if (timer < 90) then
		local theta = AB.math.random() * math.pi * 2.0
		local radius = AB.math.random(timer + 30)
		local x = player.pos.x + math.cos(theta) * radius
		local y = player.pos.y - math.sin(theta) * radius
		addEntity(Splode:new(x, y))
	end
	
	updateEntities()
end

function gameOver:render()
	renderEntities()
	
	AB.font.setColor(font, 1, 1, 1, 1, 0)
	AB.font.printString(layers.INTERFACE, font, 400, 230, 8, AB.font.CENTER, "GAME OVER")

	AB.font.printString(layers.INTERFACE, font, 400, 280, 3, AB.font.CENTER, "FINAL SCORE: " .. game.scoreString)
end
