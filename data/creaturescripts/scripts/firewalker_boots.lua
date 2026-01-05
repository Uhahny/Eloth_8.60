local bootsId = 9933 -- Firewalker Boots
local hpGain = 20
local manaGain = 20
local tick = 2 -- sekundy

function onThink(creature, interval)
    local player = Player(creature)
    if not player then return true end

    local boots = player:getSlotItem(CONST_SLOT_FEET)
    if boots and boots:getId() == bootsId then
        player:addHealth(hpGain)
        player:addMana(manaGain)
        -- player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN) -- efekt wizualny, jeśli chcesz
    end
    return true
end

