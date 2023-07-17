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
        'ALR Saum: Strukturelemente (' ||
            (SELECT CONCAT_WS(', ',
                CASE WHEN strukturelemente_strauchgruppen THEN 'Strauchgruppen' END,
                CASE WHEN strukturelemente_asthaufen_totholz THEN 'Asthaufen/Totholz' END,
                CASE WHEN strukturelemente_steinhaufen THEN 'Steinhaufen' END,
                CASE WHEN strukturelemente_schnittguthaufen THEN 'Schnittguthaufen' END
            )) ||
        ')'
        AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        strukturelemente_abgeltung_pauschal_total AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        strukturelemente_abgeltung_pauschal_total AS betrag_total
    FROM
        alle_alr_saum
    WHERE
        strukturelemente_abgeltung_pauschal_total > 0

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
    united_alr_saum_leistungen
;
