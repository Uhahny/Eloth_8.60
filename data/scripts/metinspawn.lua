local raidBossInformation = {
    {
        dayToSpawn = "Monday",
        position = Position(32346, 32215, 7),
        monsterName = "Fire Stone",
        respawnTime = 4, -- hours
        messageOnSpawn = "Fire Stone is now in Thais... Go kill Him.",
        messageOnDeath = "Fire Stone has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
    {
        dayToSpawn = "Tuesday",
        position = Position(32346, 32215, 7),
        monsterName = "Icy Stone",
        respawnTime = 4,
        messageOnSpawn = "Icy Stone is now in Thais... Go kill Him.",
        messageOnDeath = "Icy Stone has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
    {
        dayToSpawn = "Wednesday",
        position = Position(32346, 32215, 7),
        monsterName = "Earth Stone",
        respawnTime = 4,
        messageOnSpawn = "Earth Stone is now in Thais... Go kill Him.",
        messageOnDeath = "Earth Stone has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
    {
        dayToSpawn = "Thursday",
        position = Position(32346, 32215, 7),
        monsterName = "Wind Stone",
        respawnTime = 4,
        messageOnSpawn = "Wind Stone is now in Thais... Go kill Him.",
        messageOnDeath = "Wind Stone has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
    {
        dayToSpawn = "Friday",
        position = Position(32346, 32215, 7),
        monsterName = "Fire Stone",
        respawnTime = 0.1, -- szybki respawn do testów
        messageOnSpawn = "Fire Stone is now in Thais... Go kill Him.",
        messageOnDeath = "Fire Stone has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
    {
        dayToSpawn = "Saturday",
        position = Position(32346, 32215, 7),
        monsterName = "Earth Stone",
        respawnTime = 4,
        messageOnSpawn = "Earth Stone is now in Thais... Go kill Him.",
        messageOnDeath = "Earth Stone has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
    {
        dayToSpawn = "Sunday",
        position = Position(32346, 32215, 7),
        monsterName = "Metin of Darkness",
        respawnTime = 4,
        messageOnSpawn = "Metin of Darkness is now in Thais... Go kill Him.",
        messageOnDeath = "Metin of Darkness has been defeated, the Stone will reveal himself in thais in 4 hours.",
        creatureId = 0,
        lastKilledTime = 0
    },
}

local day = os.date('%A')

local function respawnBoss(index)
    local spawn = raidBossInformation[index]
    local monster = Game.createMonster(spawn.monsterName, spawn.position, false, true)
    if monster then
        spawn.creatureId = monster:getId()
        monster:registerEvent("raidBossDeath")
        Game.broadcastMessage(spawn.messageOnSpawn, MESSAGE_EVENT_ADVANCE)
    else
        print("Failed to respawn index: " .. index .. " -> " .. spawn.monsterName)
    end
end

local function spawnTodayBosses()
    day = os.date('%A')
    for index, spawn in ipairs(raidBossInformation) do
        if spawn.dayToSpawn == day or spawn.dayToSpawn == "Any" then
            local monster = Game.createMonster(spawn.monsterName, spawn.position, false, true)
            if monster then
                spawn.creatureId = monster:getId()
                monster:registerEvent("raidBossDeath")
            else
                print("Failed to spawn index: " .. index .. " -> " .. spawn.monsterName)
            end
        end
    end
end

local globalevent = GlobalEvent("raidBosses")

function globalevent.onStartup()
    spawnTodayBosses()
    return true
end

globalevent:register()

local creatureevent = CreatureEvent("raidBossDeath")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local bossId = creature:getId()
    for index, spawn in ipairs(raidBossInformation) do
        if spawn.creatureId == bossId then
            spawn.creatureId = 0
            spawn.lastKilledTime = os.time()
            Game.broadcastMessage(spawn.messageOnDeath, MESSAGE_EVENT_ADVANCE)
            addEvent(respawnBoss, 1000 * 60 * 60 * spawn.respawnTime, index)
            return true
        end
    end
    print("[Raid Boss] Unknown death detected.")
    return true
end

creatureevent:register()

local talk = TalkAction("!metin")

function talk.onSay(player, words, param)
    local text = ""
    for _, spawn in ipairs(raidBossInformation) do
        text = text .. spawn.monsterName .. " [" .. (spawn.dayToSpawn == "Any" and day or spawn.dayToSpawn) .. "]\n    "
        if spawn.creatureId == 0 then
            if spawn.lastKilledTime == 0 then
                text = text .. "Unavailable\n\n"
            else
                local remaining = (spawn.lastKilledTime + (60 * 60 * spawn.respawnTime)) - os.time()
                if remaining <= 0 then
                    text = text .. "Respawning soon\n\n"
                else
                    text = text .. "Dead -> respawning in " .. os.date("!%Hh %Mm %Ss", remaining) .. "\n\n"
                end
            end
        else
            text = text .. "Alive\n\n"
        end
    end
    player:showTextDialog(2239, text, false)
    return false
end

talk:separator(" ")
talk:register()

-- Komenda !metinreload
local talkReload = TalkAction("!metinreload")

function talkReload.onSay(player, words, param)
    if player:getGroup():getId() < 3 then -- Tylko admini (group 3+)
        player:sendCancelMessage("You are not authorized.")
        return false
    end

    -- Najpierw usuniecie obecnych bossów (jesli sa)
    for _, spawn in ipairs(raidBossInformation) do
        if spawn.creatureId ~= 0 then
            local creature = Creature(spawn.creatureId)
            if creature then
                creature:remove()
            end
            spawn.creatureId = 0
        end
    end

    -- Ponowne zrespawnowanie
    spawnTodayBosses()
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Metins reloaded successfully.")
    return false
end

talkReload:separator(" ")
talkReload:register()
