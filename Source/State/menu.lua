Menu = {}
Menu.__index = Menu

local gfx <const> = playdate.graphics
local pih <const> = playdate.inputHandlers

function Menu:init()

    local background = gfx.image.new('assets/images/game-start-bg.png')
    assert(background)

    local backgroundSprite = gfx.sprite.new(background)
    backgroundSprite:moveTo(200, 120)
    backgroundSprite:setZIndex(30)
    backgroundSprite:add()

    local text = "Press B to poo"
    local boxWidth = 120
    local textWidth = gfx.getTextSize(text)
    local boxImage = gfx.image.new(boxWidth + textWidth, 100)

    gfx.pushContext(boxImage)
        gfx.drawTextInRect(text, 0, 10, boxWidth, 85)
    gfx.popContext()

    boxImage = boxImage:rotatedImage(-3)

    local textSprite = gfx.sprite.new(boxImage)
    textSprite:moveTo(260, 191)
    textSprite:setZIndex(35)
    textSprite:add()

    local startGameHandler = {
        BButtonDown = function()
            CurrentState[1] = State.playing
            pih.pop() -- remove input handlers
            textSprite:remove()
            backgroundSprite:remove()
        end
    }

    pih.push(startGameHandler)
end