DELETE FROM awjf_waldplan_pub_v2.t_ili2db_basket;
DELETE FROM awjf_waldplan_pub_v2.t_ili2db_dataset;

INSERT INTO awjf_waldplan_pub_v2.t_ili2db_dataset
SELECT
	t_id,
	datasetname
FROM
	awjf_waldplan_v2.t_ili2db_dataset
;

INSERT INTO awjf_waldplan_pub_v2.t_ili2db_basket
SELECT 
	basket.t_id,
	basket.dataset,
	basket.topic,
	basket.t_ili_tid,
	basket.attachmentkey,
	basket.domains
FROM
	awjf_waldplan_v2.t_ili2db_basket AS basket
LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
	ON basket.dataset = dataset.t_id
;