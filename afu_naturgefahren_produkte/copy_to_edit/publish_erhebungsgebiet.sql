SELECT 
    flaeche, 
    status_ueberschwemmung, 
    status_uebermurung, 
    status_ufererosion, 
    status_permanente_rutschung, 
    status_spontane_rutschung, 
    status_hangmure, 
    status_stein_block_schlag, 
    status_fels_berg_sturz, 
    status_einsturz, 
    status_absenkung, 
    kommentar
FROM 
    afu_naturgefahren_staging_v1.erhebungsgebiet
;