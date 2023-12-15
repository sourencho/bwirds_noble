Cursor = {}

function Cursor.new(__x, __y, __minSize, __maxSize)
    local cursor = {}


    cursor.pos = {x=__x, y=__y}
    cursor.minSize = __minSize
    cursor.maxSize = __maxSize

    cursor.size = __minSize
    cursor.speed = 7
    cursor.input = {x=0, y=0}
    cursor.charging = false
    cursor.capturing = 0


    function cursor:applyMoveInput(__x, __y)
        self.input.x += __x
        self.input.y += __y
    end

    function cursor:applyAInputHeld(__x, __y)
        self.capturing = 4
    end

    function cursor:applyAInputDown(__x, __y)
        self.charging = true
    end

    function cursor:applyAInputUp(__x, __y)
        self.charging = false
    end

    function cursor:draw()
        local shrink = 4
        if self.charging then
            shrink = 6
        end
        if self.capturing > 0 then
            shrink = 0
        end

        Graphics.drawCircleAtPoint(
            self.pos.x,
            self.pos.y,
            self.size
        )
        Graphics.fillCircleAtPoint(
            self.pos.x,
            self.pos.y,
            self.size - shrink
        )
    end

    function cursor:update()
        -- move
        local delta = self.input

        delta = Utilities.vNorm(delta)

        self.pos = Utilities.vAddV(
            self.pos,
            Utilities.vScale(delta, self.speed)
        )

        self.input = {x=0, y=0}

        self.capturing = math.max(0, self.capturing-1)
    end


    return cursor
end