function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local leave = Position(32312, 31134, 6)
    local currentArena = player:getStorageValue(42355)

    if player:getStorageValue(item.actionid + currentArena * 10 - 1) == 1 then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 
            "You did arena at level " .. (currentArena + 1) .. "! Now you can take your reward.")

        -- update arena progress
        player:setStorageValue(42355, currentArena + 1) 
        player:setStorageValue(item.actionid + (currentArena + 1) * 10, 1)

        -- free the room
        Game.setStorageValue(item.actionid - 1, 0) 

        -- reset arena flags
        player:setStorageValue(42350, os.time() + 5) 
        player:setStorageValue(42352, 0) 

        player:teleportTo(leave)
        leave:sendMagicEffect(CONST_ME_TELEPORT)
    else
        player:teleportTo(fromPosition)
        fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "First kill monster!")
    end
    return true
end