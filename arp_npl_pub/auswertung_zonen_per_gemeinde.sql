DELETE FROM arp_auswertung_nutzungsplanung_pub_v1.auswrtngtzngsznen_grundnutzungszone_aggregiert_pro_gemeinde;
INSERT INTO arp_auswertung_nutzungsplanung_pub_v1.auswrtngtzngsznen_grundnutzungszone_aggregiert_pro_gemeinde
WITH distinct_zones AS (
  SELECT
     DISTINCT typ_kt
     FROM arp_npl_pub.nutzungsplanung_grundnutzung
     ORDER BY typ_kt ASC
),
distinct_bfs AS (
  SELECT
     DISTINCT bfs_nr
     FROM arp_npl_pub.nutzungsplanung_grundnutzung
     ORDER BY bfs_nr ASC
),
zonenflaechen AS (
  SELECT uuid_generate_v4() AS t_ili_tid,
       gem.gemeindename AS gemeindename,
       bfs.bfs_nr,
       zones.typ_kt,
       round(SUM(ST_Area(grunutz.geometrie)::numeric),0) AS flaeche_zone_aggregiert,
       ST_Union(grunutz.geometrie) AS geometrie
    FROM distinct_bfs bfs
    CROSS JOIN distinct_zones zones
    LEFT JOIN arp_npl_pub.nutzungsplanung_grundnutzung grunutz
      ON grunutz.bfs_nr = bfs.bfs_nr AND grunutz.typ_kt = zones.typ_kt
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gem
      ON bfs.bfs_nr = gem.bfs_gemeindenummer
    GROUP BY bfs.bfs_nr, zones.typ_kt, gem.gemeindename
    ORDER BY bfs_nr ASC, typ_kt ASC
),
zfl_mit_gebaeudedaten AS (
  SELECT zfl.t_ili_tid,
       zfl.gemeindename,
       zfl.bfs_nr,
       zfl.typ_kt,
       zfl.flaeche_zone_aggregiert,
       count(bobe.t_id) AS anzahl_gebaeude,
       round(avg(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_durchschnitt,
       round(sum(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_summe,
       round(min(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_minimum,
       round(max(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_maximum
    FROM zonenflaechen zfl
    LEFT JOIN agi_mopublic_pub.mopublic_bodenbedeckung bobe
      ON bobe.art_txt = 'Gebaeude' AND ST_Intersects(zfl.geometrie,bobe.geometrie)
    GROUP BY zfl.t_ili_tid, zfl.bfs_nr, zfl.typ_kt, zfl.gemeindename, zfl.flaeche_zone_aggregiert
    ORDER BY bfs_nr ASC, typ_kt ASC
)

SELECT * FROM zfl_mit_gebaeudedaten WHERE flaeche_zone_aggregiert IS NOT NULL
;
