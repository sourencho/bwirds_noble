import 'scripts/Bwird'
import 'scripts/Cursor'
import 'scripts/Bag'
import 'scenes/WordScene'


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
	CollectScene.tick = 0
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function scene:enter()
	scene.super.enter(self)

	-- Your code here
	initTiles()
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
	CollectScene.tick += 1
	self.cursor:update()
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)
	-- Your code here
	drawTiles()
	scene.cursor:draw()
	scene.bag:draw()
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
		attemptCapture()
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
		Noble.transition(WordScene, nil, Noble.Transition.SlideOffLeft)
	end,
	BButtonHold = function()
		-- Your code here
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

function initTiles()
	local letters = { "A", "B", "C", "D", "E", "F", "G", "H" }
	scene.letterTiles = table.create(#letters, 0)

	for i = 1, #letters do
		local bwird = Bwird.new(
			letters[i],
			math.random(0 + 10, 400 - Bwird.SIZE_X - 10),
			math.random(0 + 10, 240 - Bwird.SIZE_Y - 40)
		)
		table.insert(scene.letterTiles, bwird)
		bwird:add()
	end
end

function drawTiles()
	for i = 1, #scene.letterTiles do
		local tile = scene.letterTiles[i]
		if tile == nil then
			goto cont
		end
		tile:draw()
		::cont::
	end
end

function attemptCapture()
	for i = #scene.letterTiles, 1, -1 do
		local tile = scene.letterTiles[i]
		if tile == nil then -- todo: figure out how to do continue in lua
			goto cont
		end
		local distSqr = Utilities.vDistSqr(tile:getCenter(), scene.cursor.pos)
		if (distSqr < Utilities.sqr(scene.cursor.size + 10)) then
			scene.bag:addLetter(tile.letter)
			table.remove(scene.letterTiles, i)
			tile:remove()
		end
		::cont::
	end
end