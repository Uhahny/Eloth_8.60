function onUse(player, item, fromPosition, target, toPosition)
    local level = 120
    local onePerQuest = true

    local positions = {
        kick = Position(32713, 32339, 7),
        summon = {
            Position(32713, 32348, 7),
            Position(32720, 32349, 7),
            Position(32720, 32354, 7),
            Position(32711, 32353, 7)
        }
    }

    local summons = {
        [1] = {"Demon", "Grim Reaper", "Elder Beholder", "Demon Skeleton"},
        [2] = {"Dark Torturer", "Banshee", "Betrayed Wraith", "Blightwalker"},
        [3] = {"Bonebeast", "Braindeath", "Diabolic Imp", "Giant Spider"},
        [4] = {"Hand of Cursed Fate", "Lich", "Undead Dragon", "Vampire"},
        [5] = {"Braindeath", "Demon", "Bonebeast", "Diabolic Imp"},
        [6] = {"Demon Skeleton", "Banshee", "Elder Beholder", "Bonebeast"},
        [7] = {"Dark Torturer", "Undead Dragon", "Demon", "Demon"},
        [8] = {"Elder Beholder", "Betrayed Wraith", "Demon Skeleton", "Giant Spider"},
        [9] = {"Demon", "Banshee", "Blightwalker", "Demon Skeleton"},
        [10] = {"Grim Reaper", "Demon", "Diabolic Imp", "Braindeath"},
        [11] = {"Banshee", "Grim Reaper", "Hand of Cursed Fate", "Demon"}
    }

    local areaPosition = {
        Position(32709, 32345, 7),
        Position(32725, 32355, 7)
    }

    local demonOak = {8288, 8289, 8290, 8291}

    local storages = {
        done = 35700,
        cutTree = 36901
    }

    local blockingTree = {
        [2709] = {uid = 32193, transformTo = 3669}
    }

    -- Handling tree chop
    local blocking = blockingTree[target.itemid]
    if blocking and target.uid == blocking.uid then
        if player:getLevel() < level then
            player:sendCancelMessage("You need level " .. level .. " or more to enter this quest.")
            return true
        end

        if player:getStorageValue(storages.done) > 0 then
            player:sendCancelMessage("You already done this quest.")
            return true
        end

        if player:getStorageValue(storages.cutTree) > 0 then
            return false
        end

        if onePerQuest then
            for _, pid in pairs(Game.getPlayers()) do
                if isInRange(pid:getPosition(), areaPosition[1], areaPosition[2]) then
                    player:sendCancelMessage("Wait until " .. pid:getName() .. " finishes the quest.")
                    return true
                end
            end
        end

        target:transform(blocking.transformTo)
        toPosition:sendMagicEffect(CONST_ME_POFF)
        player:teleportTo(player:getPosition():move(0, 1, 0)) -- SOUTH
        player:setStorageValue(storages.cutTree, 1)
        return true
    end

    -- Handling demon oak hit
    if table.contains(demonOak, target.itemid) then
        local stage = player:getStorageValue(target.itemid)
        if stage == -1 then
            stage = 1
        end

        if player:getStorageValue(8288) == 12 and player:getStorageValue(8289) == 12 and player:getStorageValue(8290) == 12 and player:getStorageValue(8291) == 12 then
            player:teleportTo(positions.kick)
            player:setStorageValue(storages.done, 1)
            return true
        end

        if stage > 11 then
            toPosition:sendMagicEffect(CONST_ME_POFF)
            return true
        end

        if math.random(100) <= 10 then
            player:setStorageValue(target.itemid, 12)
            return true
        end

        if summons[stage] then
            for i = 1, #summons[stage] do
                Game.createMonster(summons[stage][i], positions.summon[i])
            end
            toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
            player:setStorageValue(target.itemid, stage + 1)

            if math.random(100) >= 50 then
                player:addHealth(-math.random(270, 310))
                player:getPosition():sendMagicEffect(CONST_ME_BIGPLANTS)
            end
        end

        return false
    end

    return false
end
