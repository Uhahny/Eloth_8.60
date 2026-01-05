-- Inquisition Quest - Nexus

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.uid == 6669 then
        local storage = 6669
        if player:getStorageValue(storage) < 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You destroy a Shadow of Nexus. Go to Thais for your reward.")
            player:setStorageValue(storage, 1)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This nexus has already been destroyed.")
        end
    end
    return true
end