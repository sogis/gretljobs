SELECT
    hoheitsgrenzpunkt.geometrie AS wkb_geometry,
    hoheitsgrenzpunkt.identifikator,
    hoheitsgrenzpunkt.lagegen,
    CASE 
        WHEN hoheitsgrenzpunkt.lagezuv = 'ja'
            THEN 0   
        WHEN hoheitsgrenzpunkt.lagezuv = 'nein'
            THEN 1   
    END AS lagezuv,
    CASE 
        WHEN hoheitsgrenzpunkt.punktzeichen = 'Stein'
            THEN 0   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'Kunststoffzeichen'
            THEN 0   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'Bolzen'
            THEN 1   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'Rohr'
            THEN 1   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'Pfahl'
            THEN 1   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'Kreuz'
            THEN 2   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'unversichert'
            THEN 3   
        WHEN hoheitsgrenzpunkt.punktzeichen = 'weitere'
            THEN 3   
    END AS punktzeichen,
    hoheitsgrenzpunktsymbol.ori AS symbolori,
    hoheitsgrenzpunktpos.ori AS numori,
    CASE 
        WHEN hoheitsgrenzpunktpos.hali = 'Left'
            THEN 0   
        WHEN hoheitsgrenzpunktpos.hali = 'Center'
            THEN 1   
        WHEN hoheitsgrenzpunktpos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN hoheitsgrenzpunktpos.vali = 'Top'
            THEN 0   
        WHEN hoheitsgrenzpunktpos.vali = 'Cap'
            THEN 1   
        WHEN hoheitsgrenzpunktpos.vali = 'Half'
            THEN 2   
        WHEN hoheitsgrenzpunktpos.vali = 'Base'
            THEN 3   
        WHEN hoheitsgrenzpunktpos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    CASE
        WHEN hoheitsgrenzpunktpos.ori >= 0 AND hoheitsgrenzpunktpos.ori < 100
            THEN (100-hoheitsgrenzpunktpos.ori)*0.9
        WHEN hoheitsgrenzpunktpos.ori = 100
            THEN 360
        WHEN hoheitsgrenzpunktpos.ori > 100 AND hoheitsgrenzpunktpos.ori <= 400
            THEN ((100-hoheitsgrenzpunktpos.ori)*0.9)+360
    END AS txt_rot,
    CAST(hoheitsgrenzpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunkt AS hoheitsgrenzpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoheitsgrenzpunkt.t_basket = basket.t_id
     LEFT JOIN agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunktpos AS hoheitsgrenzpunktpos
        ON hoheitsgrenzpunktpos.hoheitsgrenzpunktpos_von = hoheitsgrenzpunkt.t_id
     LEFT JOIN agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunktsymbol AS hoheitsgrenzpunktsymbol
        ON hoheitsgrenzpunktsymbol.hoheitsgrenzpunktsymbol_von = hoheitsgrenzpunkt.t_id
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
