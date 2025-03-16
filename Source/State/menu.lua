Menu = {}
Menu.__index = Menu

local gfx <const> = playdate.graphics
local pih <const> = playdate.inputHandlers

function Menu:init()

    local text = "Press B to start"
    local boxWidth = 120
    local textWidth = gfx.getTextSize(text)
    local boxImage = gfx.image.new(boxWidth + textWidth, 50)

    gfx.pushContext(boxImage)
        gfx.drawText(text, (boxWidth - textWidth) / 2, 0)
    gfx.popContext()

    local textSprite = gfx.sprite.new(boxImage)
    textSprite:moveTo(240, 120)
    textSprite:add()

    local startGameHandler = {
        BButtonDown = function()
            CurrentState[1] = State.playing
            pih.pop() -- remove input handlers
            gfx.sprite.removeAll()
        end
    }

    pih.push(startGameHandler)
end