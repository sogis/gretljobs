SELECT 
    geometrie AS wkb_geometry,
    CASE
        WHEN typ = 'S1'
            THEN 'GZ1'
        WHEN typ = 'S2'
            THEN 'GZ2'
        WHEN typ = 'S3'
            THEN 'GZ3'
    END AS zone,
    current_date AS new_date,
    '9999-01-01' AS archive_date,
    '0' AS archive
FROM afu_gewaesserschutz.gwszonen_gwszone
UNION
SELECT 
    geometrie AS wkb_geometry,
    'SARE' AS zone,
    current_date AS new_date,
    '9999-01-01' AS archive_date,
    '0' AS archive
FROM afu_gewaesserschutz.gwszonen_gwsareal