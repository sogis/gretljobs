SELECT 
	ST_AsBinary(ST_CurveToLine(geometrie, 0.1, 1, 1)) AS geometrie
FROM 
	agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze;
