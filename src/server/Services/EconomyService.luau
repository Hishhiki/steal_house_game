local EconomyService = {}

local STARTING_CASH = 1000

function EconomyService:SetupPlayer(player)
    player:SetAttribute("Cash", STARTING_CASH)
end

function EconomyService:TrySpend(player, amount)
    if amount <= 0 or amount >= math.huge or amount ~= amount then
        return false
    end

    local cash = player:GetAttribute("Cash")
    if cash == nil or cash < amount then
        return false
    end

    player:SetAttribute("Cash", cash - amount)
    return true
end
return EconomyService