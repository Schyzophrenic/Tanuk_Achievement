-----------------------------------------------
--- Achievement Library             v1.1.0 ---
---                                         ---
---            (c) Tanuk Prod               ---
---     https://github.com/Schyzophrenic    ---
-----------------------------------------------

import "CoreLibs/animator"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "Tanuk_Achievement"

local pd <const> = playdate
local gfx <const> = pd.graphics

local ANIMATION_DURATION <const> = 500
local REMOVAL_DELAY <const> = 5000

--- Achievement Handler
class("Tanuk_AchievementHandler").extends()

--- Initialize the achievement handler
-- @param arrAchievements array of Achievement
-- @param fnNotification to use when using a customer notification, OPTIONAL
-- @param frameCheck represents the number of frames between 2 checks, OPTIONAL, default 30
function Tanuk_AchievementHandler:init(arrAchievements, fnNotification, frameCheck, fntPath, imgNotificationPath, imgIconPath)
    Tanuk_AchievementHandler.super.init(self)

    assert(arrAchievements, "No Achievement provided")
    self.arrAchievements = arrAchievements
    self.fnNotification = fnNotification or self.defaultNotification
    self.frameCheck = frameCheck or 30 -- Check every 30 frames per default
    self.frameCount = 1
    self.arrSprNotifications = {}

    local fntPath = fntPath or "lib/fonts/font-full-circle"
    local imgNotificationPath = imgNotificationPath or "lib/images/notification"
    local imgIconPath = imgIconPath or "lib/images/icon"

    self.fnt = gfx.font.new(fntPath)
    assert(self.fnt, "The specified font cannot be found")

    -- Build Notification image
    self.imgNotif = gfx.image.new(imgNotificationPath)
    local imgIcon = gfx.image.new(imgIconPath)
    assert(self.imgNotif, "The specified notification image cannot be found")
    assert(imgIcon, "The specified icon image cannot be found")
    gfx.pushContext(self.imgNotif)
        imgIcon:draw(4, 3)
    gfx.popContext()
end

function Tanuk_AchievementHandler:checkAchievements()
    if self:shouldRunCheck() then
        for i=1, #self.arrAchievements do
            local achievement = self.arrAchievements[i]
            if not achievement.isCompleted and achievement:fnTest() then
                local sprNotification = self:fnNotification(achievement)
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

function Tanuk_AchievementHandler:defaultNotification(achievement)
    local imgNotif = self.imgNotif:copy()
    local _, h = imgNotif:getSize()
    print(_, h)

    gfx.pushContext(imgNotif)
        local drawMode = gfx.getImageDrawMode()
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextInRect(achievement.name, 26, h/2 - self.fnt:getHeight()/2, 123, 19, nil, "...", nil, self.fnt)
        gfx.setImageDrawMode(drawMode)
    gfx.popContext()

    local sprNotification = gfx.sprite.new(imgNotif)
    sprNotification:setCenter(0, 0)
    sprNotification:moveTo(3, 3 + #self.arrSprNotifications * (h + 1))
    sprNotification:add()

    return sprNotification
end

function Tanuk_AchievementHandler:removeNotificationHandler()
    local timerNotification = pd.timer.performAfterDelay(REMOVAL_DELAY, function ()
        self.arrSprNotifications[1]:remove()
        table.remove(self.arrSprNotifications, 1)
    end)
end