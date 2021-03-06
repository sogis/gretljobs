--Kanton
WITH geometrie AS (
    SELECT
        tlm_kantonsgebiet.kantonsnummer,
        tlm_kantonsgebiet.aname AS kantonsname,
        land.aname AS land,
        ST_Force2D(ST_Collect(tlm_kantonsgebiet.shape)) AS geometrie
    FROM
        agi_swissboundaries3d.tlm_kantonsgebiet
        LEFT JOIN
            agi_swissboundaries3d.tlm_landesgebiet land
            ON
                land.icc = tlm_kantonsgebiet.icc
    WHERE
        land.land_teil = 0
        OR
        land.land_teil = 1
    GROUP BY
        kantonsnummer,
        kantonsname,
        land
)

SELECT 
    kanton.uuid::uuid AS t_ili_tid,
    geometrie.kantonsnummer,
    kantonsname,
    land,
    datum_aenderung,
    geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d.tlm_kantonsgebiet kanton
        ON
            kanton.kantonsnummer = geometrie.kantonsnummer
WHERE
    kanton.kanton_teil = 0
    OR
    kanton.kanton_teil = 1;
