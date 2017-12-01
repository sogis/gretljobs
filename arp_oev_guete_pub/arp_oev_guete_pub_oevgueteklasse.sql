SELECT
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    id,
    gueteklasse 
FROM
    oev_guete.oevgueteklassen
WHERE 
    archive = 0
;