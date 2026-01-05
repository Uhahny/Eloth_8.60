function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentStamina = player:getStamina() / 60
    local REFUEL_HOURS = 42
    local FULL_HOURS = 40

    if currentStamina >= FULL_HOURS then
        player:sendCancelMessage("Your stamina is already full.")
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Your stamina now is " .. currentStamina .. " h.")
        return true
    end

    player:setStamina(REFUEL_HOURS * 60)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Your stamina has been refilled.")
    item:remove(1)
    return true
end
