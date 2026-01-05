-- Teleport system (lever/portal actionid based)

local teleports = {
    -- [actionid] = {itemid, position}
    [51151] = {9531, Position(32729, 31201, 5)},
    [51152] = {9531, Position(32734, 31201, 5)},
    [51153] = {9534, Position(32745, 31161, 5)},
    [51154] = {9534, Position(32745, 31164, 5)},
    [51155] = {9531, Position(32777, 31141, 5)},
    [51156] = {9531, Position(32777, 31145, 5)},
    [51157] = {9534, Position(32773, 31116, 7)},
    [51158] = {9534, Position(32780, 31116, 7)},
    [51159] = {9531, Position(32874, 31201, 5)},
    [51160] = {9531, Position(32869, 31201, 5)},
    [51161] = {9534, Position(32855, 31251, 5)},
    [51162] = {9534, Position(32855, 31248, 5)},
    [51163] = {9534, Position(32834, 31269, 5)},
    [51164] = {9534, Position(32834, 31266, 5)},
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local entry = teleports[item.actionid]
    if not entry then
        return false
    end

    if item.itemid ~= entry[1] then
        player:sendCancelMessage("Nothing happens.")
        return true
    end

    local dest = entry[2]
    fromPosition:sendMagicEffect(CONST_ME_POFF)
    player:teleportTo(dest)
    dest:sendMagicEffect(CONST_ME_TELEPORT)
    return true
end