SELECT
	  erdwaermesonden_bohrung.t_id,
      erdwaermesonden_bohrung.anlage_uuid,
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
      bohrprofil_link,
      bohrprofil_vorhanden,
      erdwaermesonden_bohrung.geometrie
FROM
	afu_erdwaermesonden.erdwaermesonden_bohrung
	INNER JOIN afu_erdwaermesonden.erdwaermesonden_anlage
		ON erdwaermesonden_bohrung.anlage_uuid = erdwaermesonden_anlage.anlage_uuid
WHERE 
	geschaeftsstatus_code = 'ComEwsStatusVgr-abg'