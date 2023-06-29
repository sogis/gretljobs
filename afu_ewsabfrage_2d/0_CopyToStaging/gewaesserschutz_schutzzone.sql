SELECT 
    0 AS max_bohrtiefe,
    'GW_Schutzzone' AS grund_beschraenkung,
    apolygon AS mpoly
FROM afu_gewaesserschutz_pub_v1.gewaesserschutz_schutzzone;
