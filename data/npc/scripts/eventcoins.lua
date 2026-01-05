local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler) 
NpcSystem.parseParameters(npcHandler) 
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end 
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end 
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end 
function onThink() npcHandler:onThink() end 
function creatureSayCallback(cid, type, msg) 
if(not npcHandler:isFocused(cid)) then 
return false 
end 
local talkState = {}
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid
local shopWindow = {}
local coins = 6527 -- el id de moneda

local itemsell = {
	  [8982] = {price = 1000},
	  [2121] = {price = 500},
	  [2160] = {price = 10},
	  [9019] = {price = 1000},
	  [9969] = {price = 500},
	  [10515] = {price = 100},


}

local onBuy = function(cid, item, subType, amount, ignoreCap, inBackpacks)
	if itemsell[item] and not doPlayerRemoveItem(cid, coins, itemsell[item].price) then
		selfSay("you don't have ".. itemsell[item].price .." ".. getItemNameById(coins), cid)
		else
	doPlayerAddItem(cid, item)
	selfSay("Here are you.", cid)
	end
	return true
end

if (msgcontains(msg, 'trade') or msgcontains(msg, 'TRADE')) then
	for var, ret in pairs(itemsell) do
	table.insert(shopWindow, {id = var, subType = 0, buy = ret.price, sell = 0, name = getItemNameById(var)})
	end
openShopWindow(cid, shopWindow, onBuy, onSell)
end
return true
end










npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())
