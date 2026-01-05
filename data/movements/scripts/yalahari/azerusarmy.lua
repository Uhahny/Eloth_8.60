function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if item.actionid == 58262 then
        if player:getStorageValue(102505) == 1 then
            player:say("It seems by defeating Azerus you have stopped this army from entering your world! Better leave this ghastly place forever.", TALKTYPE_MONSTER_SAY)
            player:setStorageValue(102503, 3) -- Finishing Quest
            player:setStorageValue(102500, 5)

        elseif player:getStorageValue(102504) == 1 then
            player:say("It seems by defeating Azerus you have stopped this army from entering your world! Better leave this ghastly place forever.", TALKTYPE_MONSTER_SAY)
            player:setStorageValue(102502, 3) -- Finishing Quest
            player:setStorageValue(102500, 5)

        else
            player:say("It seems by defeating Azerus you have stopped this army from entering your world! Better leave this ghastly place forever.", TALKTYPE_MONSTER_SAY)
        end
    end
    return true
end