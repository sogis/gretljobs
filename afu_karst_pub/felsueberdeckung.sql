--Polygone werden an der Kantonsgrenze gesplittet. Dies um später das Attribut "innerhalb_so" richtig zu vergeben.
WITH kantonsgrenzenverschnitt AS (
    SELECT 
        etm, 
        maechtigkeit, 
        (st_dump(st_split(karst.geometrie, st_boundary(kanton.geometrie)))).geom AS geometrie
    FROM 
        afu_karst_v1.karst_felsueberdeckung karst, 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton
)
--Die Attribute maechtigkeit_txt und innerhalb_so werden gesetzt
,addattributes AS (
    SELECT 
        etm, 
        maechtigkeit,
        maechtigkeit_text.dispname AS maechtigkeit_txt,
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
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton,
        kantonsgrenzenverschnitt karst
    LEFT JOIN 
        afu_karst_v1.karst_maechtigkeit maechtigkeit_text 
        ON 
        karst.maechtigkeit = maechtigkeit_text.ilicode
)
--Es soll nur das publiziert werden, was innerhalb 20Km um den Kanton herum ist. 
SELECT 
    etm,
    maechtigkeit,
    maechtigkeit_txt,
    st_intersection(karst.geometrie,st_buffer(kanton.geometrie,20000)) AS geometrie,
    innerhalb_so,
    innerhalb_so_txt
FROM 
    addattributes karst, 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze kanton
