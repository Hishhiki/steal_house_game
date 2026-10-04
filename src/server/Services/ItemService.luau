local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Services = ServerScriptService:WaitForChild("Services")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local CarryService = require(Services:WaitForChild("CarryService"))
local ItemConfig = require(Shared:WaitForChild("ItemConfig"))
local EconomyService = require(Services:WaitForChild("EconomyService"))

local ItemService = {}

local function setupItem(item)
	if not item:IsA("BasePart") then
		warn("Предмет должен быть физической деталью:", item.Name)
		return
	end
	local prompt = item:FindFirstChild("ProximityPrompt")
	if not prompt or not prompt:IsA("ProximityPrompt") then
		warn("У предмета нет ProximityPrompt:", item.Name)
		return
	end

	local itemType = item:GetAttribute("ItemType")

	if typeof(itemType) ~= "string" then
		warn("ItemType должен быть строкой:", item.Name)
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

	prompt.Triggered:Connect(function(player)
		local ownerId = item:GetAttribute("OwnerId")

		-- Свой предмет можно поднять бесплатно.
		if ownerId == player.UserId then
			CarryService:PickUp(player, item)
			return
		end

		-- Чужие предметы пока нельзя подбирать.
		if ownerId ~= nil then
			print(player.Name, "это чужой предмет")
			return
		end

		local cash = player:GetAttribute("Cash")
		if cash == nil or cash < config.BuyPrice then
			print(player.Name, "недостаточно денег")
			return
		end

		local pickedUp = CarryService:PickUp(player, item)
		if not pickedUp then
			return
		end

		local paid = EconomyService:TrySpend(player, config.BuyPrice)
		if not paid then
			CarryService:Drop(player)
			return
		end

		item:SetAttribute("OwnerId", player.UserId)

		print(player.Name, "купил", item.Name)
		print("Осталось денег:", player:GetAttribute("Cash"))
	end)

	print("Предмет подключен", item.Name)

end

function ItemService:Init()
    local itemsFolder = workspace:WaitForChild("Items")

    itemsFolder.ChildAdded:Connect(function(item)
        setupItem(item)
    end)

    for _, item in itemsFolder:GetChildren() do
        setupItem(item)
    end
end

return ItemService
