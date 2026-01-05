local id = 61133

local requiredStorages = {
	10001,
	10002,
	10003,
	10004,
	10005,
	10007,
	10008
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if item.actionid ~= id then
		return false
	end

	for _, storage in ipairs(requiredStorages) do
		if getPlayerStorageValue(cid, storage) < 1 then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Something is preventing you from using this.")
			return true
		end
	end

	doTransformItem(item.uid, item.itemid + 1)
	doTeleportThing(cid, toPosition)
	doSendMagicEffect(toPosition, CONST_ME_TELEPORT)
	return true
end
