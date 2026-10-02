local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Services = ServerScriptService:WaitForChild("Services")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local CarryService = require(Services:WaitForChild("CarryService"))
local ItemConfig = require(Shared:WaitForChild("ItemConfig"))

local ItemService = {}

local function setupItem(item)
	local promtp = item:FindFirstChild("ProximityPrompt")
	if not promtp then
		warn("У предмета нет ProximityPrompt:", item.Name)
		return
	end

	local itemType = item:GetAttribute("ItemType")

	if not itemType then
		warn("У предмета отсутствует ItemType:", item.Name)
		return
	end

	local config = ItemConfig[itemType]

	if not config then
		warn("Нет конфига для типа предмета:", itemType)
		return
	end

	if item:GetAttribute("State") == nil then
		item:SetAttribute("State", "Available")
	end

	promtp.Triggered:Connect(function(player)
		CarryService:PickUp(player, item)
	end)

	print("Предмет подлючен", item.Name)

end

function ItemService:Init()
	local itemsFolder = workspace:WaitForChild("Items")

	for _, item in itemsFolder:GetChildren() do
		setupItem(item)
	end

	itemsFolder.ChildAdded:Connect(function(item)
		setupItem(item)
	end)
end

return ItemService