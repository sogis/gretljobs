--Bezirke
WITH mutltisurface_surface AS (
    SELECT 
        ms.t_id,
        ms.tlm_grnzn_t_bzrksgbiet_multisurface,
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
        DISTINCT (tlm_grenzen_tlm_bezirksgebiet.bezirksnummer, tlm_grenzen_tlm_bezirksgebiet.aname) AS bezirk,
        tlm_grenzen_tlm_bezirksgebiet.bezirksnummer,
        tlm_grenzen_tlm_bezirksgebiet.aname AS bezirksname,
        kanton.aname AS kanton,
        land.aname AS land,
        ST_Collect(ms.surface) AS geometrie
--        ST_Force2D(ST_Collect(tlm_grenzen_tlm_bezirksgebiet.shape)) AS geometrie
    FROM
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_bezirksgebiet
        LEFT JOIN
            mutltisurface_surface ms
            ON
                ms.tlm_grnzn_t_bzrksgbiet_multisurface  = tlm_grenzen_tlm_bezirksgebiet.t_id
        LEFT JOIN
            agi_swissboundaries3d_v2.tlm_grenzen_tlm_kantonsgebiet kanton
            ON
                kanton.kantonsnummer = tlm_grenzen_tlm_bezirksgebiet.kantonsnummer
        LEFT JOIN
            agi_swissboundaries3d_v2.tlm_grenzen_tlm_landesgebiet land
            ON
                land.icc = tlm_grenzen_tlm_bezirksgebiet.icc
    GROUP BY
        bezirk,
        bezirksnummer,
        bezirksname,
        kanton,
        land
)

SELECT 
    t_ili_tid,
    geometrie.bezirksnummer,
    geometrie.bezirksname,
    geometrie.kanton,
    geometrie.land,
    datum_aenderung,
    geometrie.geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_bezirksgebiet bezirk
        ON
            bezirk.bezirksnummer = geometrie.bezirksnummer
