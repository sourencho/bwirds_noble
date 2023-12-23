import 'scripts/LetterColumn'


WordScroller = {}

WordScroller.MAX_SIZE = 5
WordScroller.COL_SPACING = 20

function WordScroller.new(__x, __y, __letters)
    local this = {}

    function this:init(x, y, letters)
        self.x = x
        self.y = y

        self.index = 1

        self.letterColumns = {}
        -- for i = 1, WordScroller.MAX_SIZE do
        --      local x = this.x + (i - 1) * WordScroller.COL_SPACING
        --      local y = this.y
        --     local letterColumn = LetterColumn.new(x, y, __letters)
        --     this.letterColumns[i] = letterColumn
        -- end

        self:addLetterColumn()

        self.usedLetters = table.create(#letters, 0)
    end

    function this:addLetterColumn()
        local steps = table.reduce(self.letterColumns, function(acc, l)
            return acc + (l.count or 0)
        end, 0)
        if (steps > WordScroller.MAX_SIZE) then
            return
        end
        local x = this.x + steps * WordScroller.COL_SPACING
        local y = this.y

        local letterColumn = LetterColumn.new(x, y, __letters)
        table.insert(self.letterColumns, letterColumn)
    end

    function this:removeLetterColumn()
        if (#self.letterColumns == 1) then
            return
        end

        table.remove(self.letterColumns, #self.letterColumns)
    end

    function this:nextItem()
        self:addLetterColumn()
        self.index = #self.letterColumns
    end

    function this:prevItem()
        self:removeLetterColumn()
        self.index = #self.letterColumns
    end

    function this:scrollUp()
        self.letterColumns[self.index]:prevItem()
    end

    function this:scrollDown()
        self.letterColumns[self.index]:nextItem()
    end

    function this:update()
        -- Set selected
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            letterColumn:setSelected(i == self.index)
        end

        -- Set disabled
        for i = 1, #self.usedLetters do
            self.usedLetters[i] = false
        end
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            self.usedLetters[letterColumn.index] = true
        end
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            letterColumn:resetDisabledLetters(false)
            for i = 1, #self.usedLetters do
                letterColumn:setDisabledLetter(i, self.usedLetters[i])
            end
        end
    end

    function this:draw(tick)
        local steps = table.reduce(self.letterColumns, function(acc, l)
            return acc + (l.count or 0)
        end, 0)
        local letterColumn = self.letterColumns[#self.letterColumns]
        steps = steps - letterColumn.count + 1

        local x = this.x + steps * WordScroller.COL_SPACING - 10
        local y = this.y + (LetterColumn.HALF_ROW_COUNT + 1) * LetterColumn.LETTER_SPACING + 10
        if tick % 50 > 25 then
            Graphics.setLineWidth(2)
            Graphics.drawLine(x, y, x + 10, y)
        end

        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            letterColumn:draw()
        end
    end

    this:init(__x, __y, __letters)

    return this
end
