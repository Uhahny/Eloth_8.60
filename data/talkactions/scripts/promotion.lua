local config = {
    promotion = 1,     -- docelowy poziom promocji (zazwyczaj 1 = pierwsza promocja)
    minLevel = 20,     -- minimalny level
    cost = 20000,      -- koszt w gp
    premium = "no"     -- "yes"/"no" lub true/false
}

-- czy wymagane premium
local PREMIUM_REQUIRED = (config.premium == true) or (type(config.premium) == "string" and config.premium:lower() == "yes")

-- vocations, które nie moga kupic promocji (ID vocation)
local disabledVocations = { 0 }

function onSay(player, words, param)
    
    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
local voc = player:getVocation()
    local vocId = voc:getId()
    local promotedVocation = voc:getPromotion()

    if table.contains(disabledVocations, vocId) then
        player:sendCancelMessage("Your vocation cannot buy promotion.")
        return false
    end

    if PREMIUM_REQUIRED and not player:isPremium() then
        player:sendCancelMessage("You need a premium account.")
        return false
    end

    if promotedVocation and promotedVocation:getId() == vocId then
        player:sendCancelMessage("You are already promoted.")
        return false
    end

    if player:getLevel() < config.minLevel then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
            "You need level " .. config.minLevel .. " to get promotion.")
        return false
    end

    if not player:removeMoney(config.cost) then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
            "You do not have enough money! (Promotion costs " .. config.cost .. " gp).")
        return false
    end

    if promotedVocation then
        player:setVocation(promotedVocation)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
            "You have been successfully promoted to " .. promotedVocation:getName() .. ".")
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
            "This vocation has no promotion configured.")
    end

    return false
end
