function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local yalahar = Position(579, 569, 14)

    if item.itemid == 9738 then
        player:teleportTo(yalahar)
        yalahar:sendMagicEffect(CONST_ME_ENERGYAREA)
    end
    
    return true
end