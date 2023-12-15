LetterTile = {}

LetterTile.LETTER_OFFSET_X = 25
LetterTile.LETTER_OFFSET_Y = 12
LetterTile.SIZE_X = 60
LetterTile.SIZE_Y = 40

function LetterTile.new(__letter, __x, __y)
    local letterTile = {}


    letterTile.letter = __letter
    letterTile.letterStr = "*"..__letter.."*"
    letterTile.pos = {x=__x, y=__y}

    -- Create animated sprite
    letterTile.tileImage = Graphics.imagetable.new("assets/images/tile_small")
    letterTile.tileAnimation = Noble.Animation.new(letterTile.tileImage)
    letterTile.tileAnimation:addState("default", 1, 2, nil, true, nil, 8)
    letterTile.tileSprite = NobleSprite(letterTile.tileAnimation)


    function letterTile:add()
        self.tileSprite:add()
    end

    function letterTile:remove()
        self.tileSprite:remove()
    end

    function letterTile:draw()
        self.tileSprite:draw(self.pos.x, self.pos.y)
        Noble.Text.draw(
            self.letterStr,
            self.pos.x+LetterTile.LETTER_OFFSET_X,
            self.pos.y+LetterTile.LETTER_OFFSET_Y
        )
    end

    function letterTile:getCenter()
        return {
            x=self.pos.x+LetterTile.SIZE_X/2,
            y=self.pos.y+LetterTile.SIZE_Y/2,
        }
    end

    return letterTile
end