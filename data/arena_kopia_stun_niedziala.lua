-- Hunting Arena (RevScript) — TFS 1.5 (Nekiro 8.6)
-- Single-file version for /home/tfs/data/scripts/arena.lua
-- English messages, separators set for talk actions.

-- ===================== Shared state & config =====================
HArena = HArena or {}

HArena.config = {
    positions = {
        Position(3083, 3050, 7), Position(3099, 3050, 7), Position(3113, 3050, 7),
        Position(3129, 3050, 7), Position(3144, 3050, 7), Position(3160, 3050, 7),
        Position(3175, 3050, 7), Position(3190, 3050, 7), Position(3206, 3050, 7),
        Position(3083, 3067, 7), Position(3099, 3067, 7), Position(3113, 3067, 7),
        Position(3129, 3067, 7), Position(3144, 3067, 7), Position(3160, 3067, 7),
        Position(3175, 3067, 7), Position(3190, 3067, 7), Position(3206, 3067, 7),
        Position(3081, 3085, 7), Position(3097, 3085, 7), Position(3111, 3085, 7),
        Position(3127, 3085, 7), Position(3142, 3085, 7), Position(3158, 3085, 7),
        Position(3173, 3085, 7), Position(3188, 3085, 7), Position(3204, 3085, 7)
    },
    areaFrom = Position(3078, 3044, 7),
    areaTo   = Position(3211, 3089, 7),
    temple   = Position(32369, 32241, 7),
    minLevel = 100,
    requiredItemId = 2157, -- Gold Nugget
    sessionMinutes = 20
}

-- Storage constants
HArena.STORAGE_SLOT        = 156661
HArena.STORAGE_WAVECOUNT   = 156662
HArena.STORAGE_KICK_AT     = 156666
HArena.STORAGE_ENTER_AT    = 156667
HArena.STORAGE_ENTRY_COUNT = 156668
HArena.STORAGE_EXHAUST     = 156665
HArena.STORAGE_BYPASS      = 482933

-- Runtime state
HArena.chosenByPlayerId = HArena.chosenByPlayerId or {}
HArena.kickEventById     = HArena.kickEventById or {}

-- Freeze condition (replacement for setNoMove)
HArena.FREEZE = HArena.FREEZE or (function()
    local c = Condition(CONDITION_PARALYZE)
    c:setParameter(CONDITION_PARAM_TICKS, -1)
    c:setParameter(CONDITION_PARAM_SPEED, -1000)
    return c
end)()

-- Helpers
function HArena.inside(pos)
    local f, t = HArena.config.areaFrom, HArena.config.areaTo
    return pos.z == f.z and pos.x >= f.x and pos.x <= t.x and pos.y >= f.y and pos.y <= t.y
end

function HArena.formatSeconds(secs)
    if secs < 0 then secs = 0 end
    local h = math.floor(secs / 3600)
    local m = math.floor((secs % 3600) / 60)
    local s = math.floor(secs % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

function HArena.cleanMonstersAround(center, radius)
    local creatures = Game.getSpectators(center, false, false, radius, radius, radius, radius)
    for _, c in ipairs(creatures) do
        if c:isMonster() then c:remove() end
    end
end

function HArena.cleanArea(center, radius)
    HArena.cleanMonstersAround(center, radius)
end

function HArena.kickPlayer(player)
    if not player or not player:isPlayer() then return end
    if player:getStorageValue(HArena.STORAGE_SLOT) ~= -1 then
        player:teleportTo(HArena.config.temple)
        HArena.config.temple:sendMagicEffect(CONST_ME_TELEPORT)
        player:setStorageValue(HArena.STORAGE_SLOT, -1)
        player:removeCondition(CONDITION_PARALYZE)
        HArena.chosenByPlayerId[player:getId()] = nil
        local eid = HArena.kickEventById[player:getId()]
        if eid then stopEvent(eid) HArena.kickEventById[player:getId()] = nil end
        player:say("You have been kicked out from the hunting room.", TALKTYPE_MONSTER_SAY)
    end
end

-- Forbidden list (lowercased)
HArena.forbidden = (function()
    local list = {"gostir","isildur","khamul","delicia","christmas queen","chester","pandora the summon","christmas island","malvegil","hailee","eliot","sauron","smaug","pandrodor","feomathar","halloween","zayn","cecilia","irdorath","gate","undead mummy","santa helper","resident hydra","warg","uruk hai","szeloba","talion","turin","witch king","killer","mikolaj","vandal","red goblin","bojack","undead jester","exp bug","apocalypse","omen","vojanix","maxie","baranek","dragonus","jesien","apollyon","adrian","super addoner","brick wall","ice wall","adept weza","adrian","wind stone","metal wall","flame stone","stone of madness","stone of craziness","devil stone","ice stone","earth stone","boogeyman","water stone","jocker","sinister","carie","aldo","aledr","aol seller","abbadon","archangel messenger","ariane","eddeard stark","celest","poluck","a sweaty cyclops","dark rodo","deruno","seller","donald","easter hare","eddard stark","eryn","exp","fiona","frodo","ghar'thol","miner","grizzly adams","guardian","halvar","hana adams","harmor","haroun","harry","helmut","hugo","hunting arena","john","king tibianus","lily","lola","lua82example merchant","mailman maily","marina","mariola","marlick","merchant glut","morpel","nyxic","nag'bob","nathil","nimral","oliver","the oracle","peter","pythius the rotten","rabadan","rashid","redward","riona","ruby","rybak harry","rybak tom","santa claus","secret blesser","serafin","sluga diabla","soilance","soya","starzec","steven","super accesser","sylvester","temple","boleslaw chrobry","the gambling man","the sweet girl","timral","tormir","training room","triss","tyoric","varkhal","varkkhal","vip zone","warchief wo'buff","wounded archangel","xml82example merchant","reborn system","yaman","zlowrogi duch","zombie","zonya","pandora","undead warrior","zombie event","gorlic","fire stone","black hero","death","training coach","ice demon","ice guard","the mutated pumpkin","toxiros","kriegerin","kujon","bazir","stone wall","ochrona"}
    local s = {}
    for _, n in ipairs(list) do s[n] = true end
    return s
end)()

function HArena.normalizeParam(s)
    local p = tostring(s or "")
    p = p:gsub("[<>]", "")
    p = p:gsub("^%s*,%s*", "")
    p = p:gsub("^%s+", ""):gsub("%s+$", "")
    return p
end

-- ===================== Movements (AID 10001 & 6666) =====================
local entryStepIn = MoveEvent()
function entryStepIn.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then return true end

    if player:getLevel() < HArena.config.minLevel then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your level has to be at least " .. HArena.config.minLevel .. ".")
        player:teleportTo(HArena.config.temple)
        HArena.config.temple:sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end

    local hasBypass = player:getStorageValue(HArena.STORAGE_BYPASS) == 1
    local hasItem = player:getItemCount(HArena.config.requiredItemId) > 0
    if not hasBypass and not hasItem then
        player:teleportTo(HArena.config.temple)
        HArena.config.temple:sendMagicEffect(CONST_ME_POFF)
        player:popupFYI([[Sorry, you do not have Gold Nugget which is required.
You can buy it in the shop or obtain it from quests.]])
        return true
    end

    for i, pos in ipairs(HArena.config.positions) do
        local tile = Tile(pos)
        local top = tile and tile:getTopCreature() or nil
        if not top then
            if hasItem then player:removeItem(HArena.config.requiredItemId, 1) end
            player:teleportTo(pos)
            pos:sendMagicEffect(CONST_ME_TELEPORT)
            player:setStorageValue(HArena.STORAGE_SLOT, i)
            player:setStorageValue(HArena.STORAGE_ENTER_AT, os.time())
            local kickAt = os.time() + (HArena.config.sessionMinutes * 60)
            player:setStorageValue(HArena.STORAGE_KICK_AT, kickAt)
            player:setStorageValue(HArena.STORAGE_WAVECOUNT, 0)

            local pid = player:getId()
            if HArena.kickEventById[pid] then stopEvent(HArena.kickEventById[pid]) end
            HArena.kickEventById[pid] = addEvent(function(cid)
                local p = Player(cid)
                if p then HArena.kickPlayer(p) end
            end, HArena.config.sessionMinutes * 60 * 1000, pid)

            player:sendTextMessage(MESSAGE_INFO_DESCR, "Welcome to the Hunting Arena! You will be kicked in " .. HArena.config.sessionMinutes .. " minutes.")
            return true
        end
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "All hunting places are busy.")
    player:teleportTo(HArena.config.temple)
    HArena.config.temple:sendMagicEffect(CONST_ME_TELEPORT)
    return true
end
entryStepIn:type("stepin")
entryStepIn:aid(10001)
entryStepIn:register()

local prepStepIn = MoveEvent()
function prepStepIn.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then return true end

    local entered = player:getStorageValue(HArena.STORAGE_ENTRY_COUNT)
    if entered < 0 then entered = 0 end
    player:setStorageValue(HArena.STORAGE_ENTRY_COUNT, entered + 1)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Commands: /arena <monster>, /arena, <monster>, !arena <monster>, !spawn, !huntexit, !arena info")

    player:addCondition(HArena.FREEZE)
    HArena.cleanMonstersAround(player:getPosition(), 8)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
    return true
end
prepStepIn:type("stepin")
prepStepIn:aid(6666)
prepStepIn:register()

-- ===================== Talkactions =====================
-- Exit
local taExit = TalkAction("!huntexit")
function taExit.onSay(player, words, param)
    if player:getStorageValue(HArena.STORAGE_SLOT) > 0 then
        player:removeCondition(CONDITION_PARALYZE)
        player:teleportTo(HArena.config.temple)
        HArena.config.temple:sendMagicEffect(CONST_ME_TELEPORT)
        player:setStorageValue(HArena.STORAGE_SLOT, -1)
        local eid = HArena.kickEventById[player:getId()]
        if eid then stopEvent(eid) HArena.kickEventById[player:getId()] = nil end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are not inside the hunting arena.")
    end
    return false
end
taExit:register()

-- Shared handler
local function chooseMonster(player, sourceWords, rawParam)
    local paramClean = HArena.normalizeParam(rawParam)
    if paramClean == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: " .. sourceWords .. " <monster name> (example: " .. sourceWords .. " Demon)")
        return false
    end
    if not HArena.inside(player:getPosition()) or player:getStorageValue(HArena.STORAGE_SLOT) <= 0 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are not inside the hunting arena.")
        return false
    end
    local lname = paramClean:lower()
    if HArena.forbidden[lname] then
        player:sendCancelMessage("The chosen monster is forbidden!")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chosen monster is forbidden!")
        return false
    end
    HArena.chosenByPlayerId[player:getId()] = paramClean
    player:setStorageValue(HArena.STORAGE_WAVECOUNT, 0)
    player:say("You choose: " .. paramClean .. ".", TALKTYPE_MONSTER_SAY)
    return false
end

-- /arena <monster>
local taChoose = TalkAction("/arena")
function taChoose.onSay(player, words, param)
    chooseMonster(player, words, param)
    return false
end
taChoose:separator(" ")      -- IMPORTANT: pass params after space
taChoose:register()

-- /arena, <monster>
local taChooseComma = TalkAction("/arena,")
function taChooseComma.onSay(player, words, param)
    chooseMonster(player, words, param)
    return false
end
taChooseComma:separator(",") -- IMPORTANT: pass params after comma
taChooseComma:register()

-- !arena <monster>  |  !arena info  |  !arena set <monster>  |  !arena choose <monster>  |  !arena , <monster>
local taArena = TalkAction("!arena")
function taArena.onSay(player, words, param)
    local raw   = tostring(param or "")
    local lower = raw:lower()

    if lower == "" then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            "Available arena commands: /arena <monster>, /arena, <monster>, !arena <monster>, !spawn, !huntexit, !arena info")
        return false
    end

    if lower == "info" then
        if player:getStorageValue(HArena.STORAGE_SLOT) <= 0 then
            player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You aren't inside the hunting arena!")
            return false
        end
        local enters  = math.max(0, player:getStorageValue(HArena.STORAGE_ENTRY_COUNT))
        local enterAt = player:getStorageValue(HArena.STORAGE_ENTER_AT)
        local kickAt  = player:getStorageValue(HArena.STORAGE_KICK_AT)
        local timeLeft = HArena.formatSeconds((kickAt > 0 and (kickAt - os.time()) or 0))
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            string.format("[STATS]\nEnter count: %d\nEnter time: %s\nTime left: %s",
                enters, enterAt > 0 and os.date("%Y-%m-%d %H:%M:%S", enterAt) or "-", timeLeft))
        local chosen = HArena.chosenByPlayerId[player:getId()] or "None"
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,
            string.format("[CONFIG]\nChosen monster: %s\nAuto prolongation: unavailable\nAuto spawning: unavailable", chosen))
        return false
    end

    -- aliases: set/choose/,<monster>
    if lower:find("^set%s+") then
        raw = raw:sub(5)
    elseif lower:find("^choose%s+") then
        raw = raw:sub(8)
    elseif lower:find("^,%s*") then
        raw = raw:gsub("^,%s*", "")
    end

    chooseMonster(player, words, raw)
    return false
end
taArena:separator(" ")       -- IMPORTANT: pass params after space
taArena:register()

-- Debug aliases (in case something else captures !arena)
local taHA1 = TalkAction("!ha")
function taHA1.onSay(player, words, param)
    chooseMonster(player, words, param)
    return false
end
taHA1:separator(" ")
taHA1:register()

local taHA2 = TalkAction("/ha")
function taHA2.onSay(player, words, param)
    chooseMonster(player, words, param)
    return false
end
taHA2:separator(" ")
taHA2:register()

-- Spawn
local taSpawn = TalkAction("!spawn")
function taSpawn.onSay(player, words, param)
    local last = player:getStorageValue(HArena.STORAGE_EXHAUST)
    local now = os.time()
    if last ~= -1 and (now - last) < 1 then return false end
    player:setStorageValue(HArena.STORAGE_EXHAUST, now)

    if not HArena.inside(player:getPosition()) or player:getStorageValue(HArena.STORAGE_SLOT) <= 0 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are not inside the hunting arena.")
        return false
    end

    local idx = player:getStorageValue(HArena.STORAGE_SLOT)
    local center = HArena.config.positions[idx]
    if not center then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Your arena slot is invalid. Please re-enter.")
        return false
    end

    local name = HArena.chosenByPlayerId[player:getId()]
    if not name or name == "" then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Choose a monster first: /arena <monster name>.")
        return false
    end

    local waves = math.max(0, player:getStorageValue(HArena.STORAGE_WAVECOUNT))
    if waves >= 5 then
        HArena.cleanArea(center, 5)
        player:setStorageValue(HArena.STORAGE_WAVECOUNT, 0)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Area cleaned.")
        return false
    end

    local p1 = Position(center.x, center.y + 2, center.z)
    local p2 = Position(center.x, center.y - 2, center.z)
    local m1 = Game.createMonster(name, p1, false, false)
    local m2 = Game.createMonster(name, p2, false, false)

    if not m1 and not m2 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Failed to spawn monster: " .. name)
        return false
    end

    player:setStorageValue(HArena.STORAGE_WAVECOUNT, waves + 1)
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
    return false
end
taSpawn:register()
