SELECT 
    0 AS max_bohrtiefe,
    'GW_Schutzzone' AS grund_beschraenkung,
    ST_Multi(apolygon) AS mpoly
FROM afu_gewaesserschutz_pub_v3.gewaesserschutz_schutzzone;
