SELECT
    objektnamepos.pos AS wkb_geometry,
    objektnamepos.ori AS namori,
    CASE 
        WHEN objektnamepos.hali = 'Left'
            THEN 0   
        WHEN objektnamepos.hali = 'Center'
            THEN 1   
        WHEN objektnamepos.hali = 'Right'
            THEN 2   
    END AS namhali,
    CASE 
        WHEN objektnamepos.vali = 'Top'
            THEN 0   
        WHEN objektnamepos.vali = 'Cap'
            THEN 1   
        WHEN objektnamepos.vali = 'Half'
            THEN 2   
        WHEN objektnamepos.vali = 'Base'
            THEN 3   
        WHEN objektnamepos.vali = 'Bottom'
            THEN 4   
    END AS namvali,
    CASE 
        WHEN objektnamepos.groesse = 'klein'
            THEN 0
        WHEN objektnamepos.groesse = 'mittel'
            THEN 1
        WHEN objektnamepos.groesse = 'gross'
            THEN 2
    END AS namhoehe,       
    objektname.aname AS name,
    CAST(objektname.t_datasetname AS INT) AS gem_bfs,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    0 AS archive,
    CASE
        WHEN objektnamepos.ori >= 0 AND objektnamepos.ori < 100
            THEN (100-objektnamepos.ori)*0.9
        WHEN objektnamepos.ori = 100
            THEN 360
        WHEN objektnamepos.ori > 100 AND objektnamepos.ori <= 400
            THEN ((100-objektnamepos.ori)*0.9)+360
    END AS txt_rot,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.bodenbedeckung_objektname AS objektname
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON objektname.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.bodenbedeckung_objektnamepos AS objektnamepos
        ON objektname.t_id = objektnamepos.objektnamepos_von
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
