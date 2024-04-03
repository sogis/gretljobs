SELECT
    l.objektname,
    l.objekttyp,
    l.geometrie,
    l.anpassung AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    'richtplan' AS datenquelle
FROM
    arp_richtplan_v2.raumkonzept_linie AS l
LEFT JOIN
    arp_richtplan_v2.raumkonzept_anpassung AS a ON l.anpassung = a.t_id