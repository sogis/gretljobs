WITH geometrie AS (
  SELECT
    tlm_grenzen_tlm_landesgebiet.icc AS landeskuerzel,
    tlm_grenzen_tlm_landesgebiet.aname AS landesname,
    ST_FORCE_2D(ST_Multi(tlm_grenzen_tlm_landesgebiet.shape)) AS geometrie
  
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_landesgebiet
  GROUP BY
    landeskuerzel,
    landesname,
    shape
),
  land AS (
    SELECT
      tlm_grenzen_tlm_landesgebiet.uuid::uuid,
      tlm_grenzen_tlm_landesgebiet.icc AS landeskuerzel,
      tlm_grenzen_tlm_landesgebiet.datum_aenderung 
    FROM
      agi_swissboundaries3d.tlm_grenzen_tlm_landesgebiet
    WHERE 
      land_teil=0 or land_teil=1
)
SELECT
  land.uuid AS t_ili_tid,
  geometrie.landeskuerzel,
  geometrie.landesname,
  land.datum_aenderung,
  geometrie.geometrie
FROM
  geometrie
  LEFT JOIN
    land
    ON
      land.landeskuerzel = geometrie.landeskuerzel;
