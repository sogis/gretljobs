SELECT
    l.objektnummer,
    l.objekttyp,
    l.geometrie,
    l.objektname,
    l.abstimmungskategorie,
    l.bedeutung,
    'rechtsgueltig' AS planungsstand,
    NULL AS dokumente,
    l.astatus,
    l.anpassung AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'Richtplan' AS datenquelle
FROM
    arp_richtplan_v2.richtplankarte_ueberlagernde_linie AS l 
LEFT JOIN
    arp_richtplan_v2.richtplankarte_anpassung AS a ON l.anpassung = a.t_id