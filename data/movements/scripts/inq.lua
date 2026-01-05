local config = {
    bosses = { -- [aid] = {pos, value, text}
        [1001] = {pos = Position(33069, 31783, 13), value = 1, text = "Entering The Crystal Caves"},
        [1002] = {pos = Position(33371, 31613, 14), value = 2, text = "Entering The Blood Halls"},
        [1003] = {pos = Position(33153, 31781, 12), value = 3, text = "Entering The Vats"},
        [1004] = {pos = Position(33038, 31753, 15), value = 4, text = "Entering The Arcanum"},
        [1005] = {pos = Position(33199, 31686, 12), value = 5, text = "Entering The Hive"},
        [1006] = {pos = Position(33111, 31682, 12), value = 6, text = "Entering The Shadow Nexus"}
    },
    mainroom = {
        [2001] = {pos = Position(33069, 31783, 13), value = 1, text = "Entering The Crystal Caves"},
        [2002] = {pos = Position(33371, 31613, 14), value = 2, text = "Entering The Blood Halls"},
        [2003] = {pos = Position(33153, 31781, 12), value = 3, text = "Entering The Vats"},
        [2004] = {pos = Position(33038, 31753, 15), value = 4, text = "Entering The Arcanum"},
        [2005] = {pos = Position(33199, 31686, 12), value = 5, text = "Entering The Hive"}
    },
    portals = {
        [3000] = {pos = Position(33163, 31708, 14), text = "Entering Inquisition Portals Room"},
        [3001] = {pos = Position(33158, 31728, 11), text = "Entering The Ward of Ushuriel"},
        [3002] = {pos = Position(33169, 31755, 13), text = "Entering The Undersea Kingdom"},
        [3003] = {pos = Position(33124, 31692, 11), text = "Entering The Ward of Zugurosh"},
        [3004] = {pos = Position(33356, 31590, 11), text = "Entering The Foundry"},
        [3005] = {pos = Position(33197, 31767, 11), text = "Entering The Ward of Madareth"},
        [3006] = {pos = Position(33250, 31632, 13), text = "Entering The Battlefield"},
        [3007] = {pos = Position(33232, 31733, 11), text = "Entering The Ward of The Demon Twins"},
        [3008] = {pos = Position(33094, 31575, 11), text = "Entering The Soul Wells"},
        [3009] = {pos = Position(33197, 31703, 11), text = "Entering The Ward of Annihilon"},
        [3010] = {pos = Position(33105, 31734, 11), text = "Entering The Ward of Hellgorak"}
    },
    storage = 56123
}

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    -- boss portals (set storage)
    local boss = config.bosses[item.actionid]
    if boss then
        if player:getStorageValue(config.storage) < boss.value then
            player:setStorageValue(config.storage, boss.value)
        end
        player:teleportTo(boss.pos)
        boss.pos:sendMagicEffect(CONST_ME_TELEPORT)
        player:say(boss.text, TALKTYPE_MONSTER_SAY)
        return true
    end

    -- main room portals (check storage)
    local main = config.mainroom[item.actionid]
    if main then
        if player:getStorageValue(config.storage) >= main.value then
            player:teleportTo(main.pos)
            main.pos:sendMagicEffect(CONST_ME_TELEPORT)
            player:say(main.text, TALKTYPE_MONSTER_SAY)
        else
            player:teleportTo(fromPosition)
            fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
            player:say("You don't have enough energy to enter this portal.", TALKTYPE_ORANGE_1)
        end
        return true
    end

    -- other portals
    local port = config.portals[item.actionid]
    if port then
        player:teleportTo(port.pos)
        port.pos:sendMagicEffect(CONST_ME_TELEPORT)
        player:say(port.text, TALKTYPE_MONSTER_SAY)
        return true
    end

    return true
end