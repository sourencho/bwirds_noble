LetterColumn = {}

LetterColumn.HALF_ROW_COUNT = 4
LetterColumn.LETTER_SPACING = 20

function LetterColumn.new(__x, __y, __letters)
    local this = {}

    function this:init()
        self.x = __x
        self.y = __y

        self.isSelected = false

        self.letters = {}
        table.shallowcopy(__letters, self.letters)
        -- table.insert(self.letters, "-")
        table.sort(self.letters)

        self.isLetterDisabled = table.create(#self.letters, 0)
        this:resetDisabledLetters(false)

        self.index = 1
    end

    function this:draw()
        -- Graphics.drawRoundRect(self.x, self.y - 10, 130, 220, 3)

        local sIndex = self.index - LetterColumn.HALF_ROW_COUNT
        local eIndex = sIndex + LetterColumn.HALF_ROW_COUNT * 2
        local k = 1
        for n = sIndex, eIndex do
            local i = Utilities.getModIndex(n, #self.letters)
            local letter = self.letters[i]
            local x = self.x + 15
            local y = self.y + 10
                + (k - 1) * LetterColumn.LETTER_SPACING
                + (k < LetterColumn.HALF_ROW_COUNT + 1 and -10 or 0)
                + (k > LetterColumn.HALF_ROW_COUNT + 1 and 10 or 0)

            local l =
                k == LetterColumn.HALF_ROW_COUNT + 1
                and "*" .. letter .. "*"
                or letter
            if n == sIndex or n == eIndex then
                l = "-"
            end
            Noble.Text.draw(
                l,
                x,
                y,
                Noble.Text.ALIGN_CENTER
            )
            k += 1
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

    function this:setDisabledLetter(i, enabled)
        self.isLetterDisabled[i] = enabled
    end

    function this:resetDisabledLetters(enabled)
        for i = 1, #self.letters do
            self.isLetterDisabled[i] = enabled
        end
    end

    this:init()

    return this
end
