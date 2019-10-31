SELECT
    gelaendename.aname AS gelaendename,
    CAST(gelaendename.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Center'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Half'
        ELSE pos.vali
    END AS vali,
    pos.pos,
    gemeinde.aname AS gemeinde
FROM
    agi_dm01avso24.nomenklatur_gelaendename AS gelaendename  
    LEFT JOIN agi_dm01avso24.nomenklatur_gelaendenamepos AS pos  
        ON pos.gelaendenamepos_von = gelaendename.t_id
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde AS gemeinde
        ON gemeinde.bfsnr = CAST(pos.t_datasetname AS integer)
    LEFT JOIN agi_dm01avso24.nomenklatur_nknachfuehrung AS nachfuehrung 
        ON gelaendename.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gelaendename.t_basket = basket.t_id
    LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate, dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS  aimport
        ON basket.dataset = aimport.dataset      
;