Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local gameCycles = { fine = 1, calm = 2, busy = 3, rush = 4 }

function Game:init()

    local background = gfx.image.new('assets/images/game-bg.png') -- px size 400x240
    assert(background)

    local backgroundSprite = gfx.sprite.new(background)

    backgroundSprite:setZIndex(20)
    backgroundSprite:moveTo(200, 120)
    backgroundSprite:add()

    self.currentGameCycle = gameCycles.fine
    self.gameCycleCanChange = false
    self.shitValue = 0
    self.paperValue = 100
    self.score = 0
end

function Game:start()

    local incrementShitValue = 0
    local incrementpaperValue = 0
    local crankTicks = playdate.getCrankTicks(36)
    local second = math.floor(playdate.getCurrentTimeMilliseconds() / 1000) + 1

    -- change cycle logic
    if (gameCycleCanChange and (second %= 5) == 0) then
        self:changeCycle()
        gameCycleCanChange = false
    elseif (second %= 5) == 4 then
        gameCycleCanChange = true
    end

    -- in game logic calculation
    if (self.shitValue < 100 and self.paperValue > 0) then

        if crankTicks > 0 then crankTicks = 0 end -- only one crank rotation allowed

        incrementShitValue += math.random(0, self.currentGameCycle)
        self.score += incrementShitValue
        incrementShitValue += crankTicks
        self.shitValue += incrementShitValue

        incrementpaperValue += crankTicks / 2
        incrementpaperValue += 0.6
        self.paperValue += incrementpaperValue

        if self.paperValue >= 100 then self.paperValue = 100 end
        if self.paperValue < 0 then self.paperValue = 0 end
        if self.shitValue < 0 then self.shitValue = 0 end

        self:draw(self.shitValue, self.paperValue)
    else
        self:draw(0, 0)
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

function Game:draw(shitLevel, paperLevel)

    local shitImage = gfx.image.new('assets/images/shit.png') -- px size 32x32
    local paperImage = gfx.image.new('assets/images/paper.png') -- px size 32x32
    assert(shitImage)
    assert(paperImage)

    local backgroundSprite = gfx.sprite.new(background)
    local shitSprite = gfx.sprite.new(shitImage)
    local paperSprite = gfx.sprite.new(paperImage)

    -- add sprites
    shitSprite:moveTo(20, 40)
    shitSprite:setZIndex(25)
    shitSprite:add()
    paperSprite:moveTo(380, 40)
    paperSprite:setZIndex(25)
    paperSprite:add()

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

    gfx.drawText("Score: " .. self.score, 340, 5, 55, 50, gfx.kAlignLeft)
end