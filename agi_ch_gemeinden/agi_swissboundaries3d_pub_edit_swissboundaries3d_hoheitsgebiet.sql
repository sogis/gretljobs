--Hoheitsgebiet
WITH mutltisurface_surface AS (
    SELECT 
        ms.t_id,
        ms.tlm_grnzn_tm_hhtsgbiet_multisurface,
        sf.surface,
        sf.multisurface3d_surfaces
    FROM agi_swissboundaries3d_v2.multisurface3d ms 
        LEFT JOIN
            agi_swissboundaries3d_v2.surface3d sf
            ON
            sf.multisurface3d_surfaces = ms.t_id 
),

geometrie AS (
    SELECT
        DISTINCT (tlm_grenzen_tlm_hoheitsgebiet.bfs_nummer, tlm_grenzen_tlm_hoheitsgebiet.aname) AS hoheitsgebiet,
        tlm_grenzen_tlm_hoheitsgebiet.bfs_nummer,
        tlm_grenzen_tlm_hoheitsgebiet.aname AS hoheitsgebietsname,
        tlm_grenzen_tlm_hoheitsgebiet.objektart as hoheitsgebietsart,
        bezirk.aname AS bezirksname,
        kanton.aname AS kanton,
        land.aname AS land,
        ST_Force2D(ST_Collect(ms.surface)) AS geometrie
    FROM
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_hoheitsgebiet
        LEFT JOIN
            mutltisurface_surface ms
            ON
            ms.tlm_grnzn_tm_hhtsgbiet_multisurface  = tlm_grenzen_tlm_hoheitsgebiet.t_id
        LEFT JOIN 
            agi_swissboundaries3d_v2.tlm_grenzen_tlm_bezirksgebiet bezirk
            ON 
                bezirk.bezirksnummer = tlm_grenzen_tlm_hoheitsgebiet.bezirksnummer
        LEFT JOIN
            agi_swissboundaries3d_v2.tlm_grenzen_tlm_kantonsgebiet kanton
            ON
                kanton.kantonsnummer = tlm_grenzen_tlm_hoheitsgebiet.kantonsnummer
        LEFT JOIN
            agi_swissboundaries3d_v2.tlm_grenzen_tlm_landesgebiet land
            ON
                land.icc = tlm_grenzen_tlm_hoheitsgebiet.icc
    GROUP BY
        hoheitsgebiet,
        bfs_nummer,
        hoheitsgebietsname,
        hoheitsgebietsart,
        bezirksname,
        kanton,
        land
)

SELECT 
    hoheitsgebiet.t_ili_tid,
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
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_hoheitsgebiet hoheitsgebiet
        ON
            hoheitsgebiet.bfs_nummer = geometrie.bfs_nummer
