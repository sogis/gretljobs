WITH
dataset AS (
    SELECT
        t_id  AS dataset  
    FROM 
        afu_naturgefahren_v1.t_ili2db_dataset
    WHERE 
        datasetname = ${kennung}
)

,insert_dataset AS (
    INSERT INTO 
        afu_naturgefahren_staging_v1.t_ili2db_dataset (t_id, datasetname)
        SELECT 
            nextval('afu_naturgefahren_staging_v1.t_ili2db_seq'::regclass) AS t_id,
            ${kennung} AS datasetname 
    RETURNING t_id
)
 
INSERT INTO 
    afu_naturgefahren_staging_v1.t_ili2db_basket (t_id, dataset, topic, attachmentkey)
    SELECT 
        nextval('afu_naturgefahren_staging_v1.t_ili2db_seq'::regclass) AS t_id,
        insert_dataset.t_id AS dataset, 
        'SO_AFU_Naturgefahren_Kernmodell_20231016.Naturgefahren' AS topic, 
        ${kennung}  AS attachmentkey 
    FROM 
        insert_dataset
;