WITH 

mpoly AS (
	SELECT 
		denkmal_id,
		ST_RemoveRepeatedPoints(st_multi(st_buffer(st_buffer(st_buffer(st_buffer(st_union(apolygon),0.01),-0.01),-0.01),0.01)),0.01) AS mpoly
-- TODO: Das Buffern und Re-Buffern ist definitiv nicht optimal. Allerdings ist es der einzige funktionierende Weg, die kleinen Digitalisierungsfehler zu eliminieren. 
--       Evtl. findet man hier aber in Zukunft eine bessere Lösung! 
	FROM 
		ada_denkmalschutz.gis_geometrie
	WHERE 
		apolygon IS NOT NULL 
	GROUP BY 
		denkmal_id
)

SELECT 
	id, 
	objektname, 
	gemeindename, 
	gemeindeteil, 
	adr_strasse, 
	adr_hausnummer, 
	objektart_code, 
	objektart_text, 
	schutzstufe_code, 
	schutzstufe_text, 
	schutzdurchgemeinde,
	mpoly 
FROM 
	ada_denkmalschutz.fachapplikation_denkmal
JOIN
	mpoly 
		ON fachapplikation_denkmal.id = mpoly.denkmal_id
;
