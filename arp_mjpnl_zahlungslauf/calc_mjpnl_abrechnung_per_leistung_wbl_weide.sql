INSERT INTO ${DB_Schema_MJPNL}.mjpnl_abrechnung_per_leistung (
    t_basket,
    vereinbarung,
    leistung_beschrieb,
    abgeltungsart,
    betrag_per_einheit,
    anzahl_einheiten,
    betrag_total,
    auszahlungsjahr,
    status_abrechnung
)
WITH alle_wbl_weide AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        wbl_weide.t_basket AS beurteilung_t_basket,
        wbl_weide.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_weide AS wbl_weide
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        wbl_weide.vereinbarung = vereinbarung.t_id
    WHERE
        wbl_weide.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv' AND vereinbarung.bewe_id_geprueft IS TRUE
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND wbl_weide.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_weide b WHERE b.mit_bewirtschafter_besprochen IS TRUE AND b.vereinbarung = wbl_weide.vereinbarung)
),
united_wbl_weide_leistungen AS (
    -- union aller leistungen
    SELECT -- Abgeltung generisch 
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Weide: Abgeltung generisch' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        abgeltung_generisch_betrag AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        abgeltung_generisch_betrag AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        abgeltung_generisch_betrag > 0

    UNION

    SELECT -- WBL Weide: Einstiegskriterien
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Weide: Einstiegskriterien' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        100 AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstiegskriterium_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        flaeche > 0 AND einstiegskriterium_abgeltung_ha > 0

    UNION

    SELECT -- WBL Weide: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Weide: Faunabonus' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        50 AS betrag_per_einheit,
        einstufungbeurteilungistzustand_anzahl_fauna AS anzahl_einheiten,
        einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        einstufungbeurteilungistzustand_anzahl_fauna > 0

    UNION

    SELECT -- WBL Weide: Einstufung / Beurteilung Ist-Zustand
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Weide: Einstufung / Beurteilung Ist-Zustand (' || einstufungbeurteilungistzustand_weidenkategorie ||
            CASE WHEN einstufungbeurteilungistzustand_struktur_optimal_beibehalten THEN ' + Struktur optimal beibehalten' ELSE '' END ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        einstufungbeurteilungistzustand_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstufungbeurteilungistzustand_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        flaeche > 0 AND einstufungbeurteilungistzustand_abgeltung_ha > 0

    UNION

    SELECT -- WBL Weide: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        left(('WBL Weide: Erschwernis (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN erschwernis_massnahme1 THEN 'Massnahme 1: '||COALESCE(left(erschwernis_massnahme1_text,60),'') END,
                CASE WHEN erschwernis_massnahme2 THEN 'Massnahme 2: '||COALESCE(left(erschwernis_massnahme2_text,60),'') END
            )) ||
        ')'),255)
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0

    UNION

    SELECT -- WBL Weide: Artenförderung
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        left(('WBL Weide: Artenförderung (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN artenfoerderung_ff_zielart1 IS NOT NULL THEN 'Massnahme für '||artenfoerderung_ff_zielart1||': '||COALESCE(left(artenfoerderung_ff_zielart1_massnahme,40),'') END,
                CASE WHEN artenfoerderung_ff_zielart2 IS NOT NULL THEN 'Massnahme für '||artenfoerderung_ff_zielart2||': '||COALESCE(left(artenfoerderung_ff_zielart2_massnahme,40),'') END,
                CASE WHEN artenfoerderung_ff_zielart3 IS NOT NULL THEN 'Massnahme für '||artenfoerderung_ff_zielart3||': '||COALESCE(left(artenfoerderung_ff_zielart3_massnahme,40),'') END
            )) ||
        ')'),255)
        AS leistung_beschrieb,
        artenfoerderung_abgeltungsart AS abgeltungsart,
        artenfoerderung_abgeltung_total AS betrag_per_einheit,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN 1 ELSE flaeche END AS anzahl_einheiten,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN artenfoerderung_abgeltung_total ELSE (flaeche * artenfoerderung_abgeltung_total) END AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        artenfoerderung_abgeltung_total > 0

    UNION

    SELECT -- WBL Weide: Strukturelemente
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Weide: Strukturelemente (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN strukturelemente_gewaesser THEN 'Temporäre Gewässer' END,
                CASE WHEN strukturelemente_hochstaudenflurenriederoehrichte THEN 'Hochstaudenfluren/Riede/Röhrichte' END,
                CASE WHEN strukturelemente_streuehaufen THEN 'Streuehaufen' END,
                CASE WHEN strukturelemente_asthaufentotholz THEN 'Asthaufen/Totholz' END,
                CASE WHEN strukturelemente_steinhaufen THEN 'Steinhaufen' END,
                CASE WHEN strukturelemente_gebueschgruppen THEN 'Gebüschgruppen' END,
                CASE WHEN strukturelemente_kopfweiden THEN 'Kopfweiden' END
            )) ||
        ')'
        AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_abgeltung_total AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_abgeltung_total AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_weide
    WHERE
        strukturelemente_abgeltung_total > 0
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
    END AS status_abrechnung
FROM
    united_wbl_weide_leistungen
;
