SELECT
    pdf,
    jahr,
    code,
    "text",
    wkb_geometry AS geometrie,
    ogc_fid AS t_id 
FROM
    awjf.sw_pdf
WHERE
    archive = 0
;