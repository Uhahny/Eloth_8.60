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

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local position = player:getPosition()
	local npc = Game.createNpc(param, position)
	if npc then
		npc:setMasterPos(position)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendCancelMessage("There is not enough room.")
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
