SELECT
	st_difference(swg.geometrie, st_buffer(wf.geometrie,10)) AS geometrie
FROM
	awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie AS swg,
	awjf_waldplan_v2.waldplan_waldfunktion AS wf;

	
SELECT
    (ST_Dump(ST_Difference(swg.geometrie, ST_Buffer(wf.geometrie, 10)))).geom AS geometrie
FROM
    awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie AS swg
CROSS JOIN awjf_waldplan_v2.waldplan_waldfunktion AS wf
WHERE swg.geometrie && ST_Envelope(ST_Buffer(wf.geometrie, 10));



WITH waldflaeche AS (
    SELECT ST_Union(geometrie) AS geometrie
    FROM awjf_waldplan_v2.waldplan_waldfunktion
)
SELECT
    (ST_Dump(ST_Difference(swg.geometrie, ST_Buffer(wf.geometrie, 10)))).geom AS geometrie
FROM
    awjf_statische_waldgrenze.geobasisdaten_waldgrenze_linie AS swg
CROSS JOIN waldflaeche AS wf
WHERE swg.geometrie && ST_Envelope(ST_Buffer(wf.geometrie, 10));

