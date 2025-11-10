WITH

daten_afu AS (
	SELECT
		platz.t_id AS Bootsanbindeplatz_ID,
		kontakt.aname,
		kontakt.vorname,
		kontakt.strasse_nr,
		kontakt.plz,
		kontakt.ort,
		boot.bootskennzeichen,
		boot.bootslaenge,
		platz.geometrie
	FROM
		editdb.afu_bootsanbindeplaetze_v1.bootsanbindeplatz AS platz
	LEFT JOIN editdb.afu_bootsanbindeplaetze_v1.bootsdaten AS boot 
		ON platz.bootsdaten_r = boot.t_id
	LEFT JOIN editdb.afu_bootsanbindeplaetze_v1.kontaktdaten AS kontakt
		ON platz.nutzer_bootsanbindeplatz = kontakt.t_id
),

daten_mfk AS (
	SELECT
		Stammnummer AS bootskennzeichen,
		"Länge [cm]" AS bootslaenge,
		"Name" AS aname,
		Vorname AS vorname,
		Adresse AS strasse_nr,
		plz,
		ort
	FROM
		afu_bootsanbindeplaetze_mfk.main.data_mfk
)

SELECT
	afu.Bootsanbindeplatz_ID,
	afu.bootskennzeichen,
	CASE
		WHEN 
	END
	
	afu.geometrie
FROM
	daten_afu AS afu
LEFT JOIN daten_mfk AS mfk 
	ON afu.bootskennzeichen = mfk.bootskennzeichen
	