-- Keyed door (AID=5010) opener/closer for TFS 1.5 (Nekiro 8.6).
-- Adds toggle behavior and auto-close without relying on decay().

local REQUIRED_AID   = 5010
local AUTO_CLOSE_MS  = 5000  -- auto-close after 5 seconds
local MAX_RETRIES    = 6     -- how many times to retry closing if blocked
local RETRY_MS       = 2000  -- wait 2s between retries

-- Find open variant for a closed door id.
local function findOpenDoorId(closedId)
    if Door and Door.getOpenDoorId then
        local openId = Door.getOpenDoorId(closedId)
        if openId and openId ~= 0 then
            return openId
        end
    end
    -- Heuristic: many 8.6 pairs are consecutive (closedId + 1 = open)
    local candidate = closedId + 1
    local candType = ItemType(candidate)
    if candType and candType:isDoor() then
        return candidate
    end
    return 0
end

-- Find closed variant for an open door id.
local function findClosedDoorId(openId)
    if Door and Door.getClosedDoorId then
        local closedId = Door.getClosedDoorId(openId)
        if closedId and closedId ~= 0 then
            return closedId
        end
    end
    -- Heuristic inverse: openId - 1 = closed
    local candidate = openId - 1
    local candType = ItemType(candidate)
    if candType and candType:isDoor() then
        return candidate
    end
    return 0
end

-- Best-effort check if current itemid looks like an "open" door
local function looksOpenDoor(itemId)
    -- If we can derive a closed variant, treat it as open
    return findClosedDoorId(itemId) ~= 0
end

local function tryCloseDoor(uid, closedId, retries)
    local item = Item(uid)
    if not item then
        return
    end
    local pos = item:getPosition()
    local tile = Tile(pos)

    -- Don't close on top of creatures
    if tile and tile:getTopCreature() then
        if retries > 0 then
            addEvent(tryCloseDoor, RETRY_MS, uid, closedId, retries - 1)
        end
        return
    end

    item:transform(closedId)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Must use the key on a door item
    if not target or not target:isItem() then
        return false
    end

    -- Key must have AID 5010
    if item:getActionId() ~= REQUIRED_AID then
        player:sendCancelMessage("This key does not seem to fit.")
        return true
    end

    -- Door must have matching AID 5010
    if target:getActionId() ~= REQUIRED_AID then
        player:sendCancelMessage("This key does not seem to fit.")
        return true
    end

    local ttype = target:getType()
    if not ttype or not ttype:isDoor() then
        player:sendCancelMessage("You can only use this key on a door.")
        return true
    end

    local currentId = target:getId()

    -- If door looks open -> try to close (toggle)
    if looksOpenDoor(currentId) then
        local closedId = findClosedDoorId(currentId)
        if closedId == 0 then
            player:sendCancelMessage("This door cannot be closed.")
            return true
        end

        -- Avoid closing on top of creatures
        local tile = Tile(target:getPosition())
        if tile and tile:getTopCreature() then
            player:sendCancelMessage("Someone is blocking the doorway.")
            return true
        end

        target:transform(closedId)
        player:say("Click!", TALKTYPE_MONSTER_SAY, false, player)
        return true
    end

    -- Otherwise, treat as closed -> open it
    local openId = findOpenDoorId(currentId)
    if openId == 0 then
        player:sendCancelMessage("This door cannot be opened.")
        return true
    end

    target:transform(openId)
    player:say("Click!", TALKTYPE_MONSTER_SAY, false, player)

    -- Auto-close after a delay, retry if blocked
    if AUTO_CLOSE_MS and AUTO_CLOSE_MS > 0 then
        local closedId = findClosedDoorId(openId)
        if closedId ~= 0 then
            addEvent(tryCloseDoor, AUTO_CLOSE_MS, target.uid, closedId, MAX_RETRIES)
        end
    end

    return true
end
