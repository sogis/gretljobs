SELECT
    f.objektname,
    f.objekttyp,
    f.geometrie,
    a.jahr AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    'richtplan' AS datenquelle
FROM
    arp_richtplan_v2.raumkonzept_flaeche AS f
LEFT JOIN
    arp_richtplan_v2.raumkonzept_anpassung AS a ON f.anpassung = a.t_id