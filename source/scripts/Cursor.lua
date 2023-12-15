Cursor = {}

function Cursor.new(__x, __y, __minSize, __maxSize)
    local cursor = {}

    cursor.x = __x
    cursor.y = __y
    cursor.minSize = __minSize
    cursor.maxSize = __maxSize

    cursor.size = __minSize
    cursor.speed = 7
    cursor.input = {x=0, y=0}

    function cursor:draw()
        playdate.graphics.drawCircleAtPoint(
            self.x,
            self.y,
            self.size
        )
        playdate.graphics.fillCircleAtPoint(
            self.x,
            self.y,
            self.size - 3
        )
    end

    function cursor:applyInput(__x, __y)
        self.input.x += __x
        self.input.y += __y
    end

    function cursor:update()
        -- move
        local delta = self.input

        delta = Utilities.vNorm(delta)

        self.x += delta.x * self.speed
        self.y += delta.y * self.speed

        self.input = {x=0, y=0}
    end


    return cursor
end