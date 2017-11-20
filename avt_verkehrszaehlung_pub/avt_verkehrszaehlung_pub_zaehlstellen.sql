SELECT 
    zaehlstellen.ogc_fid AS t_id, 
    zaehlstellen.z_bezei,
    zaehlstellen.wkb_geometry AS geometrie, 
    1 AS aktuell
FROM 
    verkehrszaehlung.zaehlstellen
WHERE 
    zaehlstellen.archive = 0
    
UNION 

SELECT 
    messstellen_bis_2005.ogc_fid AS t_id, 
    messstellen_bis_2005.z_bezei, 
    messstellen_bis_2005.wkb_geometry AS geometrie, 
    0 AS aktuell
FROM 
    verkehrszaehlung.messstellen_bis_2005
WHERE 
    NOT (messstellen_bis_2005.z_bezei::text IN 
        (
            SELECT 
                zaehlstellen.z_bezei
            FROM 
                verkehrszaehlung.zaehlstellen
        )) 
    AND 
        NOT messstellen_bis_2005.z_bezei::text = '202B'::text
;