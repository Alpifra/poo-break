import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "State/menu"
import "State/game"
import "State/game-over"

local gfx <const> = playdate.graphics
State = { menu = 1, playing = 2, game_over =  3}
State.__index = State
CurrentState = { State.menu }
CurrentState.__index = CurrentState
Score = { 0 }
Score.__index = Score

local function gameSetup()

    -- load font
    local scoreFont = gfx.font.new('assets/fonts/Bitmore-Medieval')
    local menuFont = gfx.font.new('assets/fonts/font-pixieval')
    assert(menuFont)
    assert(scoreFont)

    gfx.setFont(menuFont)
    Menu:init()

    gfx.setFont(scoreFont)
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
        GameOver:start()
    end
end