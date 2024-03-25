delete from afu_naturgefahren_staging_v1.t_ili2db_basket;
delete from afu_naturgefahren_staging_v1.t_ili2db_dataset;

with 
dataset as (
    select
        t_id  as dataset  
    from 
        afu_naturgefahren_v1.t_ili2db_dataset
    where 
        datasetname = ${kennung}
)

,insert_dataset as (
     insert into 
         afu_naturgefahren_staging_v1.t_ili2db_dataset (t_id, datasetname)
         select 
             nextval('afu_naturgefahren_staging_v1.t_ili2db_seq'::regclass) as t_id,
             ${kennung} as datasetname 
     returning t_id
 )
 
 insert into 
     afu_naturgefahren_staging_v1.t_ili2db_basket (t_id, dataset, topic, attachmentkey)
     select 
         nextval('afu_naturgefahren_staging_v1.t_ili2db_seq'::regclass) as t_id,
         insert_dataset.t_id as dataset, 
         'SO_AFU_Naturgefahren_Kernmodell_20231016.Naturgefahren' as topic, 
         ${kennung}  as attachmentkey 
     from 
         insert_dataset