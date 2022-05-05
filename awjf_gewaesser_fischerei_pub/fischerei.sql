SELECT 
    revierid, 
    aname, 
    beschreibung, 
    eigentum, 
    fischbestand, 
    fischerei, 
    st_multi(st_union(geometrie)) AS geometrie
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

