SELECT
    grenzpunkt.geometrie AS wkb_geometry,
    grenzpunkt.lagegen,
    CASE 
        WHEN grenzpunkt.lagezuv = 'ja'
            THEN 0   
        WHEN grenzpunkt.lagezuv = 'nein'
            THEN 1   
    END AS lagezuv,
    CASE 
        WHEN grenzpunkt.punktzeichen = 'Stein'
            THEN 0   
        WHEN grenzpunkt.punktzeichen = 'Kunststoffzeichen'
            THEN 0   
        WHEN grenzpunkt.punktzeichen = 'Bolzen'
            THEN 1   
        WHEN grenzpunkt.punktzeichen = 'Rohr'
            THEN 1   
        WHEN grenzpunkt.punktzeichen = 'Pfahl'
            THEN 1   
        WHEN grenzpunkt.punktzeichen = 'Kreuz'
            THEN 2   
        WHEN grenzpunkt.punktzeichen = 'unversichert'
            THEN 3   
        WHEN grenzpunkt.punktzeichen = 'weitere'
            THEN 3   
    END AS punktzeich,
    grenzpunktsymbol.ori AS symbolori,
    grenzpunktpos.ori AS numori,
    CASE 
        WHEN grenzpunktpos.hali = 'Left'
            THEN 0   
        WHEN grenzpunktpos.hali = 'Center'
            THEN 1   
        WHEN grenzpunktpos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN grenzpunktpos.vali = 'Top'
            THEN 0   
        WHEN grenzpunktpos.vali = 'Cap'
            THEN 1   
        WHEN grenzpunktpos.vali = 'Half'
            THEN 2   
        WHEN grenzpunktpos.vali = 'Base'
            THEN 3   
        WHEN grenzpunktpos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    CASE
        WHEN grenzpunktpos.ori >= 0 AND grenzpunktpos.ori < 100
            THEN (100-grenzpunktpos.ori)*0.9
        WHEN grenzpunktpos.ori = 100
            THEN 360
        WHEN grenzpunktpos.ori > 100 AND grenzpunktpos.ori <= 400
            THEN ((100-grenzpunktpos.ori)*0.9)+360
    END AS txt_rot,
    CAST(grenzpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.liegenschaften_grenzpunkt AS grenzpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grenzpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grenzpunktpos AS grenzpunktpos
        ON grenzpunktpos.grenzpunktpos_von = grenzpunkt.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grenzpunktsymbol AS grenzpunktsymbol
        ON grenzpunktsymbol.grenzpunktsymbol_von = grenzpunkt.t_id
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
