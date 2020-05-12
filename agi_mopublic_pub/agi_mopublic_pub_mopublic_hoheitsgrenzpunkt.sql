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
    hoheitsgrenzpunkt.identifikator AS nummer,
    hoheitsgrenzpunkt.punktzeichen AS punktzeichen_txt,
    CASE
        WHEN hoheitsgrenzpunkt.hoheitsgrenzstein = 'ja' 
            THEN TRUE
        ELSE false
    END AS schoener_stein,
    hoheitsgrenzpunkt.lagegen AS lagegenauigkeit,
    CASE
        WHEN hoheitsgrenzpunkt.lagezuv = 'ja' 
            THEN TRUE
        ELSE false
    END AS lagezuverlaessigkeit,
    CASE
        WHEN symbol.ori IS NULL 
            THEN (100 - 0) * 0.9
        ELSE (100 - symbol.ori) * 0.9
    END AS symbolorientierung,
    CASE
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    CAST(hoheitsgrenzpunkt.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    hoheitsgrenzpunkt.geometrie,
    pos.pos
FROM
    agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunkt AS hoheitsgrenzpunkt
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunktpos AS pos 
        ON pos.hoheitsgrenzpunktpos_von = hoheitsgrenzpunkt.t_id
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunktsymbol AS symbol 
        ON symbol.hoheitsgrenzpunktsymbol_von = pos.t_id
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemnachfuehrung AS nachfuehrung
        ON hoheitsgrenzpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoheitsgrenzpunkt.t_basket = basket.t_id    
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
