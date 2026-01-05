-- Koshei room check & spawn system
-- Teleport trigger

local storage = 83234
local requiredItem = 8266

local areaFrom = Position(33264, 32402, 12) -- top left
local areaTo   = Position(33278, 32417, 12) -- bottom right

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    local itemCount = player:getItemCount(requiredItem)
    local spawnPos = Position(position.x, position.y - 10, position.z)

    -- count players and monsters in the area
    local players, monsters = 0, {}
    for x = areaFrom.x, areaTo.x do
        for y = areaFrom.y, areaTo.y do
            local tile = Tile(Position(x, y, areaFrom.z))
            if tile then
                local creatures = tile:getCreatures()
                if creatures then
                    for _, c in ipairs(creatures) do
                        if c:isPlayer() then
                            players = players + 1
                        elseif c:isMonster() then
                            table.insert(monsters, c)
                        end
                    end
                end
            end
        end
    end

    if players == 0 and #monsters == 0 and itemCount > 0 then
        -- spawn Koshei if room is empty and player has the item
        Game.createMonster("Koshei The Deathless", spawnPos, true, true)

    elseif players == 0 and #monsters > 0 then
        -- clean monsters if no players
        for _, m in ipairs(monsters) do
            m:remove()
        end
    end

    return true
end