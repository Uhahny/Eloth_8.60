local config = {
    storage = 50984,
    key_id = 2092, -- Key ID
    key_aid = 3520
}

function onUse(player, item, fromPosition, target, toPosition)
    if item:getUniqueId() ~= 57346 then
        return false
    end

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
        player:sendTextMessage(MESSAGE_INFO_DESCR, "The box is empty.")
    end
    return true
end
