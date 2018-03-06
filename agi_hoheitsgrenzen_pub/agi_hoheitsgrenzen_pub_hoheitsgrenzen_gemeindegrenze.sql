--Gemeindegrenze

WITH 
    overlaps_to_gaps AS (
        SELECT 
            ROW_NUMBER() OVER() AS id,
            gem_bfs, 
            COALESCE(
                ST_Difference(geometrie, 
                    (
                        SELECT 
                            ST_Union(b.geometrie)
                        FROM 
                            av_avdpool_ng.gemeindegrenzen_gemeindegrenze b
                        WHERE 
                          ST_Intersects(a.geometrie, b.geometrie)
                          AND 
                          a.gem_bfs != b.gem_bfs
                    )
                ),
                a.geometrie
            ) AS geom
        FROM 
            av_avdpool_ng.gemeindegrenzen_gemeindegrenze a
    ),

    gemeinde_multipolygon_gaps AS (
        SELECT 
            geom, 
            ROW_NUMBER() OVER() AS id
        FROM ( 
            SELECT
                ST_Union(geom) AS geom
            FROM 
                overlaps_to_gaps) AS query
    ),


    kantonsgeometrie AS (
        SELECT
            ST_Union(geom) AS geom, 
            ROW_NUMBER() OVER() AS id
        FROM (
    	   SELECT 
    	       ST_MakePolygon(
    	       ST_ExteriorRing(subquery.geom)) AS geom,
    	       1 AS id
    	   FROM ( 
    	       SELECT 
    	           (ST_Dump(ST_Union(geometrie))).geom, 
    	           1 AS id
    	       FROM av_avdpool_ng.gemeindegrenzen_gemeindegrenze) AS subquery
    	GROUP BY
    	  id,
    	  subquery.geom) AS query
    ),

    gaps AS (
        SELECT 
            *,
            ROW_NUMBER() OVER() AS id 
        FROM (
            SELECT DISTINCT
                (ST_Dump(differenz.st_difference)).geom, 
                ST_AsText((st_dump(differenz.st_difference)).geom)
            FROM 
                kantonsgeometrie, (
                    SELECT DISTINCT 
                        ST_Difference(kantonsgeometrie.geom, gemeinde_multipolygon_gaps.geom), 
                        ST_AsText(ST_Difference(kantonsgeometrie.geom, gemeinde_multipolygon_gaps.geom))
                    FROM 
                        kantonsgeometrie, 
                        gemeinde_multipolygon_gaps
                ) differenz
            ) AS query
    ) ,

    flaechenmass_gemeinden AS (
        SELECT 
            gem_bfs, 
            geom, 
            ST_Area(geom)
        FROM
            overlaps_to_gaps
    ),

    area AS (
        SELECT DISTINCT 
            ST_Intersects(gaps.geom, flaechenmass_gemeinden.geom), 
            gem_bfs, 
            st_area, 
            gaps.geom, 
            gaps.id
        FROM 
            flaechenmass_gemeinden, 
            gaps
        WHERE
            ST_Intersects(gaps.geom, flaechenmass_gemeinden.geom)=True
    ),

    zugehoerigkeit AS (
        SELECT DISTINCT
            CASE
                WHEN area_a.st_area > area_b.st_area 
                    THEN area_a.gem_bfs
                WHEN area_a.st_area < area_b.st_area 
                    THEN area_b.gem_bfs
                WHEN area_a.st_area = area_b.st_area 
                    THEN area_a.gem_bfs
            END AS groesser,
            area_a.geom
        FROM
            area area_a, 
            area area_b
        WHERE 
            area_a.id = area_b.id 
            AND 
            area_a.gem_bfs <> area_b.gem_bfs
    ),

    gaps_multipolygon AS (
        SELECT DISTINCT
            ST_Collect(geom) AS geometrie, 
            groesser AS gem_bfs
        FROM 
            zugehoerigkeit
        GROUP BY
            groesser
    ),

    corrected_polygons AS (
        SELECT
            overlaps_to_gaps.gem_bfs,
            ST_Union(gaps_multipolygon.geometrie, overlaps_to_gaps.geom) as geom
        FROM 
            gaps_multipolygon, 
            overlaps_to_gaps
        WHERE 
            gaps_multipolygon.gem_bfs = overlaps_to_gaps.gem_bfs
    )


SELECT 
    name as gemeindename, 
      geometry.gem_bfs as bfs_gemeindenummer, 
      bezirksname,
      kantonsname,
      geom as geometrie
FROM 
    (SELECT  
        gem_bfs, 
        ST_Multi(ST_Union(geom)) as geom
    FROM 
        overlaps_to_gaps
    WHERE 
        gem_bfs NOT IN (
            SELECT 
                gem_bfs 
            FROM
                corrected_polygons)
    GROUP BY
        gem_bfs
        
    UNION
    
    SELECT 
        gem_bfs as gemeindename,
        ST_Multi(ST_Union(geom)) as geometrie
    FROM 
        corrected_polygons
    GROUP BY
    gem_bfs) geometry
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemeinde
        ON gemeindegrenzen_gemeinde.gem_bfs=geometry.gem_bfs
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_gemeinde
        ON hoheitsgrenzen_gemeinde.bfs_gemeindenummer=geometry.gem_bfs
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_bezirk
        ON hoheitsgrenzen_bezirk.t_id=hoheitsgrenzen_gemeinde.bezirk
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.t_id=hoheitsgrenzen_bezirk.kanton
;