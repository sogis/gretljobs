DELETE FROM awjf_waldplan_v2.waldplankatalog_forstbetrieb;

INSERT INTO awjf_waldplan_v2.waldplankatalog_forstbetrieb (
	aname,
	t_basket,
	t_datasetname,
	t_lastchange,
	t_createdate,
	t_user
)

SELECT
	fb.aname,
	b.t_id,
	d.datasetname,
	CURRENT_TIMESTAMP AS t_lastchange,
	CURRENT_TIMESTAMP AS t_createdate,
	'Datenmigration' t_user
FROM (VALUES
	('FR Untergäu'),
	('Wangen bei Olten'),
	('Kappel'),
	('Schwarzbubenland'),
	('Nunningen'),
	('Zullwil'),
	('Am Blauen'),
	('Forst Dünnerntal'),
	('Forst Thal'),
	('Dorneckberg'),
	('Laufental-Thierstein West'),
	('Bucheggberg'),
	('Unterramsern'),
	('Brunnenthal'),
	('Leberberg'),
	('Bellach'),
	('Kammersohr'),
	('Unterer Hauenstein'),
	('Forst Mittleres Gäu'),
	('Fulenbach'),
	('Egerkingen'),
	('Niederamt'),
	('Erlinsbach'),
	('Walterswil'),
	('Niedergösgen'),
	('Obererlinsbach'),
	('Kienberg'),
	('Solothurn'),
	('Grenchen'),
	('Oensingen'),
	('Oberbuchsiten'),
	('Oberes Gäu'),
	('Kestenholz'),
	('Niederbuchsiten'),
	('Wolfwil'),
	('Staatswald Buchban'),
	('Wasseramt AG'),
	('Aeschi'),
	('Ammannsegg'),
	('Biberist'),
	('Bolken'),
	('Deitingen'),
	('Derendingen'),
	('Etziken'),
	('Gerlafingen'),
	('Halten'),
	('Horriwil'),
	('Hüniken'),
	('Kriegestetten'),
	('Lohn'),
	('Luterbach'),
	('Obergerlafingen'),
	('Recherswil'),
	('Subingen'),
	('Winistorf'),
	('Zuchwil'),
	('Drei Höfe')
) AS fb(aname)
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
	