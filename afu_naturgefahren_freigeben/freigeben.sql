WITH 
dataset_id AS (
    SELECT
        t_id 
    FROM 
        afu_naturgefahren_v2.t_ili2db_dataset 
    WHERE 
        datasetname = ${kennung}
),

main_dataset AS (
    SELECT 
        t_id 
    FROM 
        afu_naturgefahren_v2.t_ili2db_dataset
    WHERE 
        datasetname = 'main'
)

UPDATE 
    afu_naturgefahren_v2.t_ili2db_basket 
SET 
    dataset = main_dataset.t_id 
FROM 
    dataset_id, 
    main_dataset 
WHERE 
    dataset = dataset_id.t_id
;

DELETE FROM 
    afu_naturgefahren_v2.t_ili2db_dataset
WHERE 
    datasetname = ${kennung}
;