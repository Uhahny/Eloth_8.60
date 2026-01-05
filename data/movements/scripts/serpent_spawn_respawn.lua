local config = {
    monsters = {
        {name = "Serpent Spawn", pos = Position(31994, 31832, 7)},
        {name = "Serpent Spawn", pos = Position(31998, 31832, 7)}
    },
    storage = 91001, -- storage żeby gracz nie spamował
    cooldown = 60 -- czas w sekundach (1 minuta)
}

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if player:getStorageValue(config.storage) > os.time() then
        player:sendCancelMessage("You must wait before stepping here again.")
        player:teleportTo(fromPosition, true)
        return true
    end

    for _, monster in pairs(config.monsters) do
        Game.createMonster(monster.name, monster.pos, true, true)
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have summoned Serpent Spawns!")
    player:setStorageValue(config.storage, os.time() + config.cooldown)
    return true
end