function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local leave = Position(32312, 31134, 6)

    -- jeśli gracz nie ukończył całej pierwszej areny
    if player:getStorageValue(42309) < 1 then
        for i = 42300, 42309 do
            player:setStorageValue(i, 0)
        end
    end

    -- jeśli gracz nie ukończył całej drugiej areny
    if player:getStorageValue(42319) < 1 then
        for i = 42310, 42319 do
            player:setStorageValue(i, 0)
        end
    end

    -- jeśli gracz nie ukończył całej trzeciej areny
    if player:getStorageValue(42329) < 1 then
        for i = 42320, 42329 do
            player:setStorageValue(i, 0)
        end
    end

    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You left arena!")
    player:teleportTo(leave)
    leave:sendMagicEffect(CONST_ME_TELEPORT)

    -- zwolnienie pokoju
    Game.setStorageValue(item.actionid - 21, 0)

    -- reset flag
    player:setStorageValue(42350, os.time() + 5) 
    player:setStorageValue(42352, 0)

    return true
end