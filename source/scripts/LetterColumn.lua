LetterColumn = {}

LetterColumn.HALF_ROW_COUNT = 4
LetterColumn.LETTER_SPACING = 20

function LetterColumn.new(__x, __y, __letters, __disabledLetters)
    local this = {}

    function this:init()
        self.x = __x
        self.y = __y

        self.isSelected = false

        self.letters = {}
        table.shallowcopy(__letters, self.letters)
        table.sort(self.letters)

        self.disabledLetters = table.create(#self.letters, 0)
        table.shallowcopy(__disabledLetters, self.disabledLetters)

        self.index = 0
        self:nextItem()
    end

    function this:draw()
        -- draw selected
        local x = self.x + 15
        local y = self.y + 10
            + LetterColumn.HALF_ROW_COUNT * LetterColumn.LETTER_SPACING
        local letter = self.letters[self.index]
        self:drawLetter(x, y, letter, true)

        if not self.isSelected then return end

        -- draw letters before
        local k = 0
        local i = self.index - 1
        while k > -LetterColumn.HALF_ROW_COUNT and i > 0 do
            if not self.disabledLetters[i] then
                local letter = self.letters[i]
                local x = self.x + 15
                local y = self.y + 10 - 5
                    + (k - 1 + LetterColumn.HALF_ROW_COUNT) *
                    LetterColumn.LETTER_SPACING
                -- + (k < LetterColumn.HALF_ROW_COUNT + 1 and -8 or 0)
                -- + (k > LetterColumn.HALF_ROW_COUNT + 1 and 12 or 0)
                self:drawLetter(x, y, letter, false)
                k -= 1
            end
            i -= 1
        end

        -- draw letters after
        local k = 1
        local i = self.index + 1
        while k < LetterColumn.HALF_ROW_COUNT + 1 and i <= #self.letters do
            if not self.disabledLetters[i] then
                local letter = self.letters[i]
                local x = self.x + 15
                local y = self.y + 10 + 8
                    + (k + LetterColumn.HALF_ROW_COUNT) *
                    LetterColumn.LETTER_SPACING
                self:drawLetter(x, y, letter, false)
                -- Noble.Text.draw(
                --     letter,
                --     x,
                --     y,
                --     Noble.Text.ALIGN_CENTER
                -- )
                k += 1
            end
            i += 1
        end
    end

    function this:drawLetter(x, y, letters, isBold)
        for i = 1, #letters do
            local char = letters:sub(i, i)
            Noble.Text.draw(
                isBold and "*"..char.."*" or char,
                x,
                y,
                Noble.Text.ALIGN_CENTER
            )
            x += LetterColumn.LETTER_SPACING
        end
    end

    function this:nextItem()
        self.index = self.index % #self.letters + 1
        while self.disabledLetters[self.index] do
            self.index = self.index % #self.letters + 1
        end
        self.count = string.len(self.letters[self.index])
    end

    function this:prevItem()
        self.index = (self.index - 2) % #self.letters + 1
        while self.disabledLetters[self.index] do
            self.index = (self.index - 2) % #self.letters + 1
        end
        self.count = string.len(self.letters[self.index])
    end

    function this:setSelected(b)
        self.isSelected = b
    end

    function this:getEnabledLetterIndices()
        out = {}
        for i, e in ipairs(self.disabledLetters) do
            if not e then
                out.insert(i)
            end
        end
        return out
    end

    function this:setDisabledLetter(i, enabled)
        self.disabledLetters[i] = enabled
    end

    function this:resetDisabledLetters(enabled)
        for i = 1, #self.letters do
            self.disabledLetters[i] = enabled
        end
    end

    this:init()

    return this
end
