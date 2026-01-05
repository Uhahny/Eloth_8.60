function onUse(player, item, fromPosition, target, toPosition)
player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your storage 35700 is: " .. player:getStorageValue(35700))
    local newPosition = Position(32713, 32394, 8)
    local storageKey = 35700

    if item:getUniqueId() == 55100 and player:getStorageValue(storageKey) > 0 then
        player:teleportTo(newPosition)
        newPosition:sendMagicEffect(CONST_ME_TELEPORT)
        fromPosition:sendMagicEffect(CONST_ME_POFF)
        player:setStorageValue(storageKey, -1)
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Nothing happens.")
    end

    return true
end
