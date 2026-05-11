---------------------------------------------------------------------------------------------------------
-- Wenn das Pub-Schema neu erstellt wurde, wird ein einmaliger Import von Dataset und Baskets benötigt --
-- Dazu kann dieses SQL verwendet werden --
---------------------------------------------------------------------------------------------------------

-- Dataset Admin --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_dataset (
	t_id,
	datasetname
)
VALUES (
	nextval('awjf_waldplan_pub_v2.t_ili2db_seq'::regclass),
	'admin'
	)
;

-- Dataset BFSNR --
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


-- Basket Admin Waldplan --
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
	'SO_AWJF_Waldplan_Publikation_20250312.Waldplan' AS topic,
	uuid_generate_v4(),
	datasetname || '.' || 'awjf_waldplan.xtf-1'
FROM 
	awjf_waldplan_pub_v2.t_ili2db_dataset
WHERE 
	t_id = 1
;

-- Basket BFSNR Waldplan --
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
	'SO_AWJF_Waldplan_Publikation_20250312.Waldplan' AS topic,
	uuid_generate_v4(),
	datasetname || '.' || 'awjf_waldplan.xtf-1'
FROM 
	awjf_waldplan_pub_v2.t_ili2db_dataset
WHERE
	t_id > 1
;

-- Basket Admin Waldplan Auswertung --
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
	'SO_AWJF_Waldplan_Publikation_20250312.Waldplan_Auswertung' AS topic,
	uuid_generate_v4(),
	datasetname || '.' || 'awjf_waldplan_auswertung.xtf-1'
FROM 
	awjf_waldplan_pub_v2.t_ili2db_dataset
WHERE 
	t_id = 1
;

-- Basket BFSNR Waldplan_Auswertung --
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
	'SO_AWJF_Waldplan_Publikation_20250312.Waldplan_Auswertung' AS topic,
	uuid_generate_v4(),
	datasetname || '.' || 'awjf_waldplan_auswertung.xtf-1'
FROM 
	awjf_waldplan_pub_v2.t_ili2db_dataset
WHERE
	t_id > 1
;