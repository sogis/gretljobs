SELECT
	ST_MakeValid(
		ST_Buffer(ST_UnaryUnion(ST_Collect(geometrie)),0)) AS geometrie
FROM
    awjf_waldplan_v2.waldplan_waldfunktion