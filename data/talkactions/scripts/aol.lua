local config = {
	price = 10000,
	itemId = 2173
}

function onSay(cid, words, param)
	
    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
local count = 1
	if isNumber(param) == TRUE and param < 21 then
		count = param
	end
	
	if doPlayerRemoveMoney(cid, config.price * count) == TRUE then
		for i = 1, count do
			doPlayerAddItem(cid, config.itemId, 1)
			doSendMagicEffect(getPlayerPosition(cid), 12)
		end
	else
		doPlayerSendCancel(cid, "You need "..count * config.price.." gold to buy "..count.." AoL(s).")
		doSendMagicEffect(getPlayerPosition(cid), 2)
	end
	
	return TRUE
end
