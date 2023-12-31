import 'scripts/LetterColumn'


WordScroller = {}

WordScroller.MIN_SIZE = 3
WordScroller.MAX_SIZE = 5
WordScroller.COL_SPACING = 20

function WordScroller.new(__x, __y, __letters)
    local this = {}

    function this:init(x, y, letters)
        self.x = x
        self.y = y

        self.index = 1

        self.letters = letters
        self.letterColumns = {}

        self:addLetterColumn()
    end

    function this:addLetterColumn()
        -- find pos
        local steps = table.reduce(self.letterColumns, function(acc, l)
            return acc + (l.count or 0)
        end, 0)

        if (steps > WordScroller.MAX_SIZE) then return end

        local x = this.x + steps * WordScroller.COL_SPACING
        local y = this.y

        -- calcluate disabled letters
        local disabledLetters = table.create(#self.letters, 0)
        for i = 1, #self.letters do
            disabledLetters[i] = (steps + #self.letters[i]) > WordScroller.MAX_SIZE
        end
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            disabledLetters[letterColumn.index] = true
        end

        if all(disabledLetters) and steps < WordScroller.MIN_SIZE then
            return
        end

        -- create
        local letterColumn = LetterColumn.new(
            x,
            y,
            self.letters,
            disabledLetters,
            steps >= WordScroller.MIN_SIZE
        )
        table.insert(self.letterColumns, letterColumn)
    end

    function this:removeLetterColumn()
        if (#self.letterColumns == 1) then
            return
        end

        table.remove(self.letterColumns, #self.letterColumns)
    end

    function this:nextItem()
        local letterColumn = self.letterColumns[#self.letterColumns]
        if letterColumn ~= nil and letterColumn:isLetterSubmit() then
            return self:getCurrentWord()
        else
            self:addLetterColumn()
            self.index = #self.letterColumns
        end
    end

    function this:prevItem()
        self:removeLetterColumn()
        self.index = #self.letterColumns
    end

    function this:scrollUp()
        if #self.letterColumns == 0 then return end
        self.letterColumns[self.index]:prevItem()
    end

    function this:scrollDown()
        if #self.letterColumns == 0 then return end
        self.letterColumns[self.index]:nextItem()
    end

    -- TODO: Return nil if current word not valid
    function this:getCurrentWord()
        local word = table.reduce(self.letterColumns, function(acc, l)
            return acc..l:getLetter()
        end, "")
        return word:sub(1, #word-1)
    end

    -- returns an array of true/false values that corresponds to used letters
    function this:getUsedLetters()
        local usedLetters = table.create(#self.letters, 0)
        for i = 1, #self.letters do
            usedLetters[i] = false
        end
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            usedLetters[letterColumn.index] = true
        end
        return usedLetters
    end

    function this:update()
        -- Set selected
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            letterColumn:setSelected(i == self.index)
        end
    end

    function this:draw(tick)
        if #self.letterColumns == 0 then
            Noble.Text.draw(
                "*-*",
                this.x,
                this.y +
                    (LetterColumn.HALF_ROW_COUNT + 1) *
                        LetterColumn.LETTER_SPACING + 10
                ,
                Noble.Text.ALIGN_CENTER
            )
            return
        end

        local steps = table.reduce(self.letterColumns, function(acc, l)
            return acc + (l.count or 0)
        end, 0)
        local letterColumn = self.letterColumns[#self.letterColumns]

        steps = steps - letterColumn.count + 1

        local x = this.x + steps * WordScroller.COL_SPACING - 10
        local y = this.y +
            (LetterColumn.HALF_ROW_COUNT + 1) * LetterColumn.LETTER_SPACING + 10
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
