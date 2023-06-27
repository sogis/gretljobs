SELECT 
    'Gewaesserraum' AS abklaerung,
    ST_Buffer(geometrie, raumbedarf, 'endcap=round join=round') AS mpoly
FROM afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie;
