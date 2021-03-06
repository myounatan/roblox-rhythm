--[[
    GameState Controller
    Matthew Younatan
    2021-07-24

    Controls the state of the game
]]
local GameState = {}

local GameStateService, GameEnum, Settings

function GameState:GetState()
    return self._state
end

function GameState:GetLastTick()
    return self._lasttick
end

function GameState:GetLastParams()
    return self._lastParams
end

function GameState:Start()
    GameStateService.ReplicateGameState:Connect(
        function(stateTypeValue, lasttick, ...)
            self._state = GameEnum.GameStateType[stateTypeValue]
            self._lasttick = lasttick
            self._lastParams = {...}

            if Settings.Debug then
                warn("Received game state:", self._state, self._lasttick, ...)
            end

            self:FireEvent("OnStateChanged", self._state, self._lasttick, ...)
        end
    )
end

function GameState:Init()
    GameStateService = self.Services.GameState
    GameEnum = self.Shared.Game.GameEnum
    Settings = self.Shared.Game.Settings

    self._state = GameEnum.GameStateType.INTERMISSION
    self._lasttick = 0
    self._lastParams = {}

    self:RegisterEvent "OnStateChanged"
end

return GameState
