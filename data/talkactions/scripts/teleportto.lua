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
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Command requires param.")
		return true
	end

	local creature = getCreatureByName(param)
	local player = getPlayerByNameWildcard(param)
	local waypoint = getWaypointPosition(param)
	local tile = string.explode(param, ",")
	local pos = {x = 0, y = 0, z = 0}

	if(player ~= nil and (not isPlayerGhost(player) or getPlayerGhostAccess(player) <= getPlayerGhostAccess(cid))) then
		pos = getCreaturePosition(player)
	elseif(creature ~= nil and (not isPlayer(creature) or (not isPlayerGhost(creature) or getPlayerGhostAccess(creature) <= getPlayerGhostAccess(cid)))) then
		pos = getCreaturePosition(creature)
	elseif(type(waypoint) == 'table' and waypoint.x ~= 0 and waypoint.y ~= 0) then
		pos = waypoint
	elseif(tile[2] and tile[3]) then
		pos = {x = tile[1], y = tile[2], z = tile[3]}
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid param specified.")
		return true
	end

	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Destination not reachable.")
		return true
	end

	pos = getClosestFreeTile(cid, pos, true, false)
	if(not pos or isInArray({pos.x, pos.y}, 0)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Cannot perform action.")
		return true
	end

	local tmp = getCreaturePosition(cid)
	if(doTeleportThing(cid, pos, true) and not isPlayerGhost(cid)) then
		doSendMagicEffect(tmp, CONST_ME_POFF)
		doSendMagicEffect(pos, CONST_ME_TELEPORT)
	end

	return true
end
