SELECT 
    aname,
    geometrie,
    typ,
    gemeindename,
    erhebung_abgeschlossen,
    av_geometrie,
    av_link
FROM 
    afu_stehende_gewaesser_v1.stehendes_gewaesser
WHERE
    av_geometrie IS FALSE
AND
    av_link IS FALSE

UNION ALL
    
SELECT 
    aname,
    geometrie,
    typ,
    gemeindename,
    erhebung_abgeschlossen,
    av_geometrie,
    av_link
FROM 
    afu_stehende_gewaesser_v1.av_gewaesser
;

