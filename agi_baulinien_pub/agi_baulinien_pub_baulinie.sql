SELECT 
    geom.t_id, 
    abstand.art, 
    geom.geometrie
FROM 
    av_baulinien_ng.baulinien_abstandslinie abstand, 
    av_baulinien_ng.baulinien_linienelementabstand geom
WHERE 
    geom.objekt = abstand.t_id
;