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
WITH alle_alr_saum AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        alr_saum.t_basket AS beurteilung_t_basket,
        alr_saum.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_saum AS alr_saum
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        alr_saum.vereinbarung = vereinbarung.t_id
    WHERE
        alr_saum.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv'
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND alr_saum.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_saum b WHERE b.vereinbarung = alr_saum.vereinbarung)
),
united_alr_saum_leistungen AS (
    -- union aller leistungen
    SELECT -- ALR Saum: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Faunabonus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        100 AS betrag_per_einheit,
        faunabonus_anzahl_arten AS anzahl_einheiten,
        faunabonus_artenvielfalt_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        faunabonus_anzahl_arten > 0

    UNION

    SELECT -- ALR Saum: Bewirtschaftungs- / Pflegemassnahmen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Bewirtschaftungs- / Pflegemassnahmen' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        bewirtschaftung_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * bewirtschaftung_abgeltung_ha) AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        flaeche > 0 AND bewirtschaftung_abgeltung_ha > 0

    UNION

    -- Entweder das oder alle auskommentierten unten... Nicht sicher, inwieweit auftgeteilt werden soll...
    SELECT -- ALR Saum: Strukturelemente
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Strukturelemente' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_abgeltung_pauschal_total AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_abgeltung_pauschal_total AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_abgeltung_pauschal_total > 0

    '''
    SELECT -- ALR Saum: Strauchgruppen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Strukturelement Strauchgruppen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_strauchgruppen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_strauchgruppen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_strauchgruppen
    
    UNION
    
    SELECT -- ALR Saum: Asthaufen, Totholz
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Strukturelement Asthaufen, Totholz' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_asthaufen_totholz_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_asthaufen_totholz_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_asthaufen_totholz
    
    UNION
    
    SELECT -- ALR Saum: Steinhaufen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Strukturelement Steinhaufen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_steinhaufen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_steinhaufen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_steinhaufen

    UNION
    
    SELECT -- ALR Saum: Schnittguthaufen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Strukturelement Schnittguthaufen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_schnittguthaufen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_schnittguthaufen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_schnittguthaufen

    UNION

    SELECT -- ALR Saum: Erdhaufen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Saum: Strukturelement Erdhaufen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_erdhaufen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_erdhaufen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_erdhaufen
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
    -- Ursprungsstatus mit Ausnahme der kantonsinternen Vereinbarungen
    CASE
        WHEN kantonsintern THEN 'intern_verrechnet'
        ELSE 'freigegeben'
    END AS status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_alr_saum_leistungen
;
