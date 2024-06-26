SELECT
    p.objekttyp,
    p.geometrie,
    p.objektname,
    a.jahr AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    'richtplan' AS datenquelle
FROM
    arp_richtplan_v2.raumkonzept_punkt AS p
LEFT JOIN
    arp_richtplan_v2.raumkonzept_anpassung AS a ON p.anpassung = a.t_id