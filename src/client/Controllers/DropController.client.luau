local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")
local gameUI = playerGui:WaitForChild("GameUI")
local dropButton = gameUI:WaitForChild("DropButton")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local dropEvent = Remotes:WaitForChild("DropItem")

dropButton.MouseButton1Click:Connect(function()
    dropEvent:FireServer()
end)
