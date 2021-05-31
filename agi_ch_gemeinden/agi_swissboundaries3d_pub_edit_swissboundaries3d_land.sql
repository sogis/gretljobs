WITH geometrie AS (
    SELECT
        tlm_landesgebiet.icc As landeskuerzel,
        tlm_landesgebiet.aname AS landesname,
        ST_Force2D(ST_Collect(tlm_landesgebiet.shape)) AS geometrie
    FROM
        agi_swissboundaries3d.tlm_landesgebiet
    GROUP BY
        landeskuerzel,
        landesname
)

SELECT 
    land.uuid::uuid AS t_ili_tid,
    geometrie.landeskuerzel,
    landesname,
    datum_aenderung,
    geometrie
FROM
    geometrie
    LEFT JOIN 
        agi_swissboundaries3d.tlm_landesgebiet land
        ON
            land.icc = geometrie.landeskuerzel
WHERE
    land.land_teil = 0
    OR
    land.land_teil = 1;
