DELETE FROM afu_bootsanbindeplaetze.main.sap_structure;

WITH 

-- Wenn Steggebühren an den gleichen Kunden gehen wie die restlichen Nutzungsgebühren --
nutzungsgebuehren_intern AS (
	SELECT 
		(bp.rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr,
		2232 AS "MaterialNr.",
		concat_ws(
			E'\n',
			CASE
				WHEN bp.bootsgebuehr > 0
					THEN 'Bootsgebühr: ' || bp.bootsgebuehr
			END,
			CASE
				WHEN bp.steggebuehr > 0
					THEN 'Steggebühr: ' || bp.steggebuehr
			END,
			CASE
				WHEN bp.steggebuehr > 0
					THEN 'Pfostengebühr: ' || bp.pfostengebuehr
			END
			) AS Materialtext,
		ROUND((COALESCE(bp.bootsgebuehr,0) + COALESCE(bp.steggebuehr,0) + COALESCE(bp.pfostengebuehr,0))::NUMERIC,2) AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg",
		'Bootsplatz' || ' ' || sd.gemeinde || ', ' || regexp_replace(bp.standort, '^\S+\s+', '') || ', Nr. ' || bp.platznummer AS "Kopfnotiz Zeile 1 Kopf",
		(bp.nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz AS bp
	LEFT JOIN pubdb.afu_bootsanbindeplaetze_pub_v1.standortdaten AS sd
		ON bp.standort = sd.standort
	WHERE 
		bp.rechnungsstelle_nutzungsgebuehr = bp.rechnungsstelle_steggebuehr
),

-- Wenn Steggebühren an einen anderen Kunden gehen wie die restlichen Nutzungsgebühren --
steggebuehren_separat AS (
	SELECT 
		(bp.rechnungsstelle_steggebuehr->0->>'SAP')::text AS KundenNr,
		2232 AS "MaterialNr.",
		'Steggebühr: ' || bp.steggebuehr AS Materialtext,
		ROUND((COALESCE(bp.steggebuehr,0))::NUMERIC,2) AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg",
		'Bootsplatz' || ' ' || sd.gemeinde || ', ' || regexp_replace(bp.standort, '^\S+\s+', '') || ', Nr. ' || bp.platznummer AS "Kopfnotiz Zeile 1 Kopf",
		(bp.nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz AS bp
	LEFT JOIN pubdb.afu_bootsanbindeplaetze_pub_v1.standortdaten AS sd
		ON bp.standort = sd.standort
	WHERE 
		rechnungsstelle_nutzungsgebuehr != rechnungsstelle_steggebuehr
),

bewilligunsgebuehr AS (
	SELECT 
		(bp.rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr,
		2671 AS "MaterialNr.",
		'Bewilligungsgebühr: ' || 100.00 AS Materialtext ,
		100.00 AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg",
		'Bootsplatz' || ' ' || sd.gemeinde || ', ' || regexp_replace(bp.standort, '^\S+\s+', '') || ', Nr. ' || bp.platznummer AS "Kopfnotiz Zeile 1 Kopf",
		(bp.nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz AS bp
	LEFT JOIN pubdb.afu_bootsanbindeplaetze_pub_v1.standortdaten AS sd
		ON bp.standort = sd.standort
	WHERE
    	datum_bewilligung >= CASE 
        	WHEN EXTRACT(MONTH FROM CURRENT_DATE) >= 7 -- Prüft ob der aktuelle Monat nach dem Juni ist
        		THEN
        			MAKE_DATE(EXTRACT(YEAR FROM CURRENT_DATE)::int, 7, 1) -- wenn wir uns im gleichen Jahr befinden wird der 1.7. des aktuellen Jahres genommen
       			ELSE
        			MAKE_DATE(EXTRACT(YEAR FROM CURRENT_DATE)::int - 1, 7, 1) -- wenn wir uns im Folgejahr befinden wird der 1.7. des letzten Jahres genommen
    	END
    AND
    	datum_bewilligung <= CURRENT_DATE -- Das Bewilligungsdatum darf nicht in der Zukunft liegen.
),

gebuehren_all AS (
	SELECT
 		KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2Komma",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		Kontokorrent
	FROM 
		nutzungsgebuehren_intern
	UNION ALL
	SELECT
 		KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2Komma",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		Kontokorrent
	FROM 
		steggebuehren_separat 
	UNION ALL 
	SELECT
	 	KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2Komma",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		Kontokorrent
	FROM 
		bewilligunsgebuehr
),

gebuehren_bereinigt AS (
	SELECT 
		--row_number() OVER (ORDER BY KundenNr) AS Eintragsnummer,
		dense_rank() OVER (
    		ORDER BY KundenNr
  		) AS Eintragsnummer,
		KundenNr,
		row_number() OVER (
			PARTITION BY KundenNr
		) * 10 AS Position,
		"MaterialNr.",
		Materialtext,
		"Betrag 2Komma",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		Kontokorrent
	FROM 
		gebuehren_all
)

SELECT 
	*
FROM 
	gebuehren_bereinigt
	
	
	
	

INSERT INTO afu_bootsanbindeplaetze.main.sap_structure (
	KundenNr,
	"MaterialNr.",
	Materialtext,
	"Betrag 2Komma",
	"Menge Ganzahlg"
)

SELECT 
	KundenNr,
	"MaterialNr.",
	Materialtext,
	"Betrag 2Komma",
	"Menge Ganzahlg"
FROM
	gebuehren_all
WHERE
	"Betrag 2Komma" > 0
AND 
	Kontokorrent IS FALSE
AND 
	KundenNr IS NOT NULL
AND
	KundenNr != 'XXX'
;



EXTRACT(YEAR FROM CURRENT_DATE)::int AS Materialtext