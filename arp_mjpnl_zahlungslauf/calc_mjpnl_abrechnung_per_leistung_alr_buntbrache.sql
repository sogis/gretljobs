
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
WITH alle_alr_buntbrachen AS (
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
),
united_alr_buntbrachen_leistungen AS (
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
        alle_alr_buntbrachen
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
        (anzahl_einheiten * betrag_per_einheit) AS betrag_total
    FROM
        alle_alr_buntbrachen
    WHERE
        flaeche > 0

    -- UNION
    -- SELECT -- ALR Buntbrache: Strauchgruppen
    -- UNION
    -- SELECT -- ALR Buntbrache: Asthaufen, Totholz
    -- UNION
    -- SELECT -- ALR Buntbrache: Steinhaufen
    -- UNION
    -- SELECT -- ALR Buntbrache: Schnittguthaufen
    -- UNION
    -- SELECT -- ALR Buntbrache: Erdhaufen
    Strukturelemente
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
    'initialisiert' AS  status_abrechnung,
    -- noch nicht existent, wird bei der Kalkulation von mjpnl_abrechnung_per_vereinbarung erstellt und ersetzt
    9999999 AS abrechnungpervereinbarung
FROM
    united_alr_buntbrachen_leistungen
;
