SELECT
    b.aname || ' ' || b.vorname AS aname,
    b.firmenname AS firma_name,
    b.strassenname || ' ' || b.hausnummer || CHR(10) ||
    b.plz || ' ' || b.ortschaft AS adresse,
    b.telefonnummer AS telefonnummer,
    b.email AS email,
    b.web AS web,
    r.aname AS region,
    STRING_AGG(aw.aus_weiterbildung, CHR(10) ORDER BY aw.t_seq) AS aus_weiterbildung,
    STRING_AGG(tg.themengebiete, CHR(10) ORDER BY tg.t_seq) AS themengebiete,
    b.foto,
    b.standort
FROM awa_energieberater_v1.energieberater_berater AS b
INNER JOIN awa_energieberater_v1.energieberater_region AS r
        ON b.region_r = r.t_id
LEFT JOIN awa_energieberater_v1.energieberater_berater_aus_weiterbildung AS aw
        ON aw.energieberater_berater_aus_weiterbildung = b.t_id
LEFT JOIN awa_energieberater_v1.energieberater_berater_themengebiete   AS tg
        ON tg.energieberater_berater_themengebiete = b.t_id
GROUP BY
    b.t_id,
    b.aname,
    b.vorname,
    b.firmenname,
    b.strassenname,
    b.hausnummer,
    b.plz,
    b.ortschaft,
    b.telefonnummer,
    b.email,
    b.web,
    r.aname,
    b.foto,
    b.standort
ORDER BY aname;
;