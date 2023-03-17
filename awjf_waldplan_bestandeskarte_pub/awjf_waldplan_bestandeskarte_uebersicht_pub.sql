SELECT 
    waldplan_bestandeskarte.t_id, 
    ST_Multi(ST_RemoveRepeatedPoints(waldplan_bestandeskarte.geometrie, 0.1)) AS geometrie, 
    'Waldplan'::text AS typ
FROM 
    awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte
WHERE 
    waldplan_bestandeskarte.wptyp < 9
AND 
    waldplan_bestandeskarte.wap_vollstaendig = true
    
UNION 

SELECT 
    bodenbedeckung_boflaeche.t_id,
    ST_Multi(bodenbedeckung_boflaeche.geometrie) AS geometrie,
    'AVWald'::text AS typ
FROM 
    agi_dm01avso24.bodenbedeckung_boflaeche
WHERE 
    (
        bodenbedeckung_boflaeche.art = 'bestockt.geschlossener_Wald' 
        OR 
        bodenbedeckung_boflaeche.art = 'bestockt.uebrige_bestockte.Hecke'
    )
AND 
   bodenbedeckung_boflaeche.t_datasetname::int NOT IN ( 
       SELECT 
           waldplan_bestandeskarte.gem_bfs
       FROM 
           awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte
       WHERE 
           waldplan_bestandeskarte.wap_vollstaendig = true
    )
;
