SELECT
    geodb_oid AS t_id,
    fallnr,
    betriebsart,
    bezugsperson_id,
    bezugsperson,
    tierartcode,
    tierart,
    reviernr,
    anzahl,
    datum,
    zeit,
    tieralter,
    tieralter_txt,
    geschlecht,
    todesgrund,
    kulturodernutztierart,
    totalschadenauszahlung,
    schutzart,
    beobachtungsfall,
    alt_abgangid,
    ST_Force_2D(geom) AS geometrie
FROM
    awjf_efj2.efj2
WHERE
    archive = 0
;