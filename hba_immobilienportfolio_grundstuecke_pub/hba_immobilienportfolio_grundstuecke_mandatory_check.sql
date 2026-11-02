DELETE FROM
	hba_immobilienportfolio_v2.grundstuecke_grundstueckemandatory
;

INSERT INTO hba_immobilienportfolio_v2.grundstuecke_grundstueckemandatory (
	id_gr,
	we,
	vermoegensart,
	prio,
	egrid,
	eigenbedarf,
	fach_verantwortung,
	baurecht,
	jahr_veraeussert
)

SELECT
	id_gr,
	we,
	vermoegensart,
	prio,
	egrid,
	eigenbedarf,
	fach_verantwortung,
	baurecht,
	jahr_veraeussert
FROM
	hba_immobilienportfolio_v2.grundstuecke_csv_import
WHERE
	baurecht IS NULL
AND
	jahr_veraeussert IS NULL
;