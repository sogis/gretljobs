SELECT
    l.objektname,
    l.objekttyp,
    l.abstimmungskategorie,
    l.geometrie,
    l.anpassung AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'richtplan' AS datenquelle,
    l.richtplantext,
    l.richtplantext_url,
    l.astatus
FROM
    arp_richtplan_v2.detailkarten_linie AS l
LEFT JOIN
    arp_richtplan_v2.detailkarten_anpassung AS a ON l.anpassung = a.t_id