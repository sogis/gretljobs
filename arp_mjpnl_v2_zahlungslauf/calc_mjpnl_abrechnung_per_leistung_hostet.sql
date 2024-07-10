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
WITH alle_hostet AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        hostet.t_basket AS beurteilung_t_basket,
        hostet.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_hostet AS hostet
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        hostet.vereinbarung = vereinbarung.t_id
    WHERE
        hostet.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv' AND vereinbarung.bewe_id_geprueft IS TRUE AND vereinbarung.ist_nutzungsvereinbarung IS NOT TRUE
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND hostet.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_hostet b WHERE b.mit_bewirtschafter_besprochen IS TRUE AND b.vereinbarung = hostet.vereinbarung)
),
united_hostet_leistungen AS (
    -- union aller leistungen
    SELECT -- Abgeltung generisch 
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'Hostet: Abgeltung generisch' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        abgeltung_generisch_betrag AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        abgeltung_generisch_betrag AS betrag_total,
        kantonsintern
    FROM
        alle_hostet
    WHERE
        abgeltung_generisch_betrag > 0

    UNION

    SELECT -- Hostet: Grundbeitrag
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'Hostet: Grundbeitrag' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        5 AS betrag_per_einheit,
        grundbeitrag_baum_anzahl AS anzahl_einheiten,
        grundbeitrag_baum_total AS betrag_total,
        kantonsintern
    FROM
        alle_hostet
    WHERE
        grundbeitrag_baum_anzahl > 0

    UNION

    SELECT -- Hostet: BaumAb40cmDurchmesser
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'Hostet: BaumAb40cmDurchmesser' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        15 AS betrag_per_einheit,
        beitrag_baumab40cmdurchmesser_anzahl AS anzahl_einheiten,
        beitrag_baumab40cmdurchmesser_total AS betrag_total,
        kantonsintern
    FROM
        alle_hostet
    WHERE
        beitrag_baumab40cmdurchmesser_anzahl > 0

    UNION

    SELECT -- Hostet: Erntepflicht
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'Hostet: Erntepflicht' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        beitrag_erntepflicht_anzahl AS anzahl_einheiten,
        beitrag_erntepflicht_total AS betrag_total,
        kantonsintern
    FROM
        alle_hostet
    WHERE
        beitrag_erntepflicht_anzahl > 0

    UNION

    SELECT -- Hostet: Öko Plus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'Hostet: Öko Plus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        beitrag_oekoplus_anzahl AS anzahl_einheiten,
        beitrag_oekoplus_total AS betrag_total,
        kantonsintern
    FROM
        alle_hostet
    WHERE
        beitrag_oekoplus_anzahl > 0

    UNION
    
    SELECT -- Hostet: Öko Maxi
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'Hostet: Öko Maxi' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        beitrag_oekomaxi_anzahl AS anzahl_einheiten,
        beitrag_oekomaxi_total AS betrag_total,
        kantonsintern
    FROM
        alle_hostet
    WHERE
        beitrag_oekomaxi_anzahl > 0
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
    united_hostet_leistungen
;
