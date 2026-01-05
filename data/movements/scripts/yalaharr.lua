-- Teleports by actionid

local teleports = {
    [9105]  = {pos = Position(32783, 31173, 10), effect = CONST_ME_MAGIC_BLUE},
    [9106]  = {pos = Position(32784, 31178, 9),  effect = CONST_ME_MAGIC_BLUE},
    [24061] = {pos = Position(32778, 31171, 14), effect = CONST_ME_TELEPORT}
}

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local t = teleports[item.actionid]
    if not t then
        return true
    end

    player:teleportTo(t.pos)
    t.pos:sendMagicEffect(t.effect)
    return true
end