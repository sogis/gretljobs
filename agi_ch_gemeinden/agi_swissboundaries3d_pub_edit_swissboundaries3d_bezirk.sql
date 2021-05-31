--Bezirke
WITH geometrie AS (
    SELECT
        tlm_bezirksgebiet.bezirksnummer,
        tlm_bezirksgebiet.aname AS bezirksname,
        kanton.aname AS kanton,
        land.aname AS land,
        ST_Force_2D(ST_Collect(tlm_bezirksgebiet.shape)) AS geometrie
    FROM
        agi_swissboundaries3d.tlm_bezirksgebiet
        LEFT JOIN
            agi_swissboundaries3d.tlm_kantonsgebiet kanton
            ON
                kanton.kantonsnummer = tlm_bezirksgebiet.kantonsnummer
        LEFT JOIN
            agi_swissboundaries3d.tlm_landesgebiet land
            ON
                land.icc = tlm_bezirksgebiet.icc
    WHERE
        (
           kanton.kanton_teil = 0
           OR
           kanton.kanton_teil = 1
        )
        AND
        (
           land.land_teil = 0
           OR
           land.land_teil = 1
        )
    GROUP BY
        bezirksnummer,
        bezirksname,
        kanton,
        land
)

SELECT 
    bezirk.uuid::uuid AS t_ili_tid,
    geometrie.bezirksnummer,
    bezirksname,
    kanton,
    land,
    datum_aenderung,
    geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d.tlm_bezirksgebiet bezirk
        ON
            bezirk.bezirksnummer = geometrie.bezirksnummer
WHERE
    bezirk.bezirk_teil = 0
    OR
    bezirk.bezirk_teil = 1;
