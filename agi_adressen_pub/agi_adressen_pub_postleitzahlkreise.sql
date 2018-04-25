SELECT 
    os.ogc_fid AS t_id, 
    os.wkb_geometry AS geometrie, 
    os._tid, 
    os.entstehung, 
    os.ortschaft_von, 
    os.status, 
    os.inaenderung, 
    osname.text, 
    osname.kurztext, 
    osname.indextext
FROM 
    externe_daten.plzortschaft__ortschaft os
    LEFT JOIN externe_daten.plzortschaft__ortschaftsname osname 
        ON osname.ortschaftsname_von::text = os._tid::text
WHERE
    archive = 0
;