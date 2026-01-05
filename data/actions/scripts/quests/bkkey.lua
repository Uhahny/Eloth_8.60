local config = {
    storage = 50305,
    key_id = 2088, -- Key ID
    key_aid = 5010
}

function onUse(player, item, fromPosition, target, toPosition)
    if player:getStorageValue(config.storage) < 1 then
        local key = player:addItem(config.key_id, 1)
        if key then
            key:setAttribute(ITEM_ATTRIBUTE_ACTIONID, config.key_aid)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found a key.")
            player:setStorageValue(config.storage, 1)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found a key, but you have no room to take it.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "The dead tree is empty.")
    end
    return true
end
