SELECT
    ogc_fid AS t_id,
    CASE 
        WHEN ST_IsEmpty(wkb_geometry)
            THEN NULL
        ELSE ST_Multi(wkb_geometry) 
    END AS geometrie,
    zone,
    CASE
        WHEN zone = 'GZ1'
            THEN 'S1 Fassungsbereich'
        WHEN zone = 'GZ2'
            THEN 'S2 engere Schutzzone'
        WHEN zone = 'GZ2B'
            THEN 'S2B engere Schutzzone mit spez. Regelungen'
        WHEN zone = 'GZ3'
            THEN 'S3 weitere Schutzzone'
        WHEN zone = 'GZ3B'
            THEN 'S3B weitere Schutzzone mit spez. Regelungen'
        WHEN zone = 'SARE'
            THEN ' SA Schutzareal'
    END AS zone_text,
    CASE 
        WHEN
            rrb_date < '2001-01-01'
            AND
            ZONE != 'SARE'
                THEN FALSE
        WHEN rrb_date > '2001-01-01' 
            THEN TRUE
    END AS gesetzeskonform,
    rrbnr,
    rrb_date
FROM
    aww_gszoar
WHERE
    archive = 0
;
