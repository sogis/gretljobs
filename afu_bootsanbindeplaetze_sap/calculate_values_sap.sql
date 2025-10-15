DELETE FROM afu_bootsanbindeplaetze.main.sap_structure;

WITH 

-- Wenn Steggebühren an den gleichen Kunden gehen wie die restlichen Nutzungsgebühren --
nutzungsgebuehren_all AS (
	SELECT 
		(rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr,
		2232 AS "MaterialNr.",
		'Nutzungsgebühr' || ' ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS Materialtext,
		ROUND((COALESCE(bootsgebuehr,0) + COALESCE(steggebuehr,0) + COALESCE(pfostengebuehr,0))::NUMERIC,2) AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg",
		(nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz
	WHERE 
		rechnungsstelle_nutzungsgebuehr = rechnungsstelle_steggebuehr
),

-- Wenn Steggebühren an einen anderen Kunden gehen wie die restlichen Nutzungsgebühren --
steggebuehren_separat AS (
	SELECT 
		(rechnungsstelle_steggebuehr->0->>'SAP')::text AS KundenNr,
		2232 AS "MaterialNr.",
		'Nutzungsgebühr' || ' ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS Materialtext,
		ROUND((COALESCE(steggebuehr,0))::NUMERIC,2) AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg",
		(nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz
	WHERE 
		rechnungsstelle_nutzungsgebuehr != rechnungsstelle_steggebuehr
),

bewilligunsgebuehr AS (
	SELECT 
		(rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr,
		2671 AS "MaterialNr.",
		'Bewilligungsgebühr' || ' ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS Materialtext,
		100.00 AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg",
		(nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz
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
		Kontokorrent
	FROM 
		nutzungsgebuehren_all
	UNION ALL
	SELECT
 		KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2Komma",
		"Menge Ganzahlg",
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
		Kontokorrent
	FROM 
		bewilligunsgebuehr
)

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