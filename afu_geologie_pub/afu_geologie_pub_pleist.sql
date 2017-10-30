SELECT 
    pleist.ogc_fid AS t_id, 
    pleist.wkb_geometry AS geometrie, 
    pleist.neuer_code, 
    pleist.layercode, 
    pleist.system, 
    pleist.system1, 
    pleist.system2, 
    pleist.serie, 
    pleist.serie1, 
    pleist.serie2, 
    pleist.formation, 
    pleist.formation1, 
    pleist.formation2, 
    pleist.schichtgli, 
    pleist.ausbi_fest, 
    pleist.litho_fest, 
    pleist.sacku_fest, 
    pleist.ausbi_lock, 
    pleist.litho_lock, 
    pleist.verki_lock, 
    pleist.durchlaess, 
    pleist.gw_art, 
    pleist.gw_fuehrun, 
    pleist.gespannt, 
    pleist.reib_winke, 
    pleist.kohaesion, 
    pleist.fels_reib_, 
    pleist.fels_kohae, 
    pleist.mat_maecht, 
    pleist.fehlmatmae, 
    substr(pleist.schichtgli::text, 1, 5) AS schichtgliederung, 
    substr(pleist.neuer_code::text, 11, 1) AS gesteinstyp, 
    substr(pleist.neuer_code::text, 13, 2) AS lithologie1, 
    substr(pleist.neuer_code::text, 15, 2) AS lithologie2
FROM 
    geologie.pleist
WHERE 
    pleist.archive = 0;