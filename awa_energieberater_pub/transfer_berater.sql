
WITH aw_agg AS (
  SELECT
    aw.energieberater_berater_aus_weiterbildung AS berater_id,
    STRING_AGG(aw.aus_weiterbildung, CHR(10) ORDER BY aw.t_seq NULLS LAST, aw.t_id) AS aus_weiterbildung
  FROM awa_energieberater_v1.energieberater_berater_aus_weiterbildung aw
  GROUP BY aw.energieberater_berater_aus_weiterbildung
),
tg_agg AS (
  SELECT
    tg.energieberater_berater_themengebiete AS berater_id,
    STRING_AGG(d.dispname, CHR(10) ORDER BY tg.t_seq NULLS LAST, tg.t_id) AS themengebiete
  FROM awa_energieberater_v1.energieberater_berater_themengebiete tg
  LEFT JOIN awa_energieberater_v1.energieberater_themengebiete d
         ON d.ilicode = tg.themengebiete
  GROUP BY tg.energieberater_berater_themengebiete
)
SELECT
    b.aname || ' ' || b.vorname AS aname,
    b.firmenname AS firma_name,
    b.strassenname || ' ' || b.hausnummer || CHR(10) ||
    b.plz || ' ' || b.ortschaft AS adresse,
    b.telefonnummer AS telefonnummer,
    b.email AS email,
    b.web AS web,
    r.aname AS region,
    aw_agg.aus_weiterbildung,
    tg_agg.themengebiete,
    b.foto,
    b.standort
FROM awa_energieberater_v1.energieberater_berater AS b
INNER JOIN awa_energieberater_v1.energieberater_region AS r
        ON b.region_r = r.t_id
LEFT JOIN aw_agg
        ON aw_agg.berater_id = b.t_id
LEFT JOIN tg_agg
        ON tg_agg.berater_id = b.t_id
ORDER BY aname
;
