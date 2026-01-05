function onSpeak(player, type, message)
    local playerAccountType = player:getAccountType()

    -- globalny próg: poniżej 50 lvl nie można pisać (poza GM)
    if playerAccountType < ACCOUNT_TYPE_GAMEMASTER and player:getLevel() < 50 then
        player:sendCancelMessage("You need level 50 to speak in channels.")
        return false
    end

    -- reszta jak w Twojej wersji
    if type == TALKTYPE_CHANNEL_Y then
        if playerAccountType >= ACCOUNT_TYPE_GAMEMASTER then
            type = TALKTYPE_CHANNEL_O
        end
    elseif type == TALKTYPE_CHANNEL_O then
        if playerAccountType < ACCOUNT_TYPE_GAMEMASTER then
            type = TALKTYPE_CHANNEL_Y
        end
    elseif type == TALKTYPE_CHANNEL_R1 then
        if playerAccountType < ACCOUNT_TYPE_GAMEMASTER and not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
            type = TALKTYPE_CHANNEL_Y
        end
    end
    return type
end