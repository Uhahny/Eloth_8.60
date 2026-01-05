function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- CONFIG
    local questStorage = 50001
    local completedStorage = 4765
    local actionFinished = 1974
    local actionCleanRoom = 1973
    local player_pos_entrada = Position(577, 561, 10) -- zmień na swoje coords wejścia
    local trashPos = Position(33193, 31689, 15) -- gdzie wyrzuca potwory
    local fromPos = Position(576, 560, 10) -- górny lewy róg
    local toPos = Position(586, 572, 10)   -- dolny prawy róg
    -- END CONFIG

    -- Quest zakończony
    if item.actionid == actionFinished and player:getStorageValue(questStorage) == -1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It seems by defeating Azerus you have stopped this army from entering your world! Better leave this ghastly place forever.")
        player:setStorageValue(completedStorage, 1)
        return true
    end

    -- Sprzątanie roomu + teleport gracza
    if item.actionid == actionCleanRoom and player:getStorageValue(questStorage) == -1 then
        local spectators = Game.getSpectators(fromPos, false, false, 11, 11, 13, 13)
        local monsters = {}
        local players = 0

        for _, spec in pairs(spectators) do
            if spec:isPlayer() then
                players = players + 1
            elseif spec:isMonster() then
                table.insert(monsters, spec)
            end
        end

        if players == 0 then
            for _, mon in pairs(monsters) do
                mon:teleportTo(trashPos)
                trashPos:sendMagicEffect(CONST_ME_POFF)
            end
        end

        player:teleportTo(player_pos_entrada)
        player_pos_entrada:sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already finished this quest!")
    return true
end