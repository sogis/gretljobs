SELECT
	anlagename AS nachname_anlagebesitzer,
	anlagevorname AS vorname_anlagebesitzer,
	betreuername AS name_betreuer,
	betreuervorname AS vorname_betreuer,
	gewaesser AS vorfluter,
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
	angeinwohner AS anz_angeschlossene_einwohner,
	CASE
		WHEN aufgehoben = 'WAHR'
			THEN TRUE
		WHEN aufgehoben = 'FALSCH'
			THEN FALSE
		ELSE NULL 
	END AS aufgehoben,
	CASE
		WHEN aufgehoben = 'WAHR'
			THEN 'Ja'
		WHEN aufgehoben = 'FALSCH'
			THEN 'Nein'
		ELSE NULL
	END AS aufgehoben_txt,
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
	END AS versicherkung_gewaesser,
	CASE
		WHEN gewaesser_versickerung = 'WAHR'
			THEN 'Ja'
		WHEN gewaesser_versickerung = 'FALSCH'
			THEN 'Nein'
		ELSE null
	END AS versicherkung_gewaesser_txt,
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
	anlagenummer AS nummer,
	anlagestandort AS gemeindename,
	ST_SetSRID(ST_MakePoint(x_koordinate, y_koordinate), 2056) AS geometrie
FROM
	afu_klaeranlagen_v1.klaeranlagen_kleinklaeranlage_import
;