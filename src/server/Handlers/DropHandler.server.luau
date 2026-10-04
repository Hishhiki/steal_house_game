local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local dropEvent = remotes:WaitForChild("DropItem")
local services = ServerScriptService:WaitForChild("Services")

local CarryService = require(
	services:WaitForChild("CarryService")
)

dropEvent.OnServerEvent:Connect(function(player)
	CarryService:Drop(player)
end)
