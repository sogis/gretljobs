DELETE FROM agi_av_gwr_abgleich_v1.av_gwr_differnzen_av_gwr_differenzen
    where agi_id in (
SELECT 
    abgleich.agi_id
FROM 
    agi_av_gwr_abgleich_v1.av_gwr_differnzen_av_gwr_differenzen AS abgleich
    LEFT JOIN agi_av_gwr_abgleich_import_v1.av_gwr_differnzen_av_gwr_differenzen AS importabgleich
        ON (importabgleich.bdg_egid || '-' || importabgleich.issue_category) = abgleich.agi_id
WHERE importabgleich.issue_category IS NULL OR importabgleich.issue_category = '')
