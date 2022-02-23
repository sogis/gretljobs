-- BFS-Nr-Zuordnung zu Nutzungsplanungsdaten

-- Grundnutzung
UPDATE
   arp_npl_pub.nutzungsplanung_grundnutzung gr
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_Centroid(gr.geometrie),gg.geometrie);
