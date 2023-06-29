SELECT 
    0 AS max_bohrtiefe,
    'GW_Schutzareal' AS grund_beschraenkung,
    apolygon AS mpoly
FROM afu_gewaesserschutz_pub_v1.gewaesserschutz_schutzareal;
