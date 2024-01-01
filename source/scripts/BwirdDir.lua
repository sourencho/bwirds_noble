import 'scripts/Bwird'
import 'scripts/Bwird'
import 'constants/Def'


BwirdDir = {}

Bwird.MAX_COUNT = 30

function BwirdDir.new(__letterCorpus)
    local this = {}

    function this:init()
        self.bwirds = table.create(BwirdDir.MAX_COUNT, 0)

        self.letterCorpus = {}
        for _, l in ipairs(__letterCorpus) do
            self:addLetter(l)
        end

        self.bwird_count = 5

        for i = 1, self.bwird_count do
            self:addBwird()
        end
    end

    function this:addLetter(__l)
        self.letterCorpus[__l] = Def.LETTER_FREQ[__l]
    end

    function this:addBwird()
        local bwird = Bwird.new(
            table.randomWeighted(self.letterCorpus),
            math.random(0 + 10, 400 - Bwird.SIZE_X - 10),
            math.random(0 + 10, 240 - Bwird.SIZE_Y - 40)
        )
        table.insert(self.bwirds, bwird)
        bwird:add()
    end

    function this:removeBwirdByValue(__b)
        __b:remove()
        table.removeByValue(self.bwirds, __b)
    end

    function this:removeBwird(__i)
        self.bwirds[__i]:remove()
        table.remove(self.bwirds, __i)
    end

    function this:update(__tick)
        local removeCount = 0
        for i = #self.bwirds, 1, -1 do
            local bwird = self.bwirds[i]
            if bwird:isExpired() then
                self:removeBwird(i)
                removeCount += 1
            end
        end

        for i = 1, removeCount do
            self:addBwird()
        end
    end

    function this:draw(__tick)
        for _, bwird in ipairs(self.bwirds) do
            if __tick % 3 == 0 and bwird:expireTimeLeft() < 1000 then
                Graphics.setImageDrawMode(Graphics.kDrawModeFillBlack)
            end

            bwird:draw()

            if __tick % 3 == 0 and bwird:expireTimeLeft() < 1000 then
                Graphics.setImageDrawMode(Graphics.kDrawModeCopy)
            end
        end
    end

    function this:attemptCapture(__cursorPos, __cursorSize)
        local capturedLetters = {}

        for i = #self.bwirds, 1, -1 do
            local bwird = self.bwirds[i]
            local distSqr = Utilities.vDistSqr(bwird:getCenter(), __cursorPos)
            if (distSqr < Utilities.sqr(__cursorSize + 10)) then
                self:removeBwird(i)
                table.insert(capturedLetters, bwird.letter)
            end
        end

        for i = 1, #capturedLetters do
            self:addBwird()
        end

        return capturedLetters
    end

    this:init()

    return this
end
