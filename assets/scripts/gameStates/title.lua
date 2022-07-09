title = GameState:new()

local timer
local exiting
local fadeAlpha

local introShown = false

function title:start()
	timer = 0
	exiting = false
	
	fadeAlpha = 1

	AB.audio.stopSound(sfx.LASER)
end

function title:update()
	timer = timer + 1
	if (timer > 190) then
		introShown = true
	end

	if (introShown) then
		if (AB.input.keyWasPressed(AB.input.scancodes.SPACE) or
			AB.input.gamepadWasPressed(AB.input.gamepadButtons.START)) then

			exiting = true
			AB.audio.playSound(sfx.START)
		end
	end
	
	if (exiting) then
		fadeAlpha = fadeAlpha + 0.05
		if (fadeAlpha > 1.0) then
			setGameState(game)
		end
	else
		if (fadeAlpha > 0) then
			if (introShown) then
				fadeAlpha = fadeAlpha - 0.1
			else
				fadeAlpha = fadeAlpha - 0.01
			end
		end
	end
end

function title:render()
	AB.font.setColor(font, 1, 1, 1, 1, 0)

	if (timer < 190 and not introShown) then
		--	"intro"
		local y = 140 + (130 - (math.max(timer - 60, 1)))
		AB.font.printString(layers.INTERFACE, font, 400, y, 12, AB.font.CENTER, "BATTLESNAKE II ")
	else
		AB.font.printString(layers.INTERFACE, font, 400, 140, 12, AB.font.CENTER, "BATTLESNAKE II:")
		AB.font.printString(layers.INTERFACE, font, 400, 185, 4, AB.font.CENTER, "SKIRMISH AT THE SUPERNOVA CLUSTER")

		if (AB.input.showGamepadControls()) then
			AB.font.printString(layers.INTERFACE, font, 400, 270, 3, AB.font.CENTER, "LEFT THUMBSTICK OR D-PAD TO MOVE")
			AB.font.printString(layers.INTERFACE, font, 400, 300, 3, AB.font.CENTER, "RIGHT THUMBSTICK TO ROTATE")
		else
			AB.font.printString(layers.INTERFACE, font, 400, 270, 3, AB.font.CENTER, "CURSORS MOVE")
			AB.font.printString(layers.INTERFACE, font, 400, 300, 3, AB.font.CENTER, "Z / X ROTATE")
		end

		local alpha = math.abs(math.cos(timer / 10.0))
		AB.font.setColor(font, 1, 1, 1, alpha, alpha)
		if (AB.input.showGamepadControls()) then
			AB.font.printString(layers.INTERFACE, font, 400, 400, 3, AB.font.CENTER, "- PRESS START -")
		else
			AB.font.printString(layers.INTERFACE, font, 400, 400, 3, AB.font.CENTER, "- PRESS SPACE TO START -")
		end
	end
	
	AB.graphics.flushGraphics()
	AB.graphics.setColor(0, 0, 0, 1, 1 - fadeAlpha)
	AB.graphics.renderQuad(layers.INTERFACE, 800, 600, 400, 300)
end
