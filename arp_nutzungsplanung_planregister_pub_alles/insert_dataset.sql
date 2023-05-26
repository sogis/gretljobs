-- Dataset anlegen
WITH dataset AS (
VALUES
(nextval('arp_nutzungsplanung_planregister_pub_v1.t_ili2db_seq'::regclass),'gewaesserschutz'),
(nextval('arp_nutzungsplanung_planregister_pub_v1.t_ili2db_seq'::regclass),'nutzungsplanung_kantonal'),
(nextval('arp_nutzungsplanung_planregister_pub_v1.t_ili2db_seq'::regclass),'naturreservate'),
(nextval('arp_nutzungsplanung_planregister_pub_v1.t_ili2db_seq'::regclass),'statische_waldgrenze')
).

dataset_kommunal AS (
    SELECT
        nextval('arp_nutzungsplanung_planregister_pub_v1.t_ili2db_seq'::regclass) AS t_id,
        'nutzungsplanung_kommunal' || '_' || nutzungsplanung.datasetname AS datasetname
    FROM
        arp_nutzungsplanung_v1.t_ili2db_dataset AS nutzungsplanung
)
        
SELECT
    column1 AS t_id,
    column2 AS datasetname
FROM 
    dataset
    
UNION

SELECT
    t_id,
    datasetname
FROM 
    dataset_kommunal
;
