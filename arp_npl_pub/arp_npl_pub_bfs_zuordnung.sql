-- BFS-Nr-Zuordnung zu Nutzungsplanungsdaten

-- Grundnutzung
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_grundnutzung gr
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_Centroid(gr.geometrie),gg.geometrie);
