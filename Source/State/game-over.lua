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

    if self.scoreTextSprite then self.scoreTextSprite:remove() end
    if self.retryTextSprite then self.scoreTextSprite:remove() end

    self.scoreTextSprite = gfx.sprite.new(scoreTextImage)
    self.retryTextSprite = gfx.sprite.new(retryTextImage)
    self.scoreTextSprite:moveTo(350, 10)
    self.scoreTextSprite:setZIndex(15)
    self.scoreTextSprite:add()
    self.retryTextSprite:moveTo(350, 230)
    self.retryTextSprite:setZIndex(15)
    self.retryTextSprite:add()

    local startGameHandler = {
        BButtonDown = function()
            CurrentState[1] = State.playing
            pih.pop() -- remove input handlers
            Game:init()
        end
    }

    pih.push(startGameHandler)
end