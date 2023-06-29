SELECT 
    'Gewaesserraum' AS abklaerung,
    CASE
        WHEN raumbedarf IS NULL 
            THEN ST_MULTI(ST_Buffer(geometrie, '5', 'endcap=round join=round'))
        ELSE
            ST_MULTI(ST_Buffer(geometrie, raumbedarf, 'endcap=round join=round'))
    END AS mpoly
FROM afu_gewaesser_oekomorphologie_pub_v1.oekomorphologie;
