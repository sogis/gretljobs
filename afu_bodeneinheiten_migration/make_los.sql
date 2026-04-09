WITH dataset AS ( 
    SELECT  
        t_id
    FROM 
        afu_bodeneinheiten_v1.t_ili2db_dataset 
    WHERE  
        datasetname = 'migration'
), 
basket AS (
    SELECT 
        t_id  
    FROM 
        afu_bodeneinheiten_v1.t_ili2db_basket 
    WHERE  
        attachmentkey = 'migration'
)

INSERT INTO afu_bodeneinheiten_v1.los (
    t_basket, 
    t_datasetname,
    los, 
    mit_geometrie, 
    publizieren
)
SELECT
    basket.t_id, 
    dataset.t_id,
    los, 
    'true', 
    'true'
FROM 
    afu_bodeneinheiten_v1.import_table, 
    dataset, 
    basket
GROUP BY 
    basket.t_id,
    dataset.t_id,
    los
;
