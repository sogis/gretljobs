/* Publikation Grundwasser. Technische t_id wird im Ziel erzeugt.
 * Annahme: Grenzwerte bezeichnen die Schwelle zur genannten Klasse
 * Ueberschreitung (nach Rundung) fuehrt zu dieser Klasse.
 * Nachweisgrenzen werden konservativ als obere Schranke beurteilt.
 */
WITH beurteilungsklassen AS (
    SELECT *
    FROM (VALUES
        (0, 'kein_Grenzwert'),
        (1, 'weder_ueberwachung_noch_sanierung'),
        (2, 'ueberwachungsbeduerftig'),
        (3, 'sanierungsbeduerftig')
    ) AS klassen(rang, beurteilungsklasse)
),
alle_werte AS (
    SELECT
        analysewert.t_id AS quelle_id,
        analysewert.feldprobe_r,
        analysewert.parameter_r,
        analysewert.einheit_r,
        analysewert.wert,
        analysewert.nachkommastellen,
        analysewert.ist_nachweisgrenze,
        analysewert.labor_r,
        'messwert' AS wertart
    FROM afu_stoffe_grundwasser_v1.analysewert AS analysewert
    UNION ALL
    SELECT
        wert_berechnet.t_id,
        wert_berechnet.feldprobe_r,
        wert_berechnet.parameter_r,
        wert_berechnet.einheit_r,
        wert_berechnet.wert,
        wert_berechnet.nachkommastellen,
        FALSE,
        NULL::bigint,
        'berechnet'
    FROM afu_stoffe_grundwasser_v1.wert_berechnet AS wert_berechnet
),
klassierte_werte AS (
    SELECT
        alle_werte.*,
        parameter.aposition,
        parameter.kurzbezeichnung AS parameter_kurz,
        parameter.langbezeichnung AS parameter_lang,
        analysegruppe.kurzbezeichnung AS gruppe_kurz,
        analysegruppe.langbezeichnung AS gruppe_lang,
        einheit.bezeichnung AS einheit,
        klassierung.rang,
        beurteilungsklassen.beurteilungsklasse,
        concat(
            parameter.kurzbezeichnung, ' ',
            CASE WHEN alle_werte.ist_nachweisgrenze THEN '< ' ELSE '' END,
            round(alle_werte.wert, alle_werte.nachkommastellen)::text,
            ' ', einheit.bezeichnung
        ) AS wert_anzeige
    FROM alle_werte
    JOIN afu_stoffe_grundwasser_v1.aparameter AS parameter
        ON parameter.t_id = alle_werte.parameter_r
    JOIN afu_stoffe_grundwasser_v1.analysegruppe AS analysegruppe
        ON analysegruppe.t_id = parameter.analysegruppe_r
    JOIN afu_stoffe_grundwasser_v1.einheit AS einheit
        ON einheit.t_id = alle_werte.einheit_r
    JOIN afu_stoffe_grundwasser_v1.feldprobe AS feldprobe
        ON feldprobe.t_id = alle_werte.feldprobe_r
    JOIN afu_stoffe_grundwasser_v1.probenahmestelle AS probenahmestelle
        ON probenahmestelle.t_id = feldprobe.probenahmestelle_r
    CROSS JOIN LATERAL (
        SELECT
            CASE
                WHEN count(*) = 0 THEN 0
                ELSE greatest(1, coalesce(max(grenzwertklasse.rang) FILTER (
                    WHERE round(alle_werte.wert, grenzwert.nachkommastellen)
                        > round(grenzwert.wert, grenzwert.nachkommastellen)
                ), 1))
            END AS rang
        FROM afu_stoffe_grundwasser_v1.grenzwert AS grenzwert
        JOIN beurteilungsklassen AS grenzwertklasse
            ON grenzwertklasse.beurteilungsklasse = grenzwert.beurteilungsklasse
        WHERE grenzwert.parameter_r = alle_werte.parameter_r
            AND grenzwert.einheit_r = alle_werte.einheit_r
            AND grenzwert.gilt_in_gw_schutzbereich = probenahmestelle.in_gw_schutzbereich
    ) AS klassierung
    JOIN beurteilungsklassen
        ON beurteilungsklassen.rang = klassierung.rang
),
json_werte AS (
    SELECT
        klassierte_werte.*,
        jsonb_build_object(
            'Parameter_kurz', parameter_kurz,
            'Parameter_lang', parameter_lang,
            'Wert', wert,
            'Wert_Anzeige', wert_anzeige,
            'Nachkommastellen', nachkommastellen,
            'Einheit', einheit,
            'Beurteilungsklasse', beurteilungsklasse
        ) AS basis_json
    FROM klassierte_werte
),
werte_pro_feldprobe AS (
    SELECT
        feldprobe_r,
        max(rang) AS rang,
        jsonb_agg(basis_json || jsonb_build_object(
            'Ist_Nachweisgrenze', ist_nachweisgrenze,
            'Gruppe_kurz', gruppe_kurz,
            'Gruppe_lang', gruppe_lang
        ) ORDER BY gruppe_kurz, aposition, quelle_id)
            FILTER (WHERE wertart = 'messwert') AS messwerte,
        jsonb_agg(basis_json ORDER BY gruppe_kurz, aposition, quelle_id)
            FILTER (WHERE wertart = 'berechnet') AS werte_berechnet
    FROM json_werte
    GROUP BY feldprobe_r
),
labore_pro_feldprobe AS (
    SELECT
        analysewert.feldprobe_r,
        string_agg(DISTINCT labor.aname, ', ' ORDER BY labor.aname) AS labore
    FROM afu_stoffe_grundwasser_v1.analysewert AS analysewert
    JOIN afu_stoffe_grundwasser_v1.labor AS labor
        ON labor.t_id = analysewert.labor_r
    GROUP BY analysewert.feldprobe_r
)
SELECT
    feldprobe.t_ili_tid,
    feldprobe.probenahmedatum,
    feldprobe.bemerkungen,
    feldprobe.probebezeichnung,
    probenahmestelle.xy_koordinaten AS standort_punkt,
    probenahmestelle.ok_terrain AS standort_ok_terrain,
    probenahmestelle.bezeichnung AS standort_bezeichnung,
    probenahmestelle.kbs_nummer AS standort_kbs_nummer,
    beurteilungsklassen.beurteilungsklasse,
    coalesce(werte_pro_feldprobe.messwerte, '[]'::jsonb) AS messwerte,
    coalesce(werte_pro_feldprobe.werte_berechnet, '[]'::jsonb) AS werte_berechnet,
    feldprobe.grundwasserspiegel,
    probenahmestelle.in_gw_schutzbereich,
    labore_pro_feldprobe.labore
FROM afu_stoffe_grundwasser_v1.feldprobe AS feldprobe
JOIN afu_stoffe_grundwasser_v1.probenahmestelle AS probenahmestelle
    ON probenahmestelle.t_id = feldprobe.probenahmestelle_r
LEFT JOIN werte_pro_feldprobe
    ON werte_pro_feldprobe.feldprobe_r = feldprobe.t_id
LEFT JOIN beurteilungsklassen
    ON beurteilungsklassen.rang = coalesce(werte_pro_feldprobe.rang, 0)
LEFT JOIN labore_pro_feldprobe
    ON labore_pro_feldprobe.feldprobe_r = feldprobe.t_id
;
