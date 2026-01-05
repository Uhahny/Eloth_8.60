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
local n = 1
	if(param ~= '' and tonumber(param)) then
		n = math.max(0, tonumber(param))
	end

	local tmp, pos = getCreaturePosition(cid), getCreaturePosition(cid)
	if(words:sub(2, 2) == "u") then
		pos.z = pos.z - n
	else
		pos.z = pos.z + n
	end

	pos = getClosestFreeTile(cid, pos, false, false)
	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Destination not reachable.")
		return true
	end

	if(doTeleportThing(cid, pos, true) and not isPlayerGhost(cid)) then
		doSendMagicEffect(tmp, CONST_ME_POFF)
		doSendMagicEffect(pos, CONST_ME_TELEPORT)
	end

	return true
end
