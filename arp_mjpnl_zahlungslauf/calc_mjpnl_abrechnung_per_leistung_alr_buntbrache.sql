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
WITH alle_alr_buntbrache AS (
    -- alle relevanten beurteilungen 
    -- aber nur die neuste mit derselben vereinbarungsnummer
    SELECT
        *,
        alr_buntbrache.t_basket AS beurteilung_t_basket,
        alr_buntbrache.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_buntbrache AS alr_buntbrache
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        alr_buntbrache.vereinbarung = vereinbarung.t_id
    WHERE
        alr_buntbrache.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv'
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND alr_buntbrache.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_alr_buntbrache b WHERE b.vereinbarung = alr_buntbrache.vereinbarung)
),
united_alr_buntbrache_leistungen AS (
    -- union aller leistungen
    SELECT -- ALR Buntbrache: Faunabonus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Faunabonus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        100 AS betrag_per_einheit,
        faunabonus_anzahl_arten AS anzahl_einheiten,
        faunabonus_artenvielfalt_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        faunabonus_anzahl_arten > 0

    UNION

    SELECT -- ALR Buntbrache: Bewirtschaftungs- / Pflegemassnahmen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Bewirtschaftungs- / Pflegemassnahmen' AS leistung_beschrieb,
        'per_ha' AS abgeltungsart,
        bewirtschaftung_abgeltung_ha AS betrag_per_einheit,
        flaeche AS anzahl_einheiten,
        (flaeche * bewirtschaftung_abgeltung_ha) AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        flaeche > 0 AND bewirtschaftung_abgeltung_ha > 0

    UNION

    -- Entweder das oder alle auskommentierten unten... Nicht sicher, inwieweit auftgeteilt werden soll...
    SELECT -- ALR Buntbrache: Strukturelemente
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Strukturelemente' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_abgeltung_pauschal_total AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_abgeltung_pauschal_total AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        strukturelemente_abgeltung_pauschal_total > 0

    '''
    SELECT -- ALR Buntbrache: Strauchgruppen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Strukturelement Strauchgruppen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_strauchgruppen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_strauchgruppen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        strukturelemente_strauchgruppen
    
    UNION
    
    SELECT -- ALR Buntbrache: Asthaufen, Totholz
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Strukturelement Asthaufen, Totholz' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_asthaufen_totholz_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_asthaufen_totholz_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        strukturelemente_asthaufen_totholz
    
    UNION
    
    SELECT -- ALR Buntbrache: Steinhaufen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Strukturelement Steinhaufen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_steinhaufen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_steinhaufen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        strukturelemente_steinhaufen

    UNION
    
    SELECT -- ALR Buntbrache: Schnittguthaufen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Strukturelement Schnittguthaufen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_schnittguthaufen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_schnittguthaufen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_buntbrache
    WHERE
        strukturelemente_schnittguthaufen

    UNION

    SELECT -- ALR Buntbrache: Erdhaufen
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'ALR Buntbrache: Strukturelement Erdhaufen' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_erdhaufen_abgeltung_pauschal AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_erdhaufen_abgeltung_pauschal AS betrag_total
    FROM
        alle_alr_buntbrache
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
    -- Ursprungsstatus
    'freigegeben' AS  status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_alr_buntbrache_leistungen
;
