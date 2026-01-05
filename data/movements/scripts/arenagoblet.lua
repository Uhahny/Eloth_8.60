function onStepIn(creature, item, position, fromPosition)
    local gobletPos = item:getPosition()
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local actionId = item:getActionId()
    local storage, itemId, description

    if actionId == 42360 then
        storage = 42360
        itemId = 5807
        description = "It is given to the courageous victor of the barbarian arena greenhorn difficulty.\nAwarded to " .. player:getName() .. "."
    elseif actionId == 42370 then
        storage = 42370
        itemId = 5806
        description = "It is given to the courageous victor of the barbarian arena scrapper difficulty.\nAwarded to " .. player:getName() .. "."
    elseif actionId == 42380 then
        storage = 42380
        itemId = 5805
        description = "It is given to the courageous victor of the barbarian arena warlord difficulty.\nAwarded to " .. player:getName() .. "."
    else
        return true
    end

    if player:getStorageValue(storage) ~= 1 then
        player:setStorageValue(storage, 1)
        local goblet = Game.createItem(itemId, 1)
        if goblet then
            goblet:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, description)
            goblet:moveTo(gobletPos - Position(0, 1, 0)) -- one tile north
        end
    end

    item:transform(item:getId() - 1)
    return true
end

function onStepOut(creature, item, position)
    item:transform(item:getId() + 1)
    return true
end
