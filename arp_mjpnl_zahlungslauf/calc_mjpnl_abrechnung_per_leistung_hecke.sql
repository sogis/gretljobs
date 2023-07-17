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
WITH alle_hecke AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        hecke.t_basket AS beurteilung_t_basket,
        hecke.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_hecke AS hecke
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        hecke.vereinbarung = vereinbarung.t_id
    WHERE
        hecke.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv'
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND hecke.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hecke b WHERE b.vereinbarung = hecke.vereinbarung)
),
united_hecke_leistungen AS (
    -- union aller leistungen
    SELECT -- Hecke: Einstiegskriterien
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Einstiegskriterien' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        200 AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstiegskriterium_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND einstiegskriterium_abgeltung_ha > 0

    UNION

    SELECT -- Hecke: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Faunabonus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        100 AS betrag_per_einheit,
        faunabonus_anzahl_arten AS anzahl_einheiten,
        faunabonus_artenvielfalt_abgeltung_pauschal AS betrag_total
    FROM
        alle_hecke
    WHERE
        faunabonus_anzahl_arten > 0

    UNION

    SELECT -- Hecke: Einstufung / Beurteilung Ist-Zustand
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Einstufung / Beurteilung Ist-Zustand (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN einstufungbeurteilungistzustand_artenvielfalt_strauch_bmrten THEN '10 Strauch-/Baumarten' END,
                CASE WHEN einstufungbeurteilungistzustand_asthaufen THEN 'Asthaufen' END,
                CASE WHEN einstufungbeurteilungistzustand_totholz THEN 'Totholz' END,
                CASE WHEN einstufungbeurteilungistzustand_steinhaufen THEN 'Steinhaufen' END,
                CASE WHEN einstufungbeurteilungistzustand_schichtholzbeigen THEN 'Schichtholzbeigen' END,
                CASE WHEN einstufungbeurteilungistzustand_nisthilfe_wildbienen THEN 'Nisthilfe Wildbienen' END,
                CASE WHEN einstufungbeurteilungistzustand_hoehlenbaeume_biotpbm_ttholz THEN 'Höhlen-/Biotopbäume' END,
                CASE WHEN einstufungbeurteilungistzustand_sitzwarte THEN 'Sitzwarte' END
            )) ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        einstufungbeurteilungistzustand_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstufungbeurteilungistzustand_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND einstufungbeurteilungistzustand_abgeltung_ha > 0

    UNION

    SELECT -- Hecke: Bewirtschaftung Krautsaum
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Bewirtschaftung Krautsaum (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN bewirtschaftung_krautsaum THEN 'Krautsaum' END,
                CASE WHEN bewirtschaftung_krautsaum_schnittzeitpunkte THEN 'Schnittzeitpunkte' END,
                CASE WHEN bewirtschaftung_krautsaum_offener_boden THEN 'Offener Boden' END
            )) ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        bewirtschaftung_krautsaum_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * bewirtschaftung_krautsaum_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND bewirtschaftung_krautsaum_abgeltung_ha > 0

    UNION

    SELECT -- Hecke: Bewirtschaftung Lebhag
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Bewirtschaftung Lebhag pro Laufmeter' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        1.50 AS betrag_per_einheit,
        bewirtschaftung_lebhag_laufmeter AS anzahl_einheiten,
        bewirtschaftung_lebhag_abgeltung_pauschal AS betrag_total
    FROM
        alle_hecke
    WHERE
        bewirtschaftung_lebhag_laufmeter > 0 AND bewirtschaftung_lebhag_abgeltung_pauschal > 0

    UNION
    
    SELECT -- Hecke: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Erschwernis (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN erschwernis_massnahme1 THEN 'Massnahme 1: '||erschwernis_massnahme1_text END,
                CASE WHEN erschwernis_massnahme2 THEN 'Massnahme 2: '||erschwernis_massnahme2_text END,
                CASE WHEN erschwernis_massnahme3 THEN 'Massnahme 3: '||erschwernis_massnahme3_text END
            )) ||
        ')'
        AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0
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
    date_part('year', now())::integer auszahlungsjahr,
    -- Ursprungsstatus mit Ausnahme der kantonsinternen Vereinbarungen
    CASE
        WHEN kantonsintern THEN 'intern_verrechnet'
        ELSE 'freigegeben'
    END AS status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_hecke_leistungen
;
