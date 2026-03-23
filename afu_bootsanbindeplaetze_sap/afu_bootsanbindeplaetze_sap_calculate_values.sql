DELETE FROM afu_bootsanbindeplaetze.main.sap_structure;

WITH 

-- Selektierung Beträge, wenn die Nutzungsgebühr und Steggebühr an die gleiche Rechnungsstelle geht --
nutzungsgebuehren_gleiche_RS AS (
	SELECT 
		(bp.rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr, -- extrahiert die Kunden-Nr. (SAP) aus dem JSON-Attribut
		2232 AS "MaterialNr.",
		ROUND(g.betrag,2) AS "Betrag 2 Kommastellen",
		g.Materialtext,
		1 AS "Menge Ganzahlg",
		'Nutzungsgebühr ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS "Kopfnotiz Zeile 1 Kopf",
		'Bootsplatz' || ' ' || sd.gemeinde || ', ' || regexp_replace(bp.standort, '^\S+\s+', '') || ', Nr. ' || bp.platznummer AS "MaterialVerkaufstext Zeile 1 Position",
		(bp.nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz AS bp
	LEFT JOIN pubdb.afu_bootsanbindeplaetze_pub_v1.standortdaten AS sd
		ON bp.standort = sd.standort
	CROSS JOIN LATERAL (
		VALUES
			('Bootsgebühr', bp.bootsgebuehr),
			('Steggebühr', bp.steggebuehr),
			('Pfostengebühr', bp.pfostengebuehr),
			('Miete', bp.mietkosten)
	) AS g(Materialtext, betrag)
	WHERE
		bp.rechnungsstelle_nutzungsgebuehr = bp.rechnungsstelle_steggebuehr -- Rechnungstelle für Nutzungsgebühr und Steggebühr ist die gleiche
	AND
		g.betrag IS NOT NULL
	AND
		g.betrag > 0
),

-- Selektierung Beträge, wenn die Nutzungsgebühr und Steggebühr nicht and die gleiche Rechnungsstelle geht --
nutzungsgebuehren_separate_RS AS (
	SELECT 
		(bp.rechnungsstelle_steggebuehr->0->>'SAP')::text AS KundenNr,
		2232 AS "MaterialNr.",
		'Steggebühr' AS Materialtext,
		ROUND((COALESCE(bp.steggebuehr,0))::NUMERIC,2) AS "Betrag 2 Kommastellen",
		1 AS "Menge Ganzahlg",
		'Nutzungsgebühr ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS "Kopfnotiz Zeile 1 Kopf",
		'Bootsplatz' || ' ' || sd.gemeinde || ', ' || regexp_replace(bp.standort, '^\S+\s+', '') || ', Nr. ' || bp.platznummer AS "MaterialVerkaufstext Zeile 1 Position",
		(bp.nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz AS bp
	LEFT JOIN pubdb.afu_bootsanbindeplaetze_pub_v1.standortdaten AS sd
		ON bp.standort = sd.standort
	WHERE 
		rechnungsstelle_nutzungsgebuehr IS DISTINCT FROM rechnungsstelle_steggebuehr
),

-- Die Bewilligungsgebühr wird einmalig mit der Vergabe der Nutzungsbewilligung erhoben --
-- Die Bewilligungsgebühr wird für das aktuelle Jahr nicht erhoben, wenn die Bewilligung nach dem Juni vergeben wurde --
-- Die Rechnungsperiode der Bewilligungsgebühr geht dementsprechend von Juli bis Juli --
-- Beispiel: Das heutige Datum ist der 31.3.2026 (normalerweise wird ca. Ende März die Rechnung erstellt) --
--			- Fall 1 - Bewilligungsdatum ist 20.08.2025: Bewilligugnsgebühr wird erhoben --
--			- Fall 2 - Bewilligungsdatum ist 20.06.2025: Bewilligungsgebühr wird nicht erhoben, da bereits in vorheriger Periode verrechnet --
bewilligunsgebuehr AS (
	SELECT 
		(bp.rechnungsstelle_nutzungsgebuehr->0->>'SAP')::text AS KundenNr,
		2671 AS "MaterialNr.",
		'Bewilligungsgebühr' AS Materialtext ,
		100.00 AS "Betrag 2 Kommastellen",
		1 AS "Menge Ganzahlg",
		'Bewilligungsgebühr ' || EXTRACT(YEAR FROM CURRENT_DATE)::int AS "Kopfnotiz Zeile 1 Kopf",
		'Bootsplatz' || ' ' || sd.gemeinde || ', ' || regexp_replace(bp.standort, '^\S+\s+', '') || ', Nr. ' || bp.platznummer AS "MaterialVerkaufstext Zeile 1 Position",
		(bp.nutzer->0->>'Kontokorrent')::bool AS Kontokorrent
	FROM
		pubdb.afu_bootsanbindeplaetze_pub_v1.bootsanbindeplatz AS bp
	LEFT JOIN pubdb.afu_bootsanbindeplaetze_pub_v1.standortdaten AS sd
		ON bp.standort = sd.standort
	WHERE
    	datum_bewilligung >= CASE 
        	WHEN EXTRACT(MONTH FROM CURRENT_DATE) >= 7 -- Prüft ob der aktuelle Monat nach dem Juni ist (also Juli oder später)
        		THEN
        			MAKE_DATE(EXTRACT(YEAR FROM CURRENT_DATE)::int, 7, 1) -- wenn wir uns im gleichen Jahr befinden wird der 1.7. des aktuellen Jahres genommen
       			ELSE
        			MAKE_DATE(EXTRACT(YEAR FROM CURRENT_DATE)::int - 1, 7, 1) -- wenn wir uns im Folgejahr befinden wird der 1.7. des letzten Jahres genommen
    	END
    AND
    	datum_bewilligung <= CURRENT_DATE -- Das Bewilligungsdatum darf nicht in der Zukunft liegen.
),

gebuehren_alle AS (
	SELECT
 		KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2 Kommastellen",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		"MaterialVerkaufstext Zeile 1 Position",
		Kontokorrent
	FROM 
		nutzungsgebuehren_gleiche_RS
	UNION ALL
	SELECT
 		KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2 Kommastellen",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		"MaterialVerkaufstext Zeile 1 Position",
		Kontokorrent
	FROM 
		nutzungsgebuehren_separate_RS
	UNION ALL 
	SELECT
	 	KundenNr,
		"MaterialNr.",
		Materialtext,
		"Betrag 2 Kommastellen",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		"MaterialVerkaufstext Zeile 1 Position",
		Kontokorrent
	FROM 
		bewilligunsgebuehr
	ORDER BY 
		KundenNr,
		"MaterialVerkaufstext Zeile 1 Position",
		Materialtext,
		"Kopfnotiz Zeile 1 Kopf"
),

gebuehren_nummerierung AS (
	SELECT 
		dense_rank() OVER (
    		ORDER BY KundenNr
  		) AS Eintragsnummer, -- Zuweisung Eintragsnummer
		KundenNr,
		row_number() OVER (
			PARTITION BY KundenNr
			ORDER BY
				"MaterialVerkaufstext Zeile 1 Position"
		) * 10 AS "Position", -- Pro Kunde (SAP) wird jeder Rechnungsposition eine aufsteigende Nummer (10er-Schritte) zugewiesen
		"MaterialNr.",
		Materialtext,
		"Betrag 2 Kommastellen",
		"Menge Ganzahlg",
		"Kopfnotiz Zeile 1 Kopf",
		"MaterialVerkaufstext Zeile 1 Position",
		Kontokorrent
	FROM 
		gebuehren_alle
	ORDER BY 
		KundenNr,
		"Position",
		"Kopfnotiz Zeile 1 Kopf"
),

gebuehren_sap AS (
	SELECT 
		Eintragsnummer,
		NULL AS AuftrArt,
		NULL AS VerkOrg,
		NULL AS VertrWeg,
		NULL AS Sparte,
		NULL AS "Verkaufsbüro",
		CASE
			WHEN "Position" = 10
				THEN 'K'
			ELSE 'P'
		END AS "K=Kopf/P=Position", -- Die erste Rechnungsposition jedes Kunden wird als Kopf bezeichnet
		KundenNr,
		NULL AS "Bestellnummer des Kunden",
		NULL AS BestellDatum,
		NULL AS Wunschlieferdatum,
		NULL AS Preisdatum,
		"Position",
		"MaterialNr.",
		Materialtext,
		"Betrag 2 Kommastellen",
		"Menge Ganzahlg",
		NULL AS Mengeneinheit,
		NULL AS Auftragsnummer,
		NULL AS Profitcenter,
		"Kopfnotiz Zeile 1 Kopf",
		NULL AS "Kopfnotiz Zeile 2 Kopf",
		NULL AS "Kopfnotiz Zeile 3 Kopf",
		NULL AS "Kopfnotiz Zeile 4 Kopf",
		NULL AS "Kopfnotiz Zeile 5 Kopf",
		NULL AS "Kopfnotiz Zeile 6 Kopf",
		NULL AS "Kopfnotiz Zeile 7 Kopf",
		NULL AS "Kopfnotiz Zeile 8 Kopf",
		NULL AS "Kopfnotiz Zeile 9 Kopf",
		NULL AS "Kopfnotiz Zeile 10 Kopf",
		NULL AS "Schlussnotiz Zeile 1 Kopf",
		NULL AS "Schlussnotiz Zeile 2 Kopf",
		NULL AS "Schlussnotiz Zeile 3 Kopf",
		NULL AS "Sachbearbeiter Zeile 1 Kopf",
		NULL AS "Sachbearbeiter Zeile 2 Kopf",
		NULL AS "Sachbearbeiter Zeile 3 Kopf",
		NULL AS "Sachbearbeiter Zeile 4 Kopf",
		NULL AS "Sachbearbeiter Zeile 5 Kopf",
		NULL AS "Kundenansprechperson Kopf",
		"MaterialVerkaufstext Zeile 1 Position",
		NULL AS "MaterialVerkaufstext Zeile 2 Position",
		NULL AS "MaterialVerkaufstext Zeile 3 Position",
		NULL AS "MaterialVerkaufstext Zeile 4 Position",
		NULL AS "MaterialVerkaufstext Zeile 5 Position",
		NULL AS "PositionsNotiz Zeile 1 Position",
		NULL AS "PositionsNotiz Zeile 2 Position",
		NULL AS "PositionsNotiz Zeile 3 Position",
		NULL AS "PositionsNotiz Zeile 4 Position",
		NULL AS "PositionsNotiz Zeile 5 Position",
		NULL AS "Email Kunde",
		NULL AS "Name1 Debitor(Info)",
		NULL AS "Name2 Debitor(Info)",
		NULL AS "Strasse Debitor(Info)",
		NULL AS "PostLz(Info)",
		NULL AS "Ortschaft(Info)",
		NULL AS Zahlweg
	FROM 
		gebuehren_nummerierung
	WHERE
		Kontokorrent IS NOT TRUE
	AND
		KundenNr != 'XXX'	
)

INSERT INTO afu_bootsanbindeplaetze.main.sap_structure (
	Eintragsnummer,
	AuftrArt,
	VerkOrg,
	VertrWeg,
	Sparte,
	"Verkaufsbüro",
	"K=Kopf/P=Position",
	KundenNr,
	"Bestellnummer des Kunden",
	BestellDatum,
	Wunschlieferdatum,
	Preisdatum,
	"Position",
	"MaterialNr.",
	Materialtext,
	"Betrag 2 Kommastellen",
	"Menge Ganzahlg",
	Mengeneinheit,
	Auftragsnummer,
	Profitcenter,
	"Kopfnotiz Zeile 1 Kopf",
	"Kopfnotiz Zeile 2 Kopf",
	"Kopfnotiz Zeile 3 Kopf",
	"Kopfnotiz Zeile 4 Kopf",
	"Kopfnotiz Zeile 5 Kopf",
	"Kopfnotiz Zeile 6 Kopf",
	"Kopfnotiz Zeile 7 Kopf",
	"Kopfnotiz Zeile 8 Kopf",
	"Kopfnotiz Zeile 9 Kopf",
	"Kopfnotiz Zeile 10 Kopf",
	"Schlussnotiz Zeile 1 Kopf",
	"Schlussnotiz Zeile 2 Kopf",
	"Schlussnotiz Zeile 3 Kopf",
	"Sachbearbeiter Zeile 1 Kopf",
	"Sachbearbeiter Zeile 2 Kopf",
	"Sachbearbeiter Zeile 3 Kopf",
	"Sachbearbeiter Zeile 4 Kopf",
	"Sachbearbeiter Zeile 5 Kopf",
	"Kundenansprechperson Kopf",
	"MaterialVerkaufstext Zeile 1 Position",
	"MaterialVerkaufstext Zeile 2 Position",
	"MaterialVerkaufstext Zeile 3 Position",
	"MaterialVerkaufstext Zeile 4 Position",
	"MaterialVerkaufstext Zeile 5 Position",
	"PositionsNotiz Zeile 1 Position",
	"PositionsNotiz Zeile 2 Position",
	"PositionsNotiz Zeile 3 Position",
	"PositionsNotiz Zeile 4 Position",
	"PositionsNotiz Zeile 5 Position",
	"Email Kunde",
	"Name1 Debitor(Info)",
	"Name2 Debitor(Info)",
	"Strasse Debitor(Info)",
	"PostLz(Info)",
	"Ortschaft(Info)",
	Zahlweg
)

SELECT 
	Eintragsnummer,
	AuftrArt,
	VerkOrg,
	VertrWeg,
	Sparte,
	"Verkaufsbüro",
	"K=Kopf/P=Position",
	KundenNr,
	"Bestellnummer des Kunden",
	BestellDatum,
	Wunschlieferdatum,
	Preisdatum,
	"Position",
	"MaterialNr.",
	Materialtext,
	"Betrag 2 Kommastellen",
	"Menge Ganzahlg",
	Mengeneinheit,
	Auftragsnummer,
	Profitcenter,
	"Kopfnotiz Zeile 1 Kopf",
	"Kopfnotiz Zeile 2 Kopf",
	"Kopfnotiz Zeile 3 Kopf",
	"Kopfnotiz Zeile 4 Kopf",
	"Kopfnotiz Zeile 5 Kopf",
	"Kopfnotiz Zeile 6 Kopf",
	"Kopfnotiz Zeile 7 Kopf",
	"Kopfnotiz Zeile 8 Kopf",
	"Kopfnotiz Zeile 9 Kopf",
	"Kopfnotiz Zeile 10 Kopf",
	"Schlussnotiz Zeile 1 Kopf",
	"Schlussnotiz Zeile 2 Kopf",
	"Schlussnotiz Zeile 3 Kopf",
	"Sachbearbeiter Zeile 1 Kopf",
	"Sachbearbeiter Zeile 2 Kopf",
	"Sachbearbeiter Zeile 3 Kopf",
	"Sachbearbeiter Zeile 4 Kopf",
	"Sachbearbeiter Zeile 5 Kopf",
	"Kundenansprechperson Kopf",
	"MaterialVerkaufstext Zeile 1 Position",
	"MaterialVerkaufstext Zeile 2 Position",
	"MaterialVerkaufstext Zeile 3 Position",
	"MaterialVerkaufstext Zeile 4 Position",
	"MaterialVerkaufstext Zeile 5 Position",
	"PositionsNotiz Zeile 1 Position",
	"PositionsNotiz Zeile 2 Position",
	"PositionsNotiz Zeile 3 Position",
	"PositionsNotiz Zeile 4 Position",
	"PositionsNotiz Zeile 5 Position",
	"Email Kunde",
	"Name1 Debitor(Info)",
	"Name2 Debitor(Info)",
	"Strasse Debitor(Info)",
	"PostLz(Info)",
	"Ortschaft(Info)",
	Zahlweg
FROM
	gebuehren_sap
;