local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

-- ================== USTAWIENIA ==================
local STORAGE_TOMES = 85300
local BACKPACK_ID = 1988 -- zwykly backpack

-- ================== HELPERS ==================
local function msgcontains(message, keyword)
	message = message:lower()
	keyword = keyword:lower()
	return message:find(keyword, 1, true) ~= nil
end

-- Bezpieczne mówienie (omija addEvent w npchandler.lua)
local function sayTo(cid, text, talktype)
	-- talktype: TALKTYPE_SAY (domyslnie), mozesz podac tez TALKTYPE_PRIVATE_NP
	talktype = talktype or TALKTYPE_SAY
	local npc = Npc()
	if npc and npc.say then
		-- npc:say(message, talktype, ghost, targetPlayer)
		npc:say(text, talktype, false, cid)
	else
		-- awaryjnie (starsze distro)
		selfSay(text, cid)
	end
end

-- kompatybilnosc platnosci: removeMoneyNpc (jesli istnieje) -> w przeciwnym razie getMoney/removeMoney
local function takeMoneyCompat(player, amount)
	if type(player.removeMoneyNpc) == "function" then
		return player:removeMoneyNpc(amount)
	end
	if player:getMoney() >= amount then
		return player:removeMoney(amount)
	end
	return false
end

local function addInBackpacks(player, itemId, subType, amount)
	local bp = player:addItem(BACKPACK_ID, 1)
	if not bp then
		return false
	end
	local left = amount
	while left > 0 do
		local stack = math.min(100, left)
		if (subType or 0) > 0 then
			if not bp:addItem(itemId, subType) then
				return false
			end
			left = left - 1
		else
			if not bp:addItem(itemId, stack) then
				return false
			end
			left = left - stack
		end
	end
	return true
end

-- ================== LISTY ITEMÓW ==================
local function baseItems()
	return {
		{name="axe", id=2386, buy=20, sell=7},
		{name="battle axe", id=2378, buy=235, sell=80},
		{name="battle hammer", id=2417, buy=350, sell=120},
		{name="battle shield", id=2513, sell=95},
		{name="brass armor", id=2465, buy=450, sell=150},
		{name="brass helmet", id=2460, buy=120, sell=30},
		{name="brass legs", id=2478, buy=195, sell=49},
		{name="brass shield", id=2511, buy=65, sell=25},
		{name="carlin sword", id=2395, buy=473, sell=118},
		{name="chain armor", id=2464, buy=200, sell=70},
		{name="chain helmet", id=2458, buy=52, sell=17},
		{name="chain legs", id=2648, buy=80, sell=25},
		{name="club", id=2382, buy=5, sell=1},
		{name="coat", id=2651, buy=8, sell=1},
		{name="crowbar", id=2416, buy=260, sell=50},
		{name="dagger", id=2379, buy=5, sell=2},
		{name="doublet", id=2485, buy=16, sell=3},
		{name="dwarven shield", id=2525, buy=500, sell=100},
		{name="hand axe", id=2380, buy=8, sell=4},
		{name="leather armor", id=2467, buy=35, sell=12},
		{name="leather boots", id=2643, buy=10, sell=2},
		{name="leather helmet", id=2461, buy=12, sell=9},
		{name="leather legs", id=2649, buy=10, sell=9},
		{name="longsword", id=2397, buy=160, sell=51},
		{name="mace", id=2398, buy=90, sell=30},
		{name="morning star", id=2394, buy=430, sell=100},
		{name="plate armor", id=2463, buy=1200, sell=400},
		{name="plate shield", id=2510, buy=125, sell=45},
		{name="rapier", id=2384, buy=15, sell=5},
		{name="sabre", id=2385, buy=35, sell=12},
		{name="scale armor", id=2483, buy=260, sell=75},
		{name="spear", id=2389, buy=10, sell=3},
		{name="short sword", id=2406, buy=26, sell=10},
		{name="sickle", id=2405, buy=7, sell=3},
		{name="soldier helmet", id=2481, buy=110, sell=16},
		{name="spike sword", id=2383, buy=8000, sell=240},
		{name="steel helmet", id=2457, buy=580, sell=293},
		{name="steel shield", id=2509, buy=240, sell=80},
		{name="studded armor", id=2484, buy=90, sell=25},
		{name="studded helmet", id=2482, buy=63, sell=20},
		{name="studded legs", id=2468, buy=50, sell=15},
		{name="studded shield", id=2526, buy=50, sell=16},
		{name="swampling club", id=20104, sell=40},
		{name="sword", id=2376, buy=85, sell=25},
		{name="throwing knife", id=2410, buy=25},
		{name="wooden shield", id=2512, buy=15, sell=3},
		{name="two handed sword", id=2377, sell=450},

		-- Zaoan / Draken
		{name="twin hooks", id=11309, buy=1100, sell=500},
		{name="zaoan halberd", id=11323, buy=1200, sell=500}, -- uwaga: ten sam id co necklace (ponizej tylko SELL)
		{name="bone shoulderplate", id=11315, sell=150},
		{name="broken halberd", id=11329, sell=100},
		{name="cursed shoulder spikes", id=11321, sell=320},
		{name="drachaku", id=11308, sell=10000},
		{name="drakinata", id=11305, sell=10000},
		{name="draken boots", id=12646, sell=40000},
		{name="guardian boots", id=11240, sell=35000},
		{name="high guard's shoulderplates", id=11327, sell=130},
		{name="legionnaire flags", id=11328, sell=500},
		{name="sais", id=11306, sell=16500},
		{name="spiked iron ball", id=11319, sell=100},
		{name="trashed draken boots", id=12607, sell=40000},
		{name="twiceslicer", id=12613, sell=28000},
		{name="wailing widow's necklace", id=11323, sell=3000},
		{name="zaoan armor", id=11301, sell=14000},
		{name="zaoan helmet", id=11302, sell=45000},
		{name="zaoan legs", id=11304, sell=14000},
		{name="zaoan shoes", id=11303, sell=5000},
		{name="zaoan sword", id=11307, sell=30000},
		{name="zaogun's shoulderplates", id=11325, sell=150}
	}
end

local function itemsForStorage3()
	return {
		{name="lizard weapon rack kit", id=11126, buy=500}
	}
end

local function itemsForStorage9()
	return {
	}
end

local function buildItemsForPlayer(player)
	local t = {}
	for _, it in ipairs(baseItems()) do table.insert(t, it) end
	local sv = player:getStorageValue(STORAGE_TOMES)
	if sv >= 3 then
		for _, it in ipairs(itemsForStorage3()) do table.insert(t, it) end
	end
	if sv >= 9 then
		for _, it in ipairs(itemsForStorage9()) do table.insert(t, it) end
	end
	return t
end

-- ================== CALLBACKI SKLEPU ==================
local function onBuy(cid, itemid, subType, amount, ignoreCap, inBackpacks, items)
	local player = Player(cid)
	if not player then return false end

	amount = math.max(1, amount or 1)

	local entry
	for _, it in ipairs(items) do
		if it.id == itemid and it.buy then
			entry = it
			break
		end
	end
	if not entry then
		sayTo(cid, "I don't sell that.")
		return false
	end

	local total = entry.buy * amount
	if not takeMoneyCompat(player, total) then
		sayTo(cid, "You don't have enough money.")
		return false
	end

	local ok
	if inBackpacks then
		ok = addInBackpacks(player, itemid, subType or 0, amount)
	else
		ok = player:addItem(itemid, amount, false, subType or 0) ~= nil
	end

	if not ok then
		player:addMoney(total) -- refund
		sayTo(cid, "You don't have enough capacity or free slots.")
		return false
	end

	sayTo(cid, "Here you are.")
	return true
end

local function onSell(cid, itemid, subType, amount, ignoreCap, inBackpacks, items)
	local player = Player(cid)
	if not player then return false end

	amount = math.max(1, amount or 1)

	local entry
	for _, it in ipairs(items) do
		if it.id == itemid and it.sell then
			entry = it
			break
		end
	end
	if not entry then
		sayTo(cid, "I don't buy that.")
		return false
	end

	if player:getItemCount(itemid) < amount then
		sayTo(cid, "You don't have enough of that item.")
		return false
	end

	if not player:removeItem(itemid, amount) then
		sayTo(cid, "Hmmm, something went wrong.")
		return false
	end

	player:addMoney(entry.sell * amount)
	sayTo(cid, "Deal! Thanks.")
	return true
end

-- ================== HOOKI NPC ==================
function onCreatureAppear(cid)      npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)   npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, t, msg) npcHandler:onCreatureSay(cid, t, msg) end
function onThink()                  npcHandler:onThink() end

-- ================== ROZMOWA ==================
local function creatureSayCallback(cid, type, msg)
	if (msgcontains(msg, "hi") or msgcontains(msg, "hello")) and not npcHandler:isFocused(cid) then
		local player = Player(cid)
		sayTo(cid, "Hello, " .. (player and player:getName() or "traveler") .. " and welcome to my little forge.")
		npcHandler:addFocus(cid)
		return true
	end

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "trade") then
		local player = Player(cid)
		local items = buildItemsForPlayer(player)
		openShopWindow(cid, items,
			function(cid2, itemid, subType, amount, ignoreCap, inBackpacks)
				return onBuy(cid2, itemid, subType or 0, amount or 1, ignoreCap, inBackpacks, items)
			end,
			function(cid2, itemid, subType, amount, ignoreCap, inBackpacks)
				return onSell(cid2, itemid, subType or 0, amount or 1, ignoreCap, inBackpacks, items)
			end
		)
		sayTo(cid, "Of course, just browse through my wares.")
		return true
	end

	if msgcontains(msg, "bye") or msgcontains(msg, "farewell") then
		sayTo(cid, "Bye.")
		npcHandler:releaseFocus(cid)
		return true
	end

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
