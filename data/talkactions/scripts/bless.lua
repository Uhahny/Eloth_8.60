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
if(getPlayerBlessing(cid,1)) then
			doPlayerSendCancel(cid,'You are blessed!')
		elseif(doPlayerRemoveMoney(cid,100000)) then
			for b=1,5 do
				doPlayerAddBlessing(cid,b)
			end
			doSendMagicEffect(getThingPosition(cid),CONST_ME_HOLYDAMAGE)
			doPlayerSendTextMessage(cid,MESSAGE_EVENT_ADVANCE,'You have been blessed by the gods!')
		else
			doSendMagicEffect(getThingPosition(cid),CONST_ME_POFF)
			doPlayerSendTextMessage(cid,MESSAGE_EVENT_ADVANCE,"You need 10 crystal coin to get blessed!")
		end
	return 1
end