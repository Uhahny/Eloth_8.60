function onUse(cid, item, frompos, item2, topos)
    local nagroda = 2160
    local iloscnagrody = 10
    local lvl = 30
    local queststorage = 51137
    local exhaustStorage = 51138 -- osobne storage na exhaust
    local exhaustTime = 5 -- sekundy

    local p = Player(cid)
    if not p then
        return false
    end

    -- exhaust check
    if p:getStorageValue(exhaustStorage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return true
    end
    p:setStorageValue(exhaustStorage, os.time() + exhaustTime)

    local playerpos = p:getPosition()
    local playerstorage = p:getStorageValue(queststorage)
    local capnagroda = getItemWeightById(nagroda, iloscnagrody)

    if playerstorage == -1 then
        if p:getLevel() >= lvl then
            if p:getFreeCapacity() >= capnagroda then
                p:addItem(nagroda, iloscnagrody)
                p:sendTextMessage(MESSAGE_INFO_DESCR, "You have found 10 crystal coins.")
                playerpos:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
                p:setStorageValue(queststorage, 1)
            else
                p:sendCancelMessage("You don't have enough capacity for the prize.")
                playerpos:sendMagicEffect(CONST_ME_POFF)
            end
        else
            p:sendCancelMessage("You need level 30 to get the prize.")
            playerpos:sendMagicEffect(CONST_ME_POFF)
        end
    else
        p:sendCancelMessage("It is empty.")
        playerpos:sendMagicEffect(CONST_ME_POFF)
    end
    return true
end
