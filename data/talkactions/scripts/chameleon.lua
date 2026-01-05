local condition = Condition(CONDITION_OUTFIT, CONDITIONID_COMBAT)
condition:setTicks(-1)

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

	local itemType = ItemType(param)
	if itemType:getId() == 0 then
		itemType = ItemType(tonumber(param))
		if itemType:getId() == 0 then
			player:sendCancelMessage("There is no item with that id or name.")
			return false
		end
	end

	condition:setOutfit(itemType:getId())
	player:addCondition(condition)
	return false
end
