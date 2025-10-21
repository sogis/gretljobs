DELETE FROM awjf_waldplan_v2.waldplan_schutzwald;

WITH 

dataset_gemeinde AS (
	SELECT
		dataset.t_id,
		dataset.datasetname,
		gemeinde.aname AS gemeindename
	FROM
		awjf_waldplan_v2.t_ili2db_dataset AS dataset
	LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeinde AS gemeinde
		ON dataset.datasetname = gemeinde.bfsnr::text
),

schutzwald AS (
	SELECT
		schutzwald_nr2,
		CASE 
			WHEN sturz IS TRUE
				THEN TRUE 
			ELSE FALSE
		END AS sturz,
		CASE 
			WHEN rutsch IS TRUE
				THEN TRUE 
			ELSE FALSE
		END AS rutsch,
		CASE 
			WHEN gerinnerelevante_prozesse IS TRUE
				THEN TRUE 
			ELSE FALSE
		END AS gerinnerelevante_prozesse,
		CASE 
			WHEN lawine IS TRUE
				THEN TRUE 
			ELSE FALSE
		END AS lawine,
		CASE 
			WHEN andere_kt IS TRUE
				THEN TRUE 
			ELSE FALSE
		END AS andere_kt,
		objektkategorie,
		schadenpotential,
		hauptgefahrenpotential,
		intensitaet_geschaetzt,
		CASE
			WHEN schutzwald_nr2 = 'STÜS-09'
				THEN 'Stüsslingen'
			WHEN schutzwald_nr2 = 'LÜGÄ-01'
				THEN 'Buchegg'
			ELSE gemeinde 
		END AS gemeinde,
		bemerkungen
FROM 
	awjf_schutzwald_v1.schutzwald AS sw
)

INSERT INTO awjf_waldplan_v2.waldplan_schutzwald (
	t_basket,
	t_datasetname,
	schutzwald_nr,
	sturz,
	rutsch,
	gerinnerelevante_prozesse,
	lawine,
	andere_kt,
	objektkategorie,
	schadenpotential,
	hauptgefahrenpotential,
	intensitaet_geschaetzt,
	bemerkungen 
)

SELECT
	basket.t_id AS t_basket,
	dataset.datasetname AS t_datasetname,
	sw.schutzwald_nr2 AS schutzwald_nr,
	sw.sturz,
	sw.rutsch,
	sw.gerinnerelevante_prozesse,
	sw.lawine,
	sw.andere_kt,
	sw.objektkategorie,
	sw.schadenpotential,
	sw.hauptgefahrenpotential,
	sw.intensitaet_geschaetzt,
	sw.bemerkungen
FROM 
	schutzwald AS sw
LEFT JOIN dataset_gemeinde AS dataset
	ON sw.gemeinde = dataset.gemeindename
LEFT JOIN awjf_waldplan_v2.t_ili2db_basket AS basket 
	ON dataset.t_id = basket.dataset
	