SELECT
    aname,
    geometrie,
    typ,
    gemeindename,
    av_geometrie
FROM
    afu_stehende_gewaesser_v1.stehendes_gewaesser
     
UNION ALL
    
SELECT 
    aname,
    geometrie,
    typ,
    gemeindename,
    av_geometrie
FROM 
    afu_stehende_gewaesser_v1.stehendes_gewaesser_av
;
