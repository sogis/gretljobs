SELECT 
    revierid, 
    aname, 
    beschreibung, 
    eigentum, 
    CASE
        WHEN fischbestand = 'G' THEN 'Gemischt'
        WHEN fischbestand = 'E' THEN 'Edelfisch'
        ELSE NULL
    END AS fischbestand, 
    fischerei, 
    ST_Multi(ST_RemoveRepeatedPoints(ST_Union(geometrie), 0.001)) AS geometrie
FROM 
    afu_gewaesser_v1.fischrevierabschnitt_v
GROUP BY 
    revierid, 
    aname,
    beschreibung,
    eigentum,
    fischbestand,
    fischerei 
;

