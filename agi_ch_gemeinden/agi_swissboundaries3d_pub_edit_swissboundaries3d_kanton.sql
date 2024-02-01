--Kanton
WITH mutltisurface_surface AS (
    SELECT 
        ms.t_id,
        ms.tlm_grnzn_t_kntnsgbiet_multisurface,
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
        DISTINCT (tlm_grenzen_tlm_kantonsgebiet.kantonsnummer, tlm_grenzen_tlm_kantonsgebiet.aname) AS kanton,
        tlm_grenzen_tlm_kantonsgebiet.kantonsnummer,
        tlm_grenzen_tlm_kantonsgebiet.aname AS kantonsname,
        land.aname AS land,
        ST_Collect(ms.surface) AS geometrie
    FROM
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_kantonsgebiet
        LEFT JOIN
            mutltisurface_surface ms
            ON
                ms.tlm_grnzn_t_kntnsgbiet_multisurface  = tlm_grenzen_tlm_kantonsgebiet.t_id
        LEFT JOIN
            agi_swissboundaries3d_v2.tlm_grenzen_tlm_landesgebiet land
            ON
                land.icc = tlm_grenzen_tlm_kantonsgebiet.icc
    GROUP BY
        kanton,
        kantonsnummer,
        kantonsname,
        land
)

SELECT 
    kanton.t_ili_tid,
    geometrie.kantonsnummer,
    kantonsname,
    land,
    datum_aenderung,
    geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_kantonsgebiet kanton
        ON
            kanton.kantonsnummer = geometrie.kantonsnummer
