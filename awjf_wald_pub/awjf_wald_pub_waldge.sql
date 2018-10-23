SELECT 
    ogc_fid AS t_id,
    wkb_geometry AS geometrie,
    round(area::NUMERIC/10000,2) AS area,
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
    concat_ws(' ', grundeinheit, legende) AS waldstandort,
    farbcode,
    verband,
    ertragsklasse,
    CASE
        WHEN ertragsklasse = 1
            THEN 'Ertragsklasse I, Zuwachs jährlich (10-13-15) m3 pro ha'
        WHEN ertragsklasse = 2
            THEN 'Ertragsklasse II, Zuwachs jährlich (8-10-12) m3 pro ha'
        WHEN ertragsklasse = 3
            THEN 'Ertragsklasse III, Zuwachs jährlich (7-8-9) m3 pro ha'
        WHEN ertragsklasse = 4
            THEN 'Ertragsklasse IV, Zuwachs jährlich (5-6-7) m3 pro ha'
        WHEN ertragsklasse = 5
            THEN 'Ertragsklasse V, Zuwachs jährlich (3-4-5) m3 pro ha'
        WHEN ertragsklasse = 6
            THEN 'Ertragsklasse VI, Zuwachs jährlich (1-2-3) m3 pro ha'
    END AS ertragsklasse_text,
    zuwachs,
    min_lbh_ant * 100 AS min_lbh_ant,
    '[{"name": "Ökogramm Waldstandorte", "url": "https://geo.so.ch/docs/ch.so.awjf.waldstandorte.waldstandorte/Oekogramme_Waldstandorte.pdf"},{"name": "Legende Waldstandorte", "url": "https://geo.so.ch/docs/ch.so.awjf.waldstandorte.waldstandorte/Legende_Waldstandorte.pdf"}]' AS dokumente
FROM 
    awjf.waldge
WHERE 
    archive = 0
;
