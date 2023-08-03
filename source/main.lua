import "lib/Tanuk_AchievementHandler"

local pd <const> = playdate
local gfx <const> = pd.graphics

__gameData = {
	score = 0
}

-- Creation of all achievements
local arrAchievements = {}
table.insert(arrAchievements, Tanuk_Achievement("Great Score!", "You reached an awesome score", function ()
	return __gameData.score >= 10 
end))
table.insert(arrAchievements, Tanuk_Achievement("Weird Combo", "If that's how you want to play", function ()
	return pd.buttonIsPressed(pd.kButtonLeft) and pd.buttonIsPressed(pd.kButtonB)
end))
table.insert(arrAchievements, Tanuk_Achievement("Good start!", "Welcome to the game", function () return true end))
-- End achievements

-- Global Achievement handler
-- __achievementHandler = Tanuk_AchievementHandler(arrAchievements, function (self, achievement)
-- 	print("Custom function")
-- 	local sprNotification = gfx.sprite.spriteWithText("ACHIEVEMENT\n" .. achievement.name .. "\n" .. achievement.description, 350, 100)
-- 	sprNotification:setCenter(0, 0)
-- 	sprNotification:moveTo(5, 5)
-- 	sprNotification:add()

-- 	return sprNotification
-- end)
__achievementHandler = Tanuk_AchievementHandler(arrAchievements)


-- Just to have something moving on the screen
local sprTest = gfx.sprite.spriteWithText("!!TEST!!", 100, 50)
sprTest:moveTo(50, 120)
sprTest:add()


function pd.update()
	sprTest:moveBy(1, 0)
	handleInputs()

	gfx.sprite.update()
	pd.timer.updateTimers()
	__achievementHandler:checkAchievements() -- Important to check the achievements
end

function handleInputs()
	if pd.buttonIsPressed(pd.kButtonUp) then
		__gameData.score += 1
		print ("score is now", __gameData.score)
	end
end