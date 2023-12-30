import 'libraries/noble/Noble'
import 'utilities/Utilities'
import 'scenes/CollectScene'
import 'scenes/WordScene'


Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

Noble.new(CollectScene)
