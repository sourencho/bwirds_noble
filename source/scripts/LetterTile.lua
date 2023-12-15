LetterTile = {}

LetterTile.LETTER_OFFSET_X = 25
LetterTile.LETTER_OFFSET_Y = 12

function LetterTile.new(__letter, __x, __y)
    local letterTile = {}

    letterTile.letter = __letter
    letterTile.letterStr = "*"..__letter.."*"
    letterTile.x = __x
    letterTile.y = __y

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
        self.tileSprite:draw(self.x, self.y)
        Noble.Text.draw(
            self.letterStr,
            self.x+LetterTile.LETTER_OFFSET_X,
            self.y+LetterTile.LETTER_OFFSET_Y
        )
    end

    return letterTile
end