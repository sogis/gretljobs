DELETE FROM 
    arp_bauzonengrenzen_pub.bauzonengrenzen_bauzonengrenze
WHERE 
    bfsnr = ${bfsnr}
;

INSERT INTO 
    arp_bauzonengrenzen_pub.bauzonengrenzen_bauzonengrenze 
    (
        geometrie,
        bfsnr,
        zonentyp
    )

WITH bauzonen_ohne_gewaesser AS 
(
    SELECT 
        ST_Multi(ST_Union(geometrie, 0.001)) AS geometrie,
        bfs_nr AS bfsnr,
        'Bauzone' AS zonentyp
    FROM 
        arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
    WHERE 
        bfs_nr = ${bfsnr}
        AND 
        (
            substring(typ_kt from 2 for 2)::int < 20  
        )
    GROUP BY
        bfs_nr
    
    UNION ALL
    
    SELECT 
        ST_Multi(ST_Union(geometrie, 0.001)) AS geometrie,
        bfs_nr AS bfsnr,
        'Reservezone' AS zonentyp
    FROM 
        arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
    WHERE 
        bfs_nr = ${bfsnr}
        AND 
        (
            substring(typ_kt from 2 for 2)::int = 43
        )
    GROUP BY
        bfs_nr
)
,
gewaesser_gewaesserraum AS 
(
    SELECT
        (ST_Dump(ST_Union(geometrie))).geom AS geometrie,
        bfs_nr
    FROM 
        arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung AS g
    WHERE 
        bfs_nr = ${bfsnr}
    AND 
    (
         substring(typ_kt from 2 for 3)::int = 320 
         OR 
         substring(typ_kt from 2 for 3)::int = 329
    )
    GROUP BY 
        bfs_nr 
)
,
gewaesser_intersection AS 
(
    SELECT 
        --t_id,
        bauzonen_ohne_gewaesser.bfsnr,
        bauzonen_ohne_gewaesser.zonentyp,
        --ST_Intersects(bauzonen_ohne_gewaesser.geometrie, g.geometrie), 
        ST_Length(ST_CollectionExtract(ST_Intersection(bauzonen_ohne_gewaesser.geometrie, g.geometrie),2)) / ST_Perimeter(g.geometrie) AS ratio, 
        ST_Perimeter(g.geometrie),
        g.geometrie
    FROM 
        gewaesser_gewaesserraum AS g
        LEFT JOIN bauzonen_ohne_gewaesser
        ON ST_Intersects(bauzonen_ohne_gewaesser.geometrie, g.geometrie) 
    WHERE 
        bfs_nr = ${bfsnr}
        /*
        AND 
        (
            substring(typ_kt from 2 for 3)::int = 320  
        )
        */
        AND 
            ST_Intersection(bauzonen_ohne_gewaesser.geometrie, g.geometrie) IS NOT NULL
)
--SELECT 
--*
--FROM 
--gewaesser_intersection
,
gewaesser_filter AS 
(
    SELECT
        geometrie,
        bfsnr,
        zonentyp
    FROM 
        gewaesser_intersection
    WHERE 
        ratio > 0.8
)
,
bauzone_mit_gewaesser AS 
(
    SELECT 
        geometrie,
        bfsnr,
        zonentyp
    FROM 
        bauzonen_ohne_gewaesser
    
    UNION ALL 
    
    SELECT 
        geometrie,
        bfsnr,
        zonentyp
    FROM 
        gewaesser_filter
)
SELECT 
    ST_Multi(ST_Union(geometrie)) AS geometrie,
    bfsnr,
    zonentyp
FROM 
    bauzone_mit_gewaesser
GROUP BY
    zonentyp, bfsnr
;

-- SELECT 
--     ST_Multi(ST_Union(geometrie, 0.001)),
--     bfs_nr AS bfsnr,
--     'Bauzone' AS zonentyp
-- FROM 
--     arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
-- WHERE 
--     bfs_nr = ${bfsnr}
--     AND 
--     (
--         substring(typ_kt from 2 for 2)::int < 20  
--     )
-- GROUP BY
--     bfs_nr

-- UNION ALL

-- SELECT 
--     ST_Multi(ST_Union(geometrie, 0.001)),
--     bfs_nr AS bfsnr,
--     'Reservezone' AS zonentyp
-- FROM 
--     arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
-- WHERE 
--     bfs_nr = ${bfsnr}
--     AND 
--     (
--         substring(typ_kt from 2 for 2)::int = 43
--     )
-- GROUP BY
--     bfs_nr
-- ;
