WITH kanton AS (
    SELECT ST_Buffer(geometrie, 1.0) AS geometrie
    FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze
),

prepared AS (
    SELECT
        bb.t_basket,
        bb.t_datasetname,
        bb.bezugjahr AS bezugsjahr,
        bb.mandant AS kanton,
        ST_MakeValid(
            ST_ReducePrecision(bb.geometrie, 0.5)
        ) AS geometrie
    FROM alw_landwirtschaft_tierhaltung_v1.gelan_bodnbdckung_bodenbedeckung AS bb
    JOIN kanton AS ke 
      ON ST_Within(bb.geometrie, ke.geometrie)
    WHERE bb.bodenbedeckung_text = 'LAND'
      AND bb.bezugjahr = ${publikationsjahr_flaechenerhebung}
),

dissolved AS (
    SELECT
        t_basket,
        t_datasetname,
        bezugsjahr,
        kanton,
        ST_UnaryUnion(ST_Collect(geometrie)) AS geometrie
    FROM prepared
    GROUP BY
        t_basket,
        t_datasetname,
        bezugsjahr,
        kanton
),

dumped AS (
    SELECT
        t_basket,
        t_datasetname,
        bezugsjahr,
        kanton,
        (ST_Dump(ST_CollectionExtract(ST_MakeValid(geometrie), 3))).geom AS geometrie
    FROM dissolved
)

SELECT
    t_basket,
    t_datasetname,
    bezugsjahr,
    kanton,
    ST_RemoveRepeatedPoints(
        st_buffer(
            st_buffer(geometrie, 0.5)
        ,-0.5)
    , 0.01) AS geometrie
FROM 
    dumped
;