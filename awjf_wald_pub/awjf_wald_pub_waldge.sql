SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    area,
    perimeter,
    waldge_,
    waldge_id,
    CASE massstab WHEN 1 THEN '<1:2500' 
                  WHEN 2 THEN '1:2500'
                  WHEN 3 THEN '1:5000'
                  WHEN 4 THEN '1:10000'
                  WHEN 5 THEN '1:25000'
                  WHEN 6 THEN '1:50000'
    END AS massstab,
    CASE autor WHEN 'A' THEN 'BGU'
               WHEN 'B' THEN 'Kaufmann'
               WHEN 'C' THEN 'Froelicher'
               WHEN 'D' THEN 'Borer'
               WHEN 'W' THEN 'Waldmaske'
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
