WITH
    overlaps_to_gaps AS (
        SELECT
            t_datasetname::int AS bfsnr,
            COALESCE(
                ST_Difference(geometrie,
                    (
                        SELECT 
                            ST_Union(gemeindegrenzen_1.geometrie)
                        FROM 
                            agi_dm01avso24.gemeindegrenzen_gemeindegrenze AS gemeindegrenzen_1
                        WHERE 
                            ST_Intersects(gemeindegrenzen_2.geometrie, gemeindegrenzen_1.geometrie)
                            AND 
                            gemeindegrenzen_2.t_datasetname != gemeindegrenzen_1.t_datasetname
                    )
                ),
                gemeindegrenzen_2.geometrie
            ) AS geometrie
        FROM 
            agi_dm01avso24.gemeindegrenzen_gemeindegrenze AS gemeindegrenzen_2
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
                            agi_dm01avso24.gemeindegrenzen_gemeindegrenze
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
            bfsnr,
            geometrie,
            ST_Area(geometrie) AS flaechemass
        FROM
            overlaps_to_gaps
    ),

    area AS (
        SELECT DISTINCT
            ST_Intersects(gaps.geometrie, flaechenmass_gemeinden.geometrie),
            bfsnr,
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
                    THEN area_a.bfsnr
                WHEN area_a.flaechemass < area_b.flaechemass
                    THEN area_b.bfsnr
                WHEN area_a.flaechemass = area_b.flaechemass
                    THEN area_a.bfsnr
            END AS groesser,
            area_a.geometrie
        FROM
            area AS area_a,
            area AS area_b
        WHERE 
            area_a.id = area_b.id
            AND 
            area_a.bfsnr <> area_b.bfsnr
    ),

    gaps_multipolygon AS (
        SELECT DISTINCT
            ST_Collect(geometrie) AS geometrie,
            groesser AS bfsnr
        FROM 
            zugehoerigkeit
        GROUP BY
            groesser
    ),

    corrected_polygons AS (
        SELECT
            overlaps_to_gaps.bfsnr,
            ST_Union(gaps_multipolygon.geometrie, overlaps_to_gaps.geometrie) as geometrie
        FROM 
            gaps_multipolygon,
            overlaps_to_gaps
        WHERE 
            gaps_multipolygon.bfsnr = overlaps_to_gaps.bfsnr
    )

SELECT
    gemeindegrenzen_gemeinde.aname AS gemeindename,
    geometry.bfsnr AS bfs_gemeindenummer,
    hoheitsgrenzen_bezirk.bezirksname,
    hoheitsgrenzen_kanton.kantonsname,
    geometry.geometrie
FROM
    (
        SELECT
            bfsnr,
            ST_Multi(ST_Union(geometrie)) AS geometrie
        FROM
            overlaps_to_gaps
        WHERE
            bfsnr NOT IN (
                SELECT
                    bfsnr
                FROM
                    corrected_polygons)
        GROUP BY
            bfsnr

        UNION

        SELECT
            bfsnr AS gemeindename,
            ST_Multi(ST_Union(geometrie)) AS geometrie
        FROM
            corrected_polygons
        GROUP BY
            bfsnr
    ) AS geometry
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde
        ON gemeindegrenzen_gemeinde.bfsnr = geometry.bfsnr
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_gemeinde
        ON hoheitsgrenzen_gemeinde.bfs_gemeindenummer = geometry.bfsnr
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_bezirk
        ON hoheitsgrenzen_bezirk.t_id = hoheitsgrenzen_gemeinde.bezirk
    LEFT JOIN agi_hoheitsgrenzen_v1.hoheitsgrenzen_kanton
        ON hoheitsgrenzen_kanton.t_id = hoheitsgrenzen_bezirk.kanton
;
