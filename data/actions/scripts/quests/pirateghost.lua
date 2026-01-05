local function removeStone(position)
    local tile = Tile(position)
    if tile then
        local item = tile:getTopDownItem()
        if item and item:getId() == 3666 then
            item:remove()
        end
    end
end

function onUse(player, item, fromPosition, target, toPosition)
    local stonePos = {x = 32256, y = 32790, z = 7}

    if item:getId() == 2006 and item:getActionId() == 18899 then
        if player:getStorageValue(1889) == 26 then
            -- sprawdzamy czy item NIE jest w kontenerze
            local parent = item:getParent()
            if not parent or not parent:isContainer() then
                player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONHIT)
                Game.createMonster("Pirate Ghost", {x = 32257, y = 32791, z = 7})
                player:setStorageValue(1889, 27)
                player:removeItem(2006, 1)
                Game.createItem(3666, 1, stonePos)
                addEvent(removeStone, 20000, stonePos)
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR, "You need to hold the item in your hand.")
            end
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You aren't an inquisition member.")
        end
    end
    return true
end
