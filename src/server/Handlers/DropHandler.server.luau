local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dropEvent = ReplicatedStorage.Remotes.DropItem

local CarryService = require(
	ServerScriptService.Services.CarryService
)

dropEvent.OnServerEvent:Connect(function(player)
	CarryService:Drop(player)
end)