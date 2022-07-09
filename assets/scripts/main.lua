--[[

	Mustard Engine sample project
	
	Andrew Krause
	2022.07.09

]]

-- globals!
CANVAS_WIDTH = 800
CANVAS_HEIGHT = 480
CANVAS_CENTER_X = CANVAS_WIDTH / 2
CANVAS_CENTER_Y = CANVAS_HEIGHT / 2

local timer = 0

--  called once at engine startup just to set up parameters for the video subsystem.
--  these could be read from a configuration file.
function AB.loadConfig()
	videoConfig = {
		title = "SAMPLE PROJECT",
		xRes = 800,
		yRes = 480,
		
		xOffset = 0,
		yOffset = 0,
		xScale = 1,
		yScale = 1,
		
		fullscreen = false,
		vsync = true,
	}
end

--	called once after all engine subsystems have been initialized and we're ready to run.
--	this is where you'll want to load assets and set up state
function AB.init()
	-- seed the RNG and note the seed value for deterministic replays
	AB.math.randomSeed()
	AB.math.noiseSeed(AB.math.random(2 ^ 32 - 1))

	local seed = AB.math.random(2 ^ 32 - 1)
	AB.system.log("Random seed: " .. seed)
	AB.math.randomSeed(seed)

	-- load scripts
	AB.system.loadScript("core/gameState.lua")
	AB.system.loadScript("core/entityManager.lua")
	AB.system.loadScript("core/vector2d.lua")
	
	AB.system.loadScript("gameStates/title.lua")
	AB.system.loadScript("gameStates/game.lua")
	AB.system.loadScript("gameStates/gameOver.lua")
	
	AB.system.loadScript("entities/player.lua")
	AB.system.loadScript("entities/laser.lua")
	AB.system.loadScript("entities/enemy.lua")
	AB.system.loadScript("entities/splode.lua")

	-- load A/V assets
	gfx = {
		PLAYER = AB.graphics.loadSprite("gfx/player.tga"),
		LASER = AB.graphics.loadSprite("gfx/laser.tga"),
		ENEMY = AB.graphics.loadAtlas("gfx/enemy.tga", 40, 40, true)
	}

	sfx = {
		START = AB.audio.loadSound("sfx/start.wav"),
		LASER = AB.audio.loadSound("sfx/laser.wav"),
		OUCH = AB.audio.loadSound("sfx/ouch.wav"),
		SPLODE = AB.audio.loadSound("sfx/splode.wav"),
		PLAYER_SPLODE = AB.audio.loadSound("sfx/playerSplode.wav")
	}
	
	music = AB.audio.loadMusic("music/musicLoop.ogg", 4, 150)
	AB.audio.playMusic(music)

	font = AB.font.loadFont("default3")
	
	-- create layers and canvas
	layers = {
		DEFAULT = 0,
		INTERFACE = AB.graphics.createLayer(1),
		FLASHY = AB.graphics.createLayer(2),
		SPRITES = AB.graphics.createLayer(3),
		BACKGROUND = AB.graphics.createLayer(4)
	}
	canvas = AB.graphics.createCanvas(800, 480)
	AB.input.showCursor(false)
	
	setGameState(title)
end

--	called at 60hz
function AB.update()
	timer = timer + 1
	
	currentState:update()

	AB.graphics.addColorTransform(layers.DEFAULT, AB.graphics.colorTransforms.HUE_SHIFT, 0.01)
end

--  it renders
function AB.render()
	AB.graphics.useCanvas(canvas)
	AB.graphics.clear()
	
	--	draw background thinger
	AB.graphics.setColor(0.15, 0.25, 0.25, 0.25, 1.0)
	for y = 0, CANVAS_HEIGHT, 20 do
		for x = 0, CANVAS_WIDTH, 20 do
			-- these numbers are pretty arbitrary (futzed around until i found something that looked good)
			local size = AB.math.noise(x / 1000, y / 1000, timer / 1000, 4, 8) * 30 + 20
			AB.graphics.renderQuad(layers.BACKGROUND, size, size, x, y)
		end
	end
	
	currentState:render()
	
	AB.graphics.setColor()
	AB.graphics.useCanvas(0)
	AB.graphics.renderCanvas(layers.DEFAULT, canvas, CANVAS_CENTER_X, CANVAS_CENTER_Y, -1, 0)
end

-- you can optionally implement other callback functions
function AB.onKeyPressed(key)
	if (key == AB.input.scancodes.ESCAPE) then
		if (currentState == title) then
			AB.system.quit()
		else
			setGameState(title)
		end
	end
end

function AB.onGamepadPressed(index, button)
	if (button == AB.input.gamepadButtons.BACK) then
		if (currentState == title) then
			AB.system.quit()
		else
			setGameState(title)
		end
	end
end

