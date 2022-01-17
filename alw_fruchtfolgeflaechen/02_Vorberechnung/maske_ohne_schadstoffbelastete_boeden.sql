DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden
;

WITH schadstoffbelastete_boeden AS (
    SELECT st_union(geometrie) AS geometrie 
    FROM (
             (
                 SELECT 
                     geometrie 
                 FROM  
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_schrebergarten
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_rebbau
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_gaertnerei
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlmast
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlbruecke
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlkonstruktion
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_flugplatz
             )
             UNION ALL 
             (
                 SELECT 
                     geometrie 
                 FROM 
                     afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_bodenbelastungsgebiet
                 WHERE 
                     belastungsstufe NOT IN ('Richtwert_bis_Pruefwert')
             )
        ) standorte
)

SELECT 
    st_difference(ohne_afhv.geometrie,schadstoffbelastete_boeden.geometrie,0.001) AS geometrie
INTO 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate ohne_afhv,
    schadstoffbelastete_boeden
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden
WHERE 
    ST_geometrytype(geometrie) NOT IN ('ST_Polygon','ST_MultiPolygon')
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_schadstoffbelastete_boeden_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden
USING GIST(geometrie)
;


