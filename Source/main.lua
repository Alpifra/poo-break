import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "State/game"
import "State/menu"

local gfx <const> = playdate.graphics
State = { menu = 1, playing = 2, game_over =  3}
State.__index = State
CurrentState = { State.menu }
CurrentState.__index = CurrentState

local function gameSetup()

    -- load font
    local scoreFont = gfx.font.new('assets/fonts/Bitmore-Medieval')
    assert(scoreFont)
    gfx.setFont(scoreFont)

    Menu:init()
    Game:init()
end

gameSetup()

-- screen refresh function that execute 30 times/sec
function playdate.update()

    -- setup
    gfx.sprite.update()

    -- menu
    if CurrentState[1] == State.menu then
        -- TODO back to menu
    elseif CurrentState[1] == State.playing then
        Game:start()
    else
        -- TODO game_over logic
    end
end