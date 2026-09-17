SELECT
	CASE
		WHEN anlagetyp = 'MBR'
			THEN 'Membranbioreaktor'
		WHEN anlagetyp = 'ONE SBR'
			THEN 'Einkammer SBR'
		WHEN anlagetyp = 'SBR'
			THEN 'Mehrkammer SBR'
		WHEN anlagetyp = 'Tropfkörper'
			THEN 'Tropfkörper berieselt'
		WHEN anlagetyp = 'UTB HKA'
			THEN 'System UTW'
		ELSE anlagetyp
	END AS anlagentyp,
	groesseeg AS groesse_eg,
	CASE
		WHEN aufgehoben = 'WAHR'
			THEN FALSE
		WHEN aufgehoben = 'FALSCH'
			THEN TRUE
		ELSE NULL 
	END AS in_betrieb,
	CASE
		WHEN aufgehoben = 'WAHR'
			THEN 'Nein'
		WHEN aufgehoben = 'FALSCH'
			THEN 'Ja'
		ELSE NULL
	END AS in_betrieb_txt,
	CASE
		WHEN gewaesser_drainagen = 'WAHR'
			THEN TRUE
		WHEN gewaesser_drainagen = 'FALSCH'
			THEN FALSE
		ELSE null
	END AS ableitung_drainage,
	CASE
		WHEN gewaesser_drainagen = 'WAHR'
			THEN 'Ja'
		WHEN gewaesser_drainagen = 'FALSCH'
			THEN 'Nein'
		ELSE NULL
	END AS ableitung_drainage_txt,
	CASE
		WHEN gewaesser_versickerung = 'WAHR'
			THEN TRUE
		WHEN gewaesser_versickerung = 'FALSCH'
			THEN FALSE
		ELSE null
	END AS versickerung_gewaesser,
	CASE
		WHEN gewaesser_versickerung = 'WAHR'
			THEN 'Ja'
		WHEN gewaesser_versickerung = 'FALSCH'
			THEN 'Nein'
		ELSE null
	END AS versickerung_gewaesser_txt,
	CASE
		WHEN gewaesser IS NOT NULL
			THEN TRUE
		ELSE FALSE 
	END AS ableitung_gewaesser,
	CASE
		WHEN gewaesser IS NOT NULL
			THEN 'Ja'
		ELSE 'Nein' 
	END AS ableitung_gewaesser_txt,
	anlagenummer,
	anlagestandort AS gemeindename,
	gewaesser,
	x_einleitstelle,
	y_einleitstelle,
	ST_SetSRID(ST_MakePoint(x_koordinate, y_koordinate), 2056) AS geometrie
FROM
	afu_klaeranlagen_v1.klaeranlagen_kleinklaeranlage_import
;