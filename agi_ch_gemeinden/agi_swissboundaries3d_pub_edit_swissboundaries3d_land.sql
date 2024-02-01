WITH mutltisurface_surface AS (
    SELECT 
        ms.t_id,
        ms.tlm_grnzn_tm_lndsgbiet_multisurface,
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
        DISTINCT (tlm_grenzen_tlm_landesgebiet.icc, tlm_grenzen_tlm_landesgebiet.aname) AS bezirk,
        tlm_grenzen_tlm_landesgebiet.icc As landeskuerzel,
        tlm_grenzen_tlm_landesgebiet.aname AS landesname,
        ST_Collect(ms.surface) AS geometrie
    FROM
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_landesgebiet
        LEFT JOIN
            mutltisurface_surface ms
            ON
                ms.tlm_grnzn_tm_lndsgbiet_multisurface  = tlm_grenzen_tlm_landesgebiet.t_id
    GROUP BY
        landeskuerzel,
        landesname
)

SELECT 
    land.t_ili_tid,
    geometrie.landeskuerzel,
    landesname,
    datum_aenderung,
    geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d_v2.tlm_grenzen_tlm_landesgebiet land
        ON
            land.icc = geometrie.landeskuerzel
