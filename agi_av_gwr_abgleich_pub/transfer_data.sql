SELECT 
    com_fosnr,
    bdg_geomsrc,
    bdg_category,
    bdg_gklas,
    bdg_gstat,
    av_source,
    av_type,
    issue,
    issue_category,
    bdg_e,
    bdg_n,
    link,
    agi_klasse,
    agi_text,
    agi_index,
    agi_id,
    geometrie
FROM 
    agi_av_gwr_abgleich_v1.av_gwr_differnzen_av_gwr_differenzen
;