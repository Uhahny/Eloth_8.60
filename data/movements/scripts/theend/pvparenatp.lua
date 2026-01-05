function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local newPosition = Position(32350, 32230, 8)

    if item.actionid == 7709 then
        position:sendMagicEffect(CONST_ME_POFF)
        player:teleportTo(newPosition)
        newPosition:sendMagicEffect(CONST_ME_TELEPORT)

        -- full heal
        local missingHp = player:getMaxHealth() - player:getHealth()
        if missingHp > 0 then
            player:addHealth(missingHp)
        end

        -- usuń condition fight
        player:removeCondition(CONDITION_INFIGHT)

        -- komunikat
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "You have escaped.")
    end
    return true
end