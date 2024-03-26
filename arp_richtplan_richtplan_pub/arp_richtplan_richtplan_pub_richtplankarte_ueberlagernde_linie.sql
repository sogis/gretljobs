WITH

dokumente AS (
    SELECT
        l.ueberlagernde_linie,
        string_agg(d.dateipfad, ', ') AS dokumente
    FROM
        arp_richtplan_v2.richtplankarte_dokument AS d
    JOIN
        arp_richtplan_v2.richtplankarte_ueberlagernde_linie_dokument AS l ON d.t_id = l.dokument
    GROUP BY 
        l.ueberlagernde_linie
)

SELECT
    l.objektnummer,
    l.objekttyp,
    l.geometrie,
    l.objektname,
    l.abstimmungskategorie,
    l.bedeutung,
    'rechtsgueltig' AS planungsstand,
    d.dokumente,
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
LEFT JOIN 
    dokumente AS d ON l.t_id = d.ueberlagernde_linie