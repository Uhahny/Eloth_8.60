local addonBonus = CreatureEvent("AddonBonus")

function addonBonus.onLogin(player)
    local addonCondition = Condition(CONDITION_ATTRIBUTES)
    addonCondition:setParameter(CONDITION_PARAM_TICKS, -1)
    addonCondition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
    addonCondition:setParameter(CONDITION_PARAM_SKILL_SHIELD, 1)
    addonCondition:setParameter(CONDITION_PARAM_SKILL_MELEE, 1)
    addonCondition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 1)
    addonCondition:setParameter(CONDITION_PARAM_SKILL_FIST, 1)

    local outfit = player:getOutfit()
    local lookType = outfit.lookType
    local lookAddons = outfit.lookAddons

    local eligibleLooktypes = {
        128, 129, 130, 131, 132, 133, 134, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 251, 252, 268, 269, 270, 273, 278, 279, 288, 289, 324, 325, 328, 329, 335, 336, 366, 367, 430, 431, 432, 433, 463, 464, 465, 466, 471, 472, 512, 513, 514, 516, 541, 542, 574, 575, 577, 578, 610, 618, 619, 620, 632, 633, 634, 635, 636, 637, 655, 656, 657, 658, 664, 665, 666, 667, 683, 684, 694, 695, 696, 697, 698, 699, 724, 725, 732, 733, 745, 746, 749, 750, 759, 760, 845, 846, 852, 853, 873, 874, 884, 885, 899, 900, 908, 909, 929, 931, 955, 956, 957, 958, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 1020, 1021, 1023, 1024, 1042, 1043, 1050, 1051, 1056, 1057, 1069, 1070, 1094, 1095, 1102, 1103, 1127, 1128, 1146, 1147, 1161, 1162, 1173, 1174, 1186, 1187, 1202, 1203, 1204, 1205, 1206, 1207, 1210, 1211, 1243, 1244, 1245, 1246, 1251, 1252, 1270, 1271, 1279, 1280, 1282, 1283, 1288, 1289, 1292, 1293, 1322, 1323, 1331, 1332, 1338, 1339, 1371, 1372, 1382, 1383, 1384, 1385, 1386, 1387, 1415, 1416, 1436, 1437, 1444, 1445, 1449, 1450, 1456, 1457, 1460, 1461, 1489, 1490, 1500, 1501, 1568, 1569, 1575, 1576, 1581, 1582, 1597, 1598
    }

    for _, lt in ipairs(eligibleLooktypes) do
        if lookType == lt and lookAddons == 3 then
            player:addCondition(addonCondition)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are eligible for a universal addon bonus.\n[Magic Level] +1\n[Shield] +1\n[Sword/Club/Axe] +1\n[Fist] +1\n[Distance] +1")
            return true
        end
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not eligible for a bonus addon.")
    return true
end

addonBonus:register()
