function onUse(player, item, fromPosition, target, toPosition)
    local rewardStorage = 12900
    local rewardItems = {
        [12901] = {id = 2495, message = "You have found a Demon Legs."}, -- demon legs
        [12902] = {id = 8905, message = "You have found a Rainbow Shield."}, -- rainbow shield
        [12903] = {id = 8851, message = "You have found a Royal Crossbow."}, -- royal crossbow
        [12904] = {id = 8918, message = "You have found a Spellbook of Dark Mysteries."} -- spellbook
    }

    local reward = rewardItems[item.uid]
    if not reward then
        return false
    end

    if player:getStorageValue(rewardStorage) < 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, reward.message)
        player:addItem(reward.id, 1)
        player:setStorageValue(rewardStorage, 1)
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
    end

    return true
end
