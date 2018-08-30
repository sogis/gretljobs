SELECT
    ogc_fid AS t_id,
    CASE 
        WHEN ST_IsEmpty(wkb_geometry)
            THEN NULL
        ELSE ST_Multi(wkb_geometry) 
    END AS geometrie,
    "zone",
    rrbnr,
    rrb_date
FROM
    aww_gszoar
WHERE
    archive = 0
;
