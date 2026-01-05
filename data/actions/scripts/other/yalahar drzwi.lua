local actionId = 58266      -- actionid drzwi
local storage = 102500      -- wymagany storage >= 1

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.actionid ~= actionId then
        return false
    end

    if player:getStorageValue(storage) >= 1 then
        item:transform(item.itemid == 1211 and 1210 or item.itemid + 1) -- zmiana stanu drzwi
        player:teleportTo(toPosition, true)
        toPosition:sendMagicEffect(CONST_ME_TELEPORT)
    else
        player:sendCancelMessage("The door seems to be sealed against unwanted intruders.")
    end
    return true
end