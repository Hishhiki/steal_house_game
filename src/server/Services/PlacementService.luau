local PlacementService = {}

function PlacementService:Place(player, slot)
    local carriedItem = player:FindFirstChild("CarriedItem")
    if typeof(slot) ~= "Instance" or not slot:IsA("BasePart") then
        return false
    end

    local plotsFolder = workspace:FindFirstChild("Plots")
    local slotsFolder = slot.Parent
    local plot = slotsFolder and slotsFolder.Parent

    if not plotsFolder
        or not slotsFolder
        or slotsFolder.Name ~= "Slots"
        or not plot
        or not plot:IsA("Model")
        or plot.Parent ~= plotsFolder then
        return false
    end

    if plot:GetAttribute("OwnerId") ~= player.UserId then
        return false
    end

    if not carriedItem or not carriedItem.Value then
        return false
    end

    local item = carriedItem.Value

    local itemsFolder = workspace:FindFirstChild("Items")
    if not item:IsA("BasePart") or not itemsFolder or item.Parent ~= itemsFolder then
        return false
    end

    if item:GetAttribute("OwnerId") ~= player.UserId then
        return false
    end
    if item:GetAttribute("State") ~= "Carried" then return false end
    if slot:GetAttribute("Occupied") == true then return false end
    
    local character = player.Character
    if not character then return false end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or humanoid.Health <= 0 or not rootPart or not rootPart:IsA("BasePart") then return false end

    local prompt = slot:FindFirstChildOfClass("ProximityPrompt")

    if not prompt or not prompt.Enabled then return false end

    local distance = (rootPart.Position - slot.Position).Magnitude
    if distance > prompt.MaxActivationDistance then return false end

    local weld = item:FindFirstChild("CarryWeld")
    if weld then
        weld:Destroy()
    end

    item.Anchored = true
    item.CanCollide = true
    item.Massless = false

    
    local height = slot.Size.Y / 2 + item.Size.Y / 2
    item.CFrame = slot.CFrame * CFrame.new(0, height, 0)

    item:SetAttribute("State", "Placed")
    slot:SetAttribute("Occupied", true)

    local placedItem = Instance.new("ObjectValue")
    placedItem.Name = "PlacedItem"
    placedItem.Value = item
    placedItem.Parent = slot

    local itemPrompt = item:FindFirstChildOfClass("ProximityPrompt")
    if itemPrompt then
        itemPrompt.Enabled = false
    end
    prompt.Enabled = false
    carriedItem:Destroy()

    print(player.Name, "placed", item.Name, "in", slot.Name)
    return true
end

function PlacementService:Init()
    local plotsFolder = workspace:WaitForChild("Plots")
    local connectedPrompts = {}

    local function connectPrompt(instance)
        if not instance:IsA("ProximityPrompt") or connectedPrompts[instance] then
            return
        end

        local slot = instance.Parent
        local slotsFolder = slot and slot.Parent
        local plot = slotsFolder and slotsFolder.Parent

        if not slot or not slot:IsA("BasePart")
            or not slotsFolder or not slotsFolder:IsA("Folder")
            or slotsFolder.Name ~= "Slots"
            or not plot or not plot:IsA("Model")
            or plot.Parent ~= plotsFolder then
            return
        end

        connectedPrompts[instance] = true
        instance.ActionText = "Place"
        instance.ObjectText = "Slot"
        instance.Triggered:Connect(function(player)
            self:Place(player, slot)
        end)
    end

    plotsFolder.DescendantAdded:Connect(connectPrompt)
    for _, instance in plotsFolder:GetDescendants() do
        connectPrompt(instance)
    end
end

return PlacementService
