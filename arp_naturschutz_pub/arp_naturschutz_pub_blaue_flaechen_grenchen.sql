SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    refname 
FROM
    naturschutz.blaue_flaechen_grenchen
WHERE
    archive = 0
;