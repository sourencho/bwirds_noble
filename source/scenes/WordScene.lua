import 'scripts/WordScroller'
import 'scripts/WordList'


WordScene = {}
class("WordScene").extends(NobleScene)
local scene = WordScene


-- This is the background color of this scene.
scene.backgroundColor = Graphics.kColorWhite

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitining away from another scene.
function scene:init()
	scene.super.init(self)

	scene.tick = 0

	scene.letters = {}
	table.shallowcopy(Noble.GameData.letters, scene.letters)
	table.sort(scene.letters)

	scene:createWordScroller(scene.letters)

	scene.wordList = WordList.new(
		10 + 10 + 80 + 150 + 20,
		40,
		110
	)

	scene.buyerOne = NobleSprite("assets/images/test_face.png")
	scene.buyerTwo = NobleSprite("assets/images/test_face.png")
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function scene:enter()
	scene.super.enter(self)
	-- Your code here
	scene.buyerOne:add()
	scene.buyerTwo:add()
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
	scene.wordScroller:update()
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)
	-- Your code here
	Noble.Text.draw(
		"*BWAG*",
		50,
		10,
		Noble.Text.ALIGN_CENTER
	)
	Graphics.drawRoundRect(10, 30, 80, 200 + 2, 3)
	Graphics.drawRoundRect(10, 30, 80, 200 + 1, 3)
	Graphics.drawRoundRect(10, 30, 80, 200, 3)
	for r = 0, 8 do
		for c = 0, 1 do
			local n = r + 1 + c * 9
			if n <= #scene.letters then
				Noble.Text.draw(
					scene.letters[n],
					37 * (c + 1) - 5,
					10 + 30 + r * 20,
					Noble.Text.ALIGN_CENTER
				)
			end
		end
	end

	-- word scroller
	Graphics.drawRoundRect(10 + 10 + 80, 10, 150, 222, 3)
	Graphics.drawRoundRect(10 + 10 + 80, 10, 150, 221, 3)
	Graphics.drawRoundRect(10 + 10 + 80, 10, 150, 220, 3)
	scene.wordScroller:draw(scene.tick)

	-- word list
	Noble.Text.draw(
		"*BWIRDS*",
		10 + 10 + 80 + 150 + 10 + 55,
		10,
		Noble.Text.ALIGN_CENTER
	)
	Graphics.drawRoundRect(10 + 10 + 80 + 150 + 10, 30, 110, 120 + 2, 3)
	Graphics.drawRoundRect(10 + 10 + 80 + 150 + 10, 30, 110, 120 + 1, 3)
	Graphics.drawRoundRect(10 + 10 + 80 + 150 + 10, 30, 110, 120, 3)
	scene.wordList:draw()

	-- buyers
	local buyerBoxX = 10 + 10 + 80 + 150 + 10
	local buyerBoxY = 30 + 120 + 10
	Graphics.drawRoundRect(buyerBoxX, buyerBoxY, 110, 70 + 2, 3)
	Graphics.drawRoundRect(buyerBoxX, buyerBoxY, 110, 70 + 1, 3)
	Graphics.drawRoundRect(buyerBoxX, buyerBoxY, 110, 70, 3)
	scene.buyerOne:moveTo(buyerBoxX + 20, buyerBoxY + 10 + 10)
	scene.buyerTwo:moveTo(buyerBoxX + 20, buyerBoxY + 10 + 10 + 20 + 10)
	Noble.Text.draw(
		"-*ED*",
		buyerBoxX + 40,
		buyerBoxY + 10 + 1,
		Noble.Text.ALIGN_LEFT
	)
	Noble.Text.draw(
		"*PLURAL",
		buyerBoxX + 40,
		buyerBoxY + 10 + 20 + 10 + 1,
		Noble.Text.ALIGN_LEFT
	)

	-- NEXT
	local nextBoxX = 10 + 10 + 80 + 150 + 10 + 10 + 110
	Noble.Text.draw(
		"*>*",
		nextBoxX + 5,
		10,
		Noble.Text.ALIGN_CENTER
	)
	Graphics.drawRoundRect(nextBoxX, 30, 10, 200 + 2, 3)
	Graphics.drawRoundRect(nextBoxX, 30, 10, 200 + 1, 3)
	Graphics.drawRoundRect(nextBoxX, 30, 10, 200, 3)
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
	end,
	AButtonHold = function() -- Runs every frame while the player is holding button down.
		-- Your code here
	end,
	AButtonHeld = function() -- Runs after button is held for 1 second.
		-- Your code here
	end,
	AButtonUp = function() -- Runs once when button is released.
		-- Your code here
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
	end,
	BButtonUp = function()
		-- Your code here
	end,

	-- D-pad left
	--
	leftButtonDown = function()
		-- Your code here
		scene.wordScroller:prevItem()
	end,
	leftButtonHold = function()
		-- Your code here
	end,
	leftButtonUp = function()
		-- Your code here
	end,

	-- D-pad right
	--
	rightButtonDown = function()
		-- Your code here
		local submittedWord = scene.wordScroller:nextItem()
		if submittedWord ~= nil then
			scene:submitWord(submittedWord)
		end
	end,
	rightButtonHold = function()
		-- Your code here
	end,
	rightButtonUp = function()
		-- Your code here
	end,

	-- D-pad up
	--
	upButtonDown = function()
		-- Your code here
		scene.wordScroller:scrollUp()
	end,
	upButtonHold = function()
		-- Your code here
	end,
	upButtonUp = function()
		-- Your code here
	end,

	-- D-pad down
	--
	downButtonDown = function()
		-- Your code here
		scene.wordScroller:scrollDown()
	end,
	downButtonHold = function()
		-- Your code here
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

-- Custom methods

function scene:createWordScroller(letters)
	scene.wordScroller = WordScroller.new(
		10 + 80 + 10 + 8,
		20,
		letters
	)
end

function scene:submitWord(word)
	scene.wordList:addWord(word)

	-- remove used letters
	local usedLetterIndices = scene.wordScroller:getUsedLetters()
	for i = #usedLetterIndices, 1, -1 do
		if usedLetterIndices[i] then
			table.remove(scene.letters, i)
		end
	end

	scene:createWordScroller(scene.letters)
end
