-- data/creaturescripts/scripts/arena_onkill.lua
-- TFS 1.5 (Nekiro 8.6) – mark room cleared on monster kill

-- Skonfiguruj zgodnie z arenaroom.lua
local AID_FIRST_ROOM   = 42300
local ROOMS_COUNT      = 10 -- 42300..42309
local MONSTER_UID_BASE = 42400 -- global storages 42400..42409 przechowuja UID potwora
local STORAGE = {
  ARENA_TIER    = 42355, -- który zestaw areny (0,1,2...)
  ROOM_DEADLINE = 42350, -- nie zmieniamy tutaj
}

local function roomIndexFromAid(aid)
  return aid - AID_FIRST_ROOM
end

function onKill(creature, target)
  if not creature or not creature:isPlayer() then
    return true
  end
  if not target or not target:isMonster() then
    return true
  end

  local player = creature
  local targetId = target:getId()

  -- Znajdz, czy zabity potwór jest „tym z areny” – porównujemy z global storage UID
  local foundIdx = nil
  for idx = 0, ROOMS_COUNT - 1 do
    local uid = Game.getStorageValue(MONSTER_UID_BASE + idx)
    if type(uid) == "number" and uid == targetId then
      foundIdx = idx
      break
    end
  end

  if not foundIdx then
    return true -- nie arena monster
  end

  -- Ustal AID pokoju i czy to ten gracz jest „okupantem” pokoju
  local aid = AID_FIRST_ROOM + foundIdx
  local occupierId = Game.getStorageValue(aid)
  if type(occupierId) ~= "number" or occupierId ~= player:getId() then
    -- ktos inny albo pokój juz zwolniony
    -- wyczysc UID potwora, zeby nie blokowalo kolejnych
    Game.setStorageValue(MONSTER_UID_BASE + foundIdx, 0)
    return true
  end

  -- Oznacz pokój jako zaliczony dla TEGO gracza:
  local tier = player:getStorageValue(STORAGE.ARENA_TIER)
  if type(tier) ~= "number" or tier < 0 then tier = 0 end

  -- Klucz zgodny z warunkiem w arenaroom.lua: clearedKey = nextAid + tier*10 - 1
  -- Czyli biezacy pokój ustawia (aid + tier*10) na 1
  local clearedKey = aid + (tier * ROOMS_COUNT)
  player:setStorageValue(clearedKey, 1)

  -- Wyczyszczamy UID potwora w globalu (juz martwy)
  Game.setStorageValue(MONSTER_UID_BASE + foundIdx, 0)

  -- INFO dla gracza
  player:sendTextMessage(MESSAGE_EVENT_DEFAULT, "Room cleared! You can proceed to the next room.")

  return true
end
