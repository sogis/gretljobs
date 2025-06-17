WITH 

mpoint AS (
	SELECT 
		denkmal_id,
		st_multi(st_union(punkt)) AS mpunkt
	FROM 
		ada_denkmalschutz_v1.gis_geometrie
	WHERE 
		punkt IS NOT NULL 
	GROUP BY 
		denkmal_id
)

,rechtsvorschriften AS (
SELECT
	denkmal_id AS denkmal_id,
	json_agg(json_build_object('Titel', titel, 'Link', dok_download_url, 'Datum', datum, 'Nummer', nummer)) AS dokumente
FROM
	ada_denkmalschutz_v1.oereb_doclink_v
GROUP BY
	denkmal_id
)

SELECT 
	id, 
	objektname, 
	gemeindename, 
	gemeindeteil, 
	nullif(trim(adr_strasse),'') AS adr_strasse, 
	adr_hausnummer, 
	objektart_code, 
	objektart_text, 
	schutzstufe_code, 
	schutzstufe_text, 
	schutzdurchgemeinde,
	CASE 
		WHEN schutzdurchgemeinde IS TRUE 
		THEN 'Ja'
		ELSE 'Nein'
	END AS schutzdurchgemeinde_txt,
	mpunkt,
	'https://geo.so.ch/docs/ch.so.ada.denkmalschutz/objektblatt/' || id || '.pdf' AS objektblatt, 
	rechtsvorschriften.dokumente AS rechtsvorschriften
FROM 
	ada_denkmalschutz_v1.fachapplikation_denkmal
JOIN
	mpoint 
	ON 
	fachapplikation_denkmal.id = mpoint.denkmal_id
LEFT JOIN 
    rechtsvorschriften
    ON 
    fachapplikation_denkmal.id = rechtsvorschriften.denkmal_id
;