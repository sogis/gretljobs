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
WITH alle_wbl_wiese AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        wbl_wiese.t_basket AS beurteilung_t_basket,
        wbl_wiese.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_wiese AS wbl_wiese
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        wbl_wiese.vereinbarung = vereinbarung.t_id
    WHERE
        wbl_wiese.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv' AND vereinbarung.bewe_id_geprueft IS TRUE AND vereinbarung.ist_nutzungsvereinbarung IS NOT TRUE
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND wbl_wiese.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_wbl_wiese b WHERE b.mit_bewirtschafter_besprochen IS TRUE AND b.vereinbarung = wbl_wiese.vereinbarung)
),
united_wbl_wiese_leistungen AS (
    -- union aller leistungen
    SELECT -- Abgeltung generisch 
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Abgeltung generisch' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        abgeltung_generisch_betrag AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        abgeltung_generisch_betrag AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        abgeltung_generisch_betrag > 0

    UNION

    SELECT -- WBL Wiese: Einstiegskriterien
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Einstiegskriterien' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        200 AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstiegskriterium_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND einstiegskriterium_abgeltung_ha > 0

    UNION

    SELECT -- WBL Wiese: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Faunabonus' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        50 AS betrag_per_einheit,
        einstufungbeurteilungistzustand_anzahl_fauna AS anzahl_einheiten,
        einstufungbeurteilungistzustand_abgeltung_faunaliste_paschal AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        einstufungbeurteilungistzustand_anzahl_fauna > 0

    UNION

    SELECT -- WBL Wiese: Einstufung / Beurteilung Ist-Zustand
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        regexp_replace(
            left(('WBL Weide: Einstufung / Beurteilung Ist-Zustand (' || einstufungbeurteilungistzustand_wiesenkategorie || ')'),255),
            E'[\n\r]+', ' ', 'g' 
        )
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND einstufungbeurteilungistzustand_wiesenkategorie_abgeltung_ha > 0

    UNION

    SELECT -- WBL Wiese: Bewirtschaftungsabmachungen (Messerbalken-Mähgerät)
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Bewirtschaftungsabmachungen (Messerbalken-Mähgerät)' AS leistung_beschrieb,
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

    SELECT -- WBL Wiese: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        regexp_replace(
            left(('WBL Wiese: Erschwernis (' ||
                (SELECT CONCAT_WS(', ',
                    CASE WHEN erschwernis_massnahme1 THEN 'Massnahme 1: '||COALESCE(left(erschwernis_massnahme1_text,60),'') END,
                    CASE WHEN erschwernis_massnahme2 THEN 'Massnahme 2: '||COALESCE(left(erschwernis_massnahme2_text,60),'') END
                )) ||
            ')'),255),
            E'[\n\r]+', ' ', 'g' 
        )
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0

    UNION

    SELECT -- WBL Wiese: Artenförderung
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        regexp_replace(
            left(('WBL Wiese: Artenförderung (' ||
                (SELECT CONCAT_WS(', ',
                    CASE WHEN artenfoerderung_ff_zielart1 IS NOT NULL THEN 'Massnahme für '||artenfoerderung_ff_zielart1||': '||COALESCE(left(artenfoerderung_ff_zielart1_massnahme,40),'') END,
                    CASE WHEN artenfoerderung_ff_zielart2 IS NOT NULL THEN 'Massnahme für '||artenfoerderung_ff_zielart2||': '||COALESCE(left(artenfoerderung_ff_zielart2_massnahme,40),'') END,
                    CASE WHEN artenfoerderung_ff_zielart3 IS NOT NULL THEN 'Massnahme für '||artenfoerderung_ff_zielart3||': '||COALESCE(left(artenfoerderung_ff_zielart3_massnahme,40),'') END
                )) ||
            ')'),255),
            E'[\n\r]+', ' ', 'g' 
        )
        AS leistung_beschrieb,
        artenfoerderung_abgeltungsart AS abgeltungsart,
        artenfoerderung_abgeltung_total AS betrag_per_einheit,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN 1 ELSE flaeche END AS anzahl_einheiten,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN artenfoerderung_abgeltung_total ELSE (flaeche * artenfoerderung_abgeltung_total) END AS betrag_total,
        kantonsintern
    FROM
        alle_wbl_wiese
    WHERE
        artenfoerderung_abgeltung_total > 0

    UNION

    SELECT -- WBL Wiese: Strukturelemente
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Strukturelemente (' ||
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
        alle_wbl_wiese
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
    united_wbl_wiese_leistungen
;
