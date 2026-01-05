-- Ustaw tu ID kanału Trade, dla którego ma działać cooldown 2 min
local CHANNEL_ADVERTISING = 5

-- 2 minuty mute tylko dla kanału Trade
local muted = Condition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT)
muted:setParameter(CONDITION_PARAM_SUBID, CHANNEL_ADVERTISING)
muted:setParameter(CONDITION_PARAM_TICKS, 120000)

-- (opcjonalnie) używane przez silnik do weryfikacji dołączania do kanału
-- Jeśli chcesz też blokować samo DOŁĄCZANIE poniżej 50 lvl, zostaw to.
-- Jeśli ma dotyczyć tylko pisania, usuń tę funkcję lub dostosuj.
function canJoin(player)
    if player:getAccountType() >= ACCOUNT_TYPE_GAMEMASTER then
        return true
    end
    return player:getLevel() >= 50
end

-- TFS 1.5 sygnatura: onSpeak(player, type, message, channelId)
function onSpeak(player, type, message, channelId)
    -- GM mają pełne uprawnienia i zamieniają Y na O
    if player:getAccountType() >= ACCOUNT_TYPE_GAMEMASTER then
        if type == TALKTYPE_CHANNEL_Y then
            return TALKTYPE_CHANNEL_O
        end
        return true
    end

    -- Blokada pisania dla wszystkich kanałów poniżej 50 lvl
    if player:getLevel() < 50 then
        player:sendCancelMessage("You need level 50 to speak in this channel.")
        return false
    end

    -- Cooldown tylko dla Trade
    if channelId == CHANNEL_ADVERTISING then
        if player:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_ADVERTISING) then
            player:sendCancelMessage("You may only place one offer in two minutes.")
            return false
        end
        player:addCondition(muted)
    end

    -- Ochrona typów wiadomości (jak w oryginale)
    if type == TALKTYPE_CHANNEL_O then
        -- zwykli gracze nie mogą Channel_O -> zamiana na Channel_Y
        type = TALKTYPE_CHANNEL_Y
    elseif type == TALKTYPE_CHANNEL_R1 then
        if not player:hasFlag(PlayerFlag_CanTalkRedChannel) then
            type = TALKTYPE_CHANNEL_Y
        end
    end
    return type
end