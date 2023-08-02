import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "Tanuk_Achievement"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Tanuk_AchievementHandler").extends()

function Tanuk_AchievementHandler:init(arrAchievements, fnNotification, frameCheck)
    Tanuk_AchievementHandler.super.init(self)

    assert(arrAchievements, "No Achievement provided")
    self.arrAchievements = arrAchievements
    self.fnNotification = fnNotification or self.defaultNotification
    self.frameCheck = frameCheck or 30 -- Check every 30 frames per default
    self.frameCount = 1
    self.arrSprNotifications = {}
end

function Tanuk_AchievementHandler:checkAchievements()
    if self:shouldRunCheck() then
        for i=1, #self.arrAchievements do
            local achievement = self.arrAchievements[i]
            if not achievement.isCompleted and achievement:fnTest() then
                local sprNotification = self.fnNotification(achievement)
                assert(sprNotification, "The custom notification implement did not return a sprite")
                achievement.isCompleted = true
                table.insert(self.arrSprNotifications, sprNotification)
                self:removeNotificationHandler()
            end
        end
    end
end

function Tanuk_AchievementHandler:shouldRunCheck()
    self.frameCount += 1
    if self.frameCount >= self.frameCheck then
        self.frameCount = 1
        return true
    end
    return false
end

function Tanuk_AchievementHandler.defaultNotification(achievement)
    local sprNotification = gfx.sprite.spriteWithText("ACHIEVEMENT\n" .. achievement.name .. "\n" .. achievement.description, 350, 100)
    sprNotification:moveTo(200, 200)
    sprNotification:add()

    return sprNotification
end

function Tanuk_AchievementHandler:removeNotificationHandler()
    local timerNotification = pd.timer.performAfterDelay(5000, function ()
        self.arrSprNotifications[1]:remove()
        table.remove(self.arrSprNotifications, 1)
    end)
end