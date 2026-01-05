local config = {
	costPremiumDays = 1 
}

function onSay(cid, words, param, channel)
	
    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
if(getPlayerSex(cid) >= 2) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You cannot change your gender.")
		return TRUE
	end

	if(getPlayerPremiumDays(cid) < config.costPremiumDays) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Sorry, not enough premium time- changing gender costs " .. config.costPremiumDays .. " days.")
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_POFF)
		return TRUE
	end

	if(getPlayerPremiumDays(cid) < 65535) then
		doPlayerAddPremiumDays(cid, -config.costPremiumDays)
	end

	if(getPlayerSex(cid) == PLAYERSEX_FEMALE) then
		doPlayerSetSex(cid, PLAYERSEX_MALE)
	else
		doPlayerSetSex(cid, PLAYERSEX_FEMALE)
	end

	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "You have changed your gender and lost " .. config.costPremiumDays .. " days of premium time.")
	doSendMagicEffect(getCreaturePosition(cid), CONST_ME_MAGIC_RED)
	return TRUE
end
