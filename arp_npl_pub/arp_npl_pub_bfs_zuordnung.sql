-- BFS-Nr-Zuordnung zu Nutzungsplanungsdaten

-- Grundnutzung
UPDATE
   arp_npl_pub.nutzungsplanung_grundnutzung
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM arp_npl_pub.nutzungsplanung_grundnutzung gn
    LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gg
      ON ST_Within(ST_Centroid(gn.geometrie),gg.geometrie);
