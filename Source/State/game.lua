
Game = {}
Game.__index = Game

local gfx <const> = playdate.graphics
local gameCycles = { fine = 1, calm = 2, busy = 3, rush = 4 }

function Game:init()

    self.currentGameCycle = gameCycles.fine
    self.gameCycleCanChange = false
    self.shitValue = 0
    self.earthValue = 100
    self.score = 0
end

function Game:start()

    local incrementShitValue = 0
    local incrementEarthValue = 0
    local crankTicks = playdate.getCrankTicks(36)
    local second = math.floor(playdate.getCurrentTimeMilliseconds() / 1000) + 1

    gfx.drawText("Score: " .. self.score, 340, 5, 55, 50, gfx.kAlignLeft)

    if (gameCycleCanChange and (second %= 5) == 0) then
        self:changeCycle()
        gameCycleCanChange = false
    elseif (second %= 5) == 4 then
        gameCycleCanChange = true
    end

    if (self.shitValue < 100 and self.earthValue > 0) then

        if crankTicks > 0 then crankTicks = 0 end -- only one crank rotation allowed

        incrementShitValue += math.random(0, self.currentGameCycle)
        self.score += incrementShitValue
        incrementShitValue += crankTicks
        self.shitValue += incrementShitValue

        incrementEarthValue += crankTicks / 2
        incrementEarthValue += 0.6
        self.earthValue += incrementEarthValue

        if self.earthValue >= 100 then self.earthValue = 100 end
        if self.earthValue < 0 then self.earthValue = 0 end
        if self.shitValue < 0 then self.shitValue = 0 end

        self:drawBars(self.shitValue, self.earthValue)
    else
        self:drawBars(0, 0)
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

function Game:drawBars(shitLevel, earthLevel)

    local barWidth, barHeight = 16, 120
    local shitChange = barHeight * (shitLevel / 100)
    local earthChange = barHeight * (earthLevel / 100)
    local screenWidth, screenHeight = playdate.display.getSize()

    -- dray geometrics forms
    gfx.setLineWidth(1)
    gfx.drawRect(12, 60, barWidth, barHeight)
    gfx.drawRect(screenWidth - 12 - barWidth, 60, barWidth, barHeight)

    -- fill bars level
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(
        12,
        screenHeight - 60,
        barWidth,
        -shitChange
    )
    gfx.fillRect(
        screenWidth - 12 - barWidth,
        screenHeight - 60,
        barWidth,
        -earthChange
    )
end