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
        'Hecke: Einstufung / Beurteilung Ist-Zustand' AS leistung_beschrieb,
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
        'Hecke: Bewirtschaftung Krautsaum' AS leistung_beschrieb,
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
    
    -- Entweder das oder alle auskommentierten unten... Nicht sicher, inwieweit auftgeteilt werden soll...
    SELECT -- Hecke: Erschwernis
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Erschwernis Massnahme 1: '||erschwernis_massnahme1_text||' / Massnahme 2: '||erschwernis_massnahme2_text||' / Massnahme 3: '||erschwernis_massnahme3_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND erschwernis_abgeltung_ha > 0

    UNION
    '''
    SELECT -- Hecke: Erschwernis Massnahme 1
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Erschwernis Massnahme 1: '||erschwernis_massnahme1_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_massnahme1_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_massnahme1_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND erschwernis_massnahme1

    UNION
    
    SELECT -- Hecke: Erschwernis Massnahme 2
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Erschwernis Massnahme 2: '||erschwernis_massnahme2_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_massnahme2_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_massnahme2_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND erschwernis_massnahme2

    UNION
    
    SELECT -- Hecke: Erschwernis Massnahme 3
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hecke: Erschwernis Massnahme 3 '||erschwernis_massnahme3_text AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        erschwernis_massnahme3_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * erschwernis_massnahme3_abgeltung_ha) AS betrag_total
    FROM
        alle_hecke
    WHERE
        flaeche > 0 AND erschwernis_massnahme13
    '''
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
    united_hecke_leistungen
;
