SELECT
    strassenstueck.t_id AS tid,
    strassenstueck.strassenstueck_von,
    strassenstueck.anfangspunkt,
    strassenstueck.ordnung,
    str_istachse.itfcode AS istachse,
    strassenstueck.istachse AS istachse_txt,
    CAST(strassenstueck.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_strassenstueck AS strassenstueck
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON strassenstueck.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadrssen_strassenstueck_istachse AS str_istachse
        ON strassenstueck.istachse = str_istachse.ilicode
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
