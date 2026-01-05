function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if item.actionid == 58262 and player:getStorageValue(10510) < 1 then
        player:say("It seems by defeating Azerus you have stopped this army from entering your world! Better leave this ghastly place forever.", TALKTYPE_MONSTER_SAY)
        player:setStorageValue(10510, 1)
    end

    return true
end
