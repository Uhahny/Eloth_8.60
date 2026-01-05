-- Combat settings
-- NOTE: valid values for worldType are: "pvp", "no-pvp" and "pvp-enforced"
worldType = "pvp"
hotkeyAimbotEnabled = true
protectionLevel = 80
killsToRedSkull = 10
killsToBlackSkull = 15
pzLocked = 30000
removeChargesFromRunes = false
removeChargesFromPotions = false
removeWeaponAmmunition = false
removeWeaponCharges = true
timeToDecreaseFrags = 24 * 60 * 60
whiteSkullTime = 180
stairJumpExhaustion = 2000
experienceByKillingPlayers = false
expFromPlayersLevelRange = 75
pzLockSkullAttacker = false

-- proxy
ip = "127.0.0.1" -- important, do not change
proxyPort = 7172
statusIP = "91.99.157.67" -- set this to your closest forward proxy server IP
bindOnlyGlobalAddress = true -- important, do not change
bindOnlyGlobalAddress = false
loginProtocolPort = 7171
gameProtocolPort = 7172
statusProtocolPort = 7171
maxPlayers = 0
motd = "Welcome to Eloth"
advertisingBlock = "ALFA;go.alfa;alfa;.net;servegame;no-ip;.net;.com;.com.br;.org;.pl;.net;.biz;.online;duster;.ml;.pl;.biz;.zapto;ddns;REALLY;Really;really"
onePlayerOnlinePerAccount = true
allowClones = false
allowWalkthrough = false
serverName = "Eloth"
statusTimeout = 5000
replaceKickOnLogin = true
maxPacketsPerSecond = 1000

-- Deaths
-- NOTE: Leave deathLosePercent as -1 if you want to use the default
-- death penalty formula. For the old formula, set it to 10. For
-- no skill/experience loss, set it to 0.
deathLosePercent = -1

-- Houses
-- NOTE: set housePriceEachSQM to -1 to disable the ingame buy house functionality
-- NOTE: valid values for houseRentPeriod are: "daily", "weekly", "monthly", "yearly"
-- use any other value to disable the rent system
housePriceEachSQM = 1000
houseRentPeriod = "never"
houseOwnedByAccount = false
houseDoorShowPrice = true
onlyInvitedCanMoveHouseItems = true

-- Item Usage
timeBetweenActions = 200
timeBetweenExActions = 1000

-- Map
-- NOTE: set mapName WITHOUT .otbm at the end
mapName = "CaldeumMapa"
mapAuthor = "Komic"

-- Market
marketOfferDuration = 30 * 24 * 60 * 60
premiumToCreateMarketOffer = true
checkExpiredMarketOffersEachMinutes = 60
maxMarketOffersAtATimePerPlayer = 100

-- MySQL
mysqlHost = "127.0.0.1"
mysqlUser = "zuras"
mysqlPass = "@Zuras123"
mysqlDatabase = "tfs"
mysqlPort = 3306
mysqlSock = ""

-- Misc.
-- NOTE: classicAttackSpeed set to true makes players constantly attack at regular
-- intervals regardless of other actions such as item (potion) use. This setting
-- may cause high CPU usage with many players and potentially affect performance!
-- NOTE: forceMonsterTypesOnLoad loads all monster types on startup to validate them.
-- You can disable it to save some memory if you don't see any errors at startup.
allowChangeOutfit = true
freePremium = true
kickIdlePlayerAfterMinutes = 15
maxMessageBuffer = 4
emoteSpells = true
classicEquipmentSlots = false
classicAttackSpeed = false
showScriptsLogInConsole = false
showOnlineStatusInCharlist = false
yellMinimumLevel = 2
yellAlwaysAllowPremium = false
minimumLevelToSendPrivate = 1
premiumToSendPrivate = false
forceMonsterTypesOnLoad = true
cleanProtectionZones = true
luaItemDesc = false
showPlayerLogInConsole = true

-- VIP and Depot limits
-- NOTE: you can set custom limits per group in data/XML/groups.xml
vipFreeLimit = 20
vipPremiumLimit = 100
depotFreeLimit = 2000
depotPremiumLimit = 10000

-- World Light
-- NOTE: if defaultWorldLight is set to true the world light algorithm will
-- be handled in the sources. set it to false to avoid conflicts if you wish
-- to make use of the function setWorldLight(level, color)
defaultWorldLight = true

-- Server Save
-- NOTE: serverSaveNotifyDuration in minutes
serverSaveNotifyMessage = true
serverSaveNotifyDuration = 5
serverSaveCleanMap = true
serverSaveClose = false
serverSaveShutdown = false

-- Experience stages
-- NOTE: to use a flat experience multiplier, set experienceStages to nil
-- minlevel and multiplier are MANDATORY
-- maxlevel is OPTIONAL, but is considered infinite by default
-- to disable stages, create a stage with minlevel 1 and no maxlevel
experienceStages = {
    { minlevel = 1,  maxlevel = 20,  multiplier = 100 },
    { minlevel = 21, maxlevel = 40,  multiplier = 75 },
    { minlevel = 41, maxlevel = 60,  multiplier = 50 },
    { minlevel = 61, maxlevel = 80,  multiplier = 25 },
    { minlevel = 81, maxlevel = 100, multiplier = 10 },
    { minlevel = 101, maxlevel = 120, multiplier = 3 },
    { minlevel = 121, maxlevel = 150, multiplier = 2 },
    { minlevel = 151, multiplier = 1 }
}

-- Rates
-- NOTE: rateExp is not used if you have enabled stages above
rateExp = 5
rateSkill = 8
rateLoot = 3
rateMagic = 5
rateSpawn = 1

-- Monster Despawn Config
-- despawnRange is the amount of floors a monster can be from its spawn position
-- despawnRadius is how many tiles away it can be from its spawn position
-- removeOnDespawn will remove the monster if true or teleport it back to its spawn position if false
-- walkToSpawnRadius is the allowed distance that the monster will stay away from spawn position when left with no targets, 0 to disable
deSpawnRange = 2
deSpawnRadius = 50
removeOnDespawn = true
walkToSpawnRadius = 15

-- Stamina
staminaSystem = true

-- Scripts
warnUnsafeScripts = true
convertUnsafeScripts = true

-- Startup
-- NOTE: defaultPriority only works on Windows and sets process
-- priority, valid values are: "normal", "above-normal", "high"
defaultPriority = "high"
startupDatabaseOptimization = false

-- Status Server Information
ownerName = ""
ownerEmail = ""
url = "https://otland.net/"
location = "Sweden"