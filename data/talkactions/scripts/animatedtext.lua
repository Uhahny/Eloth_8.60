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
if(param == '') then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command param required.")
		return true
	end

	local t = string.explode(param, ",")
	local tmp = t[1]
	if(t[2]) then
		tmp = t[2]
	end

	t[1] = tonumber(t[1])
	if(t[1] > 0 and t[1] < 256) then
		doSendAnimatedText(getCreaturePosition(cid), tmp, t[1])
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Typed color has to be between 0 and 256")
	end

	return true
end
