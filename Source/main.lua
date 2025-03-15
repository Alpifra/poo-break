import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics

-- screen size : 400, 240
local screenWidth, screenHeight = playdate.display.getSize()
local shitValue = 0
local earthValue = 100
local score = 0

local state = { menu, playing, game_over }
local currentState = state.menu

local gameCycles = { fine = 1, calm = 2, busy = 3, rush = 4 }
local currentGameCycle = gameCycles.fine
local gameCycleCanChange = false

local function gameSetup()

    local shitImage = gfx.image.new('assets/images/shit.png') -- px size 32x32
    local earthImage = gfx.image.new('assets/images/earth.png') -- px size 32x32
    local scoreFont = gfx.font.new('assets/fonts/Bitmore-Medieval')
    assert(shitImage)
    assert(earthImage)
    assert(scoreFont)

    local shitSprite = gfx.sprite.new(shitImage)
    local earthSprite = gfx.sprite.new(earthImage)

    -- load font
    gfx.setFont(scoreFont)

    -- add sprites
    shitSprite:moveTo(20, 40)
    shitSprite:add()
    earthSprite:moveTo(screenWidth - 20, 40)
    earthSprite:add()
end

gameSetup()

local function drawBars(shitLevel, earthLevel)

    local barWidth, barHeight = 16, 120
    local shitChange = barHeight * (shitLevel / 100)
    local earthChange = barHeight * (earthLevel / 100)

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

local function changeCycle()
    if currentGameCycle == gameCycles.rush then
        currentGameCycle = gameCycles.calm
    elseif currentGameCycle == gameCycles.busy then
        currentGameCycle = gameCycles.rush
    elseif currentGameCycle == gameCycles.calm then
        currentGameCycle = gameCycles.busy
    elseif currentGameCycle == gameCycles.fine then
        currentGameCycle = gameCycles.calm
    end
end

-- screen refresh function that execute 30 times/sec
function playdate.update()

    -- setup
    gfx.sprite.update()

    -- game logic
    local incrementShitValue = 0
    local incrementEarthValue = 0
    local crankTicks = playdate.getCrankTicks(36)
    local second = math.floor(playdate.getCurrentTimeMilliseconds() / 1000) + 1

    gfx.drawText("Score: " .. score, 340, 5, 55, 50, gfx.kAlignLeft)

    if (gameCycleCanChange and (second %= 5) == 0) then
        changeCycle()
        gameCycleCanChange = false
    elseif (second %= 5) == 4 then
        gameCycleCanChange = true
    end

    if (shitValue < 100 and earthValue > 0) then

        if crankTicks > 0 then crankTicks = 0 end -- only one crank rotation allowed

        incrementShitValue += math.random(0, currentGameCycle)
        score += incrementShitValue
        incrementShitValue += crankTicks
        shitValue += incrementShitValue

        incrementEarthValue += crankTicks / 2
        incrementEarthValue += 0.6
        earthValue += incrementEarthValue

        if earthValue >= 100 then earthValue = 100 end
        if earthValue < 0 then earthValue = 0 end
        if shitValue < 0 then shitValue = 0 end

        drawBars(shitValue, earthValue)
    else
        drawBars(0, 0)
    end
    -- end game logic
end