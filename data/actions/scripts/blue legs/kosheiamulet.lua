function onUse(player, item, fromPosition, target, toPosition)
    -- sprawdzamy czy kliknięty obiekt to amulet (6028)
    if target.itemid == 6028 then
        if player:getStorageValue(36205) < 1 then
            player:say("At least I have it back, my precious amulet. I am glad you didn't use it! I allow you to ...ahh....enter door.... ahh", TALKTYPE_MONSTER_SAY, false, player, Position(toPosition.x, toPosition.y - 1, toPosition.z))
            
            item:remove(1) -- usuwa przedmiot z użycia (np. quest item)
            player:setStorageValue(36205, 1)
        end
    end
    return true
end