local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local dropEvent = Remotes:WaitForChild("DropItem")

local buttonConnection = nil

local function bindGameUI(gameUI)
    if not gameUI:IsA("ScreenGui") then
        return
    end

    local dropButton = gameUI:WaitForChild("DropButton", 10)
    if gameUI.Parent ~= playerGui then
        return
    end

    if not dropButton or not dropButton:IsA("GuiButton") then
        warn("GameUI должен содержать кнопку DropButton")
        return
    end

    if buttonConnection then
        buttonConnection:Disconnect()
    end

    buttonConnection = dropButton.Activated:Connect(function()
        dropEvent:FireServer()
    end)
end

playerGui.ChildAdded:Connect(function(child)
    if child.Name == "GameUI" then
        bindGameUI(child)
    end
end)

local gameUI = playerGui:FindFirstChild("GameUI")
if gameUI then
    bindGameUI(gameUI)
end
