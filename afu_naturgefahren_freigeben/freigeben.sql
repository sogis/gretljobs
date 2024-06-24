-- Naturgefahren
with dataset_id as (
    select
        t_id 
    from 
        afu_naturgefahren_v2.t_ili2db_dataset 
    where 
        datasetname = ${kennung}
),

main_dataset as (
    select 
        t_id 
    from 
        afu_naturgefahren_v2.t_ili2db_dataset
    where 
        datasetname = 'main'
)

update 
    afu_naturgefahren_v2.t_ili2db_basket 
set 
    dataset = main_dataset.t_id 
from 
    dataset_id, 
    main_dataset 
where 
    dataset = dataset_id.t_id
;

delete from 
    afu_naturgefahren_v2.t_ili2db_dataset
where 
    datasetname = ${kennung}
;

--Beurteilungsgebiet
with dataset_id as (
    select
        t_id 
    from 
        afu_naturgefahren_beurteilungsgebiet_v1.t_ili2db_dataset 
    where 
        datasetname = ${kennung}
),

main_dataset as (
    select 
        t_id 
    from 
        afu_naturgefahren_beurteilungsgebiet_v1.t_ili2db_dataset
    where 
        datasetname = 'main'
)

update 
    afu_naturgefahren_beurteilungsgebiet_v1.t_ili2db_basket 
set 
    dataset = main_dataset.t_id 
from 
    dataset_id, 
    main_dataset 
where 
    dataset = dataset_id.t_id
;

delete from 
    afu_naturgefahren_beurteilungsgebiet_v1.t_ili2db_dataset
where 
    datasetname = ${kennung}
;
