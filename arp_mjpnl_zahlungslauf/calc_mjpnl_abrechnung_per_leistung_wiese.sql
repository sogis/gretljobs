INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung (
    t_basket,
    vereinbarung,
    leistung_beschrieb,
    abgeltungsart,
    betrag_per_einheit,
    anzahl_einheiten,
    betrag_total,
    auszahlungsjahr,
    status_abrechnung,
    abrechnungpervereinbarung
)
WITH alle_wiese AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        wiese.t_basket AS beurteilung_t_basket,
        wiese.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese AS wiese
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        wiese.vereinbarung = vereinbarung.t_id
    WHERE
        wiese.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv'
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND wiese.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wiese b WHERE b.mit_bewirtschafter_besprochen IS TRUE AND b.vereinbarung = wiese.vereinbarung)
),
united_wiese_leistungen AS (
    -- union aller leistungen
    SELECT -- Wiese: Einstiegskriterien
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Wiese: Einstiegskriterien' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        200 AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstiegskriterium_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wiese
    WHERE
        flaeche > 0 AND einstiegskriterium_abgeltung_ha > 0

    UNION

    SELECT -- Wiese: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Wiese: Faunabonus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        50 AS betrag_per_einheit,
        einstufungbeurteilungistzustand_anzahl_fauna AS anzahl_einheiten,
        einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal AS betrag_total,
        kantonsintern
    FROM
        alle_wiese
    WHERE
        einstufungbeurteilungistzustand_anzahl_fauna > 0

    UNION

    SELECT -- Wiese: Einstufung / Beurteilung Ist-Zustand
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Wiese: Einstufung / Beurteilung Ist-Zustand (' || einstufungbeurteilungistzustand_wiesenkategorie || ')' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wiese
    WHERE
        flaeche > 0 AND einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha > 0

    UNION

    SELECT -- Wiese: Bewirtschaftungsabmachungen (Messerbalken-Mähgerät)
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Wiese: BBewirtschaftungsabmachungen (Messerbalken-Mähgerät)' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        bewirtschaftabmachung_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * bewirtschaftabmachung_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND bewirtschaftabmachung_abgeltung_ha > 0

    UNION

    SELECT -- Wiese: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Wiese: Erschwernis (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN erschwernis_massnahme1 THEN 'Massnahme 1: '||erschwernis_massnahme1_text END,
                CASE WHEN erschwernis_massnahme2 THEN 'Massnahme 2: '||erschwernis_massnahme2_text END
            )) ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wiese
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0

    UNION

    SELECT -- Wiese: Artenförderung
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Wiese: Artenförderung (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN artenfoerderung_ff_zielart1 THEN 'Massnahme für '||artenfoerderung_ff_zielart1||': '||artenfoerderung_ff_zielart1_massnahme END,
                CASE WHEN artenfoerderung_ff_zielart2 THEN 'Massnahme für '||artenfoerderung_ff_zielart2||': '||artenfoerderung_ff_zielart2_massnahme END,
                CASE WHEN artenfoerderung_ff_zielart3 THEN 'Massnahme für '||artenfoerderung_ff_zielart3||': '||artenfoerderung_ff_zielart3_massnahme END
            )) ||
        ')'
        AS leistung_beschrieb,
        artenfoerderung_abgeltungsart AS abgeltungsart,
        artenfoerderung_abgeltung_total AS betrag_per_einheit,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN 1 ELSE flaeche END AS anzahl_einheiten,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN artenfoerderung_abgeltung_total ELSE (flaeche * artenfoerderung_abgeltung_total) END AS betrag_total,
        kantonsintern
    FROM
        alle_wiese
    WHERE
        artenfoerderung_abgeltung_total > 0
)
SELECT 
    t_basket,
    vereinbarung,
    leistung_beschrieb,
    abgeltungsart,
    betrag_per_einheit,
    anzahl_einheiten,
    betrag_total,
    /* Statisch kalkulierte und gleiche Werte */
    -- aktuelles Jahr
    date_part('year', now())::integer AS auszahlungsjahr,
    -- Ursprungsstatus mit Ausnahme der kantonsinternen Vereinbarungen
    CASE
        WHEN kantonsintern THEN 'intern_verrechnet'
        ELSE 'freigegeben'
    END AS status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_wiese_leistungen
;