LetterColumn = {}

LetterColumn.MAX_SIZE = 8
LetterColumn.LETTER_SPACING = 20

function LetterColumn.new(__x, __y, __letters)
    local this = {}

    this.x = __x
    this.y = __y

    this.isSelected = false

    this.letters = {}
    table.shallowcopy(__letters, this.letters)
    table.insert(this.letters, "-")
    table.sort(this.letters)
    this.index = 1

    function this:draw()
        for i = 1, #self.letters do
            local letter = self.letters[i]
            local x = self.x + 4
            local y = self.y + 8
             + (i - 1 - self.index) * LetterColumn.LETTER_SPACING
             + (i < self.index and -2 or 0)
             + (i > self.index and 2 or 0)
            Noble.Text.draw(
                (i == self.index and self.isSelected) and
                    "*"..letter.."*" or letter,
                x,
                y
            )
        end
    end

    function this:nextItem()
        self.index = self.index % #self.letters + 1
    end

    function this:prevItem()
        self.index = (self.index - 2) % #self.letters + 1
    end

    function this:setSelected(b)
        self.isSelected = b
    end

    return this
end
