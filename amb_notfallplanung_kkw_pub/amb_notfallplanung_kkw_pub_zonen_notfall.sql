WITH zonenzugehoerigkeit_einzeln AS (
    SELECT
        CASE 
            WHEN s1 = 1
                THEN '1'
        END AS s1,
        CASE 
            WHEN s2 = 1
                THEN '2'
        END AS s2,
        CASE 
            WHEN s3 = 1
                THEN '3'
        END AS s3,
        CASE 
            WHEN s4 = 1
                THEN '4'
        END AS s4,
        CASE 
            WHEN s5 = 1
                THEN '5'
        END AS s5,
        CASE 
            WHEN s6 = 1
                THEN '6'
        END AS s6,
        zone_1,
        gem_bfs,
        CASE 
            WHEN kkw = 'G'
                THEN 'Gösgen'
            WHEN kkw = 'M'
                THEN 'Mühleberg'
        END AS kkw
    FROM
        notfallplanung_kkw.zonen_notfall
    WHERE
        archive = 0
),
zonenzugehoerigkeit_zusammengefasst AS (
    SELECT
        CASE
            WHEN zone_1 = 1
                THEN 1
            WHEN 
                s1 IS NOT NULL
                OR
                s2 IS NOT NULL
                OR 
                s3 IS NOT NULL
                OR
                s4 IS NOT NULL
                OR
                s5 IS NOT NULL
                OR
                s6 IS NOT NULL
                    THEN 2
        END AS zonenzugehoerigkeit,
        CASE
            WHEN 
                s1 IS NOT NULL
                OR
                s2 IS NOT NULL
                OR 
                s3 IS NOT NULL
                OR
                s4 IS NOT NULL
                OR
                s5 IS NOT NULL
                OR
                s6 IS NOT NULL
                    THEN concat_ws(', ' , s1, s2, s3, s4, s5, s6)
        END AS sektoren,
        gem_bfs,
        kkw
    FROM 
        zonenzugehoerigkeit_einzeln
),
zonenzugehoerigkeit_gemeinden AS (
    SELECT
        bfs_gemeindenummer AS gem_bfs,
        gemeindename AS gmde_name,
        geometrie,
        CASE 
            WHEN zonenzugehoerigkeit IS NULL
                THEN 3
            ELSE zonenzugehoerigkeit
        END AS zonenzugehoerigkeit,
        sektoren,
        kkw
    FROM 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
        LEFT JOIN zonenzugehoerigkeit_zusammengefasst
            ON zonenzugehoerigkeit_zusammengefasst.gem_bfs = hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer
)

SELECT 
    geometrie,
    gem_bfs,
    gmde_name,
    kkw,
    zonenzugehoerigkeit,
    sektoren
FROM 
    zonenzugehoerigkeit_gemeinden
;