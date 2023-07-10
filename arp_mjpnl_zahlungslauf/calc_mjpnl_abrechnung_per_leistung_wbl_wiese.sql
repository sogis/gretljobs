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
        AND vereinbarung.status_vereinbarung = 'aktiv'
),
united_wbl_wiese_leistungen AS (
    -- union aller leistungen
    SELECT -- WBL Wiese: Einstiegskriterien
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Einstiegskriterien' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        200 AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstiegskriterium_abgeltung_ha) AS betrag_total
    FROM
        alle_wbl_weide
    WHERE
        flaeche > 0 AND einstiegskriterium_abgeltung_ha > 0

    UNION

    -- Diese müssen aufgesplittet werden, da der eine pauschal und der andere per Ha
    SELECT -- WBL Wiese: Einstufung / Beurteilung Ist-Zustand
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Einstufung / Beurteilung Ist-Zustand' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        einstufungbeurteilungistzustand_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * einstufungbeurteilungistzustand_abgeltung_ha) AS betrag_total
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND einstufungbeurteilungistzustand_abgeltung_ha > 0

    UNION

    -- Entweder das oder alle auskommentierten unten... Nicht sicher, inwieweit auftgeteilt werden soll...
    SELECT -- WBL Wiese: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Erschwernis Massnahme 1: '||erschwernis_massnahme1_text||' / Massnahme 2: '||erschwernis_massnahme2_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0

    '''
    UNION

    SELECT -- WBL Wiese: Erschwernis Massnahme 1
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Erschwernis Massnahme 1: '||erschwernis_massnahme1_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_massnahme1_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_massnahme1_abgeltung_ha) AS betrag_total
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND erschwernis_massnahme1

    UNION
    
    SELECT -- WBL Wiese: Erschwernis Massnahme 2
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Erschwernis Massnahme 2: '||erschwernis_massnahme2_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_massnahme2_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_massnahme2_abgeltung_ha) AS betrag_total
    FROM
        alle_wbl_wiese
    WHERE
        flaeche > 0 AND erschwernis_massnahme2
    '''

    UNION

    -- Entweder das oder einzelne Auflistung pro Art und Massnahme
    SELECT -- WBL Wiese: Artenförderung
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Artenförderung Massnahme 1 ('||artenfoerderung_ff_zielart1||') '||artenfoerderung_ff_zielart1_massnahme||' / Massnahme 2 ('||artenfoerderung_ff_zielart2||') '||artenfoerderung_ff_zielart2_massnahme||' / Massnahme 3 ('||artenfoerderung_ff_zielart3||') '||artenfoerderung_ff_zielart3_massnahme AS leistung_beschrieb,
        artenfoerderung_abgeltungsart AS abgeltungsart,
        artenfoerderung_abgeltung_total AS betrag_per_einheit,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN 1 ELSE flaeche END AS anzahl_einheiten,
        CASE WHEN artenfoerderung_abgeltungsart = 'pauschal' THEN artenfoerderung_abgeltung_total ELSE (flaeche * artenfoerderung_abgeltung_total) END AS betrag_total
    FROM
        alle_wbl_wiese
    WHERE
        artenfoerderung_abgeltung_total > 0

    UNION

    -- Entweder das oder einzelne Auflistung pro Art
    SELECT -- WBL Wiese: Strukturelemente
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'WBL Wiese: Strukturelemente' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_abgeltung_total AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_abgeltung_total AS betrag_total
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
    (SELECT date_part('year', now())::integer) AS auszahlungsjahr,
    -- Ursprungsstatus
    'freigegeben' AS  status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_wbl_wiese_leistungen
;
