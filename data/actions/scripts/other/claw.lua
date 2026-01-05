local config = {
    conditionsToRemove = {CONDITION_POISON, CONDITION_CURSED},
    timeBetweenUse = 10,
    usesLimit = 60,
    usesLimitTime = 1, -- hours
    damage = 200,
    timeStorage = 64500,
    usesStorage = 64501,
    usesLimitStorage = 64502
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
    if getPlayerStorageValue(cid, config.timeStorage) < 0 then
        setPlayerStorageValue(cid, config.timeStorage, 0)
    end
    if getPlayerStorageValue(cid, config.usesStorage) < 0 then
        setPlayerStorageValue(cid, config.usesStorage, 0)
    end

    local lastUse = getPlayerStorageValue(cid, config.timeStorage)
    local now = os.clock()

    if (now - lastUse) > config.timeBetweenUse then
        if getTilePzInfo(getCreaturePosition(cid)) then
            doCreatureSay(cid, "It tightens around your wrist as you take it on.", TALKTYPE_MONSTER)
        else
            doCreatureSay(cid, "Ouch! The serpent claw stabbed you.", TALKTYPE_MONSTER)
            doCreatureAddHealth(cid, -config.damage)
            doSendMagicEffect(getCreaturePosition(cid), CONST_ME_DRAWBLOOD)
        end

        setPlayerStorageValue(cid, config.timeStorage, now)

        local limitStart = getPlayerStorageValue(cid, config.usesLimitStorage)
        if limitStart < 0 or (now - limitStart) > (config.usesLimitTime * 3600) then
            setPlayerStorageValue(cid, config.usesLimitStorage, now)
            setPlayerStorageValue(cid, config.usesStorage, 1)
        else
            local uses = getPlayerStorageValue(cid, config.usesStorage)
            setPlayerStorageValue(cid, config.usesStorage, uses + 1)

            if (uses + 1) >= config.usesLimit then
                doTransformItem(item.uid, item.itemid + 2)
            end
        end

        for i = 1, #config.conditionsToRemove do
            doRemoveCondition(cid, config.conditionsToRemove[i])
        end
    else
        doPlayerSendCancel(cid, "The claw is still recharging.")
        return false
    end

    return true
end
