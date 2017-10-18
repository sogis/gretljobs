WITH kanton AS (
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
    tlm_grenzen_tlm_bezirksgebiet.bezirksnummer,
    tlm_grenzen_tlm_bezirksgebiet.aname AS bezirksname,
    kanton.aname AS kanton,
    land.aname AS land,
    ST_Force_2D(ST_Collect(tlm_grenzen_tlm_bezirksgebiet.shape)) AS geometrie
  FROM
    agi_swissboundaries3d.tlm_grenzen_tlm_bezirksgebiet
    LEFT JOIN
      kanton
      ON
        kanton.kantonsnummer = tlm_grenzen_tlm_bezirksgebiet.kantonsnummer
    LEFT JOIN
      land
      ON
        land.icc = tlm_grenzen_tlm_bezirksgebiet.icc
  GROUP BY
    bezirksnummer,
    bezirksname,
    kanton,
    land
),
  bezirk AS (
    SELECT
      tlm_grenzen_tlm_bezirksgebiet.uuid::uuid,
      tlm_grenzen_tlm_bezirksgebiet.bezirksnummer,
      tlm_grenzen_tlm_bezirksgebiet.datum_aenderung  
    FROM
      agi_swissboundaries3d.tlm_grenzen_tlm_bezirksgebiet
    WHERE 
      bezirk_teil=0 or bezirk_teil=1
)

SELECT 
  uuid AS t_ili_tid,
  geometrie.bezirksnummer,
  bezirksname,
  kanton,
  land,
  datum_aenderung,
  geometrie
FROM
  geometrie
  LEFT JOIN 
    bezirk
    ON
      bezirk.bezirksnummer = geometrie.bezirksnummer;
