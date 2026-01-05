function onUse(cid, item, frompos, item2, topos)
    local LustroPos = {x = 32739, y = 32392, z = 14}
    local TapestryPos = {x = 32739, y = 32393, z = 14}
    local tpPos = {x = 32712, y = 32392, z = 13}
    local stoneId = 1847

    local getItem2 = getTileItemById(LustroPos, stoneId)
    local getItem3 = getTileThingByPos(TapestryPos)

    if getItem2 and getItem2.itemid == stoneId then
        doTeleportThing(cid, tpPos)
        doSendMagicEffect(tpPos, CONST_ME_TELEPORT)
        
        if getItem3 and getItem3.itemid > 0 then
            doRemoveItem(getItem3.uid, 1)
        end

        local ek = doCreateItem(6434, 1, LustroPos)
        doSetItemActionId(ek, 39511)
    end

    return true
end
