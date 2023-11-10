SELECT
    aname,
    geometrie,
    typ,
    gemeindename,
    av_geometrie
FROM
    afu_stehende_gewaesser_v1.stehendes_gewaesser
WHERE
    av_geometrie IS FALSE AND av_link IS FALSE
     
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
