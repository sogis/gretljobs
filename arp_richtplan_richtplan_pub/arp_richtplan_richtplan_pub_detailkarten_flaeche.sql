SELECT
    f.objektname,
    f.objekttyp,
    f.abstimmungskategorie,
    f.geometrie,
    f.richtplantext,
    string_agg(g.gemeindename, ', ') AS gemeindenamen,
    f.anpassung AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'richtplan' AS datenquelle,
    f.astatus,
    f.richtplantext_url
FROM
    arp_richtplan_v2.detailkarten_flaeche AS f           
JOIN
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g ON ST_Intersects(f.geometrie, g.geometrie)
LEFT JOIN
    arp_richtplan_v2.detailkarten_anpassung AS a ON f.anpassung = a.t_id
GROUP BY 
    f.objektname,
    f.objekttyp,
    f.abstimmungskategorie,
    f.richtplantext,
    f.geometrie,
    f.anpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    f.astatus,
    f.richtplantext_url