delete from afu_naturgefahren_staging_v1.t_ili2db_basket;
delete from afu_naturgefahren_staging_v1.t_ili2db_dataset;

with 
auftrag_basket as (
    select 
        t_basket 
    from 
        afu_naturgefahren_v1.auftrag 
    where 
        kennung = ${kennung}
), 

att_key as (
    select distinct 
        attachmentkey 
    from 
        afu_naturgefahren_v1.t_ili2db_basket,
        auftrag_basket
    where 
        t_id = auftrag_basket.t_basket
), 
        
basket as (
    select 
        t_id,
        dataset, 
        topic 
    from 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        att_key
    where 
        basket.attachmentkey = att_key.attachmentkey 
       and 
       topic like '%Befunde'
 ),
 
datasetname as (
    select 
       datasetname 
    from
       afu_naturgefahren_v1.t_ili2db_dataset
    where 
       t_id = (select dataset from basket)
 ),
 
 insert_dataset as (
     insert into 
         afu_naturgefahren_staging_v1.t_ili2db_dataset (t_id, datasetname)
         select 
             nextval('afu_naturgefahren_staging_v1.t_ili2db_seq'::regclass) as t_id,
             datasetname 
         from
             datasetname
     returning t_id
 )
 
 insert into 
     afu_naturgefahren_staging_v1.t_ili2db_basket (t_id, dataset, topic, attachmentkey)
     select 
         nextval('afu_naturgefahren_staging_v1.t_ili2db_seq'::regclass) as t_id,
         insert_dataset.t_id as dataset, 
         basket.topic as topic, 
         att_key.attachmentkey  as attachmentkey 
     from 
         insert_dataset,
         basket,
         att_key
 