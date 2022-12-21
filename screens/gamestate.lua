GameState = {}
GameState.__index = GameState

function GameState:create()
    local state = {}
    setmetatable(state, GameState)
    state.titleScreen = TitleScreen:create()
    state.gameScreen = GameScreen:create()
    state.failScreen = FailScreen:create()
    state.winScreen = WinScreen:create()
    state.currentState = nil
    state.newState = nil
    return state
end

function GameState:setState(state)
    self.currentState = state
    self.newState = state
end

function GameState:setNewState(newState)
    self.newState = newState
end

--function GameState:applyChangeState()
--    self.currentState = self.newState
--end