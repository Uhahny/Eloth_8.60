function onLogin(player)
    local serverName = configManager.getString(configKeys.SERVER_NAME)

    -- First login ? set Town 2 and teleport to temple
    if player:getLastLoginSaved() == 0 then
        local targetTown = Town(2) -- make sure TownID=2 exists in towns.xml/map
        if targetTown then
            local templePos = targetTown:getTemplePosition()
            player:setTown(targetTown)
            player:teleportTo(templePos)
            templePos:sendMagicEffect(CONST_ME_TELEPORT)
        end

        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Welcome to " .. serverName .. "! Please choose your outfit.")
        player:sendOutfitWindow()
    else
        -- Subsequent logins
        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("Welcome to %s!", serverName))
        local last = os.date("%d %b %Y %X", player:getLastLoginSaved())
        player:sendTextMessage(MESSAGE_STATUS_DEFAULT, string.format("Your last visit in %s: %s.", serverName, last))
    end

    -- Promotion handling (TFS 1.x style)
    local vocation = player:getVocation()
    local promotion = vocation and vocation:getPromotion() or nil
    if player:isPremium() then
        if player:getStorageValue(PlayerStorageKeys.promotion) == 1 and promotion then
            player:setVocation(promotion)
        end
    else
        if promotion then
            player:setVocation(vocation:getDemotion())
        end
    end

function onLogin(player)
    player:registerEvent("BossTeleport")
    return true
end


    -- Register events (make sure they exist in creaturescripts.xml)
    player:registerEvent("TaskKill")              -- your task kill counter
    player:registerEvent("PlayerDeath")           -- only if you have this script
    player:registerEvent("DropLoot")              -- only if you have this script
    player:registerEvent("KillingInTheNameOf")    -- only if you actually have such an event
	player:registerEvent("ArenaKill")

    return true
end
