--Polygone werden an der Kantonsgrenze gesplittet. Dies um später das Attribut "innerhalb_so" richtig zu vergeben.
WITH kantonsgrenzenverschnitt AS (
    SELECT 
        (st_dump(st_split(karst.geometrie, st_boundary(kanton.geometrie)))).geom AS geometrie
    FROM 
        afu_karst_v1.karst_subartesische_zone karst, 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton
)
--Die Attribute area und innerhalb_so werden gesetzt
,addattributes AS (
    SELECT 
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
,finale AS (
    SELECT 
        st_intersection(karst.geometrie,st_buffer(kanton.geometrie,20000)) AS geometrie,
        innerhalb_so,
        innerhalb_so_txt
    FROM 
        addattributes karst, 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton
)

SELECT 
    *
FROM 
    finale
WHERE 
    st_area(geometrie) > 1 --Kleinstflächen fallen durch den area-checker