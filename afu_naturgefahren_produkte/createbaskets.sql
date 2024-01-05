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
),

basket as (
    select 
        basket.t_id,
        basket.topic,
        basket.attachmentkey
    from 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        dataset
    where 
        basket.dataset = dataset.dataset
        and 
        topic like '%Befunde'
),
 
 insert_dataset as (
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
         basket.topic as topic, 
         basket.attachmentkey  as attachmentkey 
     from 
         insert_dataset,
         basket
 
