DELETE FROM arp_npl_pub.auswertung_grundnutzungszonen_pro_gemeinde;
INSERT INTO arp_npl_pub.auswertung_grundnutzungszonen_pro_gemeinde
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
endresult AS (
  SELECT uuid_generate_v4() AS t_ili_tid,
       gem.gemeindename AS gemeindename,
       bfs.bfs_nr, zones.typ_kt,
       round(SUM(ST_Area(grunutz.geometrie)::numeric),0) AS flaeche_zone_aggregiert,
       count(bobe.t_id) AS anzahl_gebaeude,
       round(avg(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_durchschnitt,
       round(sum(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_summe,
       round(min(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_minimum,
       round(max(ST_Area(bobe.geometrie))) AS flaeche_gebaeude_maximum
    FROM distinct_bfs bfs
    CROSS JOIN distinct_zones zones
    LEFT JOIN arp_npl_pub.nutzungsplanung_grundnutzung grunutz
      ON grunutz.bfs_nr = bfs.bfs_nr AND grunutz.typ_kt = zones.typ_kt
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gem
      ON bfs.bfs_nr = gem.bfs_gemeindenummer
    LEFT JOIN agi_mopublic_pub.mopublic_bodenbedeckung bobe
      ON bobe.art_txt = 'Gebaeude' AND ST_Intersects(grunutz.geometrie,bobe.geometrie)
    GROUP BY bfs.bfs_nr, zones.typ_kt, gem.gemeindename
    ORDER BY bfs_nr ASC, typ_kt ASC
)
SELECT * FROM endresult WHERE flaeche_zone_aggregiert IS NOT NULL
;
