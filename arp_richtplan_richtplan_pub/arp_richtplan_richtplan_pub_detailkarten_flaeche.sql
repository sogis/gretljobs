WITH
    detailkarten_flaeche AS (
        SELECT
            f.objektname,
            f.richtplantext,
            f.abstimmungskategorie,
            f.geometrie,
            string_agg(g.gemeindename, ', ') AS gemeindenamen,
            f.anpassung AS richtplananpassung,
            'Richtplan' AS datenquelle,
            f.astatus,
            f.richtplantext_url
        FROM
            arp_richtplan_v2.detailkarten_flaeche AS f           
        JOIN
            agi_hoheitsgrenzen_pub.gemeindegrenze AS g ON ST_Intersects(f.geometrie, g.geometrie)
        GROUP BY 
            f.objektname,
            f.richtplantext,
            f.abstimmungskategorie,
            f.geometrie,
            f.anpassung,
            f.astatus,
            f.richtplantext_url
)

SELECT
    f.objektname,
    f.richtplantext,
    f.abstimmungskategorie,
    f.geometrie,
    f.gemeindenamen,
    f.richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    f.datenquelle,
    f.astatus,
    f.richtplantext_url
FROM
    detailkarten_flaeche AS f  
LEFT JOIN
    arp_richtplan_v2.detailkarten_anpassung AS a ON f.richtplananpassung = a.t_id
