WITH

ovitraps AS (
	SELECT
		*
	FROM (
		SELECT 
			trapid,
			plz || ' ' || ort AS gemeinde,
			standort,
			lv95_e,
			lv95_n,
			art,
			SamMethode AS Sammelmethode,
			TO_DATE(datumsam, 'MM.DD.YYYY') AS sammeldatum,

			-- Anzahl positive und negative Funde
			COUNT(*) FILTER (WHERE positiv = 'Ja') OVER (PARTITION BY trapid) AS anzahl_positv,
			COUNT(*) FILTER (WHERE positiv = 'Nein') OVER (PARTITION BY trapid) AS anzahl_negativ,
		
			-- 🆕 letztes positives Datum
			MAX(
				CASE 
					WHEN LOWER(TRIM(positiv)) = 'ja' 
					THEN TO_DATE(datumsam, 'MM.DD.YYYY')
				END
			) OVER (PARTITION BY trapid) AS letztes_positiv_datum,
			
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie,

			-- neuester Datensatz bestimmen
			ROW_NUMBER() OVER (
				PARTITION BY trapid 
				ORDER BY TO_DATE(datumsam, 'MM.DD.YYYY') DESC
			) AS rn

		FROM 
			gesa_tigermueckenfundstellen_v1.csv_import
	) AS t
	WHERE
		rn = 1
	AND 
		t.sammelmethode = 'Ovitrap'
)

meldungen AS (
	SELECT 
		trapid,
		CONCAT_WS(' ', plz::text, ort) AS Gemeinde,
		standort,
		lv95_e,
		lv95_n,
		art,
		'Meldung durch Privatperson' AS Sammelmethode,
		TO_DATE(datumsam, 'MM.DD.YYYY') AS sammeldatum,
		ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
	FROM 
		gesa_tigermueckenfundstellen_v1.csv_import
	WHERE 
		SamMethode IS DISTINCT FROM 'Ovitrap'
)
;
