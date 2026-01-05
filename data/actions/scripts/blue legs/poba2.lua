function onUse(player, item, fromPosition, target, toPosition)
    if item.uid == 7512 then
        local questStatus = player:getStorageValue(7612)
        if questStatus < 1 then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found one piece of the broken amulet.")
            player:addItem(8263, 1)
            player:setStorageValue(7612, 1)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
        end
    end
    return true
end