WITH 

mpoly AS (
	SELECT 
		denkmal_id,
		st_multi(st_union(apolygon)) AS mpoly
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
WHERE schutzstufe_code IN ('geschuetzt')
;
