WITH bfs_nr_umliegende_gemeinden AS (
    SELECT 
        DISTINCT bfs_nr 
    FROM 
        agi_mopublic_pub.mopublic_gemeindegrenze
    WHERE 
        ST_Touches(geometrie, (SELECT st_union(geometrie) FROM agi_mopublic_pub.mopublic_gemeindegrenze WHERE bfs_nr = ${bfsnr}))
        OR 
        bfs_nr = ${bfsnr}        
),
humusiert AS (

    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE 
        art_txt IN ('Acker_Wiese', 'Weide', 'Reben', 'Obstkultur', 'uebrige_Intensivkultur')
        AND 
        bfs_nr = ${bfsnr}
), 

bestockt AS (
    SELECT
        ST_union(ST_buffer(geometrie,6)) AS geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE 
        art_txt IN ('geschlossener_Wald', 'Parkanlage_bestockt', 'Hecke', 'uebrige_bestockte') 
        AND 
--        bfs_nr = ${bfsnr}
        bfs_nr IN (SELECT bfs_nr FROM bfs_nr_umliegende_gemeinden)
),

gebaeude AS (
    SELECT 
        ST_union(ST_buffer(geometrie,3)) AS geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE 
        art_txt IN ('Gebaeude') 
        AND 
--        bfs_nr = ${bfsnr}
        bfs_nr IN (SELECT bfs_nr FROM bfs_nr_umliegende_gemeinden)
), 

gewaesser AS (
    SELECT 
        ST_union(ST_buffer(geometrie,6)) AS geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE 
        art_txt IN ('fliessendes Gewaesser') 
        AND 
--        bfs_nr = ${bfsnr}
        bfs_nr IN (SELECT bfs_nr FROM bfs_nr_umliegende_gemeinden)
), 

strassen AS (
    SELECT 
        ST_union(ST_buffer(geometrie,1)) AS geometrie
    FROM 
        agi_mopublic_pub.mopublic_bodenbedeckung
    WHERE 
        art_txt IN ('Strasse_Weg','Bahn','Trottoir','Verkehrsinsel','Flugplatz') 
        AND 
--        bfs_nr = ${bfsnr}
        bfs_nr IN (SELECT bfs_nr FROM bfs_nr_umliegende_gemeinden)
), 

nicht_bestockt AS (

    SELECT DISTINCT 
        CASE 
            WHEN bestockt.geometrie IS NOT NULL 
            THEN ST_difference(humusiert.geometrie,bestockt.geometrie) 
            ELSE humusiert.geometrie 
        END AS geometrie
    FROM 
        humusiert, 
        bestockt
 ), 
 
 nicht_gebaeude AS (

    SELECT DISTINCT 
        CASE 
            WHEN gebaeude.geometrie IS NOT NULL 
            THEN ST_difference(nicht_bestockt.geometrie,gebaeude.geometrie) 
            ELSE nicht_bestockt.geometrie 
        END AS geometrie
    FROM 
        nicht_bestockt, 
        gebaeude 
 ), 
 
 nicht_gewaesser AS (

    SELECT DISTINCT 
        CASE 
            WHEN gewaesser.geometrie IS NOT NULL 
            THEN ST_difference(nicht_gebaeude.geometrie,gewaesser.geometrie) 
            ELSE nicht_gebaeude.geometrie 
        END AS geometrie
    FROM  
        nicht_gebaeude, 
        gewaesser 
  ),  
 
  nicht_strassen AS (

    SELECT DISTINCT 
        CASE 
            WHEN strassen.geometrie IS NOT NULL
            THEN ST_difference(nicht_gewaesser.geometrie,strassen.geometrie) 
            ELSE nicht_gewaesser.geometrie 
        END AS geometrie
    FROM 
        nicht_gewaesser,
        strassen
 )
 
INSERT INTO alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung (geometrie)
    (
     SELECT 
         (ST_dump(nicht_strassen.geometrie)).geom AS geometrie 
     FROM 
         nicht_strassen
    )
;
