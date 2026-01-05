function onSpeak(player, type, message)
    local accType = player:getAccountType()

    -- Blokada: gracze < 50 lvl nie mogą pisać (GM bez blokady)
    if accType < ACCOUNT_TYPE_GAMEMASTER and player:getLevel() < 50 then
        player:sendCancelMessage("You need level 50 to speak in channels.")
        return false
    end

    -- (opcjonalnie) dodatkowa blokada dla level 1 – już zbędna, ale jeśli chcesz, odkomentuj:
    --[[
    if player:getLevel() == 1 and accType < ACCOUNT_TYPE_GAMEMASTER then
        player:sendCancelMessage("You may not speak into channels as long as you are on level 1.")
        return false
    end
    ]]

    if type == TALKTYPE_CHANNEL_Y then
        if accType >= ACCOUNT_TYPE_GAMEMASTER then
            type = TALKTYPE_CHANNEL_O
        end
    elseif type == TALKTYPE_CHANNEL_O then
        if accType < ACCOUNT_TYPE_GAMEMASTER then
            type = TALKTYPE_CHANNEL_Y
        end
    elseif type == TALKTYPE_CHANNEL_R1 then
        if accType < ACCOUNT_TYPE_GAMEMASTER and not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
            type = TALKTYPE_CHANNEL_Y
        end
    end
    return type
end