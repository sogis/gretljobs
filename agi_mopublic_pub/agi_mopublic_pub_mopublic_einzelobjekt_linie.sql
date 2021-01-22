WITH aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset 
)
SELECT
    split_part(einzelobjekt.art,'.',array_upper(string_to_array(einzelobjekt.art,'.'), 1)) AS art_txt,
    CAST(SUBSTRING(einzelobjekt.t_datasetname,1,4) AS INT) AS bfs_nr,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    linie.geometrie AS geometrie
FROM
    agi_dm01avso24.einzelobjekte_linienelement AS linie 
    LEFT JOIN agi_dm01avso24.einzelobjekte_einzelobjekt AS einzelobjekt
        ON einzelobjekt.t_id  = linie.linienelement_von
    LEFT JOIN agi_dm01avso24.einzelobjekte_eonachfuehrung AS nachfuehrung
        ON nachfuehrung.t_id = einzelobjekt.entstehung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON einzelobjekt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
