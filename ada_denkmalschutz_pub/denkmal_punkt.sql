WITH 

mpoint AS (
	SELECT 
		denkmal_id,
		st_multi(st_union(punkt)) AS mpunkt
	FROM 
		ada_denkmalschutz.gis_geometrie
	WHERE 
		punkt IS NOT NULL 
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
	mpunkt
FROM 
	ada_denkmalschutz.fachapplikation_denkmal
JOIN
	mpoint 
		ON fachapplikation_denkmal.id = mpoint.denkmal_id
WHERE schutzstufe_code IN ('geschuetzt')
;
