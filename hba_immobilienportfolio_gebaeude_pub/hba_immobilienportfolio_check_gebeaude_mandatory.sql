DELETE FROM
	hba_immobilienportfolio_gebaeude_v2.gebaeude_gebaeudemandatory
;

INSERT INTO hba_immobilienportfolio_gebaeude_v2.gebaeude_gebaeudemandatory (
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
	verantwortung_geb,
	email_geb,
	verantwortung_hw,
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
	verantwortung_geb,
	email_geb,
	verantwortung_hw,
	email_hw
FROM
	hba_immobilienportfolio_gebaeude_v2.gebaeude_csv_import
WHERE
	anmiete IS NULL
AND
	vermietet IS NULL
;