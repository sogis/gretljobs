WITH

dokumente AS (
    SELECT
        f.ueberlagernde_flaeche,
        string_agg(d.dateipfad, ', ') AS dokumente
    FROM
        arp_richtplan_v2.richtplankarte_dokument AS d
    JOIN
        arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche_dokument AS f ON d.t_id = f.dokument
    GROUP BY 
        f.ueberlagernde_flaeche
)

SELECT
    f.t_id,
    f.objektnummer,
    f.objekttyp,
    f.weitere_informationen,
    f.geometrie,
    string_agg(g.gemeindename, ', ') AS gemeindenamen,
    f.objektname,
    f.abstimmungskategorie,
    f.bedeutung,
    'rechtsgueltig' AS planungsstand,
    d.dokumente,
    f.astatus,
    a.jahr AS richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'richtplan' AS datenquelle
FROM
    arp_richtplan_v2.richtplankarte_ueberlagernde_flaeche AS f           
JOIN
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g ON ST_Intersects(f.geometrie, g.geometrie)
LEFT JOIN
    arp_richtplan_v2.richtplankarte_anpassung AS a ON f.anpassung = a.t_id
LEFT JOIN
    dokumente AS d ON f.t_id = d.ueberlagernde_flaeche
GROUP BY
    f.t_id,
    f.objektnummer,
    f.objekttyp,
    f.weitere_informationen,
    f.geometrie,
    f.objektname,
    f.abstimmungskategorie,
    f.bedeutung,
    d.dokumente,
    f.astatus,
    a.jahr,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum