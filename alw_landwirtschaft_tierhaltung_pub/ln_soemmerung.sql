WITH bb_land_kt_buffer AS (
    -- Nur LN Flächen im Kanton und um 10cm puffern
    SELECT
        bb.t_basket,
        bb.t_datasetname,   
        st_buffer(bb.geometrie,0.1) AS geometrie,
        bb.bezugjahr
    FROM
        alw_landwirtschaft_tierhaltung_v1.gelan_bodnbdckung_bodenbedeckung AS bb    
        JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze AS ke ON bb.geometrie && ke.geometrie AND ST_Within(bb.geometrie, ke.geometrie)
    WHERE 
        bb.bodenbedeckung_text = 'LAND' 
            AND
                bb.bezugjahr = ${publikationsjahr_flaechenerhebung} -- es wird immer nur ein Jahr publiziert
),

bb_land_aggregiert AS (
    -- LN Flächen zusammenfügen. Kein Mulitpolygon deshalb st_dump verwendet
    SELECT
        bb.t_basket,
        bb.t_datasetname,   
        (ST_Dump(ST_UnaryUnion(ST_Collect(bb.geometrie)))).geom AS geometrie,
        bb.bezugjahr
    FROM
        bb_land_kt_buffer AS bb
    GROUP BY 
        bb.t_basket,
        bb.t_datasetname,
        bb.bezugjahr
)
    -- Geometrien vereinfachen und zurück puffern
    SELECT
        bb.t_basket,
        bb.t_datasetname,   
        (ST_Dump(ST_SimplifyPreserveTopology(st_buffer(bb.geometrie, -0.1),0.5)).geom AS geometrie, 
        bb.bezugjahr
    FROM
        bb_land_aggregiert AS bb
