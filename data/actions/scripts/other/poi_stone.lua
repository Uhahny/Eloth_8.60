function onUse(cid, item, fromPosition, itemEx, toPosition)
    local rockPos = {x = 32852, y = 32319, z = 9}
    local newPos = {x = 32854, y = 32319, z = 9}
    local rockId = 1304

    if item.itemid == 1945 then
        local rock = getTileItemById(rockPos, rockId)
        if rock and rock.uid > 0 then
            doRemoveItem(rock.uid, 1)
            doSendMagicEffect(rockPos, CONST_ME_POFF)
        end
        doTransformItem(item.uid, 1946)

    elseif item.itemid == 1946 then
        doCreateItem(rockId, 1, rockPos)
        doSendMagicEffect(rockPos, CONST_ME_MAGIC_RED)

        -- sprawdz czy kamien istnieje (czyli nie zostal usuniety recznie lub przez blad)
        local rock = getTileItemById(rockPos, rockId)
        if rock and rock.uid > 0 then
            doTeleportThing(cid, newPos)
            doSendMagicEffect(newPos, CONST_ME_TELEPORT)
        end
        doTransformItem(item.uid, 1945)
    end
    return true
end
