WordList = {}

WordList.ROW_SPACING = 20

function WordList.new(__x, __y, __width)
    local this = {}

    function this:init(x, y, width)
        self.x = x
        self.y = y
        self.width =  width

        self.words = {}
    end

    function this:draw()
		for i, w in ipairs(self.words) do
            local y = self.y + (i-1) * WordList.ROW_SPACING
            Noble.Text.draw(
                w,
                self.x,
                y,
                Noble.Text.ALIGN_LEFT
            )
            Noble.Text.draw(
                #w,
                self.x + self.width - 20,
                y,
                Noble.Text.ALIGN_RIGHT
            )
        end
    end

    function this:addWord(word)
        table.insert(self.words, word)
    end

    this:init(__x, __y, __width)

    return this
end