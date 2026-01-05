function onLogin(player)
    if player:getGroup():getId() == 1 and player:getStorageValue(50000) == -1 then
        local vocationId = player:getVocation():getId()

        local bag = player:addItem(9774, 1)
        if bag then
            bag:addItem(2120, 1) -- rope
            bag:addItem(2554, 1) -- shovel
            bag:addItem(2160, 1) -- cc
          bag:addItem(2789, 20) -- grzybki
        end

        -- Common items
        player:addItem(2525, 1) -- dwarven shield
        player:addItem(2463, 1) -- plate armor
        player:addItem(2457, 1) -- steel helmet
        player:addItem(2647, 1) -- plate legs
        player:addItem(2643, 1) -- leather boots

        if vocationId == 1 then -- Sorcerer
            player:addItem(2190, 1) -- wand of vortex

        elseif vocationId == 2 then -- Druid
            player:addItem(2182, 1) -- snakebite rod

        elseif vocationId == 3 then -- Paladin
            player:addItem(2389, 3) -- spears

        elseif vocationId == 4 then -- Knight
            if bag then
                bag:addItem(8601, 1) -- health potion
                bag:addItem(2383, 1) -- spike sword
                bag:addItem(2417, 1) -- battle axe
            end
        end

        player:setStorageValue(50000, 1)
    end
    return true
end
