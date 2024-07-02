SELECT 
    flaeche, 
    datenherr, 
    kantone.dispname AS datenherr_txt, 
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
    afu_naturgefahren_staging_v1.chcantoncode kantone 
    ON 
    kantone.ilicode = erhebungsgebiet.datenherr 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_ueberschwemmung 
    ON 
    beurteilung_ueberschwemmung.ilicode = erhebungsgebiet.status_ueberschwemmung 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_uebermurung 
    ON 
    beurteilung_uebermurung.ilicode = erhebungsgebiet.status_uebermurung
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_ufererosion 
    ON 
    beurteilung_ufererosion.ilicode = erhebungsgebiet.status_ufererosion 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_permanente_rutschung 
    ON 
    beurteilung_permanente_rutschung.ilicode = erhebungsgebiet.status_permanente_rutschung 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_spontane_rutschung 
    ON 
    beurteilung_spontane_rutschung.ilicode = erhebungsgebiet.status_spontane_rutschung 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_hangmure 
    ON 
    beurteilung_hangmure.ilicode = erhebungsgebiet.status_hangmure  
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_stein_block_schlag 
    ON 
    beurteilung_stein_block_schlag.ilicode = erhebungsgebiet.status_stein_block_schlag
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_komplex_typ beurteilung_fels_bergs_sturz 
    ON 
    beurteilung_fels_bergs_sturz.ilicode = erhebungsgebiet.status_fels_berg_sturz 
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_einfach_typ beurteilung_einsturz 
    ON 
    beurteilung_einsturz.ilicode = erhebungsgebiet.status_einsturz  
LEFT JOIN 
    afu_naturgefahren_staging_v1.beurteilung_einfach_typ beurteilung_absenkung 
    ON 
    beurteilung_absenkung.ilicode = erhebungsgebiet.status_absenkung  
;