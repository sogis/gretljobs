SELECT 
    geom.t_id, 
    abstand.art, 
    geom.geometrie
FROM 
    agi_av_baulinien_ng.baulinien_abstandslinie abstand, 
    agi_av_baulinien_ng.baulinien_linienelementabstand geom
WHERE 
    geom.objekt = abstand.t_id
;
