local CarryService = {}

function CarryService:PickUp(player, item)
	if not item:IsA("BasePart") then
		return false	
	end

	local itemsFolder = workspace:FindFirstChild("Items")
	if not itemsFolder or item.Parent ~= itemsFolder then
		return false
	end
	if player:FindFirstChild("CarriedItem") then
		print(player.Name, "уже что то несет")
		return false
	end

	if item:GetAttribute("State") ~= "Available" then
		print(item.Name, "сейчас нельзя поднять")
		return false
	end

	local character = player.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return false
	end

	local prompt = item:FindFirstChild("ProximityPrompt")
	if not prompt or not prompt:IsA("ProximityPrompt") then
		return false
	end

	if not prompt.Enabled then
		return false
	end

	local distance = (rootPart.Position - item.Position).Magnitude
	if distance > prompt.MaxActivationDistance then
		return false
	end

	item:SetAttribute("State", "Carried")

	item.Anchored = false
	item.CanCollide = false
	item.Massless = true

	item.CFrame = rootPart.CFrame * CFrame.new(0, 0, -3)

	local weld = Instance.new("WeldConstraint")
	weld.Name = "CarryWeld"
	weld.Part0 = rootPart
	weld.Parent = item
	weld.Part1 = item

	prompt.Enabled = false

	local carriedItem = Instance.new("ObjectValue")
	carriedItem.Name = "CarriedItem"
	carriedItem.Value = item
	carriedItem.Parent = player

	print(player.Name, "поднял", item.Name)
	return true

end


function CarryService:Drop(player)

	local carriedItem = player:FindFirstChild("CarriedItem")

	if not carriedItem then
		return
	end

	local item = carriedItem.Value

	if not item then
		carriedItem:Destroy()
		return
	end

	local character = player.Character
	local rootPart = nil

	if character then
		rootPart = character:FindFirstChild("HumanoidRootPart")
	end

	local weld = item:FindFirstChild("CarryWeld")

 	if weld then
		weld:Destroy()
	end

	if rootPart then
		item.CFrame = rootPart.CFrame * CFrame.new(0, 0, -4)
	end

	item.Anchored = true
	item.CanCollide = true
	item.Massless = false

	item:SetAttribute("State", "Available")

	local prompt = item:FindFirstChild("ProximityPrompt")
	if prompt then
		prompt.Enabled = true
	end

	carriedItem:Destroy()

	print(player.Name, "сбросил", item.Name)

end
return CarryService