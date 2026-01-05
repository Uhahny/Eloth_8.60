local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_DEATHAREA)
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)

-- Ustaw formule obrazen
setCombatFormula(combat, COMBAT_FORMULA_LEVELMAGIC, 0, -100, 0, -200)

-- Funkcja wywolywana podczas uzycia broni
function onUseWeapon(cid, var)
    return doCombat(cid, combat, var)
end
