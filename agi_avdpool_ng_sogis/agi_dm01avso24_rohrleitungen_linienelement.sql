SELECT
    linienelement.t_id AS tid,
    linienelement.linienelement_von,
    linienelement.geometrie,
    li_linienart.itfcode AS linienart,
    linienelement.linienart AS linienart_txt,
    cast(linienelement.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_linienelement AS linienelement
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON linienelement.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.rohrleitungen_linienelement_linienart AS li_linienart
        ON linienelement.linienart = li_linienart.ilicode
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
