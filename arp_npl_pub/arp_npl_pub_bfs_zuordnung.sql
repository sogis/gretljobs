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

-- Beschriftung
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_nutzungsplanung_beschriftung be
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(be.pos,gg.geometrie);
    
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

-- überlagernde Objekte
-- Flächenobjekt
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_ueberlagernd_flaeche uefl
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_Centroid(uefl.geometrie),gg.geometrie);
    
-- Linienobjekt
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_ueberlagernd_linie uelin
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_LineInterpolatePoint(uelin.geometrie,0.5),gg.geometrie);
    
-- Punktobjekt
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_ueberlagernd_punkt uepkt
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(uepkt.geometrie,gg.geometrie);

-- VS Perimeter Beschriftung
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_vs_perimeter_beschriftung vsbe
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(vsbe.pos,gg.geometrie);

-- VS Perimeter Verfahrensstand
UPDATE
    ${dbSchemaNPL}.nutzungsplanung_vs_perimeter_verfahrensstand vsver
     SET bfs_nr = gg.bfs_gemeindenummer
  FROM ${dbSchemaHoheitsgr}.hoheitsgrenzen_gemeindegrenze gg
    WHERE ST_Within(ST_Centroid(vsver.geometrie),gg.geometrie);
