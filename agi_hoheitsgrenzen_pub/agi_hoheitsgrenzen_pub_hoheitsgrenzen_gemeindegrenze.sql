WITH
    overlaps_to_gaps AS (
        SELECT
            gem_bfs,
            COALESCE(
                ST_Difference(geometrie,
                    (
                        SELECT 
                            ST_Union(gemeindegrenzen_1.geometrie)
                        FROM 
                            av_avdpool_ng.gemeindegrenzen_gemeindegrenze AS gemeindegrenzen_1
                        WHERE 
                            ST_Intersects(gemeindegrenzen_2.geometrie, gemeindegrenzen_1.geometrie)
                            AND 
                            gemeindegrenzen_2.gem_bfs != gemeindegrenzen_1.gem_bfs
                    )
                ),
                gemeindegrenzen_2.geometrie
            ) AS geometrie
        FROM 
            av_avdpool_ng.gemeindegrenzen_gemeindegrenze AS gemeindegrenzen_2
    ),

    gemeinde_multipolygon_gaps AS (
        SELECT
            geometrie
        FROM (
            SELECT
                ST_Union(geometrie) AS geometrie
            FROM
                overlaps_to_gaps
            ) AS query
    ),

    kantonsgeometrie AS (
        SELECT
            ST_Union(geometrie) AS geometrie
        FROM
            (
                SELECT
                    ST_MakePolygon(ST_ExteriorRing(subquery.geometrie)) AS geometrie,
                    1 AS id
                FROM
                    (
                        SELECT
                            (ST_Dump(ST_Union(geometrie))).geom AS geometrie
                        FROM 
                            av_avdpool_ng.gemeindegrenzen_gemeindegrenze
                    ) AS subquery
                GROUP BY
                    id,
                    subquery.geometrie
            ) AS query
    ),

    gaps AS (
        SELECT
            geometrie,
            ROW_NUMBER() OVER() AS id
        FROM (
            SELECT DISTINCT
                (ST_Dump(differenz.differenz_geometrie)).geom AS geometrie
            FROM 
                kantonsgeometrie, (
                    SELECT DISTINCT
                        ST_Difference(kantonsgeometrie.geometrie, gemeinde_multipolygon_gaps.geometrie) AS differenz_geometrie
                    FROM 
                        kantonsgeometrie,
                        gemeinde_multipolygon_gaps
                ) AS differenz
            ) AS query
    ) ,

    flaechenmass_gemeinden AS (
        SELECT
            gem_bfs,
            geometrie,
            ST_Area(geometrie) AS flaechemass
        FROM
            overlaps_to_gaps
    ),

    area AS (
        SELECT DISTINCT
            ST_Intersects(gaps.geometrie, flaechenmass_gemeinden.geometrie),
            gem_bfs,
            flaechemass,
            gaps.geometrie,
            gaps.id
        FROM
            flaechenmass_gemeinden,
            gaps
        WHERE
            ST_Intersects(gaps.geometrie, flaechenmass_gemeinden.geometrie) = True
    ),

    zugehoerigkeit AS (
        SELECT DISTINCT
            CASE
                WHEN area_a.flaechemass > area_b.flaechemass
                    THEN area_a.gem_bfs
                WHEN area_a.flaechemass < area_b.flaechemass
                    THEN area_b.gem_bfs
                WHEN area_a.flaechemass = area_b.flaechemass
                    THEN area_a.gem_bfs
            END AS groesser,
            area_a.geometrie
        FROM
            area AS area_a,
            area AS area_b
        WHERE 
            area_a.id = area_b.id
            AND 
            area_a.gem_bfs <> area_b.gem_bfs
    ),

    gaps_multipolygon AS (
        SELECT DISTINCT
            ST_Collect(geometrie) AS geometrie,
            groesser AS gem_bfs
        FROM 
            zugehoerigkeit
        GROUP BY
            groesser
    ),

    corrected_polygons AS (
        SELECT
            overlaps_to_gaps.gem_bfs,
            ST_Union(gaps_multipolygon.geometrie, overlaps_to_gaps.geometrie) as geometrie
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
    geometrie
FROM
    (
        SELECT
            gem_bfs,
            ST_Multi(ST_Union(geometrie)) AS geometrie
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
            gem_bfs AS gemeindename,
            ST_Multi(ST_Union(geometrie)) AS geometrie
        FROM
            corrected_polygons
        GROUP BY
            gem_bfs
    ) AS geometry
    LEFT JOIN av_avdpool_ng.gemeindegrenzen_gemeinde
        ON gemeindegrenzen_gemeinde.gem_bfs = geometry.gem_bfs
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_gemeinde
        ON hoheitsgrenzen_gemeinde.bfs_gemeindenummer = geometry.gem_bfs
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_bezirk
        ON hoheitsgrenzen_bezirk.t_id = hoheitsgrenzen_gemeinde.bezirk
    LEFT JOIN agi_hoheitsgrenzen.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.t_id = hoheitsgrenzen_bezirk.kanton
;