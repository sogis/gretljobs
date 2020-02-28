SELECT
    signalpunkt.t_id AS tid,
    signalpunkt.entstehung,
    signalpunkt.nummer,
    signalpunkt.betreiber,
    signalpunkt.geometrie,
    qualitaetsstandard.itfcode AS qualitaet,
    signalpunkt.qualitaet AS qualitaet_txt,
    rl_medium.itfcode AS art,
    signalpunkt.art AS art_txt,
    sp_punktart.itfcode AS punktart,
    signalpunkt.punktart AS punktart_txt,
    cast(signalpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_signalpunkt AS signalpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON signalpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.rohrleitungen_medium AS rl_medium
        ON signalpunkt.art = rl_medium.ilicode
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON signalpunkt.qualitaet = qualitaetsstandard.ilicode
    LEFT JOIN agi_dm01avso24.rohrleitungen_signalpunkt_punktart AS sp_punktart
        ON signalpunkt.punktart = sp_punktart.ilicode
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
