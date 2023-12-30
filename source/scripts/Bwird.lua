Bwird = {}

Bwird.LETTER_OFFSET_X = 25
Bwird.LETTER_OFFSET_Y = 12
Bwird.SIZE_X = 60
Bwird.SIZE_Y = 40

function Bwird.new(__letter, __x, __y)
    local bwird = {}


    bwird.letter = __letter
    bwird.letterStr = "*" .. __letter .. "*"
    bwird.pos = { x = __x, y = __y }

    -- Create animated sprite
    bwird.tileImage = Graphics.imagetable.new("assets/images/tile_small")
    bwird.tileAnimation = Noble.Animation.new(bwird.tileImage)
    bwird.tileAnimation:addState("default", 1, 2, nil, true, nil, 8)
    bwird.tileSprite = NobleSprite(bwird.tileAnimation)


    function bwird:add()
        self.tileSprite:add()
    end

    function bwird:remove()
        self.tileSprite:remove()
    end

    function bwird:draw()
        self.tileSprite:draw(self.pos.x, self.pos.y)
        Noble.Text.draw(
            self.letterStr,
            self.pos.x + Bwird.LETTER_OFFSET_X,
            self.pos.y + Bwird.LETTER_OFFSET_Y
        )
    end

    function bwird:getCenter()
        return {
            x = self.pos.x + Bwird.SIZE_X / 2,
            y = self.pos.y + Bwird.SIZE_Y / 2,
        }
    end

    return bwird
end
