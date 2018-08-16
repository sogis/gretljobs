SELECT 
    gewisso.gnrso,
    gewisso.name AS aname, 
    ST_Multi(ST_Union(ST_Force_2D(gewisso.wkb_geometry))) AS geometrie
FROM 
    gewisso.gewisso
WHERE 
    archive = 0
GROUP BY
  gewisso.gnrso, gewisso.name
;