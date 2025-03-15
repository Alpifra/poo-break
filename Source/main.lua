import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "State/game"

local gfx <const> = playdate.graphics
local state <const> = { menu, playing, game_over }
local currentState = state.menu

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
    earthSprite:moveTo(380, 40)
    earthSprite:add()
end

gameSetup()
Game:init()

-- screen refresh function that execute 30 times/sec
function playdate.update()

    -- setup
    gfx.sprite.update()

    -- menu
    -- TODO menu logic

    -- game logic
    Game:start()

    print(Game.score)

end