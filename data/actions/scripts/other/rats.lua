-- rook lever by Sasir~ (TFS 1.5 compatible)
local posi3 = {x=32102, y=32205, z=8}

local poss = {
    [1] = {x=32099, y=32205, z=8},
    [2] = {x=32100, y=32205, z=8},
    [3] = {x=32101, y=32205, z=8}
}

local lever = {
    [1] = {x=32098, y=32204, z=8},
    [2] = {x=32104, y=32204, z=8}
}

local itemids = 5770

function onUse(player, item, fromPosition, target, toPosition)
    local o, b

    if item.itemid == 1945 then
        Game.createItem(itemids, 1, poss[1])

        local tile2 = Tile(poss[2])
        if tile2 then
            local item2 = tile2:getItemById(4645)
            if item2 then
                item2:transform(itemids)
            end
        end

        local tile3 = Tile(poss[3])
        if tile3 then
            local item3 = tile3:getItemById(4647)
            if item3 then
                item3:transform(itemids)
            end
        end

        for i = 1, #lever do
            if lever[i].x == fromPosition.x then
                o = i
            end
        end

        b = (o == 1) and 2 or 1

        item:transform(item.itemid + 1)
        local otherLever = Tile(lever[b]):getItemById(1945)
        if otherLever then
            otherLever:transform(1946)
        end

    elseif item.itemid == 1946 then
        for p = 1, #poss do
            local tile = Tile(poss[p])
            if tile then
                local creature = tile:getTopCreature()
                if creature then
                    creature:teleportTo(posi3)
                end
                local topItem = tile:getTopDownItem()
                if topItem and topItem:isItem() then
                    topItem:moveTo(posi3)
                end
            end
        end

        for z = 1, #poss do
            local tile = Tile(poss[z])
            if tile then
                for stack = 0, 255 do
                    local thing = tile:getThing(stack)
                    if thing and thing:isItem() then
                        thing:remove()
                    end
                end
            end
        end

        for i = 1, #lever do
            if lever[i].x == toPosition.x then
                o = i
            end
        end

        b = (o == 1) and 2 or 1

        Game.createItem(4616, 1, poss[1])
        Game.createItem(351, 1, poss[2])
        Game.createItem(351, 1, poss[3])
        Game.createItem(4645, 1, poss[2])
        Game.createItem(4647, 1, poss[3])

        item:transform(item.itemid - 1)
        local otherLever = Tile(lever[b]):getItemById(1946)
        if otherLever then
            otherLever:transform(1945)
        end
    end

    return true
end
