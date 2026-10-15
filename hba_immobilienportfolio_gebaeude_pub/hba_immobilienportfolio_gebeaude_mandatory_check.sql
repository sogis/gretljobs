DELETE FROM
	hba_immobilienportfolio_v2.gebaeude_gebaeudemandatory
;

INSERT INTO hba_immobilienportfolio_v2.gebaeude_gebaeudemandatory (
	vermoegensart,
	prio,
	baujahr_gruppe,
	egid,
	id_ge,
	we,
	nutzung,
	gebaeude_bez,
	eigenbedarf,
	anmiete,
	vermietet,
	link,
	name_geb,
	email_geb,
	name_hw,
	email_hw
)

SELECT
	vermoegensart,
	prio,
	baujahr_gruppe,
	egid,
	id_ge,
	we,
	nutzung,
	gebaeude_bez,
	eigenbedarf,
	anmiete,
	vermietet,
	link,
	name_geb,
	email_geb,
	name_hw,
	email_hw
FROM 
	hba_immobilienportfolio_v2.gebaeude_csv_import
WHERE
	anmiete IS NULL
AND
	vermietet IS NULL
;