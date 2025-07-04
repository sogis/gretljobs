WITH 

mpoly AS (
SELECT 
		denkmal_id,
		ST_RemoveRepeatedPoints(st_multi(st_buffer(st_buffer(st_buffer(st_buffer(st_union(apolygon),
	0.01),
	-0.01),
	-0.01),
	0.01)),
	0.01) AS mpoly
	-- TODO: Das Buffern und Re-Buffern ist definitiv nicht optimal. Allerdings ist es der einzige funktionierende Weg, die kleinen Digitalisierungsfehler zu eliminieren. 
	--       Evtl. findet man hier aber in Zukunft eine bessere Lösung! 
FROM 
		ada_denkmalschutz_v1.gis_geometrie
WHERE 
		apolygon IS NOT NULL
GROUP BY 
		denkmal_id
)

,rechtsvorschriften AS (
SELECT
	denkmal_id AS denkmal_id,
	json_agg(json_build_object('Titel', titel, 'Link', dok_download_url, 'Datum', datum, 'Nummer', rrb_jahr_nummer)) AS dokumente
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
		WHEN schutzdurchgemeinde = TRUE 
		THEN 'Ja'
		ELSE 'Nein'
	END AS schutzdurchgemeinde_txt,
	mpoly, 
	'https://geo.so.ch/docs/ch.so.ada.denkmalschutz/objektblatt/' || id || '.pdf' AS objektblatt, 
	rechtsvorschriften.dokumente AS rechtsvorschriften
FROM 
	ada_denkmalschutz_v1.fachapplikation_denkmal
JOIN
	mpoly 
	ON 
	fachapplikation_denkmal.id = mpoly.denkmal_id
LEFT JOIN 
    rechtsvorschriften
    ON 
    fachapplikation_denkmal.id = rechtsvorschriften.denkmal_id
;
