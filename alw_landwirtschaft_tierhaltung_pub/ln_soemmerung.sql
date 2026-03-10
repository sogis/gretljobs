    -- Noch keine Geometrie optimiert
    SELECT
        bb.t_basket,
        bb.t_datasetname,   
        bb.geometrie AS geometrie,
        bb.bezugjahr
    FROM
        alw_landwirtschaft_tierhaltung_v1.gelan_bodnbdckung_bodenbedeckung AS bb    
        JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze AS ke ON ST_Within(bb.geometrie, ke.geometrie) --nur Objekte im Kanton SO
    WHERE 
        bb.bodenbedeckung_text = 'LAND' 
            AND
                bb.bezugjahr = ${publikationsjahr_flaechenerhebung} -- es wird immer nur ein Jahr publiziert