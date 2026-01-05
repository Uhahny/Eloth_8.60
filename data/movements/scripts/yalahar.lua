-- Simple teleport system by actionid

local teleports = {
    [1393] = Position(32889, 31044, 9),
    [1394] = Position(32894, 31046, 9),
    [1392] = Position(32861, 31061, 9),
    [1391] = Position(32856, 31055, 9)
}

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local dest = teleports[item.actionid]
    if not dest then
        return true
    end

    player:teleportTo(dest)
    dest:sendMagicEffect(CONST_ME_TELEPORT)
    return true
end