function onUse(player, item, fromPosition, target, toPosition)
    if player:getStorageValue(4767) ~= 1 then
        player:say("You have gained your new outfit and may leave the reward room now!", TALKTYPE_MONSTER_SAY)
        
        -- Outfit male (336), female (335) — full addons (1 = first addon, 2 = second)
        player:addOutfit(336) -- base outfit
        player:addOutfitAddon(336, 1)
        player:addOutfitAddon(336, 2)

        player:addOutfit(335)
        player:addOutfitAddon(335, 1)
        player:addOutfitAddon(335, 2)

        player:setStorageValue(4767, 1)
        player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already gained your new outfit. You may leave the room now.")
    end
    return true
end
