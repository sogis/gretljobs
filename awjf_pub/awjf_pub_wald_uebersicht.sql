SELECT 
    wap_bst.ogc_fid AS t_id, 
    st_multi(wap_bst.wkb_geometry) AS  geometrie, 
    'Waldplan'::text AS typ
FROM 
    awjf.wap_bst
WHERE 
    wap_bst.archive = 0 
    AND 
    (
        wap_bst.wptyp = 1 
        OR 
        wap_bst.wptyp = 2
    ) 
    AND 
    (
        wap_bst.gem_bfs IN ( 
            SELECT 
                wap_uebersicht.gem_bfs
            FROM 
                awjf_work.wap_uebersicht
            WHERE 
                wap_uebersicht.wap_vollstaendig = true)
    )
    
UNION 

SELECT 
    bodenbedeckung_boflaeche.ogc_fid AS t_id,
    st_multi(bodenbedeckung_boflaeche.geometrie) AS geometrie,
    'AVWald'::text AS typ
FROM 
    av_avdpool_ng.bodenbedeckung_boflaeche
WHERE 
    (
        bodenbedeckung_boflaeche.art = 27 
        OR 
        bodenbedeckung_boflaeche.art = 30 
        OR 
        bodenbedeckung_boflaeche.art = 31
    ) 
    AND 
    NOT (bodenbedeckung_boflaeche.gem_bfs IN ( 
        SELECT 
            wap_uebersicht.gem_bfs
        FROM 
            awjf_work.wap_uebersicht
        WHERE 
            wap_uebersicht.wap_vollstaendig = true)
    )
;