function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local gobletPos = item:getPosition()
    local targetPos = Position(gobletPos.x, gobletPos.y - 1, gobletPos.z)

    if item.actionid == 42360 and player:getStorageValue(42360) ~= 1 then
        player:setStorageValue(42360, 1)
        local goblet = Game.createItem(5807, 1)
        goblet:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "It is given to the courageous victor of the barbarian arena greenhorn difficulty.\nAwarded to " .. player:getName() .. ".")
        goblet:moveTo(targetPos)

    elseif item.actionid == 42370 and player:getStorageValue(42370) ~= 1 then
        player:setStorageValue(42370, 1)
        local goblet = Game.createItem(5806, 1)
        goblet:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "It is given to the courageous victor of the barbarian arena scrapper difficulty.\nAwarded to " .. player:getName() .. ".")
        goblet:moveTo(targetPos)

    elseif item.actionid == 42380 and player:getStorageValue(42380) ~= 1 then
        player:setStorageValue(42380, 1)
        local goblet = Game.createItem(5805, 1)
        goblet:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "It is given to the courageous victor of the barbarian arena warlord difficulty.\nAwarded to " .. player:getName() .. ".")
        goblet:moveTo(targetPos)
    end

    item:transform(item.itemid - 1)
    return true
end

function onStepOut(creature, item, position, fromPosition)
    item:transform(item.itemid + 1)
    return true
end