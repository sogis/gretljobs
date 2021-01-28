WITH pos AS 
(
    SELECT
        DISTINCT ON (flurnamepos_von)
        flurnamepos_von,
        hali,
        vali,
        ori,
        pos,
        gemeinde.aname AS gemeinde
    FROM
    agi_dm01avso24.nomenklatur_flurnamepos AS pos
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde AS gemeinde
    ON gemeinde.bfsnr = CAST(pos.t_datasetname AS integer)
),
aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset 
)
SELECT
    flurname.aname AS flurname,
    CAST(flurname.t_datasetname AS INT) AS bfs_nr,    
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
    aimport.importdate AS importdatum,
    flurname.geometrie AS geometrie,
    pos.pos,
    pos.gemeinde AS gemeinde
FROM
    pos 
    LEFT JOIN agi_dm01avso24.nomenklatur_flurname AS flurname
        ON pos.flurnamepos_von = flurname.t_id
    LEFT JOIN agi_dm01avso24.nomenklatur_nknachfuehrung AS nachfuehrung
        ON flurname.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON flurname.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
