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
local pid = cid
	local t = string.explode(param, ",")
	if(t[2]) then
		pid = getPlayerByNameWildcard(t[2])
		if(not pid or (isPlayerGhost(pid) and getPlayerGhostAccess(pid) > getPlayerGhostAccess(cid))) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. t[2] .. " not found.")
			return true
		end
	end

	local effect = CONST_ME_MAGIC_RED
	local ret = doSummonMonster(pid, t[1])
	if(ret ~= RETURNVALUE_NOERROR) then
		effect = CONST_ME_POFF
		doPlayerSendDefaultCancel(cid, ret)
	end

	doSendMagicEffect(getCreaturePosition(cid), effect)
	return true
end
