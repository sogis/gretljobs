SELECT 
    0 AS max_bohrtiefe,
    'GW_Schutzareal' AS grund_beschraenkung,
    ST_Multi(apolygon) AS mpoly
FROM afu_gewaesserschutz_pub_v2.gewaesserschutz_schutzareal;
