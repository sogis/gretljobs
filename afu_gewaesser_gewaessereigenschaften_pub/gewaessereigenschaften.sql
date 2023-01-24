SELECT 
    ST_RemoveRepeatedPoints(geometrie, 0.001) AS geometrie,        /* Ausnahme, da abgeleitete Geometrie */
    gnrso,
    typ,
    '' AS typ_txt,
    groesse,
    '' AS groesse_txt,
    aname,
    gdenr as gemeindenummeruferrechts,
    gdenr2  as gemeindenummeruferlinks,
    qualitaet,
    '' AS qualitaet_txt,
    eigentum,
    '' AS eigentum_txt,
    strahler,
    erhebungsdatum
FROM 
    afu_gewaesser_v1.gewaessereigenschaft_v
;
