DELETE FROM awjf_waldplan_v2.waldplancatalgues_forstrevier;

INSERT INTO awjf_waldplan_v2.waldplancatalgues_forstrevier (
	aname,
	t_basket,
	t_datasetname,
	t_lastchange,
	t_createdate,
	t_user
)

SELECT DISTINCT
	CASE 
		WHEN fid_fr = 1
			THEN 'Grenchen'
		WHEN fid_fr = 2
			THEN 'Leberberg'
		WHEN fid_fr = 3
			THEN 'Bucheggberg'
		WHEN fid_fr = 4
			THEN 'Wasseramt'
		WHEN fid_fr = 5
			THEN 'Solothurn'
		WHEN fid_fr = 6
			THEN 'Vorderes Thal'
		WHEN fid_fr = 8
			THEN 'Dünnerntal'
		WHEN fid_fr = 9
			THEN 'Roggen'
		WHEN fid_fr = 10
			THEN 'Oberes Gäu'
		WHEN fid_fr = 11
			THEN 'Mittleres Gäu'
		WHEN fid_fr = 13
			THEN 'Untergäu'
		WHEN fid_fr = 15
			THEN 'Unterer Hauenstein'
		WHEN fid_fr = 18
			THEN 'Niederamt'
		WHEN fid_fr = 19
			THEN 'Dorneckberg Nord'
		WHEN fid_fr = 20
			THEN 'Schwarzbubenland'
		WHEN fid_fr = 21
			THEN 'Am Blauen'
		WHEN fid_fr = 24
			THEN 'Thierstein West/Laufental'	
	END AS aname,
	b.t_id,
	d.datasetname,
	CURRENT_TIMESTAMP AS t_lastchange,
	CURRENT_TIMESTAMP AS t_createdate,
	'Datenmigration' t_user
FROM 
	awjf_waldplan_bestandeskarte_v1.waldplan_bestandeskarte
CROSS JOIN (
	SELECT
		t_id
	FROM
		awjf_waldplan_v2.t_ili2db_basket
	WHERE 
		attachmentkey = 'admin.awjf_waldplan.xtf-1') AS b 
CROSS JOIN (
	SELECT
		datasetname 
	FROM 
		awjf_waldplan_v2.t_ili2db_dataset
	WHERE 
		t_id = 1) AS d
	