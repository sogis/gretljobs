SELECT
    NULL AS objektnummer,
    'Historischer_Verkehrsweg' AS objekttyp,
    ST_Multi(lo.ivs_geometrie) AS geometrie,
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
    'inventar_historische_verkehrswege' AS datenquelle
FROM
    arp_inventar_historische_verkehrswege_v1.ivs_inventarkarte_ivs_linienobjekte_lv95 AS lo
LEFT JOIN
    arp_inventar_historische_verkehrswege_v1.ivs_inventarkarte_ivs_signatur_linie AS sl ON lo.role_ivs_signatur_linie = sl.t_id
WHERE sl.ivs_deutsch IN ('Regionale Bedeutung, historischer Verlauf mit Substanz', 'Regionale Bedeutung, historischer Verlauf mit viel Substanz')

