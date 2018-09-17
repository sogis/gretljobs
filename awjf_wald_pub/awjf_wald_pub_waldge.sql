SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    waldge_,
    waldge_id,
    CASE
        WHEN massstab = 1
            THEN '<1:2500'
        WHEN massstab = 2
            THEN '1:2500'
        WHEN massstab = 3
            THEN '1:5000'
        WHEN massstab = 4
            THEN '1:10000'
        WHEN massstab = 5
            THEN '1:25000'
        WHEN massstab = 6
            THEN '1:50000'
    END AS massstab,
    CASE
        WHEN autor = 'A'
            THEN 'BGU'
        WHEN autor = 'B'
            THEN 'Kaufmann'
        WHEN autor = 'C'
            THEN 'Froelicher'
        WHEN autor = 'D'
            THEN 'Borer'
        WHEN autor = 'W'
            THEN 'Waldmaske'
    END AS autor,
    kartierung,
    ges_alt,
    ges_neu,
    bezirk,
    wald,
    ges_neu_ber,
    grundeinheit,
    legende,
    farbcode,
    verband,
    ertragsklasse,
    zuwachs,
    min_lbh_ant
FROM 
    awjf.waldge
WHERE 
    archive = 0
;
