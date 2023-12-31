import 'scenes/WordScene'
import 'scripts/BwirdDir'
import 'scripts/Bwird'
import 'scripts/Cursor'
import 'scripts/Bag'
import 'constants/Def'


CollectScene = {}
class("CollectScene").extends(NobleScene)
local scene = CollectScene

-- It is recommended that you declare, but don't yet define,
-- your scene-specific varibles and methods here. Use "local" where possible.
--
-- local variable1 = nil	-- local variable
-- scene.variable2 = nil	-- Scene variable.
--							   When accessed outside this file use SceneTemplate.variable2.
-- ...
--

-- This is the background color of this scene.
scene.backgroundColor = Graphics.kColorWhite

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitining away from another scene.
function scene:init()
	scene.super.init(self)

	-- variable1 = 100
	-- SceneTemplate.variable2 = "string"
	-- ...

	-- Your code here
	scene.tick = 0
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function scene:enter()
	scene.super.enter(self)

	-- Your code here
	scene.roundEndTime = playdate.getCurrentTimeMilliseconds() +
		Def.COLLECT_ROUND_TIME

	local letters = {
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
		"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	}
	scene.bwirdDir = BwirdDir.new(letters)

	scene.cursor = Cursor.new(200, 200, 8)
	scene.bag = Bag.new()
end

-- This runs once a transition from another scene is complete.
function scene:start()
	scene.super.start(self)
	-- Your code here
end

-- This runs once per frame.
function scene:update()
	scene.super.update(self)

	-- Your code here
	scene.tick += 1

	if playdate.getCurrentTimeMilliseconds() > self.roundEndTime then
		scene:switchToWordScene()
	end

	self.bwirdDir:update(scene.tick)
	self.cursor:update()
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)
	-- Your code here
	scene.bwirdDir:draw(scene.tick)
	scene.cursor:draw()
	scene.bag:draw()

	-- UI
	Noble.Text.draw(
		math.floor((self.roundEndTime - playdate.getCurrentTimeMilliseconds()) /
			1000),
		Def.SCREEN.x - 16,
		Def.SCREEN.y - 20,
		Noble.Text.ALIGN_CENTER
	)
end

-- This runs as as soon as a transition to another scene begins.
function scene:exit()
	scene.super.exit(self)
	-- Your code here
end

-- This runs once a transition to another scene completes.
function scene:finish()
	scene.super.finish(self)
	-- Your code here
end

function scene:pause()
	scene.super.pause(self)
	-- Your code here
end

function scene:resume()
	scene.super.resume(self)
	-- Your code here
end

-- Define the inputHander for this scene here, or use a previously defined inputHandler.

-- scene.inputHandler = someOtherInputHandler
-- OR
scene.inputHandler = {

	-- A button
	--
	AButtonDown = function() -- Runs once when button is pressed.
		-- Your code here
		scene.cursor:applyAInputDown()
	end,
	AButtonHold = function() -- Runs every frame while the player is holding button down.
		-- Your code here
	end,
	AButtonHeld = function() -- Runs after button is held for 1 second.
		-- Your code here
		scene.cursor:applyAInputHeld()
		local caputuredLetters = scene.bwirdDir:attemptCapture(
			scene.cursor.pos,
			scene.cursor.size
		)
		for _, l in ipairs(caputuredLetters) do
			scene.bag:addLetter(l)
		end
	end,
	AButtonUp = function() -- Runs once when button is released.
		-- Your code here
		scene.cursor:applyAInputUp()
	end,

	-- B button
	--
	BButtonDown = function()
		-- Your code here
	end,
	BButtonHeld = function()
		-- Your code here
	end,
	BButtonHold = function()
		-- Your code here
		Display.setInverted(true)
	end,
	BButtonUp = function()
		-- Your code here
	end,

	-- D-pad left
	--
	leftButtonDown = function()
		-- Your code here
		scene.cursor:applyMoveInput(-1, 0)
	end,
	leftButtonHold = function()
		-- Your code here
		scene.cursor:applyMoveInput(-1, 0)
	end,
	leftButtonUp = function()
		-- Your code here
	end,

	-- D-pad right
	--
	rightButtonDown = function()
		-- Your code here
		scene.cursor:applyMoveInput(1, 0)
	end,
	rightButtonHold = function()
		-- Your code here
		scene.cursor:applyMoveInput(1, 0)
	end,
	rightButtonUp = function()
		-- Your code here
	end,

	-- D-pad up
	--
	upButtonDown = function()
		-- Your code here
		scene.cursor:applyMoveInput(0, -1)
	end,
	upButtonHold = function()
		-- Your code here
		scene.cursor:applyMoveInput(0, -1)
	end,
	upButtonUp = function()
		-- Your code here
	end,

	-- D-pad down
	--
	downButtonDown = function()
		-- Your code here
		scene.cursor:applyMoveInput(0, 1)
	end,
	downButtonHold = function()
		-- Your code here
		scene.cursor:applyMoveInput(0, 1)
	end,
	downButtonUp = function()
		-- Your code here
	end,

	-- Crank
	--
	cranked = function(change, acceleratedChange) -- Runs when the crank is rotated. See Playdate SDK documentation for details.
		-- Your code here
	end,
	crankDocked = function() -- Runs once when when crank is docked.
		-- Your code here
	end,
	crankUndocked = function() -- Runs once when when crank is undocked.
		-- Your code here
	end
}

function scene:switchToWordScene()
	Noble.GameData.letters = {}
	table.shallowcopy(scene.bag.letters, Noble.GameData.letters)
	Noble.transition(WordScene, nil, Noble.Transition.SlideOffLeft)
end
