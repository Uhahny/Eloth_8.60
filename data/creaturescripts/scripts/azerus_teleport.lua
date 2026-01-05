-- Azerus -> spawn a temporary teleport on death (TFS 1.5, Nekiro 8.6)

local TELEPORT_ITEMID     = 1387                         -- classic teleport
local DESTINATION         = Position(32778, 31206, 7)    -- where it sends players
local TELEPORT_LIFETIME_S = 60                           -- lifetime in seconds
local ACTION_ID           = 45231                        -- unique AID to identify/remove

function onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
    if not creature or not creature:isMonster() then
        return true
    end
    if creature:getName():lower() ~= "azerus" then
        return true
    end

    local pos = creature:getPosition()

    -- If a previous teleport with the same AID exists here, remove it first
    local tile = Tile(pos)
    if tile then
        local existing = tile:getItemById(TELEPORT_ITEMID)
        if existing and existing:getActionId() == ACTION_ID then
            existing:remove()
        end
    end

    -- Create teleport and set destination
    local tp = Game.createItem(TELEPORT_ITEMID, 1, pos)
    if not tp then
        return true
    end
    tp:setActionId(ACTION_ID)
    tp:setDestination(DESTINATION)
    pos:sendMagicEffect(CONST_ME_TELEPORT)

    -- Schedule auto-removal after TELEPORT_LIFETIME_S
    addEvent(function(p, aid)
        local t = Tile(p)
        if not t then return end
        local it = t:getItemById(TELEPORT_ITEMID)
        if it and it:getActionId() == aid then
            it:remove()
            p:sendMagicEffect(CONST_ME_POFF)
        end
    end, TELEPORT_LIFETIME_S * 1000, pos, ACTION_ID)

    return true
end
