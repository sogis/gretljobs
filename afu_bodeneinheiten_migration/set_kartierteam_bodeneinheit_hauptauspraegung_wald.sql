UPDATE 
    afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald 
SET 
    kartierer_r = kartierteam_id 
FROM (
    SELECT distinct 
        k.t_id as kartierteam_id, 
        imp.gemnr, 
        imp.objnr 
    FROM 
        afu_bodeneinheiten_v1.bodeneinheithauptauspraegung_wald 
    LEFT JOIN 
        afu_bodeneinheiten_v1.import_table imp 
        ON 
        gemeinde_nr = imp.gemnr 
        and 
        bodeneinheit_nummer = imp.objnr
    LEFT JOIN 
        afu_bodeneinheiten_v1.kartierteam k 
        ON 
        imp.kartierteam = k.teamkuerzel
    ) 
WHERE 
    gemeinde_nr = gemnr 
    and 
    bodeneinheit_nummer = objnr 
    and 
    import_oid > 0
;