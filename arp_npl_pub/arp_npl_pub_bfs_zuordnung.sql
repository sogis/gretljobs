-- BFS-Nr-Zuordnung zu Nutzungsplanungsdaten
-- Bei Flächen werden Zentroide gerechnet, bei Linien die mittlere Punkt der Linie
-- damit wird sichergestellt, dass eine eindeutige Gemeindezuordnung erfolgt bei
-- Objekten die die Gemeindegrenze berühren

-- Grundnutzung
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_grundnutzung gr
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_Centroid(gr.geometrie),gg.geometrie);

-- Erschliessungsplanung
-- Beschriftung
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_erschliessung_beschriftung be
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(be.pos,gg.geometrie);

-- Flächenobjekt
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_erschliessung_flaechenobjekt efl
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_Centroid(efl.geometrie),gg.geometrie);

-- Linienobjekt
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_erschliessung_linienobjekt elin
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_LineInterpolatePoint(elin.geometrie,0.5),gg.geometrie);

-- Punktobjekt
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_erschliessung_punktobjekt epkt
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(epkt.geometrie,gg.geometrie);
