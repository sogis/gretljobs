-- Delete dataset and baskets --
DELETE FROM awjf_waldplan_pub_v2.t_ili2db_dataset CASCADE;

-- restart t_id sequence --
ALTER SEQUENCE awjf_waldplan_pub_v2.t_ili2db_seq RESTART WITH 1;
;

-- insert admin dataset --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_dataset (
	t_id,
	datasetname
)
VALUES (
	nextval('awjf_waldplan_pub_v2.t_ili2db_seq'::regclass),
	'admin'
	)
;

-- insert bfsnr as dataset --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_dataset (
	t_id,
	datasetname
)

SELECT
	nextval('awjf_waldplan_pub_v2.t_ili2db_seq'::regclass),
	bfs_gemeindenummer AS datasetname
FROM 
	agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
;

-- insert basket (admin) --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_basket (
	t_id,
	dataset,
	topic,
	t_ili_tid,
	attachmentkey
)

SELECT
	nextval('awjf_waldplan_pub_v2.t_ili2db_seq'::regclass),
	t_id AS dataset,
	'SO_AWJF_Waldplan_20250312.Waldplankatalog' AS topic,
	uuid_generate_v4(),
	datasetname || '.' || 'awjf_waldplan.xtf-1'
FROM 
	awjf_waldplan_pub_v2.t_ili2db_dataset
WHERE 
	t_id = 1
;

-- insert basket (bfsnr) --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_basket (
	t_id,
	dataset,
	topic,
	t_ili_tid,
	attachmentkey
)

SELECT
	nextval('awjf_waldplan_pub_v2.t_ili2db_seq'::regclass),
	t_id AS dataset,
	'SO_AWJF_Waldplan_20250312.Waldplan' AS topic,
	uuid_generate_v4(),
	datasetname || '.' || 'awjf_waldplan.xtf-1'
FROM 
	awjf_waldplan_pub_v2.t_ili2db_dataset
WHERE
	t_id > 1
;
