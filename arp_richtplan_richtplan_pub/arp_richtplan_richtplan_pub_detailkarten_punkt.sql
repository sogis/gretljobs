WITH
    detailkarten_punkt AS (
        SELECT
            p.astatus,
            p.geometrie,
            g.gemeindename,
            p.anpassung AS richtplananpassung,
            'Richtplan' AS datenquelle,
            p.richtplantext,
            p.richtplantext_url
        FROM
            arp_richtplan_v2.detailkarten_punkt AS p           
        JOIN
            agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g ON ST_Contains(g.geometrie, p.geometrie)
)

SELECT
    p.astatus,
    p.geometrie,
    p.gemeindename,
    p.richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    p.datenquelle,
    p.richtplantext,
    p.richtplantext_url
FROM
    detailkarten_punkt AS p  
LEFT JOIN
    arp_richtplan_v2.detailkarten_anpassung AS a ON p.richtplananpassung = a.t_id
