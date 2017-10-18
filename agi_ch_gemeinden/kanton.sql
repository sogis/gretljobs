WITH land AS (
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
    tlm_grenzen_tlm_kantonsgebiet.kantonsnummer,
    tlm_grenzen_tlm_kantonsgebiet.aname AS kantonsname,
    land.aname AS land,
    ST_FORCE_2D(ST_Collect(tlm_grenzen_tlm_kantonsgebiet.shape)) AS geometrie
  
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_kantonsgebiet
    LEFT JOIN
      land
      ON
        land.icc = tlm_grenzen_tlm_kantonsgebiet.icc
  GROUP BY
    kantonsnummer,
    kantonsname,
    land
),
  kanton AS (
    SELECT
      tlm_grenzen_tlm_kantonsgebiet.uuid::uuid,
      tlm_grenzen_tlm_kantonsgebiet.kantonsnummer,
      tlm_grenzen_tlm_kantonsgebiet.datum_aenderung  
    FROM
      agi_swissboundaries3d.tlm_grenzen_tlm_kantonsgebiet
    WHERE 
      kanton_teil=0 or kanton_teil=1
)

SELECT 
  kanton.uuid AS t_ili_tid,
  geometrie.kantonsnummer,
  geometrie.kantonsname,
  geometrie.land,
  kanton.datum_aenderung,
  geometrie.geometrie
FROM
  geometrie
  LEFT JOIN
    kanton
    ON
      kanton.kantonsnummer = geometrie.kantonsnummer;
