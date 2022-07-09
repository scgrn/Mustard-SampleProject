game = GameState:new()

local timer
local paused
local score

function game:start()
	timer = 0
	paused = false
	score = 0
	game.scoreString = "0"
	
	clearEntities()
	
	player = Player:new()
	addEntity(player)
	
	AB.audio.playSound(sfx.LASER, 1, 0, true)
end

-- it's kinda wild that Lua's string library doesn't include this.
function string.insert(str1, str2, pos)
    return str1:sub(1, pos) .. str2 .. str1:sub(pos + 1)
end

function game:score(points)
	score = score + points
	game.scoreString = "" .. score
	
	--	add thousands separators
	local offset = 3
	for i = 0, 3 do
		if (string.len(game.scoreString) > offset) then
			game.scoreString = string.insert(game.scoreString, ",", string.len(game.scoreString) - offset)
			offset = offset + 4
		end
	end
end

function game:update()
	local MIN_ENEMIES = 5
	local MAX_ENEMIES = 20
	local ENEMY_SPAWN_RATE = 30 	-- in frames
	
	--	check for pause
	if (AB.input.keyWasPressed(AB.input.scancodes.RETURN) or
		AB.input.gamepadWasPressed(AB.input.gamepadButtons.START)) then
		
		paused = not paused
		
		if (paused) then
			AB.audio.stopSound(sfx.LASER)
		else
			AB.audio.playSound(sfx.LASER, 1, 0, true)
		end
	end

	if (not paused) then
		timer = timer + 1
		
		-- spwan enemies regularly
		if (timer % ENEMY_SPAWN_RATE == 0 and getEntityCount("enemy") < MAX_ENEMIES) then
			for i = 1, math.max(MIN_ENEMIES - getEntityCount("enemy"), 1) do
				local theta = AB.math.random() * math.pi * 2.0
				local x = CANVAS_CENTER_X + math.cos(theta) * 450
				local y = CANVAS_CENTER_Y - math.sin(theta) * 450
				addEntity(Enemy:new(x, y))
			end
		end
		
		updateEntities()
	end
	
	-- update flashy layer
	AB.graphics.resetColorTransforms(layers.FLASHY)
	AB.graphics.addColorTransform(layers.FLASHY, AB.graphics.colorTransforms.COLOR_FILL, 0, math.floor(timer / 3) % 2, 0, 1.0)
end

function game:render()
	renderEntities()
	
	--	health bar
	AB.graphics.setColor(0, 0, 0, 1, 0)
	AB.graphics.renderQuad(layers.INTERFACE, 606, 12, 400, 460)

	local length = player.hp * 60 
	local center = length / 2 + 100
	AB.graphics.setColor(1, 0.1875, 0, 1, 0.5)
	AB.graphics.renderQuad(layers.INTERFACE, length, 6, center, 460)

	AB.font.setColor(font, 1, 1, 1, 1, 0)
	AB.font.printString(layers.INTERFACE, font, 400, 30, 3, AB.font.CENTER, game.scoreString)

	--	pause
	if (paused) then
		AB.graphics.setColor(0, 0, 0, 1, 0.5)
		AB.graphics.renderQuad(layers.INTERFACE, 800, 600, 400, 300)

		AB.font.setColor(font, 1, 1, 1, 1, 0)
		AB.font.printString(layers.INTERFACE, font, 400, 240, 4, AB.font.CENTER, "PAUSED")
	end
end
