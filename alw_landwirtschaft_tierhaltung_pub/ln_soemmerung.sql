    -- Noch keine Geometrie optimiert
    WITH kanton AS (
    SELECT 
        ST_Buffer(geometrie, 1.0) AS geometrie -- für leicht überlappende Flächen
        FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze
)
    
    SELECT
        bb.t_id,
        bb.t_basket,
        bb.t_datasetname,           
        bb.bezugjahr AS bezugsjahr,
        bb.mandant AS kanton,
        bb.geometrie AS geometrie
    FROM
        alw_landwirtschaft_tierhaltung_v1.gelan_bodnbdckung_bodenbedeckung AS bb    
        JOIN kanton AS ke ON ST_Within(bb.geometrie, ke.geometrie) --nur Objekte im Kanton SO
    WHERE 
        bb.bodenbedeckung_text = 'LAND' 
            AND
                bb.bezugjahr = ${publikationsjahr_flaechenerhebung} -- es wird immer nur ein Jahr publiziert