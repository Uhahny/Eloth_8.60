-- data/creaturescripts/scripts/logout.lua

nextUseStaminaTime = nextUseStaminaTime or {}

function onLogout(player)
    local playerId = player:getId()
    if nextUseStaminaTime[playerId] ~= nil then
        nextUseStaminaTime[playerId] = nil
    end
    return true
end
