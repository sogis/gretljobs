SELECT
    NULL AS objektnummer,
    'Historischer_Verkehrsweg' AS objekttyp,
    ST_Multi(i.ivs_geometrie) AS geometrie,
    NULL AS objektname,
    'Ausgangslage' AS abstimmungskategorie,
    NULL AS bedeutung,
    'rechtsgueltig' AS planungsstand,
    NULL AS dokumente,
    'bestehend' AS astatus,
    NULL AS richtplananpassung,
    NULL AS rrb_nr,
    NULL AS rrb_datum,
    NULL AS rrb_url,
    NULL AS anpassung_bemerkung,
    NULL AS bundesblatt_nr,
    NULL AS bundesblatt_url,
    NULL AS bundesblatt_datum,
    'inventar_historischer_verkehrsweg' AS datenquelle
FROM
    arp_inventar_historische_verkehrswege_v1.ivs_inventarkarte_ivs_linienobjekte_lv95 AS i
JOIN
    agi_hoheitsgrenzen_pub.kantonsgrenze AS k
ON
    ST_Intersects(i.ivs_geometrie, k.geometrie)
;