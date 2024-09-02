SELECT 
    flaeche, 
    status_ueberschwemmung, 
    beurteilung_ueberschwemmung.dispname AS status_ueberschwemmung_txt, 
    status_uebermurung, 
    beurteilung_uebermurung.dispname AS status_uebermurung_txt, 
    status_ufererosion, 
    beurteilung_ufererosion.dispname AS status_ufererosion_txt, 
    status_permanente_rutschung, 
    beurteilung_permanente_rutschung.dispname AS status_permanente_rutschung_txt, 
    status_spontane_rutschung, 
    beurteilung_spontane_rutschung.dispname AS status_spontane_rutschung_txt, 
    status_hangmure, 
    beurteilung_hangmure.dispname AS status_hangmure_txt, 
    status_stein_block_schlag, 
    beurteilung_stein_block_schlag.dispname AS status_stein_block_schlag_txt, 
    status_fels_berg_sturz, 
    beurteilung_fels_bergs_sturz.dispname AS status_fels_berg_sturz_txt, 
    status_einsturz, 
    beurteilung_einsturz.dispname AS status_einsturz_txt, 
    status_absenkung, 
    beurteilung_absenkung.dispname AS status_absenkung_txt, 
    kommentar
FROM 
    afu_naturgefahren_staging_v1.erhebungsgebiet erhebungsgebiet
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_ueberschwemmung 
    ON 
    beurteilung_ueberschwemmung.ilicode = split_part(erhebungsgebiet.status_ueberschwemmung,',',1) 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_uebermurung 
    ON 
    beurteilung_uebermurung.ilicode = split_part(erhebungsgebiet.status_uebermurung,',',1)
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_ufererosion 
    ON 
    beurteilung_ufererosion.ilicode = split_part(erhebungsgebiet.status_ufererosion,',',1) 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_permanente_rutschung 
    ON 
    beurteilung_permanente_rutschung.ilicode = split_part(erhebungsgebiet.status_permanente_rutschung,',',1) 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_spontane_rutschung 
    ON 
    beurteilung_spontane_rutschung.ilicode = split_part(erhebungsgebiet.status_spontane_rutschung,',',1) 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_hangmure 
    ON 
    beurteilung_hangmure.ilicode = split_part(erhebungsgebiet.status_hangmure,',',1)  
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_stein_block_schlag 
    ON 
    beurteilung_stein_block_schlag.ilicode = split_part(erhebungsgebiet.status_stein_block_schlag,',',1)
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_fels_bergs_sturz 
    ON 
    beurteilung_fels_bergs_sturz.ilicode = split_part(erhebungsgebiet.status_fels_berg_sturz,',',1) 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_einfach_typ beurteilung_einsturz 
    ON 
    beurteilung_einsturz.ilicode = split_part(erhebungsgebiet.status_einsturz,',',1)  
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_einfach_typ beurteilung_absenkung 
    ON 
    beurteilung_absenkung.ilicode = split_part(erhebungsgebiet.status_absenkung,',',1)  
;
