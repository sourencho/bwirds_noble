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
        -- table.insert(self.letters, "-")
        table.sort(self.letters)

        self.disabledLetters = table.create(#self.letters, 0)
        table.shallowcopy(__disabledLetters, self.disabledLetters)

        self.index = 0
        self:nextItem()

        self.count = 1
    end

    function this:draw()
        -- draw selected
        local x = self.x + 15
        local y = self.y + 10
            + LetterColumn.HALF_ROW_COUNT * LetterColumn.LETTER_SPACING
        Noble.Text.draw(
            "*" .. self.letters[self.index] .. "*",
            x,
            y,
            Noble.Text.ALIGN_CENTER
        )

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
                Noble.Text.draw(
                    letter,
                    x,
                    y,
                    Noble.Text.ALIGN_CENTER
                )
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
                local y = self.y + 10 + 10
                    + (k + LetterColumn.HALF_ROW_COUNT) *
                    LetterColumn.LETTER_SPACING
                -- + (k < LetterColumn.HALF_ROW_COUNT + 1 and -8 or 0)
                -- + (k > LetterColumn.HALF_ROW_COUNT + 1 and 12 or 0)
                Noble.Text.draw(
                    letter,
                    x,
                    y,
                    Noble.Text.ALIGN_CENTER
                )
                k += 1
            end
            i += 1
        end
    end

    function this:oldDraw()
        local sIndex = self.index - LetterColumn.HALF_ROW_COUNT
        local eIndex = sIndex + LetterColumn.HALF_ROW_COUNT * 2
        local k = 1
        for n = sIndex, eIndex do
            local i = Utilities.getModIndex(n, #self.letters)
            local letter = self.letters[i]
            local x = self.x + 15
            local y = self.y + 10
                + (k - 1) * LetterColumn.LETTER_SPACING
                + (k < LetterColumn.HALF_ROW_COUNT + 1 and -8 or 0)
                + (k > LetterColumn.HALF_ROW_COUNT + 1 and 12 or 0)

            local l =
                k == LetterColumn.HALF_ROW_COUNT + 1
                and "*" .. letter .. "*"
                or letter
            if n == sIndex or n == eIndex then
                l = "-"
            end
            if self.isSelected or k == LetterColumn.HALF_ROW_COUNT + 1 then
                Noble.Text.draw(
                    l,
                    x,
                    y,
                    Noble.Text.ALIGN_CENTER
                )
            end
            k += 1
        end
    end

    function this:nextItem()
        self.index = self.index % #self.letters + 1
        while self.disabledLetters[self.index] do
            self.index = self.index % #self.letters + 1
        end
    end

    function this:prevItem()
        self.index = (self.index - 2) % #self.letters + 1
        while self.disabledLetters[self.index] do
            self.index = (self.index - 2) % #self.letters + 1
        end
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
