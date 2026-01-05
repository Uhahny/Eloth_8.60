local config = {
    cost = 15000,      -- koszt naprawy
    idsoft = 2640,     -- ID soft boots (naprawione)
    idwornsoft = 10021 -- ID worn soft boots (zepsute)
}

function onSay(player, words, param)
    -- czy gracz ma worn soft boots
    if player:getItemCount(config.idwornsoft) < 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have worn soft boots.")
        return false
    end

    -- czy ma kase i czy da sie ja zdjac
    if not player:removeMoney(config.cost) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have enough money!")
        return false
    end

    -- zdejmij worn soft boots i daj naprawione
    player:removeItem(config.idwornsoft, 1)
    player:addItem(config.idsoft, 1)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Your soft boots have been repaired.")
    return false
end
