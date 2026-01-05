local ipBanDays = 7

function onSay(player, words, param)
	
    local exhaust = 5
    local storage = 123456
    local p = player or Player(cid)
    if not p then return false end
    if p:getStorageValue(storage) > os.time() then
        p:sendCancelMessage("You are exhausted.")
        return false
    end
    p:setStorageValue(storage, os.time() + exhaust)
if not player:getGroup():getAccess() then
		return true
	end

	local resultId = db.storeQuery("SELECT `name`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		return false
	end

	local targetName = result.getString(resultId, "name")
	local targetIp = result.getNumber(resultId, "lastip")
	result.free(resultId)

	local targetPlayer = Player(param)
	if targetPlayer then
		targetIp = targetPlayer:getIp()
		targetPlayer:remove()
	end

	if targetIp == 0 then
		return false
	end

	resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip` = " .. targetIp)
	if resultId ~= false then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetName .. "  is already IP banned.")
		result.free(resultId)
		return false
	end

	local timeNow = os.time()
	db.query("INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..
			targetIp .. ", '', " .. timeNow .. ", " .. timeNow + (ipBanDays * 86400) .. ", " .. player:getGuid() .. ")")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetName .. "  has been IP banned.")
	return false
end
