Menu = {}
Menu.__index = Menu

local gfx <const> = playdate.graphics

function Menu:init()

    local myInputHandlers = {
        BButtonDown = function()
            CurrentState[1] = 2
        end
    }

    playdate.inputHandlers.push(myInputHandlers)
end

function Menu:start()

    gfx.drawText("Press B to start", 200, 120, 100, 50, gfx.kAlignCenter)

    return self
end