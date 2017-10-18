WITH bezirk AS (
  SELECT 
    tlm_grenzen_tlm_bezirksgebiet.bezirksnummer,
    tlm_grenzen_tlm_bezirksgebiet.aname
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_bezirksgebiet
  WHERE
    bezirk_teil = 0 OR bezirk_teil = 1
),
kanton AS (
  SELECT 
    tlm_grenzen_tlm_kantonsgebiet.kantonsnummer,
    tlm_grenzen_tlm_kantonsgebiet.aname
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_kantonsgebiet
  WHERE
    kanton_teil = 0 OR kanton_teil = 1
),
land AS (
  SELECT 
    tlm_grenzen_tlm_landesgebiet.icc,
    tlm_grenzen_tlm_landesgebiet.aname
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_landesgebiet
  WHERE
    land_teil = 0 OR land_teil = 1
),
geometrie AS (
  SELECT
    tlm_grenzen_tlm_hoheitsgebiet.bfs_nummer,
    tlm_grenzen_tlm_hoheitsgebiet.aname AS hoheitsgebietsname,
    tlm_grenzen_tlm_hoheitsgebiet.objektart AS hoheitsgebietsart,
    bezirk.aname AS bezirksname,
    kanton.aname AS kantonsname,
    land.aname AS landesname,
    ST_FORCE_2D(ST_Collect(tlm_grenzen_tlm_hoheitsgebiet.shape)) AS geometrie
  
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_hoheitsgebiet
    LEFT JOIN
      bezirk
      ON
        bezirk.bezirksnummer = tlm_grenzen_tlm_hoheitsgebiet.bezirksnummer
    LEFT JOIN
      kanton
      ON 
        kanton.kantonsnummer = tlm_grenzen_tlm_hoheitsgebiet.kantonsnummer
    LEFT JOIN
      land
      ON
        land.icc = tlm_grenzen_tlm_hoheitsgebiet.icc
  GROUP BY
    bfs_nummer,
    hoheitsgebietsname,
    hoheitsgebietsart,
    bezirksname,
    kantonsname,
    landesname
),
gemeinde AS (
    SELECT
      tlm_grenzen_tlm_hoheitsgebiet.uuid::uuid,
      tlm_grenzen_tlm_hoheitsgebiet.bfs_nummer,
      tlm_grenzen_tlm_hoheitsgebiet.datum_aenderung  
    FROM
      agi_swissboundaries3d.tlm_grenzen_tlm_hoheitsgebiet
    WHERE 
      gem_teil=0 or gem_teil=1
)

SELECT
  gemeinde.uuid AS t_ili_tid,
  geometrie.bfs_nummer,
  geometrie.hoheitsgebietsname,
  geometrie.hoheitsgebietsart,
  geometrie.bezirksname AS bezirk,
  geometrie.kantonsname AS kanton,
  geometrie.landesname AS land,
  gemeinde.datum_aenderung,
  geometrie.geometrie
  
FROM
  geometrie
  LEFT JOIN
    gemeinde
    ON gemeinde.bfs_nummer = geometrie.bfs_nummer;
