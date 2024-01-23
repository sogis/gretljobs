WITH

 dokument_new AS (
 SELECT
    d.dateiname,
    fd.filterbrunnen_r,
    kd.kontrollschacht_r,
    pd.pumpwerk_r,
    qgd.quelle_gefasst_r,
    qd.quellwasserbehaelter_r,
    rd.reservoir_r,
    sd.sammelbrunnstube_r
    FROM afu_wasserversorg_obj_v1.dokument d
    LEFT JOIN afu_wasserversorg_obj_v1.filterbrunnen__dokument fd  ON d.t_id = fd.dokument_r
    LEFT JOIN afu_wasserversorg_obj_v1.kontrollschacht__dokument kd  ON d.t_id = kd.dokument_r
    LEFT JOIN afu_wasserversorg_obj_v1.pumpwerk__dokument pd ON d.t_id = pd.dokument_r
    LEFT JOIN afu_wasserversorg_obj_v1.quelle_gefasst__dokument qgd  ON d.t_id = qgd.dokument_r
    LEFT JOIN afu_wasserversorg_obj_v1.quellwasserbehaelter__dokument qd  ON d.t_id = qd.dokument_r
    LEFT JOIN afu_wasserversorg_obj_v1.reservoir__dokument rd  ON d.t_id = rd.dokument_r
    LEFT JOIN afu_wasserversorg_obj_v1.sammelbrunnstube__dokument sd ON d.t_id = sd.dokument_r
),

dokumente_filterbrunnen AS (
SELECT
	n.filterbrunnen_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.filterbrunnen_r
),

dokumente_kontrollschacht AS (
SELECT
	n.kontrollschacht_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.kontrollschacht_r
),

dokumente_pumpwerk AS (
SELECT
	n.pumpwerk_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.pumpwerk_r
),

dokumente_quelle_gefasst AS (
SELECT
	n.quelle_gefasst_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.quelle_gefasst_r
),

dokumente_quellwasserbehaelter AS (
SELECT
	n.quellwasserbehaelter_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.quellwasserbehaelter_r
),

dokumente_reservoir AS (
SELECT
	n.reservoir_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.reservoir_r
),

dokumente_sammelbrunnstube AS (
SELECT
	n.sammelbrunnstube_r,
	concat('[',string_agg(concat('"',n.dateiname, '"'), ','),']') AS dokumente
	FROM dokument_new n
	GROUP BY n.sammelbrunnstube_r
),

pumpwerk AS (
	SELECT 
		'Pumpwerk' AS trinkwasserobjektart,
		'Pumpwerk' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		dp.dokumente,
		geometrie
	FROM
		afu_wasserversorg_obj_v1.pumpwerk
		LEFT JOIN dokumente_pumpwerk dp ON t_id = dp.pumpwerk_r
),

reservoir AS (
	SELECT
		'Reservoir' AS trinkwasserobjektart,
		'Reservoir' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		dr.dokumente,
		geometrie
	FROM
		afu_wasserversorg_obj_v1.reservoir
		LEFT JOIN dokumente_reservoir dr ON t_id = dr.reservoir_r
),

sammelbrunnstube AS (
	SELECT
		'Sammelbrunnstube' AS trinkwasserobjektart,
		'Sammelbrunnstube' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		ds.dokumente,
		geometrie
	FROM
		afu_wasserversorg_obj_v1.sammelbrunnstube
		LEFT JOIN dokumente_sammelbrunnstube ds ON t_id = ds.sammelbrunnstube_r
),

kontrollschacht AS (
	SELECT
		'Kontrollschacht' AS trinkwasserobjektart,
		'Kontrollschacht' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		dk.dokumente,
		geometrie
	FROM
		afu_wasserversorg_obj_v1.kontrollschacht
		LEFT JOIN dokumente_kontrollschacht dk ON t_id = dk.kontrollschacht_r
),

quellwasserbehaelter AS (
	SELECT
		'Quellwasserbehaelter' AS trinkwasserobjektart,
		'Quellwasserbehälter' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		dq.dokumente,
		geometrie
	FROM
		afu_wasserversorg_obj_v1.quellwasserbehaelter
		LEFT JOIN dokumente_quellwasserbehaelter dq ON t_id = dq.quellwasserbehaelter_r
),

trinkwasserversorgung AS (
	SELECT * FROM pumpwerk
	UNION ALL
	SELECT * FROM reservoir
	UNION ALL
	SELECT * FROM sammelbrunnstube
	UNION ALL
	SELECT * FROM kontrollschacht
	UNION ALL
	SELECT * FROM quellwasserbehaelter
)

SELECT * FROM trinkwasserversorgung;

