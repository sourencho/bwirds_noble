import 'scripts/LetterColumn'


WordScroller = {}

WordScroller.MAX_SIZE = 8
WordScroller.COL_SPACING = 20

function WordScroller.new(__x, __y, __letters)
    local this = {}

    this.x = __x
    this.y = __y

    this.index = 1

    this.letterColumns = table.create(WordScroller.MAX_SIZE, 0)
    for i = 1, WordScroller.MAX_SIZE do
        local x = this.x + (i - 1) * WordScroller.COL_SPACING + 8
        local y = this.y
        local letterColumn = LetterColumn.new(x, y, __letters)
        this.letterColumns[i] = letterColumn
    end

    function this:nextItem()
        self.index = self.index % #self.letterColumns + 1
    end

    function this:prevItem()
        self.index = (self.index - 2) % #self.letterColumns + 1
    end

    function this:scrollUp()
        self.letterColumns[self.index]:prevItem()
    end

    function this:scrollDown()
        self.letterColumns[self.index]:nextItem()
    end

    function this:draw()
        for i = 1, #self.letterColumns do
            local letterColumn = self.letterColumns[i]
            letterColumn:setSelected(i == self.index)
            letterColumn:draw()
        end
    end

    return this
end