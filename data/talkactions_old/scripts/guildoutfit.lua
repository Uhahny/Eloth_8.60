local config = {
    exhaustionInSeconds = 30,
    storage = 34534
}

function onSay(player, words, param)
    -- Exhaust
    local now = os.time()
    local nextUse = player:getStorageValue(config.storage)
    if nextUse ~= -1 and nextUse > now then
        player:sendCancelMessage("You can change outfit only once every " .. config.exhaustionInSeconds .. " seconds.")
        return false
    end

    -- Czy w gildii
    local guild = player:getGuild()
    if not guild then
        player:sendCancelMessage("Sorry, you're not in a guild.")
        return false
    end
    local guildId = guild:getId()

    -- Czy lider (3 = GUILDLEVEL_LEADER)
    if player:getGuildLevel() < 3 then
        player:sendCancelMessage("You have to be Leader of your guild to change outfits!")
        return false
    end

    -- Outfit lidera (kopiujemy tabele, zeby nie modyfikowac referencji)
    local pOutfit = player:getOutfit()
    local outfit = {
        lookType   = pOutfit.lookType,
        lookTypeEx = pOutfit.lookTypeEx,
        lookAddons = pOutfit.lookAddons,
        lookHead   = pOutfit.lookHead,
        lookBody   = pOutfit.lookBody,
        lookLegs   = pOutfit.lookLegs,
        lookFeet   = pOutfit.lookFeet,
        lookMount  = pOutfit.lookMount
    }

    local membersChanged = 0
    local message = "*Guild* Your outfit has been changed by leader. (" .. player:getName() .. ")"

    for _, target in ipairs(Game.getPlayers()) do
        if target:getId() ~= player:getId() then
            local tGuild = target:getGuild()
            if tGuild and tGuild:getId() == guildId then
                local newOutfit = outfit

                -- Jesli gracz nie ma odblokowanego tego lookType/addons, zachowujemy jego wlasny lookType/addons
                if not target:hasOutfit(outfit.lookType, outfit.lookAddons) then
                    local tOutfit = target:getOutfit()
                    newOutfit = {
                        lookType   = tOutfit.lookType,
                        lookTypeEx = tOutfit.lookTypeEx,
                        lookAddons = tOutfit.lookAddons,
                        lookHead   = outfit.lookHead,
                        lookBody   = outfit.lookBody,
                        lookLegs   = outfit.lookLegs,
                        lookFeet   = outfit.lookFeet,
                        lookMount  = outfit.lookMount
                    }
                end

                target:setOutfit(newOutfit)
                target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
                target:sendTextMessage(MESSAGE_INFO_DESCR, message)
                membersChanged = membersChanged + 1
            end
        end
    end

    player:setStorageValue(config.storage, now + config.exhaustionInSeconds)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Guild members outfit has been changed. (Total: " .. membersChanged .. ")")
    return false
end
