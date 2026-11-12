DELETE FROM 
	awjf_nais_schutzwald_v1.nais_dokument
;

INSERT INTO awjf_nais_schutzwald_v1.nais_dokument (
	geometrie,
	dokument,
	jahr,
	nais_code,
	beschreibung
)

SELECT
	geometrie,
	dokument,
	jahr,
	nais_code,
	beschreibung
FROM 
	awjf_schutzwald_v1.dokument
WHERE 
	dokument != 'test'