function onSay(player, words, param)
    local exhaust = 5 -- sekundy
    local storage = 123456

    -- Sprawdź czy gracz ma cooldown
    if player:getStorageValue(storage) > os.time() then
        player:sendCancelMessage("You are exhausted.")
        return false
    end
    player:setStorageValue(storage, os.time() + exhaust)

    -- Pobranie listy zaklęć
    local spells = {}
    for _, spell in ipairs(Game.getSpells()) do
        if spell:isInstant() then
            table.insert(spells, spell)
        end
    end

    table.sort(spells, function(a, b)
        return a:getLevel() < b:getLevel()
    end)

    -- Tworzenie treści
    local text, prevLevel = "", -1
    for _, spell in ipairs(spells) do
        if prevLevel ~= spell:getLevel() then
            if prevLevel ~= -1 then
                text = text .. "\n"
            end
            text = text .. "Spells for Level " .. spell:getLevel() .. ":\n"
            prevLevel = spell:getLevel()
        end
        text = text .. string.format("  %s - %s : %s\n",
            spell:getWords(),
            spell:getName(),
            spell:getMana() > 0 and spell:getMana() or (spell:getManaPercent() > 0 and spell:getManaPercent() .. "%" or "0"))
    end

    -- Wyświetlenie listy w okienku
    player:showTextDialog(2175, text)
    return false
end