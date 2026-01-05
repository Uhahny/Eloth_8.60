local waittime = 5 -- seconds
local storage = 5568

function onUse(player, item, fromPosition, target, toPosition)
    local currentTime = os.time()
    local cooldown = player:getStorageValue(storage)

    if cooldown ~= -1 and cooldown > currentTime then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "You have to wait " .. (cooldown - currentTime) .. " seconds.")
        return true
    else
        player:setStorageValue(storage, currentTime + waittime)
    end

    local firstPlayerPosition = Position(32354, 32228, 8)
    local secondPlayerPosition = Position(32356, 32228, 8)
    local arenaLevel = 120

    local firstPlayer = Tile(firstPlayerPosition):getTopCreature()
    local secondPlayer = Tile(secondPlayerPosition):getTopCreature()

    if not firstPlayer or not secondPlayer or not firstPlayer:isPlayer() or not secondPlayer:isPlayer() then
        player:sendCancelMessage("You need 2 players for a duel.")
        return true
    end

    if firstPlayer:getLevel() < arenaLevel or secondPlayer:getLevel() < arenaLevel then
        player:sendCancelMessage("Both fighters must have level 120.")
        return true
    end

    -- sprawdz, czy arena jest pusta
    for x = 32352, 32363 do
        for y = 32226, 32232 do
            local tile = Tile(Position(x, y, 13))
            if tile then
                local creature = tile:getTopCreature()
                if creature then
                    if creature:isPlayer() then
                        player:sendCancelMessage("Wait for current duel to end.")
                        return true
                    elseif creature:isMonster() then
                        creature:remove()
                    end
                end
            end
        end
    end

    -- transformacja dzwigni
    item:transform(item.itemid == 1945 and 1946 or 1945)

    local newFirstPlayerPosition = Position(32355, 32229, 13)
    local newSecondPlayerPosition = Position(32360, 32229, 13)

    firstPlayer:getPosition():sendMagicEffect(CONST_ME_POFF)
    secondPlayer:getPosition():sendMagicEffect(CONST_ME_POFF)

    firstPlayer:teleportTo(newFirstPlayerPosition)
    secondPlayer:teleportTo(newSecondPlayerPosition)

    newFirstPlayerPosition:sendMagicEffect(CONST_ME_TELEPORT)
    newSecondPlayerPosition:sendMagicEffect(CONST_ME_TELEPORT)

    firstPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "FIGHT!")
    secondPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "FIGHT!")

    return true
end
