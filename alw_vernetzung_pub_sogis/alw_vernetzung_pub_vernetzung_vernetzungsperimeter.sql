SELECT 
    t_ili_tid,
    vp_id,
    vp_name,
    traegersch,
    erarb_jahr,
    stand,
    bemerkung,
    ST_Area(geometrie) AS flaeche,
    geometrie
FROM
    alw_vernetzung.vernetzung_vernetzungsperimeter
;