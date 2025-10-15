DELETE FROM afu_bootsanbindeplaetze.main.sap_structure;

WITH 

nutzungsgebuehren AS (
	SELECT 
		(rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr,
		2232 AS "MaterialNr.",
		'Nutzungsgebühr' || ' ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS Materialtext,
		ROUND((COALESCE(bootsgebuehr,0) + COALESCE(steggebuehr,0) + COALESCE(pfostengebuehr,0))::NUMERIC,2) AS "Betrag 2Komma",
		1 AS "Menge Ganzahlg"
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz
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
	nutzungsgebuehren
WHERE
	"Betrag 2Komma" > 0
AND 
	KundenNr IS NOT NULL
AND
	KundenNr != 'XXX'
;