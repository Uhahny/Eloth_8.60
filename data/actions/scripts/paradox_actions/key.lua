function onUse(player, item, fromPosition, target, toPosition)
    local config = {
        key_aid = 3899
    }

    if item.uid == 11001 and player:getStorageValue(10004) == -1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a key.")
        local key = player:addItem(2089, 1)
        if key then
            key:setAttribute(ITEM_ATTRIBUTE_ACTIONID, config.key_aid)
        end
        player:setStorageValue(10004, 1)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
    end
    return true
end
