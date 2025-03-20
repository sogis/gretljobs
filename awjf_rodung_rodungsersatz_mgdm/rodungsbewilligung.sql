-- Löschung bisheriger Daten (inkl. Abhängigkeiten) --

DELETE FROM
	awjf_rodung_rodungsersatz_mgdm_v1.ersatzmassnahmennl_
;
DELETE FROM 
	awjf_rodung_rodungsersatz_mgdm_v1.massnahmenltyp_
;
DELETE FROM 
	awjf_rodung_rodungsersatz_mgdm_v1.ersatzverzicht_
;
DELETE FROM 
	awjf_rodung_rodungsersatz_mgdm_v1.objekt
;
DELETE FROM 
	awjf_rodung_rodungsersatz_mgdm_v1.uri_
;
DELETE FROM
    awjf_rodung_rodungsersatz_mgdm_v1.rodungsbewilligung
;

WITH

-- Selektion Attribute aus Tabelle Flaeche --
flaechen AS (
    SELECT
        t_id,
        ersatzmassnahmennl,
        geometrie,
        ST_AREA(geometrie) AS flaeche,
        frist,
        frist_bemerkung,
        frist_verlaengerung,
        frist_verlaengerung_bemerkung,
        datum_abnahme,
        massnahmennl_typ,
        ausgleichsabgabe_r,
        rodung_r,
        objekttyp,
        bemerkung AS bemerkung_geometrie,
        CASE 
            WHEN flaeche.objekttyp = 'Realersatz'
                THEN 1
            ELSE
                0
        END AS Ersatz_Real
    FROM 
        awjf_rodung_rodungsersatz_v1.flaeche
),

-- Selektion der grössten Fläche für den Schwerpunkt --
groesste_flaeche AS (
    SELECT
        rodung_r,
        geometrie AS max_geometrie
    FROM
        flaechen
    WHERE (rodung_r, flaeche) IN (
        SELECT 
            rodung_r,
            MAX(flaeche)
        FROM
            flaechen
        GROUP BY
            rodung_r
    )
),

fristen AS (
    SELECT 
        rodung_r,
        MAX(CASE 
            WHEN objekttyp IN ('Rodung_definitiv', 'Rodung_temporaer')
                THEN frist
            ELSE NULL
        END) AS Frist_Rodung,
        MAX(CASE 
            WHEN objekttyp IN ('Realersatz', 'MassnahmenNL')
                THEN frist
            ELSE NULL
        END) AS Frist_Ersatz
    FROM
        awjf_rodung_rodungsersatz_v1.flaeche
    GROUP BY
        rodung_r
),

-- Selektion Attribute aus Tabelle Rodungsdaten --
rodung AS (
    SELECT 
        t_id,
        nr_kanton,
        nr_bund,
        vorhaben,
        astatus,
        zustaendigkeit,
        rodungszweck,
        rodungszweck_bemerkung,
        art_bewilligungsverfahren,
        datum_amtsblatt_gesuch,
        datum_amtsblatt_bewilligung,
        auflagestart,
        auflageende,
        datum_entscheid,
        datum_rechtskraft,
        datum_anzeige_bafu,    
        datum_abschluss_rodung,
        ausgleichsabgabe_eingang,
        rodungsentscheid,
        sobauid,
        einsprache,
        beschwerde,
        massnahmenl_pool,    
        ersatzverzicht,
        art_sicherung,
        anmerkung_grundbuch,
        lieferung_bafu,
        waldplan_nachgefuehrt,
        flaeche_rodung_def_g,
        flaeche_rodung_def_e,
        flaeche_rodung_temp_g,
        flaeche_rodung_temp_e,
        flaeche_ersatz_real_g,
        flaeche_ersatz_real_e,
        flaeche_ersatz_massnahmennl_g,
        flaeche_ersatz_massnahmennl_e,
        bemerkung AS bemerkung_rodung
    FROM 
        awjf_rodung_rodungsersatz_v1.rodungsdaten
),

-- Selektion Attribute aus Tabelle Ausgleichsabgabe --
ausgleichsabgabe AS (
    SELECT 
        ausgleichsabgabe.t_id,
        ausgleichsabgabe.bezeichnung,
        ausgleichsabgabe.betrag,
        ausgleichsabgabe.zahlung,
        ausgleichsabgabe.bemerkung,
        flaeche.rodung_r
    FROM 
        awjf_rodung_rodungsersatz_v1.ausgleichsabgabe AS ausgleichsabgabe
    LEFT JOIN awjf_rodung_rodungsersatz_v1.flaeche AS flaeche
            ON ausgleichsabgabe.t_id = flaeche.ausgleichsabgabe_r
),

-- Selektion Attribute aus Tabelle Dokument --
dokumente AS (
    SELECT
        dok_id.rodung_r AS rodung_r,
        dokument.t_id,
        dokument.bezeichnung,
        dokument.dateipfad,
        dokument.typ,
        dokument.publiziertab,
        dokument.offiziellenr,
        dokument.bemerkung,
        dokument.verfuegung_url,
        dokument.astatus
    FROM 
        awjf_rodung_rodungsersatz_v1.dokument AS dokument
    LEFT JOIN awjf_rodung_rodungsersatz_v1.rodung_dokument AS dok_id
        ON dokument.t_id = dok_id.dokument_r
),

-- Zusammenfassung Attribute für die Tabelle Rodungsbewilligung --
rodungsbewilligung AS (
    SELECT
        rodung.nr_kanton,
        rodung.nr_bund,
        rodung.vorhaben,
        rodung.rodungsentscheid,
        rodung.datum_entscheid,
        rodung.datum_abschluss_rodung,
        rodung.ersatzverzicht,
        flaechen.objekttyp,
        flaechen.rodung_r,
        ersatz_real,
        rodung.zustaendigkeit AS Zustaendigkeit,
        flaeche_rodung_def_e AS flaeche_rodung_def,
        flaeche_rodung_temp_e AS flaeche_rodung_temp,
        flaeche_ersatz_real_e AS flaeche_ersatz_real,
        flaeche_ersatz_massnahmennl_e AS flaeche_ersatz_massnahmennl,
        CASE 
            WHEN flaechen.objekttyp = 'MassnahmenNL'
            AND flaechen.ErsatzMassnahmenNL = 'Gebiet_Waldflaeche_zunehmend'
                THEN ST_AREA(flaechen.geometrie)
            ELSE 
                0
        END AS FlaecheMassnahmeNL_imWaldareal,
        CASE 
            WHEN flaechen.objekttyp = 'MassnahmenNL'
            AND flaechen.ErsatzMassnahmenNL = 'Gebiet_uebrige'
                THEN ST_AREA(flaechen.geometrie)
            ELSE 
                0
        END AS FlaecheMassnahmeNL_AusserhalbWaldareal,
        rodung.massnahmenl_pool AS massnahmenl_pool,
        rodung.rodungszweck AS rodungszweck,
        rodung.rodungszweck_bemerkung AS rodungszweck_bemerkungen,
        CASE
            WHEN fristen.frist_rodung IS NOT NULL 
                THEN fristen.frist_rodung
            ELSE fristen.frist_ersatz
        END AS frist_rodung,
        CASE
            WHEN fristen.frist_ersatz IS NOT NULL 
                THEN fristen.frist_ersatz
            ELSE fristen.frist_rodung
        END AS frist_ersatz,
        ausgleichsabgabe.betrag AS ausgleichsabgabe,
        flaechen.geometrie,
        gflaeche.max_geometrie
    FROM 
        rodung AS rodung
    LEFT JOIN flaechen AS flaechen
        ON rodung.t_id = flaechen.rodung_r
    LEFT JOIN ausgleichsabgabe AS ausgleichsabgabe
        ON rodung.t_id = ausgleichsabgabe.rodung_r
    LEFT JOIN dokumente AS dokument
        ON rodung.t_id = dokument.rodung_r
    LEFT JOIN groesste_flaeche AS gflaeche
        ON rodung.t_id = gflaeche.rodung_r
    LEFT JOIN fristen AS fristen
        ON rodung.t_id = fristen.rodung_r
    GROUP BY
        rodung.nr_kanton,
        flaechen.rodung_r,
        rodung.nr_bund,
        rodung.vorhaben,
        rodung.rodungsentscheid,
        rodung.datum_entscheid,
        rodung.datum_abschluss_rodung,
        rodung.ersatzverzicht,
        flaechen.objekttyp,
        flaechen.ersatz_real,
        rodung.ersatzverzicht,
        rodung.zustaendigkeit,
        rodung.flaeche_rodung_def_e,
        rodung.flaeche_rodung_temp_e,
        rodung.flaeche_ersatz_real_e,
        rodung.flaeche_ersatz_massnahmennl_e,
        flaechen.ErsatzMassnahmenNL,
        rodung.massnahmenl_pool,
        rodung.rodungszweck,
        rodung.rodungszweck_bemerkung,
        fristen.frist_rodung,
        fristen.frist_ersatz,
        flaechen.objekttyp,
        flaechen.frist,
        ausgleichsabgabe.betrag,
        flaechen.geometrie,
        gflaeche.max_geometrie
)

-- Abfüllen der Tabelle Rodungsbewilligung --
INSERT INTO awjf_rodung_rodungsersatz_mgdm_v1.rodungsbewilligung (
    nr_kanton,
    nr_bund, -- freiwillig
    vorhaben,
    ersatz_real,
    zustaendigkeit,
    flaeche_rodung_def,
    flaeche_rodung_temp,
    flaeche_ersatz_real,
    flaeche_ersatz_verzicht,
    flaeche_ersatz_massnahmennl,
    flaechemassnahmenl_imwaldareal, -- freiwillig
    flaecheMassnahmenl_ausserhalbwaldareal, -- freiwillig
    massnahmenl_pool, -- freiwillig
    rodungszweck,
    rodungszweck_bemerkungen, -- freiwillig
    frist_rodung,
    frist_ersatz,
    ausgleich, -- freiwillig
    stand_abgeschlossen,
    datum_abgeschlossen,
    verfuegung_datum,
    schwerpunkt
)

-- Selektion und Umwandlung Attribute für Tabelle Rodungsbewilligung im MGDM --
SELECT
    nr_kanton,
    nr_bund,
    vorhaben,
    CASE 
        WHEN SUM(CASE
            WHEN ersatz_real = 1
                THEN 1
            ELSE 0
        END) > 0
            THEN TRUE
        ELSE FALSE
    END AS ersatz_real,
    CASE 
        WHEN zustaendigkeit = 'Kanton'
            THEN 'Z1'
        WHEN zustaendigkeit = 'Bund'
            THEN 'Z2'
    END AS Zustaendigkeit,
    CASE
        WHEN flaeche_rodung_def IS NOT NULL 
            THEN flaeche_rodung_def
        ELSE 0
    END AS flaeche_rodung_def,
    CASE
        WHEN flaeche_rodung_temp IS NOT NULL 
            THEN flaeche_rodung_temp
        ELSE 0
    END AS flaeche_rodung_temp,
    CASE
        WHEN flaeche_ersatz_real IS NOT NULL 
            THEN flaeche_ersatz_real
        ELSE 0
    END AS flaeche_ersatz_real,
    CASE 
        WHEN flaeche_rodung_def > flaeche_ersatz_real
            THEN (flaeche_rodung_def - flaeche_ersatz_real)
        ELSE 0
    END AS flaeche_ersatz_verzicht,
    CASE
        WHEN flaeche_ersatz_massnahmennl IS NOT NULL 
            THEN flaeche_ersatz_massnahmennl
        ELSE 0
    END AS flaeche_ersatz_massnahmennl,
    CASE
        WHEN (SUM(flaechemassnahmenl_imwaldareal) + SUM(flaecheMassnahmeNL_AusserhalbWaldareal)) > 0 AND NOT NULL
            THEN ROUND((SUM(flaechemassnahmenl_imwaldareal) / (SUM(flaechemassnahmenl_imwaldareal) + SUM(flaecheMassnahmeNL_AusserhalbWaldareal))) * flaeche_ersatz_massnahmennl)
        ELSE 0
    END AS flaechemassnahmenl_imwaldareal,
    CASE
        WHEN (SUM(flaechemassnahmenl_imwaldareal) + SUM(flaecheMassnahmeNL_AusserhalbWaldareal)) > 0 AND NOT NULL
            THEN ROUND((SUM(FlaecheMassnahmeNL_AusserhalbWaldareal) / (SUM(flaechemassnahmenl_imwaldareal) + SUM(flaecheMassnahmeNL_AusserhalbWaldareal))) * flaeche_ersatz_massnahmennl)
        ELSE 0
    END AS FlaecheMassnahmeNL_AusserhalbWaldareal,
    CASE 
        WHEN massnahmenl_pool IS TRUE 
            THEN TRUE 
        ELSE FALSE
    END AS massnahmenl_pool,
    CASE
        WHEN rodungszweck = 'Strassenverkehr'
            THEN 'R1'
        WHEN rodungszweck = 'Schienenverkehr'
            THEN 'R2'
        WHEN rodungszweck = 'Schifffahrt'
            THEN 'R3'
        WHEN rodungszweck = 'Luftfahrt'
            THEN 'R4'
        WHEN rodungszweck = 'Energie'
            THEN 'R5'
        WHEN rodungszweck = 'Anlagen_Grundwasser'
            THEN 'R6'
        WHEN rodungszweck = 'Rohstoffe'
            THEN 'R7'
        WHEN rodungszweck = 'Entsorgung'
            THEN 'R8'
        WHEN rodungszweck = 'Rohstoffe_Entsorgung'
            THEN 'R9'
        WHEN rodungszweck = 'Freizeit'
            THEN 'R10'
        WHEN rodungszweck = 'Hochbau'
            THEN 'R11'
        WHEN rodungszweck = 'Kulturland'
            THEN 'R12'
        WHEN rodungszweck = 'Wasserbau'
            THEN 'R13'
        WHEN rodungszweck = 'Revitalisierung'
            THEN 'R14'
        WHEN rodungszweck = 'Wasserbau_Revitalisierung'
            THEN 'R15'
        WHEN rodungszweck = 'Biotope'
            THEN 'R16'
        WHEN rodungszweck = 'Industrie'
            THEN 'R17'
        WHEN rodungszweck = 'Funkanlagen'
            THEN 'R18'
        WHEN rodungszweck = 'Militaer'
            THEN 'R19'
        WHEN rodungszweck = 'Verschiedenes'
            THEN 'R20'
    END AS rodungszweck,
    rodungszweck_bemerkungen,
    frist_rodung,
    frist_ersatz,
    CASE 
        WHEN ausgleichsabgabe IS NOT NULL
            THEN TRUE 
        ELSE FALSE
    END AS ausgleich,
    CASE 
        WHEN datum_abschluss_rodung IS NOT NULL
        AND ersatzverzicht = 'Nein'
            THEN 'S1' --Ja: Rodung und Rodungsersatz realisiert
        WHEN datum_abschluss_rodung IS NOT NULL 
        AND ersatzverzicht != 'Nein'
            THEN 'S2' --Ja: Nichtgebrauch der Rodungsbewilligung (Rodungsersatz entfällt)
        ELSE 'S3' --Nein, noch nicht abgeschlossen
    END AS Stand_Abgeschlossen,
    datum_abschluss_rodung AS datum_abgeschlossen,
    datum_entscheid AS Verfuegung_Datum,
    ST_PointOnSurface(max_geometrie) AS Schwerpunkt
FROM
    rodungsbewilligung
WHERE 
    rodungsentscheid = 'positiv'
AND 
    datum_entscheid >= '2020-01-01' -- Nur Rodungen, welche ab 01.01.2020 bewilligt wurden, sollen geliefert werden
AND 
    frist_ersatz >= CURRENT_DATE - INTERVAL '10 years' -- Nur Rodungen deren Rodungsersatz vor weniger als 10 Jahren abgeschlossen wurden sollen geliefert werden
AND 
    geometrie IS NOT NULL
GROUP BY
    nr_kanton,
    nr_bund,
    vorhaben,
    zustaendigkeit,
    ersatzverzicht,
    flaeche_rodung_def,
    flaeche_rodung_temp,
    flaeche_ersatz_real,
    flaeche_ersatz_verzicht,
    flaeche_ersatz_massnahmennl,
    massnahmenl_pool,
    rodungszweck,
    rodungszweck_bemerkungen,
    frist_rodung,
    frist_ersatz,
    ausgleichsabgabe,
    datum_abschluss_rodung,
    datum_entscheid,
    max_geometrie
;