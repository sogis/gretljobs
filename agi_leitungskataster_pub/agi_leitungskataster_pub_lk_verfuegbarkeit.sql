SELECT
  t_id,
  gem_bfs,
  name,
  infotext,
  geometrie
FROM
(
  SELECT
    lk.ogc_fid,
    gemeindegrenze.t_id,
    gemeindegrenze.bfs_gemeindenummer AS gem_bfs,
    gemeindegrenze.gemeindename AS name,
    ''::varchar AS infotext,
    gemeindegrenze.geometrie
  FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS gemeindegrenze
    LEFT JOIN gemgis.qgis_community_not_participating_info_t AS lk
    ON ST_Intersects(ST_PointOnSurface(gemeindegrenze.geometrie), lk.geometrie)
) AS foo
WHERE ogc_fid IS NULL
;