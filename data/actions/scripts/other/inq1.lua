-- Lever that toggles walls on/off
local walls = {
    Position(33226, 31721, 11),
    Position(33227, 31721, 11),
    Position(33228, 31721, 11),
    Position(33229, 31721, 11),
    Position(33230, 31721, 11),
    Position(33231, 31721, 11),
    Position(33232, 31721, 11),
    Position(33233, 31721, 11),
    Position(33234, 31721, 11),
    Position(33235, 31721, 11),
    Position(33236, 31721, 11),
    Position(33237, 31721, 11),
    Position(33238, 31721, 11)
}

local wallClosed = 1524 -- kamienna ściana
local wallOpen   = 1050 -- puste pole (np. dirt)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == 1945 then
        -- remove closed walls, create open tiles
        for _, pos in ipairs(walls) do
            local tile = Tile(pos)
            local thing = tile and tile:getItemById(wallClosed)
            if thing then
                thing:remove()
            end
            Game.createItem(wallOpen, 1, pos)
        end
        item:transform(1946)

    elseif item.itemid == 1946 then
        -- remove open tiles, create closed walls
        for _, pos in ipairs(walls) do
            local tile = Tile(pos)
            local thing = tile and tile:getItemById(wallOpen)
            if thing then
                thing:remove()
            end
            Game.createItem(wallClosed, 1, pos)
        end
        item:transform(1945)

    else
        player:sendCancelMessage("Sorry, not possible.")
    end

    return true
end