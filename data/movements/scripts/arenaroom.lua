-- data/movements/scripts/arenaroom.lua
-- TFS 1.5 (Nekiro 8.6) – arena rooms

-- === CONFIG ===
local AID_FIRST_ROOM = 42300
local ROOMS_COUNT    = 10 -- 42300..42309

-- Time per room (seconds)
local ARENA_ROOM_MAX_TIME = 60 -- TODO: set to your value

-- Kick position when time ends
local ARENA_KICK_POSITION = Position(100, 100, 7) -- TODO: PUT YOUR POSITION

-- Storage keys
local STORAGE = {
  ARENA_TIER    = 42355, -- which arena set (0,1,2...). If unused, keep 0.
  ROOM_DEADLINE = 42350, -- deadline (os.time()) for the current room
  STAGE_FLAG_1  = 42351, -- optional flags kept from your original
  STAGE_FLAG_2  = 42352
}

-- Monsters per room (index 0..9 for tier 0). Extend for tiers if needed.
local arenaMonsters = {
  [0] = "Frostfur",
  [1] = "Bloodpaw",
  [2] = "Bovinus",
  [3] = "Achad",
  [4] = "Colerian the Barbarian",
  [5] = "The Hairy One",
  [6] = "Axeitus Headbanger",
  [7] = "Rocky",
  [8] = "Cursed Gladiator",
  [9] = "Orcus the Cruel",
}

-- Spawn positions for each room (AID 42300..42309)
-- TODO: FILL WITH YOUR COORDS
local spawnByAid = {
  [42300] = Position(32209, 31098, 7),
  [42301] = Position(32196, 31098, 7),
  [42302] = Position(32182, 31099, 7),
  [42303] = Position(32168, 31099, 7),
  [42304] = Position(32203, 31084, 7),
  [42305] = Position(32189, 31084, 7),
  [42306] = Position(32175, 31084, 7),
  [42307] = Position(32197, 31070, 7),
  [42308] = Position(32182, 31070, 7),
  [42309] = Position(32189, 31056, 7),
}

-- Global storages:
-- 42300..42309     -> playerId occupying the room (0 = free)
-- 42400..42409     -> monster uid for the room (0 = none)
local MONSTER_UID_BASE = 42400

-- === HELPERS ===
local function roomIndexFromAid(aid)
  return aid - AID_FIRST_ROOM -- 0..9
end

local function getTierSafe(player)
  local tier = player:getStorageValue(STORAGE.ARENA_TIER)
  if type(tier) ~= "number" or tier < 0 then
    tier = 0
    player:setStorageValue(STORAGE.ARENA_TIER, 0)
  end
  return tier
end

local function monsterNameFor(aid, tier)
  local idx = roomIndexFromAid(aid) + (tier * ROOMS_COUNT)
  return arenaMonsters[idx] or arenaMonsters[roomIndexFromAid(aid)] or "Rotworm"
end

local function clearRoom(aid)
  -- remove monster
  local idx = roomIndexFromAid(aid)
  local monsterUid = Game.getStorageValue(MONSTER_UID_BASE + idx)
  if type(monsterUid) == "number" and monsterUid > 0 then
    local m = Creature(monsterUid)
    if m then
      m:remove()
    end
  end
  Game.setStorageValue(MONSTER_UID_BASE + idx, 0)
  -- free room
  Game.setStorageValue(aid, 0)
end

-- === WATCHDOG (periodic check) ===
local initDone = false

local function selfCheck()
  for aid = AID_FIRST_ROOM, AID_FIRST_ROOM + ROOMS_COUNT - 1 do
    local playerId = Game.getStorageValue(aid)
    if type(playerId) ~= "number" then
      Game.setStorageValue(aid, 0)
    elseif playerId > 0 then
      local player = Player(playerId)
      if not player then
        -- player left/vanished
        Game.setStorageValue(aid, 0)
      else
        local deadline = player:getStorageValue(STORAGE.ROOM_DEADLINE)
        if type(deadline) == "number" and deadline > 0 then
          local now = os.time()
          if deadline <= now then
            player:teleportTo(ARENA_KICK_POSITION)
            player:setStorageValue(STORAGE.ROOM_DEADLINE, 0)
            Game.setStorageValue(aid, 0)
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
              "You have been kicked from the arena! You only have " .. ARENA_ROOM_MAX_TIME .. " seconds per room.")
          elseif (deadline - 10) <= now then
            player:sendTextMessage(MESSAGE_EVENT_DEFAULT,
              "You have " .. (deadline - now) .. " seconds to reach the next room!")
          end
        end
      end
    end
  end
  addEvent(selfCheck, 1000)
end

local function initArenaGlobals()
  if initDone then return end
  initDone = true
  for i = 0, ROOMS_COUNT - 1 do
    Game.setStorageValue(AID_FIRST_ROOM + i, 0)           -- room free
    Game.setStorageValue(MONSTER_UID_BASE + i, 0)         -- no monster
  end
  addEvent(selfCheck, 1000)
end

-- === MOVEMENT HANDLER ===
function onStepIn(creature, item, position, fromPosition)
  if not creature:isPlayer() then
    return true
  end
  local player = creature
  initArenaGlobals()

  local aid = item:getActionId()
  if aid < AID_FIRST_ROOM or aid >= AID_FIRST_ROOM + ROOMS_COUNT then
    return true
  end

  local tier = getTierSafe(player)
  local currentRoomIdx = roomIndexFromAid(aid)

  -- Allow entering first room always; else require previous room cleared
  local canEnter
  if currentRoomIdx == 0 then
    canEnter = true
  else
    local clearedKey = aid + (tier * ROOMS_COUNT) - 1
    local clearedVal = player:getStorageValue(clearedKey)
    canEnter = (type(clearedVal) == "number" and clearedVal == 1)
  end

  if not canEnter then
    player:teleportTo(fromPosition, true)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "First kill the previous monster!")
    return true
  end

  -- Check if room is free
  local occupierId = Game.getStorageValue(aid)
  if type(occupierId) ~= "number" or occupierId == 0 then
    -- Clean old monster just in case
    clearRoom(aid)

    local spawnPos = spawnByAid[aid] or item:getPosition()
    local mName = monsterNameFor(aid, tier)
    local monster = Game.createMonster(mName, spawnPos)
    if monster then
      Game.setStorageValue(MONSTER_UID_BASE + currentRoomIdx, monster:getId())
    else
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Arena error: failed to create monster '" .. mName .. "'.")
    end

    player:teleportTo(spawnPos, true)
    Game.setStorageValue(aid, player:getId())
    if currentRoomIdx > 0 then
      Game.setStorageValue(aid - 1, 0) -- free previous room slot
    end
    player:setStorageValue(STORAGE.ROOM_DEADLINE, os.time() + ARENA_ROOM_MAX_TIME)

  else
    -- Room occupied
    player:teleportTo(fromPosition, true)
    local occ = Player(occupierId)
    local name = occ and occ:getName() or "Someone"
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, name .. " is in the next room. Please wait and try again.")
  end

  -- Keep your original stage flags on first room
  if aid == AID_FIRST_ROOM then
    player:setStorageValue(STORAGE.STAGE_FLAG_1, 0)
    player:setStorageValue(STORAGE.STAGE_FLAG_2, 1)
  end
  return true
end
