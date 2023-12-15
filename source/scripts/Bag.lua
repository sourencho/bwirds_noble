Bag = {}

Bag.MAX_SIZE = 8
Bag.LETTER_SPACING = 20

function Bag.new()
    local bag = {}


    bag.x = 20
    bag.y = 240-30

    bag.letters = table.create(Bag.MAX_SIZE, 0)
    bag.index = 1


    function bag:addLetter(__letter)
        if self.index > Bag.MAX_SIZE then
            print("Bag full. Failed to add letter!")
            return false
        end

        self.letters[self.index] = __letter
        self.index += 1

        return true
    end

    function bag:draw()
        Graphics.setLineWidth(2)
        Graphics.drawRect(
            self.x,
            self.y,
            self.x + ((Bag.MAX_SIZE - 1) * Bag.LETTER_SPACING) + 4,
            24
        )
        for i = 1, #self.letters do
            Noble.Text.draw(
                self.letters[i],
                self.x + (i-1) * Bag.LETTER_SPACING + 8,
                self.y + 4
            )
        end
    end


    return bag
end