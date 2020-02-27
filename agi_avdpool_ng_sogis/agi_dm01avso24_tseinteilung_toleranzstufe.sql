SELECT
    toleranzstufe.t_id AS tid,
    toleranzstufe.nbident,
    toleranzstufe.identifikator,
    toleranzstufe.geometrie,
    to_char(toleranzstufe.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,    
    ts_art.itfcode AS art,
    toleranzstufe.art AS art_txt,
    CAST(toleranzstufe.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.tseinteilung_toleranzstufe AS toleranzstufe
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON toleranzstufe.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.tseinteilung_toleranzstufe_art AS ts_art
        ON toleranzstufe.art = ts_art.ilicode
    LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate,
            dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS  aimport
        ON basket.dataset = aimport.dataset
;
