INSERT INTO
    agi_av_gwr_abgleich_v1.av_gwr_differnzen_av_gwr_differenzen 
    (
        agi_id,
        com_fosnr,
        bdg_egid,
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
        geometrie    
    )
SELECT 
    bdg_egid || '-' || issue_category AS agi_id,
    com_fosnr,
    bdg_egid,
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
CASE 
    WHEN issue_category = 'Only in GWR, under construction'
        THEN 'Korrektur Geometer'
    WHEN issue_category = 'Different EGID in AV and GWR'
        THEN 'Korrektur Geometer'
	WHEN issue_category = 'Linked by EGID to outdated building'
        THEN 'Korrektur Geometer'
	WHEN issue_category = 'Obsolete in GWR'
        THEN 'Korrektur Gemeinde'
    ELSE 'Neu'
END AS agi_klasse,
    ST_SetSRID(ST_MakePoint(bdg_e, bdg_n), 2056) AS geometrie
FROM 
    agi_av_gwr_abgleich_import_v1.av_gwr_differnzen_av_gwr_differenzen
ON CONFLICT (agi_id) DO NOTHING
;
