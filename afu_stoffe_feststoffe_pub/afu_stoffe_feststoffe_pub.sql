WITH
abfallklassen AS (
    SELECT
        abfallklassen.bezeichnung,
        abfallklassen.rang
    FROM
        (
            VALUES
                ('kein_Grenzwert', 0),
                ('unverschmutztes_Material', 1),
                ('technisches_Material', 2),
                ('Bauabfaelle', 3),
                ('Erdaushub', 4),
                ('Sonderabfaelle', 5)
        ) AS abfallklassen (bezeichnung, rang)
),
messwerte AS (
    SELECT
        analysewert.t_id,
        analysewert.feldprobe_r,
        analysewert.parameter_r,
        analysewert.einheit_r,
        analysewert.wert,
        analysewert.nachkommastellen,
        analysewert.ist_nachweisgrenze,
        aparameter.kurzbezeichnung AS parameter_kurz,
        aparameter.langbezeichnung AS parameter_lang,
        aparameter.aposition,
        analysegruppe.kurzbezeichnung AS gruppe_kurz,
        analysegruppe.langbezeichnung AS gruppe_lang,
        einheit.bezeichnung AS einheit,
        labor.aname AS labor
    FROM
        afu_stoffe_feststoffe_v1.analysewert AS analysewert
        JOIN afu_stoffe_feststoffe_v1.aparameter AS aparameter
            ON aparameter.t_id = analysewert.parameter_r
        JOIN afu_stoffe_feststoffe_v1.analysegruppe AS analysegruppe
            ON analysegruppe.t_id = aparameter.analysegruppe_r
        JOIN afu_stoffe_feststoffe_v1.einheit AS einheit
            ON einheit.t_id = analysewert.einheit_r
        JOIN afu_stoffe_feststoffe_v1.labor AS labor
            ON labor.t_id = analysewert.labor_r
),
berechnete_werte AS (
    SELECT
        wert_berechnet.t_id,
        wert_berechnet.feldprobe_r,
        wert_berechnet.parameter_r,
        wert_berechnet.einheit_r,
        wert_berechnet.wert,
        wert_berechnet.nachkommastellen,
        aparameter.kurzbezeichnung AS parameter_kurz,
        aparameter.langbezeichnung AS parameter_lang,
        aparameter.aposition,
        einheit.bezeichnung AS einheit
    FROM
        afu_stoffe_feststoffe_v1.wert_berechnet AS wert_berechnet
        JOIN afu_stoffe_feststoffe_v1.aparameter AS aparameter
            ON aparameter.t_id = wert_berechnet.parameter_r
        JOIN afu_stoffe_feststoffe_v1.einheit AS einheit
            ON einheit.t_id = wert_berechnet.einheit_r
),
alle_werte AS (
    SELECT
        'messwert'::text AS art,
        t_id,
        feldprobe_r,
        parameter_r,
        einheit_r,
        wert,
        nachkommastellen,
        ist_nachweisgrenze
    FROM
        messwerte
    UNION ALL
    SELECT
        'berechnet',
        t_id,
        feldprobe_r,
        parameter_r,
        einheit_r,
        wert,
        nachkommastellen,
        FALSE
    FROM
        berechnete_werte
),
-- Zuerst je Wert die kleinste Klasse bestimmen, deren Grenzwert eingehalten wird.
-- Fehlen Grenzwerte, gilt 'kein_Grenzwert'. Werden alle überschritten,
-- gilt vorläufig 'Sonderabfaelle' (fachlich noch zu bestätigen).
grenzwerte_je_wert AS (
    SELECT
        alle_werte.art,
        alle_werte.t_id,
        alle_werte.feldprobe_r,
        COUNT(grenzwert.t_id) AS anzahl_grenzwerte,
        MIN(abfallklassen.rang) FILTER (
            WHERE
                ROUND(alle_werte.wert, grenzwert.nachkommastellen)
                    <= ROUND(grenzwert.wert, grenzwert.nachkommastellen)
        ) AS passender_rang
    FROM
        alle_werte AS alle_werte
        LEFT JOIN afu_stoffe_feststoffe_v1.grenzwert AS grenzwert
            ON grenzwert.parameter_r = alle_werte.parameter_r
            AND grenzwert.einheit_r = alle_werte.einheit_r
        LEFT JOIN abfallklassen AS abfallklassen
            ON abfallklassen.bezeichnung = grenzwert.abfallklasse_vvea
    GROUP BY
        alle_werte.art,
        alle_werte.t_id,
        alle_werte.feldprobe_r
),
grenzwerte_klassiert AS (
    SELECT
        grenzwerte_je_wert.art,
        grenzwerte_je_wert.t_id,
        grenzwerte_je_wert.feldprobe_r,
        abfallklassen.bezeichnung AS abfallklasse_vvea,
        abfallklassen.rang AS abfallklasse_rang
    FROM
        grenzwerte_je_wert AS grenzwerte_je_wert
        JOIN abfallklassen AS abfallklassen
            ON abfallklassen.rang =
                CASE
                    WHEN grenzwerte_je_wert.anzahl_grenzwerte = 0
                        THEN 0
                    ELSE
                        COALESCE(grenzwerte_je_wert.passender_rang, 5)
                END
),
messwerte_json AS (
    SELECT
        messwerte.feldprobe_r,
           jsonb_agg(jsonb_build_object(
               'abfallklasse_vvea',
               grenzwerte_klassiert.abfallklasse_vvea,
               'ist_nachweisgrenze',
               messwerte.ist_nachweisgrenze,
               'gruppe_kurz',
               messwerte.gruppe_kurz,
               'gruppe_lang',
               messwerte.gruppe_lang,
               'parameter_kurz',
               messwerte.parameter_kurz,
               'parameter_lang',
               messwerte.parameter_lang,
               'wert',
               messwerte.wert,
               'wert_anzeige', concat(messwerte.parameter_kurz, ' ',
                   CASE WHEN messwerte.ist_nachweisgrenze THEN '< ' ELSE '' END,
                   round(messwerte.wert, messwerte.nachkommastellen)::text,
                   ' ',
                   messwerte.einheit),
               'nachkommastellen',
               messwerte.nachkommastellen,
               'einheit',
               messwerte.einheit
           ) ORDER BY messwerte.aposition, messwerte.t_id) AS messwerte
    FROM
        messwerte AS messwerte
        JOIN grenzwerte_klassiert AS grenzwerte_klassiert
            ON grenzwerte_klassiert.art = 'messwert'
            AND
                grenzwerte_klassiert.t_id = messwerte.t_id
    GROUP BY
        messwerte.feldprobe_r
),
berechnete_json AS (
    SELECT
        berechnete_werte.feldprobe_r,
           jsonb_agg(jsonb_build_object(
               'abfallklasse_vvea',
               grenzwerte_klassiert.abfallklasse_vvea,
               'parameter_kurz',
               berechnete_werte.parameter_kurz,
               'parameter_lang',
               berechnete_werte.parameter_lang,
               'wert',
               berechnete_werte.wert,
               'wert_anzeige', concat(berechnete_werte.parameter_kurz, ' ',
                   round(berechnete_werte.wert, berechnete_werte.nachkommastellen)::text,
                   ' ',
                   berechnete_werte.einheit),
               'nachkommastellen',
               berechnete_werte.nachkommastellen,
               'einheit',
               berechnete_werte.einheit
           ) ORDER BY berechnete_werte.aposition, berechnete_werte.t_id) AS werte_berechnet
    FROM
        berechnete_werte AS berechnete_werte
        JOIN grenzwerte_klassiert AS grenzwerte_klassiert
            ON grenzwerte_klassiert.art = 'berechnet'
            AND
                grenzwerte_klassiert.t_id = berechnete_werte.t_id
    GROUP BY
        berechnete_werte.feldprobe_r
),
labore AS (
    SELECT
        feldprobe_r,
        string_agg(DISTINCT labor, ', ' ORDER BY labor) AS labore
    FROM
        messwerte
    GROUP BY
        feldprobe_r
),
-- Fuer die Feldprobe zählt die gravierendste Klasse aller Einzelwerte.
-- Rang 0 ('kein_Grenzwert') beeinflusst vorhandene Klassierungen nicht.
proben_klassierung AS (
    SELECT
        grenzwerte_klassiert.feldprobe_r,
        abfallklassen.bezeichnung AS abfallklasse_vvea
    FROM
        (
            SELECT
                grenzwerte_klassiert.feldprobe_r,
                MAX(grenzwerte_klassiert.abfallklasse_rang) AS abfallklasse_rang
            FROM
                grenzwerte_klassiert AS grenzwerte_klassiert
            GROUP BY
                grenzwerte_klassiert.feldprobe_r
        ) AS grenzwerte_klassiert
        JOIN abfallklassen AS abfallklassen
            ON abfallklassen.rang = grenzwerte_klassiert.abfallklasse_rang
)
SELECT
    feldprobe.t_id,
    feldprobe.t_ili_tid,
    feldprobe.probenahmedatum,
    feldprobe.bemerkungen,
    feldprobe.probebezeichnung,
    probenahmestelle.xy_koordinaten AS standort_punkt,
    probenahmestelle.bezeichnung AS standort_bezeichnung,
    probenahmestelle.kbs_nummer AS standort_kbs_nummer,
    COALESCE(proben_klassierung.abfallklasse_vvea, 'kein_Grenzwert') AS abfallklasse_vvea,
    COALESCE(messwerte_json.messwerte, '[]'::jsonb) AS messwerte,
    COALESCE(berechnete_json.werte_berechnet, '[]'::jsonb) AS werte_berechnet,
    feldprobe.tiefe_von,
    feldprobe.tiefe_bis,
    COALESCE(labore.labore, '') AS labore
FROM
    afu_stoffe_feststoffe_v1.feldprobe AS feldprobe
    JOIN afu_stoffe_feststoffe_v1.probenahmestelle AS probenahmestelle
    ON probenahmestelle.t_id = feldprobe.probenahmestelle_r
    LEFT JOIN proben_klassierung AS proben_klassierung
        ON proben_klassierung.feldprobe_r = feldprobe.t_id
    LEFT JOIN messwerte_json AS messwerte_json
        ON messwerte_json.feldprobe_r = feldprobe.t_id
    LEFT JOIN berechnete_json AS berechnete_json
        ON berechnete_json.feldprobe_r = feldprobe.t_id
    LEFT JOIN labore AS labore
        ON labore.feldprobe_r = feldprobe.t_id
ORDER BY
    feldprobe.t_id
;
