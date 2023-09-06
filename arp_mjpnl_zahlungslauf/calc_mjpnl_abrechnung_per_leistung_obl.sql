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
WITH alle_obl AS (
    -- alle relevanten beurteilungen
    SELECT
        *,
        obl.t_basket AS beurteilung_t_basket,
        obl.vereinbarung AS beurteilung_vereinbarung
    FROM 
        ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl AS obl
    JOIN
        ${DB_Schema_MJPNL}.mjpnl_vereinbarung AS vereinbarung
        ON 
        obl.vereinbarung = vereinbarung.t_id
    WHERE
        obl.mit_bewirtschafter_besprochen IS TRUE
        AND vereinbarung.status_vereinbarung = 'aktiv' AND vereinbarung.bewe_id_geprueft IS TRUE
        -- und berücksichtige nur die neusten (sofern mehrere existieren)
        AND obl.beurteilungsdatum = (SELECT MAX(beurteilungsdatum) FROM ${DB_Schema_MJPNL}.mjpnl_beurteilung_obl b WHERE b.mit_bewirtschafter_besprochen IS TRUE AND b.vereinbarung = obl.vereinbarung)
),
united_obl_leistungen AS (
    -- union aller leistungen
    SELECT -- Abgeltung generisch 
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        /* Indiviuelle Werte */
        'OBL: Abgeltung generisch' AS leistung_beschrieb,
        'pauschal' AS abgeltungsart,
        abgeltung_generisch_betrag AS betrag_per_einheit,
        1 AS anzahl_einheiten,
        abgeltung_generisch_betrag AS betrag_total,
        kantonsintern
    FROM
        alle_obl
    WHERE
        abgeltung_generisch_betrag > 0

    UNION

    SELECT -- OBL: Grundbeitrag
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'OBL: Grundbeitrag' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        grundbeitrag_baum_anzahl AS anzahl_einheiten,
        grundbeitrag_baum_total AS betrag_total,
        kantonsintern
    FROM
        alle_obl
    WHERE
        grundbeitrag_baum_anzahl > 0
        
    UNION

    SELECT -- OBL: BaumAb40cmDurchmesser
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'OBL: BaumAb40cmDurchmesser' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        15 AS betrag_per_einheit,
        beitrag_baumab40cmdurchmesser_anzahl AS anzahl_einheiten,
        beitrag_baumab40cmdurchmesser_total AS betrag_total,
        kantonsintern
    FROM
        alle_obl
    WHERE
        beitrag_baumab40cmdurchmesser_anzahl > 0

    UNION

    SELECT -- OBL: Erntepflicht
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'OBL: Erntepflicht' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        beitrag_erntepflicht_anzahl AS anzahl_einheiten,
        beitrag_erntepflicht_total AS betrag_total,
        kantonsintern
    FROM
        alle_obl
    WHERE
        beitrag_erntepflicht_anzahl > 0

    UNION

    SELECT -- OBL: Öko Plus
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'OBL: Öko Plus' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        beitrag_oekoplus_anzahl AS anzahl_einheiten,
        beitrag_oekoplus_total AS betrag_total,
        kantonsintern
    FROM
        alle_obl
    WHERE
        beitrag_oekoplus_anzahl > 0

    UNION
    
    SELECT -- OBL: Öko Maxi
        beurteilung_t_basket AS t_basket,
        beurteilung_vereinbarung AS vereinbarung,
        'OBL: Öko Maxi' AS leistung_beschrieb,
        'per_stueck' AS abgeltungsart,
        10 AS betrag_per_einheit,
        beitrag_oekomaxi_anzahl AS anzahl_einheiten,
        beitrag_oekomaxi_total AS betrag_total,
        kantonsintern
    FROM
        alle_obl
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
    united_obl_leistungen
;
