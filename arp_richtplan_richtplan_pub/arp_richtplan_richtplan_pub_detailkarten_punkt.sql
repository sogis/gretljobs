SELECT
    p.objektname,
    p.objekttyp,
    p.astatus,
    p.geometrie,
    g.gemeindename,
    a.jahr AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'richtplan' AS datenquelle,
    p.richtplantext,
    p.richtplantext_url
FROM
    arp_richtplan_v2.detailkarten_punkt AS p           
JOIN
    agi_hoheitsgrenzen_pub.gemeindegrenze AS g ON ST_Contains(g.geometrie, p.geometrie)
LEFT JOIN
    arp_richtplan_v2.detailkarten_anpassung AS a ON p.anpassung = a.t_id