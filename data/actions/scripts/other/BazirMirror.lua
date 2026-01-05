function onUse(cid, item, frompos, item2, topos)
    local stoneId = 6434

    -- Pozycje kamieni
    local fromStone = {x = 32739, y = 32392, z = 14}
    local toStone = {x = 32739, y = 32393, z = 14}

    -- Pobierz obiekt kamienia z aktualnej pozycji
    local stone = getTileItemById(fromStone, stoneId)

    if stone and stone.uid > 0 then
        -- Usun stary kamien i stwórz nowy w nowej pozycji
        doRemoveItem(stone.uid, 1)
        doCreateItem(stoneId, 1, toStone)
        doSendMagicEffect(fromStone, CONST_ME_POFF)
        doSendMagicEffect(toStone, CONST_ME_TELEPORT)
    else
        doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "There is nothing to move.")
    end

    return true
end
