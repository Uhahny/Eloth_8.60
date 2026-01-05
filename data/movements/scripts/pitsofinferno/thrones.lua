local failTeleportPos = Position(32824, 32231, 12)

local thrones = {
    [10001] = {storage = 10001, effect = CONST_ME_FIREAREA, message = "You have touched Verminor큦 throne and absorbed some of his spirit.", failTeleport = Position(32840, 32327, 15)},
    [10002] = {storage = 10002, effect = CONST_ME_FIREWORK_RED, message = "You have touched Infernatil큦 throne and absorbed some of his spirit.", failTeleport = Position(32909, 32211, 15)},
    [10003] = {storage = 10003, effect = CONST_ME_EXPLOSIONAREA, message = "You have touched Tafariel큦 throne and absorbed some of his spirit.", failTeleport = Position(32761, 32243, 15)},
    [10004] = {storage = 10004, effect = CONST_ME_MAGIC_RED, message = "You have touched Apocalypse큦 throne and absorbed some of his spirit.", failTeleport = Position(32875, 32267, 15)},
    [10005] = {storage = 10005, effect = CONST_ME_BLOCKHIT, message = "You have touched Pumin큦 throne and absorbed some of his spirit.", failTeleport = Position(32785, 32279, 15)},
    [10007] = {storage = 10007, effect = CONST_ME_SOUND_RED, message = "You have touched Ashfalor큦 throne and absorbed some of his spirit.", failTeleport = Position(32839, 32310, 15)},
    [10008] = {storage = 10008, effect = CONST_ME_ENERGYHIT, message = "You have touched Bazir큦 throne and absorbed some of his spirit.", failTeleport = Position(32745, 32385, 15)}
}

local throneChecks = {
    [14334] = 10001,
    [14333] = 10002,
    [14332] = 10003,
    [14339] = 10004,
    [14330] = 10005,
    [14329] = 10007,
    [14328] = 10008
}

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local uid = item:getUniqueId()

    -- Obsluga wejscia na tron
    if thrones[uid] then
        local data = thrones[uid]
        if player:getStorageValue(data.storage) == -1 then
            player:setStorageValue(data.storage, 1)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, data.message)
            position:sendMagicEffect(data.effect)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already absorbed some of this spirit.")
            player:teleportTo(data.failTeleport)
            data.failTeleport:sendMagicEffect(CONST_ME_TELEPORT)
        end

    -- Obsluga wejscia na kratki sprawdzajace energie
    elseif throneChecks[uid] then
        local storage = throneChecks[uid]
        if player:getStorageValue(storage) == -1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sorry, but you did not absorb enough energy!")
            player:teleportTo(failTeleportPos)
            failTeleportPos:sendMagicEffect(CONST_ME_MORTAREA)
        end
    end

    return true
end
