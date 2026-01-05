local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
setCombatParam(combat, COMBAT_PARAM_BLOCKARMOR, 1)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, 37)

function onGetFormulaValues(cid, level, skill, attack, factor)
    local min = -300
    local max = -800
    return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onUseWeapon(cid, var)
    local target = variantToNumber(var)
    if isCreature(target) then
        doCombat(cid, combat, var)
        return true
    end
    return false
end
