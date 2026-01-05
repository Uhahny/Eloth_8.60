-- Custom Team Quest Lever
-- Requires 4 vocations + items placed on basins

local config = {
    switchUid = 1912,
    switchOn = 1945,
    switchOff = 1946,
    requiredLevel = 20,

    -- items that must be placed
    items = {
        {id = 2376, pos = Position(32673, 32094, 8)}, -- sword
        {id = 2455, pos = Position(32673, 32083, 8)}, -- crossbow
        {id = 2674, pos = Position(32667, 32089, 8)}, -- apple
        {id = 2175, pos = Position(32679, 32089, 8)}  -- spellbook
    },

    -- player start positions
    players = {
        {pos = Position(32673, 32093, 8), vocs = {4, 8}, dest = Position(32671, 32069, 8)}, -- Knight
        {pos = Position(32673, 32085, 8), vocs = {3, 7}, dest = Position(32672, 32069, 8)}, -- Paladin
        {pos = Position(32669, 32089, 8), vocs = {2, 6}, dest = Position(32671, 32070, 8)}, -- Druid
        {pos = Position(32677, 32089, 8), vocs = {1, 5}, dest = Position(32672, 32070, 8)}  -- Sorcerer
    }
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.uid ~= config.switchUid then
        return true
    end

    if item.itemid == config.switchOn then
        -- check items on basins
        for _, basin in ipairs(config.items) do
            local thing = Tile(basin.pos):getTopVisibleThing()
            if not thing or thing.itemid ~= basin.id then
                player:sendCancelMessage("Sorry, you need to put the correct items in the correct basins.")
                return true
            end
        end

        -- check players
        local participants = {}
        for i, info in ipairs(config.players) do
            local tile = Tile(info.pos)
            if not tile then
                player:sendCancelMessage("One of the required positions is invalid.")
                return true
            end

            local creature = tile:getTopCreature()
            if not creature or not creature:isPlayer() then
                player:sendCancelMessage("All 4 players must be standing in the right positions.")
                return true
            end

            if creature:getLevel() < config.requiredLevel then
                player:sendCancelMessage("All players must be at least level " .. config.requiredLevel .. ".")
                return true
            end

            if not table.contains(info.vocs, creature:getVocation():getId()) then
                player:sendCancelMessage("Each vocation must be represented (Knight, Paladin, Druid, Sorcerer).")
                return true
            end

            table.insert(participants, {player = creature, dest = info.dest})
        end

        -- teleport players + remove items
        for i, basin in ipairs(config.items) do
            local thing = Tile(basin.pos):getTopVisibleThing()
            if thing then
                thing:remove(1)
            end
        end

        for _, entry in ipairs(participants) do
            entry.player:getPosition():sendMagicEffect(CONST_ME_POFF)
            entry.player:teleportTo(entry.dest)
            entry.dest:sendMagicEffect(CONST_ME_TELEPORT)
        end

        item:transform(config.switchOff)

    elseif item.itemid == config.switchOff then
        item:transform(config.switchOn)
    end
    return true
end