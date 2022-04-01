-- zuerst Tabelle leeren
DELETE FROM
  ${DB_Schema_AuswNPL}.bauzonenstatistik_liegenschaft_nach_bebauungsstand
 WHERE bfs_nr = ${gem_bfs}
;
-- wieder befüllen
INSERT INTO
  ${DB_Schema_AuswNPL}.bauzonenstatistik_liegenschaft_nach_bebauungsstand
   (egris_egrid, nummer, bfs_nr, gemeindename, grundnutzung_typ_kt, bebauungsstand, flaeche, flaeche_beschnitten, flaeche_unbebaut, geometrieart_liegenschaft, geometrie)

WITH
bfsnr AS (
    SELECT
        ${gem_bfs} AS nr
),
-- Nutzungszonen
nutzzon AS (
  SELECT
    geometrie,
    typ_kt,
    bfs_nr
  FROM ${DB_Schema_NPL}.nutzungsplanung_grundnutzung
    WHERE
      bfs_nr = (SELECT nr FROM bfsnr)
      AND typ_code_kommunal < 2000
      AND typ_kt NOT IN ('N160_Gruen_und_Freihaltezone_innerhalb_Bauzone','N161_kommunale_Uferschutzzone_innerhalb_Bauzone','N169_weitere_eingeschraenkte_Bauzonen','N180_Verkehrszone_Strasse','N181_Verkehrszone_Bahnareal','N182_Verkehrszone_Flugplatzareal','N189_weitere_Verkehrszonen')
      AND typ_bezeichnung NOT LIKE '%Golf%'
),
-- unbebaute Flächen Methode mit Liegenschaftsgrenzen
unbeb_fl AS (
  SELECT
    geometrie
  FROM
    ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen
   WHERE
    bfs_nr = (SELECT nr FROM bfsnr) AND bebauungsstand = 'unbebaut'
),
-- Liegenschaften
gr_tmp AS (
  SELECT
   gru.t_id,
   gru.egrid AS egris_egrid,
   gru.nummer,
   gru.bfs_nr,
   gem.gemeindename,
   nutzzon.typ_kt AS grundnutzung_typ_kt,
   gru.flaechenmass AS flaeche,
   -- Liegenschaftsgeometrie wird auf Nutzungszone innerhalb Siedlungsgebiet beschnitten. Cast in Multi-Polygon.
   ST_Multi(ST_CollectionExtract(ST_Intersection(gru.geometrie,ST_Union(nutzzon.geometrie,0.001),0.001),3)) AS geometrie,
   -- Auszählung wie viele Übersteuerungspunkte innerhalb der Liegenschaft sind
   COUNT(ueberst_bebaut.bebaut) AS ct_uebersteuert_bebaut,
   COUNT(ueberst_unbebaut.bebaut) AS ct_uebersteuert_unbebaut
  FROM ${DB_Schema_AV}.mopublic_grundstueck gru
   -- Nutzungszonen innerhalb Siedlungsgebiet an Liegenschaftsfläche anhängen
   LEFT JOIN nutzzon ON ST_Intersects(gru.geometrie, nutzzon.geometrie)
   -- Gemeinden anhängen via BFS-Nr
   LEFT JOIN ${DB_Schema_Hoheitsgr}.hoheitsgrenzen_gemeindegrenze gem ON gru.bfs_nr = gem.bfs_gemeindenummer
   -- Punktlayer für Übersteuerung des Bebauungsstandes bebaut anhängen
   LEFT JOIN ${DB_Schema_AuswNPL}.bauzonenstatistik_uebersteuerung_bebauungsstand ueberst_bebaut
      ON ST_Intersects(ueberst_bebaut.geometrie,gru.geometrie) AND ueberst_bebaut.bebaut IS True
   -- Punktlayer für Übersteuerung des Bebauungsstandes unbebaut anhängen
   LEFT JOIN ${DB_Schema_AuswNPL}.bauzonenstatistik_uebersteuerung_bebauungsstand ueberst_unbebaut
      ON ST_Intersects(ueberst_unbebaut.geometrie,gru.geometrie) AND ueberst_unbebaut.bebaut IS False
  WHERE
     gru.bfs_nr = (SELECT nr FROM bfsnr)
     AND gru.art_txt = 'Liegenschaft'
     AND nutzzon.typ_kt IS NOT NULL
    GROUP BY gru.t_id, gru.egrid, gru.nummer, gru.bfs_nr, gru.flaechenmass, gru.geometrie, gem.gemeindename, nutzzon.typ_kt
),
-- bebaute Flächen Input
bebaut_fl AS (
  -- Gebäude aus Bodenbedeckung
  SELECT geometrie, bfs_nr FROM ${DB_Schema_AV}.mopublic_bodenbedeckung
    WHERE bfs_nr = (SELECT nr FROM bfsnr) AND art_txt = 'Gebaeude' AND ST_Area(geometrie) >= 25
  UNION ALL
  -- projektierte Gebäude aus Bodenbedeckung
  SELECT geometrie, bfs_nr FROM ${DB_Schema_AV}.mopublic_bodenbedeckung_proj
    WHERE bfs_nr = (SELECT nr FROM bfsnr) AND art_txt = 'Gebaeude' AND ST_Area(geometrie) >= 25
  UNION ALL
  -- Einzelobjekte Flächen
  SELECT geometrie, bfs_nr FROM ${DB_Schema_AV}.mopublic_einzelobjekt_flaeche
    WHERE bfs_nr = (SELECT nr FROM bfsnr) AND art_txt IN ('Unterstand','unterirdisches_Gebaeude','uebriger_Gebaeudeteil','Reservoir','Aussichtsturm','Bahnsteig') AND ST_Area(geometrie) >= 25
),
-- Verknüpfung mit unbebauten Flächen aus Methode unter Berücksichtigung Liegenschaften und Nutzungszonen
gr_tmp2 AS (
  SELECT
    gr.*,
    -- unbebaute Flächen innerhalb der Liegenschaft aufsummieren
    Round(SUM(COALESCE(ST_Area(ST_Intersection(gr.geometrie,unbeb_fl.geometrie,0.001)),0)))::NUMERIC AS flaeche_unbebaut,
    CASE
      WHEN flaeche - Round(ST_Area(gr.geometrie)) > 1 THEN 'beschnitten'
      ELSE 'original'
    END AS geometrieart_liegenschaft,
    Round(ST_Area(gr.geometrie)) AS flaeche_beschnitten
   FROM gr_tmp gr
     -- unbebaute Flächen anhängen
     LEFT JOIN unbeb_fl ON ST_Intersects(gr.geometrie, unbeb_fl.geometrie)
    GROUP BY gr.t_id, gr.egris_egrid, gr.nummer, gr.bfs_nr, gr.grundnutzung_typ_kt, gr.flaeche, gr.geometrie, gr.gemeindename, gr.ct_uebersteuert_bebaut, gr.ct_uebersteuert_unbebaut
),
-- Liegenschaften mit bebauten Flächen (Gebäude und Einzelobjekte, inkl. projektiert) verknüpfen
gr AS (
  SELECT
    gr.*,
    -- bebaute Flächen innerhalb der Liegenschaft aufsummieren
    Round(SUM(COALESCE(ST_Area(ST_Intersection(gr.geometrie,bebaut_fl.geometrie,0.001)),0)))::NUMERIC AS flaeche_bebaut
  FROM gr_tmp2 gr
    -- bebaute Flächen anhängen
    LEFT JOIN bebaut_fl ON ST_Intersects(gr.geometrie, bebaut_fl.geometrie)
   GROUP BY gr.t_id, gr.egris_egrid, gr.nummer, gr.bfs_nr, gr.grundnutzung_typ_kt, gr.flaeche, gr.geometrie, gr.gemeindename, gr.ct_uebersteuert_bebaut, gr.ct_uebersteuert_unbebaut,
     flaeche_unbebaut, geometrieart_liegenschaft, flaeche_beschnitten
)
SELECT
   gr.egris_egrid,
   gr.nummer,
   gr.bfs_nr,
   gr.gemeindename,
   gr.grundnutzung_typ_kt,
   CASE
     WHEN gr.flaeche_unbebaut = 0 THEN 'bebaut'
     -- Filter Übersteuerung durch Punktlayer
     WHEN gr.ct_uebersteuert_bebaut > 0 THEN 'bebaut'
     WHEN gr.ct_uebersteuert_unbebaut > 0 THEN 'unbebaut'
     ELSE
       CASE
         WHEN gr.flaeche_bebaut < 25 AND gr.flaeche_unbebaut >= 180 THEN 'unbebaut'
         ELSE
           CASE
             WHEN gr.flaeche_bebaut >= 25 AND gr.flaeche_unbebaut >= 180 THEN 'teilweise_bebaut'
             ELSE 'bebaut'
           END
       END
   END AS bebauungsstand,
   gr.flaeche,
   gr.flaeche_beschnitten,
   gr.flaeche_unbebaut,
   gr.geometrieart_liegenschaft,
   gr.geometrie
 FROM gr
   -- um Artefakte wegzufiltern
   -- ev Wert anpassen
   WHERE gr.flaeche_beschnitten > 0
;
