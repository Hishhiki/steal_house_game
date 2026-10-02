local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Services = ServerScriptService:WaitForChild("Services")

local CarryService = require(Services:WaitForChild("CarryService"))
local ItemService = require(Services:WaitForChild("ItemService"))

print("Main started")

ItemService:Init()

Players.PlayerAdded:Connect(function(player)
	print("Игрок вошёл:", player.Name)
end)

