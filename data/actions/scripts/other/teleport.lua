-- data/actions/scripts/other/teleport.lua

if not table.contains then
    function table.contains(tbl, val)
        for i = 1, #tbl do
            if tbl[i] == val then
                return true
            end
        end
        return false
    end
end

local upFloorIds = {1386, 3678, 5543}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if table.contains(upFloorIds, item.itemid) then
        fromPosition:moveUpstairs()
    else
        fromPosition.z = fromPosition.z + 1
    end

    local tile = Tile(fromPosition)
    if player:isPzLocked() and tile and tile:hasFlag(TILESTATE_PROTECTIONZONE) then
        player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
        return true
    end

    player:teleportTo(fromPosition, false)
    return true
end
