local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Services = ServerScriptService:WaitForChild("Services")

local CarryService = require(Services:WaitForChild("CarryService"))
local ItemService = require(Services:WaitForChild("ItemService"))
local EconomyService = require(Services:WaitForChild("EconomyService"))
local PlotService = require(Services:WaitForChild("PlotService"))
local PlacementService = require(Services:WaitForChild("PlacementService"))

local function setupPlayer(player)
    EconomyService:SetupPlayer(player)
    PlotService:AssignPlot(player)
    local function setupCharacter(character)
        local humanoid = character:WaitForChild("Humanoid")

        humanoid.Died:Connect(function()
            CarryService:Drop(player)
        end)
    end

    player.CharacterAdded:Connect(setupCharacter)

    player.CharacterRemoving:Connect(function()
        CarryService:Drop(player)
    end)

    if player.Character then
        setupCharacter(player.Character)
    end
end

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(player)
    CarryService:Drop(player)
    PlotService:ReleasePlot(player)
end)

for _, player in Players:GetPlayers() do
    setupPlayer(player)
end

ItemService:Init()
PlacementService:Init()

print("Main started")
