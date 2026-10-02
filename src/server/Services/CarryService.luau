local CarryService = {}

function CarryService:PickUp(player, item)
	if player:FindFirstChild("CarriedItem") then
		print(player.Name, "уже что то несет")
		return	
	end
	
	if item:GetAttribute("State") == "Carried" then
		print(item.Name, "уже кто то несет")
		return
	end
	
	local character = player.Character
	if not character then
		return
	end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return
	end
	
	local prompt = item:FindFirstChild("ProximityPrompt")
	if not prompt then
		return
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
	
	local character  = player.Character
	if not character then
		return
	end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then
		return
	end
	
	local weld = item:FindFirstChild("CarryWeld")
	
 	if weld then
		weld:Destroy()
	end
	
	item.CFrame =  rootPart.CFrame * CFrame.new(0, 0, -4)
	
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