--Polygone werden an der Kantonsgrenze gesplittet. Dies um später das Attribut "innerhalb_so" richtig zu vergeben.
WITH kantonsgrenzenverschnitt AS (
    SELECT 
        untere_hoehe, 
        obere_hoehe, 
        area, 
        (st_dump(st_split(karst.geometrie, st_boundary(kanton.geometrie)))).geom AS geometrie
    FROM 
        afu_karst_v1.karst_allogene_gebiete karst, 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton
)
--Die Attribute area und innerhalb_so werden gesetzt
,addattributes AS (
    SELECT 
        untere_hoehe, 
        obere_hoehe,
        round(st_area(karst.geometrie)::numeric) AS area,
        karst.geometrie,
        CASE
            WHEN (st_dwithin(st_pointonsurface(karst.geometrie), kanton.geometrie,0)=TRUE) THEN TRUE
            ELSE FALSE 
        END AS innerhalb_so,
        CASE
            WHEN (st_dwithin(st_pointonsurface(karst.geometrie), kanton.geometrie,0)=TRUE) THEN 'Ja'
            ELSE 'Nein'
        END AS innerhalb_so_txt
    FROM 
        kantonsgrenzenverschnitt karst,
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton
)
--Es soll nur das publiziert werden, was innerhalb 20Km um den Kanton herum ist. 
SELECT 
    untere_hoehe,
    obere_hoehe,
    area,
    st_intersection(karst.geometrie,st_buffer(kanton.geometrie,20000)) AS geometrie,
    innerhalb_so,
    innerhalb_so_txt
FROM 
    addattributes karst, 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton

