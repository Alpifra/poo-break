import "State/game"

GameOver = {}
GameOver.__index = GameOver

local gfx <const> = playdate.graphics
local pih <const> = playdate.inputHandlers

function GameOver:init()

    local background = gfx.image.new('assets/images/game-over-bg.png')
    assert(background)

    self.backgroundSprite = gfx.sprite.new(background)
    self.backgroundSprite:moveTo(200, 120)
    self.backgroundSprite:setZIndex(10)
    self.backgroundSprite:add()
end

function GameOver:start()

    local scoreText = "Score: " .. Score[1]
    local retryText = "Press B to retry"
    local scoreTextWidth = gfx.getTextSize(scoreText)
    local retryTextWidth = gfx.getTextSize(retryText)
    local scoreTextImage = gfx.image.new(scoreTextWidth, 10)
    local retryTextImage = gfx.image.new(retryTextWidth, 10)

    gfx.lockFocus(scoreTextImage)
        gfx.drawTextInRect(scoreText, 0, 0, scoreTextWidth, 50)
    gfx.lockFocus(retryTextImage)
        gfx.drawTextInRect(retryText, 0, 0, retryTextWidth, 50)
    gfx.unlockFocus()

    local scoreTextSprite = gfx.sprite.new(scoreTextImage)
    local retryTextSprite = gfx.sprite.new(retryTextImage)
    scoreTextSprite:moveTo(350, 10)
    scoreTextSprite:setZIndex(15)
    scoreTextSprite:add()
    retryTextSprite:moveTo(350, 230)
    retryTextSprite:setZIndex(15)
    retryTextSprite:add()

    local startGameHandler = {
        BButtonDown = function()
            CurrentState[1] = State.playing
            pih.pop() -- remove input handlers
            Game:init()
            -- need to fix the display bug on score
            scoreTextSprite:remove()
            retryTextSprite:remove()
            self.backgroundSprite:remove()
        end
    }

    pih.push(startGameHandler)
end