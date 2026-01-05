local bosses = {
    {name = 'azerus', storage = 8000, pos = Position(32783, 31160, 10), destination = Position(32778, 31206, 7)},
    {name = 'zugurosh', storage = 8001, pos = Position(1263, 1542, 12), destination = Position(1234, 1576, 12)}
}

local function removeTeleport(position)
    local teleportItem = Tile(position):getItemById(1387)
    if teleportItem then
        teleportItem:remove()
        position:sendMagicEffect(CONST_ME_POFF)
    end
end

function onKill(creature, target)
    if not target:isMonster() then
        return true
    end

    for _, boss in pairs(bosses) do
        if(target:getName():lower() == boss.name) then
            for attackerUid, damage in pairs(target:getDamageMap()) do
                local player = Player(attackerUid)
                if player and player:getStorageValue(boss.storage) < 1 then
                    player:setStorageValue(boss.storage, 1)
                end
            end

            local position = target:getPosition()
            position:sendMagicEffect(CONST_ME_TELEPORT)
            local item = Game.createItem(1387, 1, boss.pos)
            if item:isTeleport() then
                item:setDestination(boss.destination)
            end

            target:say('Congratulations on killing ' .. target:getName() .. '. You have 3 minutes to enter the Crystal Caves.', TALKTYPE_MONSTER_SAY, 0, 0, position)
            addEvent(removeTeleport, 3 * 60 * 1000, boss.pos)
        end
    end
end