SELECT
	erdwaermesonden_anlage.anlage_uuid,
	bohrung_nummer AS nummer,
	status_code AS anlage_status_code,
	status_text AS anlage_status_text,
	bezeichnung AS anlage_bezeichnung,
	anzahl_bohrloecher AS anlage_anzahl_bohrloecher,
	grundbuchnummer_text AS anlage_grundbuchnummer_text,
	datum_bewilligung AS anlage_datum_bewilligung,
	gemeindename AS anlage_gemeindename,
	sondenmeter_summe AS anlage_sondenmeter_summe,
	leistung AS anlage_leistung,
	CASE
	WHEN 'ja' = LOWER(waermeeintrag) THEN TRUE
	ELSE FALSE
	END AS anlage_waermeeintrag,
	waermequelle_code,
	waermequelle_text,
	bohrtiefe,
	vorkommnisse,
	CASE
		WHEN bohrprofil_link IS NULL THEN NULL
		WHEN bohrprofil_link = '' THEN NULL
		ELSE CONCAT_WS('', bohrprofil_link, ' \r\n Aufgrund einer Stoerung kann der Link nicht aus dem Internet aufgerufen werden. Die Stoerung wird schnellstmoeglich behoben.')
	END AS bohrprofil_link,
	COALESCE(bohrprofil_vorhanden, FALSE) AS bohrprofil_vorhanden,
	COALESCE(erdwaermesonden_bohrung.geometrie, erdwaermesonden_anlage.geometrie) AS geometrie
FROM
	afu_erdwaermesonden.erdwaermesonden_anlage
	LEFT JOIN afu_erdwaermesonden.erdwaermesonden_bohrung
		ON erdwaermesonden_anlage.anlage_uuid = erdwaermesonden_bohrung.anlage_uuid
WHERE 
	geschaeftsstatus_code = 'ComEwsStatusVgr-abg'