# Simple Achievement System for Playdate games
This repository is an example of how to use Tanuk_Achievement. If you are just looking for the lib, go into the lib/ folder.

![playdate-20230803-122330](https://github.com/Schyzophrenic/Tanuk_Achievement/assets/1174479/4be98bf9-9f61-4b71-af64-905fda467ecc)


## Usage
First, you need to import the library with `import "lib/Tanuk_AchievementHandler" `

Then, you need to create your list of achievements and how to test them by creating multiple `Tanuk_Achievement`. You then initialize the `Tanuk_AchievementHandler` with this list. 
```lua

local arrAchievements = {}
table.insert(arrAchievements, Tanuk_Achievement("Great Score!", "You reached an awesome score", function ()
	return someVar >= 10 
end))
table.insert(arrAchievements, Tanuk_Achievement("Weird Combo", "If that's how you want to play", function ()
	return pd.buttonIsPressed(pd.kButtonLeft) and pd.buttonIsPressed(pd.kButtonB)
end))
table.insert(arrAchievements, Tanuk_Achievement("Good start!", "Welcome to the game", function () return true end)) -- This is going to be triggered when the game is started for instance
```

Finally, don't forget to add the following line to your update loop. Tanuk_Achievement uses both sprites and timers so you also need to make sure their update functions are called in the update loop.

```lua
function pd.update()
	gfx.sprite.update()
	pd.timer.updateTimers()
	__achievementHandler:checkAchievements() -- Important to check the achievements
end
```

## Configuration
`Tanuk_Achievement` also contains a description field. This can be used to display more information if you have a dedicated achievement screen for instance.
`Tanuk_AchievementHandler` takes the following arguments:
| Argument    | Mandatory | Description |
| ----------- | ----------- | ----------- |
| arrAchievements | yes | Array of `Tanuk_Achievement` |
| fnNotification | no | Allows to customize how the achievement notifications are displayed |
| frameCheck | no | How often should the achievements be checked? Default is 30 frames |
| fntPath | no | Path to a customized font to use when displaying the achievement name |
| imgNotificationPath | no | Path to a customized background image to use when displaying the achievement |
| imgIconPath | no | Path to a customized image to use as icon when displaying the achievement |

## Credits
Credits are not required, but are always nice! I am always curious to see where this code may end as well!
