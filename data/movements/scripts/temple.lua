--- Created by Grlx ----

local rawPositions = {
    {32365, 32240, 7},
    {32369, 32245, 7},
    {32372, 32239, 7},
    {32369, 32239, 7},
    {32373, 32242, 7},
    {32367, 32235, 7},
    {32372, 32236, 7},
    {32367, 32237, 7},
    {32369, 32238, 7},
    {32373, 32236, 7},
    {32366, 32237, 7},
    {32369, 32236, 7},
    {32366, 32234, 7},
    {32372, 32233, 7}
}

local positions = {}
for i = 1, #rawPositions do
    table.insert(positions, {x = rawPositions[i][1], y = rawPositions[i][2], z = rawPositions[i][3]})
end

function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
    doTeleportThing(cid, positions[math.random(1, #positions)])
    return true
end
