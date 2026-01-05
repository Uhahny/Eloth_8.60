local specialQuests = {
    [2001] = 30015 -- Annihilator
}

local questsExperience = {
    [30015] = 10000
}

function onUse(player, item, fromPosition, target, toPosition)
    if player:getGroup():getAccess() then
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local storage = specialQuests[item:getActionId()]
    if not storage then
        storage = item:getUniqueId()
        if storage > 65535 then
            return false
        end
    end

    if player:getStorageValue(storage) > 0 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
        return true
    end

    -- prevent container from opening
    if item:getType():isContainer() then
        local container = Container(item.uid)
        local size = container:getSize()
        if size == 0 then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "It is empty.")
            return true
        end

        local rewardText = ""
        for i = 0, size - 1 do
            local rewardItem = container:getItem(i)
            if rewardItem then
                local clone = rewardItem:clone()
                if player:addItemEx(clone, true) ~= RETURNVALUE_NOERROR then
                    player:sendCancelMessage("You have found a reward weighing " ..
                        rewardItem:getType():getWeight(rewardItem:getCount()) ..
                        " oz. It is too heavy or you have not enough space.")
                    return true
                end

                local name = rewardItem:getType():getName()
                if rewardItem:getType():isRune() then
                    rewardText = rewardText .. rewardItem:getCount() .. " charges " .. name .. ", "
                elseif rewardItem:getType():isStackable() then
                    rewardText = rewardText .. rewardItem:getCount() .. " " .. rewardItem:getType():getPluralName() .. ", "
                else
                    rewardText = rewardText .. rewardItem:getType():getArticle() .. " " .. name .. ", "
                end
            end
        end

        rewardText = rewardText:sub(1, #rewardText - 2)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found " .. rewardText .. ".")
        player:setStorageValue(storage, 1)

        if questsExperience[storage] then
            player:addExperience(questsExperience[storage])
            player:getPosition():sendAnimatedText(questsExperience[storage], TEXTCOLOR_WHITE)
        end

        return true
    end

    return false
end
