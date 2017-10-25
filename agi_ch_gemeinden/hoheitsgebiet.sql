--Hoheitsgebiet
WITH geometrie AS (
    SELECT
        tlm_grenzen_tlm_hoheitsgebiet.bfs_nummer,
        tlm_grenzen_tlm_hoheitsgebiet.aname AS hoheitsgebietsname,
        tlm_grenzen_tlm_hoheitsgebiet.objektart as hoheitsgebietsart,
        bezirk.aname AS bezirksname,
        kanton.aname AS kanton,
        land.aname AS land,
        ST_Force_2D(ST_Collect(tlm_grenzen_tlm_hoheitsgebiet.shape)) AS geometrie
    FROM
        agi_swissboundaries3d.tlm_grenzen_tlm_hoheitsgebiet
        left join
            agi_swissboundaries3d.tlm_grenzen_tlm_bezirksgebiet bezirk
            on
                bezirk.bezirksnummer = tlm_grenzen_tlm_hoheitsgebiet.bezirksnummer
        LEFT JOIN
            agi_swissboundaries3d.tlm_grenzen_tlm_kantonsgebiet kanton
            ON
                kanton.kantonsnummer = tlm_grenzen_tlm_hoheitsgebiet.kantonsnummer
        LEFT JOIN
            agi_swissboundaries3d.tlm_grenzen_tlm_landesgebiet land
            ON
                land.icc = tlm_grenzen_tlm_hoheitsgebiet.icc
    WHERE
        (
           bezirk.bezirk_teil = 0
           OR
           bezirk.bezirk_teil= 1
        )
        AND
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
        bfs_nummer,
        hoheitsgebietsname,
        hoheitsgebietsart,
        bezirksname,
        kanton,
        land
)

SELECT 
    hoheitsgebiet.uuid::uuid AS t_ili_tid,
    geometrie.bfs_nummer,
    geometrie.hoheitsgebietsname,
    geometrie.hoheitsgebietsart,
    bezirksname AS bezirk,
    kanton,
    land,
    datum_aenderung,
    geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d.tlm_grenzen_tlm_hoheitsgebiet hoheitsgebiet
        ON
            hoheitsgebiet.bfs_nummer = geometrie.bfs_nummer
WHERE
    hoheitsgebiet.gem_teil = 0
    OR
    hoheitsgebiet.gem_teil = 1;