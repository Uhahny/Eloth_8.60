local femaleOutfits = {
    ["citizen"] = 136, ["hunter"] = 137, ["mage"] = 138, ["knight"] = 139,
    ["noblewoman"] = 140, ["summoner"] = 141, ["warrior"] = 142, ["barbarian"] = 147,
    ["druid"] = 148, ["wizard"] = 149, ["oriental"] = 150, ["pirate"] = 155,
    ["assassin"] = 156, ["beggar"] = 157, ["shaman"] = 158, ["norsewoman"] = 252,
    ["nightmare"] = 269, ["jester"] = 270, ["brotherhood"] = 279, ["demonhunter"] = 288,
    ["yalaharian"] = 324, ["warmaster"] = 336
}
local maleOutfits = {
    ["citizen"] = 128, ["hunter"] = 129, ["mage"] = 130, ["knight"] = 131,
    ["nobleman"] = 132, ["summoner"] = 133, ["warrior"] = 134, ["barbarian"] = 143,
    ["druid"] = 144, ["wizard"] = 145, ["oriental"] = 146, ["pirate"] = 151,
    ["assassin"] = 152, ["beggar"] = 153, ["shaman"] = 154, ["norsewoman"] = 251,
    ["nightmare"] = 268, ["jester"] = 273, ["brotherhood"] = 278, ["demonhunter"] = 289,
    ["yalaharian"] = 325, ["warmaster"] = 335, ["wayfarer"] = 366
}

function onSay(player, words, param)
    local dollId = 8982
    param = param and param:lower() or ""
    if param == "" then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Podaj nazwe outfitu, np. !addon knight")
        return false
    end

    local outfitId = player:getSex() == 1 and maleOutfits[param] or femaleOutfits[param]
    if not outfitId then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Niepoprawna nazwa outfitu!")
        return false
    end

    if player:getItemCount(dollId) < 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Nie masz Addon Doll!")
        return false
    end

    player:removeItem(dollId, 1)
    player:addOutfitAddon(outfitId, 3) -- full addon
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Full addon dodany!")
    player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
    return false
end
