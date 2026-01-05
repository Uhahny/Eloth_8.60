local talkState = {}

local shopItems = {
    ["crossbow"] = {id = 2455, price = 160},
    ["enchanted spear"] = {id = 7367, price = 100},
    ["bow"] = {id = 2456, price = 130},
    ["spear"] = {id = 2389, price = 1},
    ["royal"] = {id = 7378, price = 50},
    ["bolt"] = {id = 2543, price = 2},
    ["arrow"] = {id = 2544, price = 1},
    ["power"] = {id = 2547, price = 6},
}

function onCreatureSay(cid, type, msg)
    local player = Player(cid)
    if not player then return true end

    local lower = msg:lower()

    -- Pokazuje oferte NPC
    if lower == "trade" or lower == "offer" or lower == "bows" then
        local text = "I sell the following items:\n"
        for name, item in pairs(shopItems) do
            text = text .. "- " .. name .. " for " .. item.price .. " gold\n"
        end
        text = text .. "Say the name of the item to buy it."
        player:sendTextMessage(MESSAGE_INFO_DESCR, text)
        talkState[cid] = 1
        return true
    end

    -- Gracz chce cos kupic
    if talkState[cid] == 1 then
        local item = shopItems[lower]
        if item then
            if player:removeMoney(item.price) then
                local count = 1
                -- Wyjatek dla enchanted spear (stackable) – dajemy 100 sztuk
                if item.id == 7367 then
                    count = 100
                end
                player:addItem(item.id, count)
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Here is your " .. lower .. ".")
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have enough money.")
            end
            talkState[cid] = 0
            return true
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "I don't sell that item.")
        end
    end

    return true
end

function onCreatureAppear(cid) end
function onCreatureDisappear(cid) end
function onThink() end
