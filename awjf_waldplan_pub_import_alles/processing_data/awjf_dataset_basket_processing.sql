DELETE FROM awjf_waldplan_pub_v2.t_ili2db_basket;
DELETE FROM awjf_waldplan_pub_v2.t_ili2db_dataset;

INSERT INTO awjf_waldplan_pub_v2.t_ili2db_dataset
SELECT
	t_id,
	datasetname
FROM
	awjf_waldplan_v2.t_ili2db_dataset
;

-- insert basket (admin) --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_basket
SELECT 
	basket.t_id,
	basket.dataset,
	'SO_AWJF_Waldplan_Publikation_20250312.Waldplankatalog' AS topic,
	basket.t_ili_tid,
	basket.attachmentkey,
	basket.domains
FROM
	awjf_waldplan_v2.t_ili2db_basket AS basket
LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
	ON basket.dataset = dataset.t_id
WHERE
	dataset.datasetname = 'admin'
;

-- insert basket (bfsnr) --
INSERT INTO awjf_waldplan_pub_v2.t_ili2db_basket
SELECT 
	basket.t_id,
	basket.dataset,
	'SO_AWJF_Waldplan_Publikation_20250312.Waldplan' AS topic,
	basket.t_ili_tid,
	basket.attachmentkey,
	basket.domains
FROM
	awjf_waldplan_v2.t_ili2db_basket AS basket
LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
	ON basket.dataset = dataset.t_id
WHERE
	dataset.datasetname != 'admin'
;