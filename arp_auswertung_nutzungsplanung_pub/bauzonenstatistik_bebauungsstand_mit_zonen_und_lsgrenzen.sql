DELETE FROM ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen
  WHERE bfs_nr = ${gem_bfs}
;
INSERT
  INTO ${DB_Schema_AuswNPL}.bauzonenstatistik_bebauungsstand_mit_zonen_und_lsgrenzen
   (grundnutzung_typ_kt,bebauungsstand,bfs_nr,gemeindename,flaeche,geometrie)
   
-- hier wird Gemeinde selektiert
WITH
bfsnr AS (
	SELECT
	  ${gem_bfs} AS nr
     --Himmelried: 2618, Büsserach: 2614, Oensingen: 2407
),
-- Gemeindegeometrie
gem AS (
  SELECT
    geometrie,
    gemeindename,
    bfs_gemeindenummer
  FROM
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
   WHERE bfs_gemeindenummer = (SELECT nr FROM bfsnr)
),
-- Gebäude inkl. projektierten Gebäuden
geb AS (
  SELECT
    --positive buffer of 12m and then negative buffer of 6m
    --special buffer parameters 
    ST_Buffer(ST_Buffer(geometrie,12,'endcap=flat join=miter'),-6,'endcap=flat join=miter') AS geometrie
  FROM
    agi_mopublic_pub.mopublic_bodenbedeckung
   WHERE
    art_txt = 'Gebaeude'
    AND bfs_nr = (SELECT nr FROM bfsnr)
    AND ST_Area(geometrie) >= 25 --kleinere Gebäude werden ignoriert (gelten als abbrechbar)
 UNION ALL
  SELECT
    --positive buffer of 12m and then negative buffer of 6m
    --special buffer parameters 
    ST_Buffer(ST_Buffer(geometrie,12,'endcap=flat join=miter'),-6,'endcap=flat join=miter') AS geometrie
  FROM
    agi_mopublic_pub.mopublic_bodenbedeckung_proj
   WHERE
    art_txt = 'Gebaeude'
    AND bfs_nr = (SELECT nr FROM bfsnr)
    AND ST_Area(geometrie) >= 25 --kleinere Gebäude werden ignoriert (gelten als abbrechbar)
),
-- Einzelbojekte
eob AS (
  SELECT
   ST_Buffer(geometrie,1,'endcap=flat join=miter') AS geometrie
  FROM agi_mopublic_pub.mopublic_einzelobjekt_flaeche
   WHERE
    bfs_nr = (SELECT nr FROM bfsnr)
    AND art_txt IN ('Unterstand','unterirdisches_Gebaeude','uebriger_Gebaeudeteil','Reservoir','Aussichtsturm','Bahnsteig')
    AND ST_Area(geometrie) >= 25
),
-- Liegenschaften
gr AS (
  SELECT
   t_id,
   geometrie,
   ST_Buffer(ST_ExteriorRing(geometrie),4,'endcap=flat join=miter') AS geom_buff,
   nummer,
   egrid
  FROM agi_mopublic_pub.mopublic_grundstueck mg 
   WHERE
    art_txt = 'Liegenschaft'
    AND bfs_nr = (SELECT nr FROM bfsnr)
),
-- Nutzungszonen
nutzzon AS (
  SELECT
    t_id,
    geometrie,
    ST_Buffer(ST_Exteriorring(geometrie),4,'endcap=flat join=miter') AS geom_buff,
    typ_kt,
    bfs_nr
  FROM arp_npl_pub.nutzungsplanung_grundnutzung
    WHERE bfs_nr = (SELECT nr FROM bfsnr)
    AND typ_code_kommunal < 2000
    AND typ_kt NOT IN ('N160_Gruen_und_Freihaltezone_innerhalb_Bauzone','N161_kommunale_Uferschutzzone_innerhalb_Bauzone','N169_weitere_eingeschraenkte_Bauzonen','N180_Verkehrszone_Strasse','N181_Verkehrszone_Bahnareal','N182_Verkehrszone_Flugplatzareal','N189_weitere_Verkehrszonen')
    AND typ_bezeichnung NOT LIKE '%Golf%'
),
-- Dissolve (GIS Union) aller Nutzungszonen in Siedlungsflächen
nutzzon_dissolved_tmp AS (
  SELECT
    ST_Union(geometrie,0.001) AS geometrie
  FROM nutzzon
),
-- clean up narrow holes (data errors)
-- first step: dump geometries and rings
nutzzon_rings_tmp AS (
  SELECT
    (ST_DumpRings((st_dump(geometrie)).geom)).geom AS geometrie
  FROM nutzzon_dissolved_tmp
),
-- second intermediate step for cleaning: calculate inscribed circle
nutzzon_rings_tmp2 AS (
  SELECT
   geometrie,
   (ST_MaximumInscribedCircle(geometrie)).radius AS radius
  FROM nutzzon_rings_tmp
),
-- third and final step for cleaning: filter away small rings and rebuild polygons
nutzzon_dissolved AS (
  SELECT
   ST_BuildArea(ST_Collect(geometrie)) AS geometrie
  FROM nutzzon_rings_tmp2
   WHERE
     radius > 0.4 -- very narrow polygons with only 80cm width are filtered away
),
-- Verkehrsflächen
verkfl AS (
  SELECT
   ST_Buffer(geometrie,4,'endcap=flat join=miter') AS geometrie
  FROM agi_mopublic_pub.mopublic_bodenbedeckung mb 
   WHERE
    bfs_nr = (SELECT nr FROM bfsnr)
    AND art_txt = 'Strasse_Weg'
),
--Merge (SQL Union) aller nicht bebaubaren Flächen and clip it (ST_Intersection) to Nutzunszonen Siedlungsgebiet
--TODO: test if intersection would be faster if done after the  ST_Union() step below
nicht_bebaubar_tmp AS (
  SELECT ST_Intersection(geb.geometrie,nd.geometrie,0.001) AS geometrie FROM geb, nutzzon_dissolved nd WHERE ST_Intersects(geb.geometrie,nd.geometrie)
  UNION ALL
  SELECT ST_Intersection(eob.geometrie,nd.geometrie,0.001) AS geometrie FROM eob, nutzzon_dissolved nd WHERE ST_Intersects(eob.geometrie,nd.geometrie)
  UNION ALL
  SELECT ST_Intersection(verkfl.geometrie,nd.geometrie,0.001) AS geometrie FROM verkfl, nutzzon_dissolved nd WHERE ST_Intersects(verkfl.geometrie,nd.geometrie)
  UNION ALL
  SELECT ST_Intersection(gr.geom_buff,nd.geometrie,0.001) AS geometrie FROM gr, nutzzon_dissolved nd WHERE ST_Intersects(gr.geometrie,nd.geometrie)
  UNION ALL
  SELECT geom_buff AS geometrie FROM nutzzon
),
-- Dissolve (GIS Union) aller nicht bebaubaren Flächen
nicht_bebaubar AS (
  SELECT ST_CollectionExtract(ST_Union(geometrie,0.001),3) AS geometrie FROM nicht_bebaubar_tmp
),
-- Calculate Difference between Nutzungszonen Siedlungsgebiet and bebaubaren Flächen, Dump them to individual polygons
bebaubar_tmp AS (
  SELECT (ST_Dump(ST_Difference(nd.geometrie,nbb.geometrie,0.001))).geom AS geometrie FROM nutzzon_dissolved nd, nicht_bebaubar nbb
),
-- filter away small parts of polygons < 180m2, negative buffer followed by positive buffer to get rid of very narrow polygon passages and spikes
double_buff AS (
  SELECT
     (ST_Dump(
      ST_Buffer(
        ST_Buffer(
          geometrie,
          -3,
          'endcap=flat join=miter mitre_limit=2.0'),
        3,
        'endcap=flat join=miter mitre_limit=2.0')
      )
    ).geom
    AS geometrie
  FROM
    bebaubar_tmp
   WHERE
     ST_Area(geometrie) >= 180
),
-- final version of unbebaute Flächen
-- filter small polygons away and calculate pole of inaccessibility with ST_MaximumInscribedCircle
unbebaut_final AS (
  SELECT
    (ST_MaximumInscribedCircle(geometrie)).radius AS radius,
    geometrie
  FROM double_buff
   WHERE
    ST_Area(geometrie) >= 180
),
-- ST_Union of unbebaut
unbebaut_dissolved AS (
  SELECT
    ST_Union(geometrie,0.001) AS geometrie
  FROM unbebaut_final
   WHERE
    radius > 5
)
,
-- final version of bebaute Flächen mit ST_Difference
bebaut_final_tmp AS (
  SELECT
    (ST_Dump(ST_Difference(nd.geometrie,unbb.geometrie,0.001))).geom AS geometrie
  FROM nutzzon_dissolved nd, unbebaut_dissolved unbb
),
-- intersection with undissolved Nutzungszonen to get polygons that honor the Nutzungszonen
bebaut_final AS (
  SELECT ST_Intersection(bft.geometrie,nz.geometrie,0.001) AS geometrie
    FROM bebaut_final_tmp bft, nutzzon nz
    WHERE ST_Intersects(nz.geometrie,bft.geometrie)
),
-- union of bebaut_final and unbebaut_dissolved
gesamt_final AS (
  SELECT 'bebaut' AS bebauungsstand, ST_Multi((ST_Dump(bb.geometrie)).geom) AS geometrie FROM bebaut_final bb
    UNION ALL
  SELECT 'unbebaut' AS bebauungsstand, ST_Multi((ST_Dump(ubb.geometrie)).geom) AS geometrie FROM unbebaut_dissolved ubb
)
-- areas (m2) can only be calculated at the very end after the ST_Dump()
-- also joining Nutzungszonen and Gemeinden
SELECT 
  nz.typ_kt AS grundnutzung_typ_kt,
  f.bebauungsstand,
  nz.bfs_nr,
  gem.gemeindename,
  Round(ST_Area(f.geometrie)) AS flaeche,
  f.geometrie
FROM gesamt_final f
  LEFT JOIN nutzzon nz ON ST_Intersects(ST_PointOnSurface(f.geometrie),nz.geometrie)
  LEFT JOIN gem ON gem.bfs_gemeindenummer = nz.bfs_nr
 WHERE
   f.geometrie IS NOT NULL
   AND ST_IsValid(f.geometrie)
   AND ST_GeometryType(f.geometrie) = 'ST_MultiPolygon'
   AND Round(ST_Area(f.geometrie)) > 0
 ORDER BY nz.bfs_nr, nz.typ_kt, f.bebauungsstand
;
