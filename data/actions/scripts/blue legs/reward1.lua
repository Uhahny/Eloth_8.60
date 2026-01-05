function onUse(player, item, fromPosition, target, toPosition)
    if item.uid == 7516 then
        local questStatus = player:getStorageValue(7616)
        if questStatus < 1 then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found Blue Legs.")
            player:addItem(7730, 1)
            player:setStorageValue(7616, 1)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You already done this quest.")
        end
    end
    return true
end