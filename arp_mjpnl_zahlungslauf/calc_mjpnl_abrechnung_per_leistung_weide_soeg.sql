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
WITH alle_weide_soeg AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        weide_soeg.t_basket AS beurteilung_t_basket,
        weide_soeg.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_soeg AS weide_soeg
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        weide_soeg.vereinbarung = vereinbarung.t_id
    WHERE
        weide_soeg.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv'
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND weide_soeg.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_weide_soeg b WHERE b.mit_bewirtschafter_besprochen IS TRUE AND b.vereinbarung = weide_soeg.vereinbarung)
),
united_weide_soeg_leistungen AS (
    -- union aller leistungen
    SELECT -- Weide SöG: Einstiegskriterien
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Weide SöG: Einstiegskriterien' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        100 AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstiegskriterium_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_weide_soeg
    WHERE
        flaeche > 0 AND einstiegskriterium_abgeltung_ha > 0

    UNION

    SELECT -- Weide SöG: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Weide SöG: Faunabonus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        50 AS betrag_per_einheit,
        einstufungbeurteilungistzustand_anzahl_fauna AS anzahl_einheiten,
        einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal AS betrag_total,
        kantonsintern
    FROM
        alle_weide_soeg
    WHERE
        einstufungbeurteilungistzustand_anzahl_fauna > 0

    UNION

    SELECT -- Weide SöG: Einstufung / Beurteilung Ist-Zustand
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Weide SöG: Einstufung / Beurteilung Ist-Zustand (' || einstufungbeurteilungistzustand_weidenkategorie ||
            CASE WHEN einstufungbeurteilungistzustand_struktur_optimal_beibehalten THEN ' + Struktur optimal beibehalten' END ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        einstufungbeurteilungistzustand_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstufungbeurteilungistzustand_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_weide_soeg
    WHERE
        flaeche > 0 AND einstufungbeurteilungistzustand_abgeltung_ha > 0

    UNION

    SELECT -- Weide SöG: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Weide SöG: Erschwernis (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN erschwernis_massnahme1 THEN 'Massnahme 1: '||erschwernis_massnahme1_text END,
                CASE WHEN erschwernis_massnahme2 THEN 'Massnahme 2: '||erschwernis_massnahme2_text END,
                CASE WHEN erschwernis_massnahme3 THEN 'Massnahme 2: '||erschwernis_massnahme3_text END
            )) ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_weide_soeg
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0

    UNION

    SELECT -- Weide SöG: Artenförderung
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Weide SöG: Artenförderung (' ||
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
        alle_weide_soeg
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
    ${AUSZAHLUNGSJAHR}::integer AS auszahlungsjahr,
    -- Ursprungsstatus mit Ausnahme der kantonsinternen Vereinbarungen
    CASE
        WHEN kantonsintern THEN 'intern_verrechnet'
        ELSE 'freigegeben'
    END AS status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_weide_soeg_leistungen
;