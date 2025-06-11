import "State/game-over"

Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local gameCycles = { fine = 1, calm = 2, busy = 3, rush = 4 }

function Game:init()

    local background = gfx.image.new('assets/images/game-bg.png') -- px size 400x240
    local shitImage = gfx.image.new('assets/images/shit.png') -- px size 32x32
    local paperImage = gfx.image.new('assets/images/paper.png') -- px size 32x32
    local toiletPaperImages = {
        gfx.image.new('assets/images/toilet-paper1.png'), -- px size 150x100
        gfx.image.new('assets/images/toilet-paper2.png'), -- px size 150x100
        gfx.image.new('assets/images/toilet-paper3.png'), -- px size 150x100
        gfx.image.new('assets/images/toilet-paper4.png'), -- px size 150x100
        gfx.image.new('assets/images/toilet-paper5.png'), -- px size 150x100
        gfx.image.new('assets/images/toilet-paper6.png'), -- px size 150x100
    }

    assert(background)
    assert(shitImage)
    assert(paperImage)

    self.backgroundSprite = gfx.sprite.new(background)
    self.shitSprite = gfx.sprite.new(shitImage)
    self.paperSprite = gfx.sprite.new(paperImage)
    self.toiletPaperSprites = {}

    for key, toiletPaperImage in ipairs(toiletPaperImages) do
        assert(toiletPaperImage)
        self.toiletPaperSprites[key] = gfx.sprite.new(toiletPaperImage)
    end

    -- add sprites
    self.backgroundSprite:setZIndex(20)
    self.backgroundSprite:moveTo(200, 120)
    self.backgroundSprite:add()
    self.shitSprite:moveTo(20, 40)
    self.shitSprite:setZIndex(25)
    self.shitSprite:add()
    self.paperSprite:moveTo(380, 40)
    self.paperSprite:setZIndex(25)
    self.paperSprite:add()

    self.currentGameCycle = gameCycles.fine
    self.currentToiletPaperSprite = 1
    self.cumulatedCrankRotation = 0
    self.gameCycleCanChange = false
    self.shitValue = 0
    self.paperValue = 100

    Game:drawToiletPaper(0, self.currentToiletPaperSprite)
end

function Game:start()

    local incrementShitValue = 0
    local incrementpaperValue = 0
    local crankTicks = playdate.getCrankTicks(36)
    local crankChange, acceleration = playdate.getCrankChange()
    local second = math.floor(playdate.getCurrentTimeMilliseconds() / 1000) + 1

    -- change cycle logic
    if (gameCycleCanChange and (second %= 5) == 0) then
        self:changeCycle()
        gameCycleCanChange = false
    elseif (second %= 5) == 4 then
        gameCycleCanChange = true
    end

    -- change toilet paper sprite on crank rotation
    if crankChange > 0 then

        self.cumulatedCrankRotation += math.floor(crankChange)

        if self.cumulatedCrankRotation > 360 then
            self.cumulatedCrankRotation = 0
        elseif self.cumulatedCrankRotation > 300 and self.currentToiletPaperSprite < 6 then
            self.currentToiletPaperSprite = 6
            Game:drawToiletPaper(5, 6)
        elseif self.cumulatedCrankRotation > 240 and self.currentToiletPaperSprite < 5 then
            self.currentToiletPaperSprite = 5
            Game:drawToiletPaper(4, 5)
        elseif self.cumulatedCrankRotation > 180 and self.currentToiletPaperSprite < 4 then
            self.currentToiletPaperSprite = 4
            Game:drawToiletPaper(3, 4)
        elseif self.cumulatedCrankRotation > 120 and self.currentToiletPaperSprite < 3 then
            self.currentToiletPaperSprite = 3
            Game:drawToiletPaper(2, 3)
        elseif self.cumulatedCrankRotation > 60 and self.currentToiletPaperSprite < 2 then
            self.currentToiletPaperSprite = 2
            Game:drawToiletPaper(1, 2)
        elseif self.cumulatedCrankRotation < 60 and self.currentToiletPaperSprite ~= 1 then
            self.currentToiletPaperSprite = 1
            Game:drawToiletPaper(6, 1)
        end
    end

    -- in game logic calculation
    if (self.shitValue < 100 and self.paperValue > 0) then

        if crankTicks < 0 then crankTicks = 0 end -- only one crank rotation allowed

        incrementShitValue += math.random(0, self.currentGameCycle)
        Score[1] += incrementShitValue
        incrementShitValue -= crankTicks
        self.shitValue += incrementShitValue

        incrementpaperValue -= crankTicks / 2
        incrementpaperValue += 0.6
        self.paperValue += incrementpaperValue

        if self.paperValue >= 100 then self.paperValue = 100 end
        if self.paperValue < 0 then self.paperValue = 0 end
        if self.shitValue < 0 then self.shitValue = 0 end

        self:drawScore(self.shitValue, self.paperValue)
    else
        self:drawScore(0, 0)
        self:over()
    end

    return self
end

function Game:changeCycle()

    if self.currentGameCycle == gameCycles.rush then
        self.currentGameCycle = gameCycles.calm
    elseif self.currentGameCycle == gameCycles.busy then
        self.currentGameCycle = gameCycles.rush
    elseif self.currentGameCycle == gameCycles.calm then
        self.currentGameCycle = gameCycles.busy
    elseif self.currentGameCycle == gameCycles.fine then
        self.currentGameCycle = gameCycles.calm
    end
end

function Game:drawScore(shitLevel, paperLevel)

    local barWidth, barHeight = 16, 110
    local shitChange = barHeight * (shitLevel / 100)
    local paperChange = barHeight * (paperLevel / 100)
    local screenWidth, screenHeight = playdate.display.getSize()

    -- draw geometrics forms
    gfx.setLineWidth(1)
    gfx.drawRect(12, 60, barWidth, barHeight)
    gfx.drawRect(screenWidth - 12 - barWidth, 60, barWidth, barHeight)

    -- fill bars level
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(
        12,
        screenHeight - 70,
        barWidth,
        -shitChange
    )
    gfx.fillRect(
        screenWidth - 12 - barWidth,
        screenHeight - 70,
        barWidth,
        -paperChange
    )

    gfx.drawText("Score: " .. Score[1], 340, 5, 55, 50, gfx.kAlignLeft)
end

function Game:drawToiletPaper(prev, next)

    if self.toiletPaperSprites[prev] then 
        self.toiletPaperSprites[prev]:remove()
    end

    self.toiletPaperSprites[next]:setZIndex(25)
    self.toiletPaperSprites[next]:moveTo(200, 60)
    self.toiletPaperSprites[next]:add()
end

function Game:over()

    self.backgroundSprite:remove()
    self.shitSprite:remove()
    self.paperSprite:remove()
    CurrentState[1] = State.game_over
    GameOver:init()
end