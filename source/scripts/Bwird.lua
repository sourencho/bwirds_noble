Bwird = {}

Bwird.LETTER_OFFSET_X = 0
Bwird.LETTER_OFFSET_Y = -9
Bwird.SIZE_X = 60
Bwird.SIZE_Y = 40

Bwird.EXPIRE_TIME_MIN = 5
Bwird.EXPIRE_TIME_MAX = 10

function Bwird.new(__letter, __x, __y)
    local this = {}

    function this:add()
        self.tileSprite:add()
    end

    function this:remove()
        self.tileSprite:remove()
    end

    function this:draw()
        self.tileSprite:draw(self.pos.x, self.pos.y)
        Noble.Text.draw(
            self.letterStr,
            self.pos.x + Bwird.LETTER_OFFSET_X + (Bwird.SIZE_X / 2),
            self.pos.y + Bwird.LETTER_OFFSET_Y + (Bwird.SIZE_Y / 2),
            Noble.Text.ALIGN_CENTER
        )
    end

    function this:getCenter()
        return {
            x = self.pos.x + Bwird.SIZE_X / 2,
            y = self.pos.y + Bwird.SIZE_Y / 2,
        }
    end

    function this:init(x, y, letter)
        self.letter = letter
        self.letterStr = "*" .. letter .. "*"
        self.pos = { x = x, y = y }

        -- Create animated sprite
        self.tileImage = Graphics.imagetable.new("assets/images/tile_small")
        self.tileAnimation = Noble.Animation.new(self.tileImage)
        self.tileAnimation:addState("default", 1, 2, nil, true, nil, 8)
        self.tileSprite = NobleSprite(self.tileAnimation)

        -- expiration
        self.expire_time = playdate.getCurrentTimeMilliseconds() +
            1000 * math.random(Bwird.EXPIRE_TIME_MIN, Bwird.EXPIRE_TIME_MAX)
    end

    function this:isExpired()
        return self:expireTimeLeft() <= 0
    end

    function this:expireTimeLeft()
        return self.expire_time - playdate.getCurrentTimeMilliseconds()
    end

    this:init(__x, __y, __letter)

    return this
end
