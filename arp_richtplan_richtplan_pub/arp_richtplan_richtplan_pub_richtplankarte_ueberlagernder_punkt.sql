WITH

dokumente AS (
    SELECT
        p.ueberlagernder_punkt,
        string_agg(d.dateipfad, ', ') AS dokumente
    FROM
        arp_richtplan_v2.richtplankarte_dokument AS d
    JOIN
        arp_richtplan_v2.richtplankarte_ueberlagernder_punkt_dokument AS p ON d.t_id = p.dokument
    GROUP BY 
        p.ueberlagernder_punkt
),

ueberlagernder_punkt AS (
    SELECT
        p.t_id,
        p.objekttyp,
        p.spezifikation,
        p.geometrie,
        g.gemeindename,
        p.objektname,
        p.abstimmungskategorie,
        p.bedeutung,
        'rechtsgueltig' AS planungsstand,
        NULL AS dokumente,
        p.astatus,
        p.anpassung AS richtplananpassung
    FROM
        arp_richtplan_v2.richtplankarte_ueberlagernder_punkt AS p
    JOIN
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS g ON ST_Contains(g.geometrie, p.geometrie)
)

SELECT
    p.objekttyp,
    p.spezifikation,
    p.geometrie,
    p.gemeindename,
    p.objektname,
    p.abstimmungskategorie,
    p.bedeutung,
    p.planungsstand,
    d.dokumente,
    p.astatus,
    p.richtplananpassung,
    a.rrb_nr,
    a.rrb_datum,
    a.rrb_url,
    a.bemerkung AS anpassung_bemerkung,
    a.bundesblatt_nr,
    a.bundesblatt_url,
    a.bundesblatt_datum,
    'Richtplan' AS datenquelle
FROM
    ueberlagernder_punkt AS p  
LEFT JOIN
    arp_richtplan_v2.richtplankarte_anpassung AS a ON p.richtplananpassung = a.t_id
LEFT JOIN 
    dokumente AS d ON p.t_id = d.ueberlagernder_punkt