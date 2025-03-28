INSERT INTO
    agi_av_gwr_abgleich_v1.av_gwr_differnzen_av_gwr_differenzen 
    (
        agi_id,
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
        geometrie    
    )
SELECT 
    bdg_egid || '-' || issue_category AS agi_id,
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
    ST_SetSRID(ST_MakePoint(bdg_e, bdg_n), 2056) AS geometrie
FROM 
    agi_av_gwr_abgleich_import_v1.av_gwr_differnzen_av_gwr_differenzen
ON CONFLICT (agi_id) DO NOTHING
;