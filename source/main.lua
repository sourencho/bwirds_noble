import 'libraries/noble/Noble'
import 'utilities/Utilities'
import 'scenes/MainScene'
import 'scenes/WordScene'


Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

Noble.new(WordScene)
