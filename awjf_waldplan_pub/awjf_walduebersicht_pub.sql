SELECT ST_MakeValid(
    ST_RemoveRepeatedPoints(
        ST_Buffer(
            ST_Buffer(ST_Union(geometrie), 0.001),
        -0.001),
    0.01)
) AS geometrie
FROM awjf_waldplan_v2.waldplan_waldfunktion;