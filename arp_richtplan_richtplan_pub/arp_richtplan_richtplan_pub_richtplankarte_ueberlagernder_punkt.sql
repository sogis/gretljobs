WITH
    ueberlagernder_punkt AS (
        SELECT
            p.objekttyp,
            p.spezifikation,
            p.geometrie,
            g.gemeindename,
            p.objektname,
            p.abstimmungskategorie,
            p.bedeutung,
            'rechtsgueltig' AS planungsstand,
            NULL AS dokumente,
            p.astatus,
            p.anpassung AS richtplananpassung
        FROM
            arp_richtplan_v2.richtplankarte_ueberlagernder_punkt AS p
        JOIN
            agi_hoheitsgrenzen_pub.gemeindegrenze AS g ON ST_Contains(g.geometrie, p.geometrie)
)

SELECT
    p.objekttyp,
    p.spezifikation,
    p.geometrie,
    p.gemeindename,
    p.objektname,
    p.abstimmungskategorie,
    p.bedeutung,
    p.planungsstand,
    p.dokumente,
    p.astatus,
    p.richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'Richtplan' AS datenquelle
FROM
    ueberlagernder_punkt AS p  
LEFT JOIN
    arp_richtplan_v2.richtplankarte_anpassung AS a ON p.richtplananpassung = a.t_id