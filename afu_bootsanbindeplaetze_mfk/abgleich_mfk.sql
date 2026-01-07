DELETE FROM afu_bootsanbindeplaetze_mfk.main.abgleich_mfk;

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
		boot.bootslaenge * 100 AS bootslaenge,
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
		schild AS bootskennzeichen,
		"Länge [cm]" AS bootslaenge,
		"Breite [cm]" AS bootsbreite,
		"Motorenstärke Hauptantrieb [kw]" AS motorenstaerke,
		"Name" AS aname,
		Vorname AS vorname,
		Adresse AS strasse_nr,
		plz,
		ort
	FROM
		afu_bootsanbindeplaetze_mfk.main.data_mfk
),

abgleich AS (
	SELECT
		afu.Bootsanbindeplatz_ID,
		afu.bootskennzeichen,
		mfk.vorname AS Vorname_MFK,
		mfk.aname AS Nachname_MFK,
		mfk.strasse_nr AS Adresse_MFK,
		mfk.plz AS PLZ_MFK,
		mfk.ort AS Ort_MFK,
		mfk.bootslaenge / 100 AS MFK_Bootslaenge,
		mfk.bootsbreite / 100 AS MFK_Bootsbreite,
		mfk.motorenstaerke AS MFK_Motorenstaerke_Boot,
		CASE
			WHEN afu.aname = mfk.aname 
			AND afu.vorname = mfk.vorname
			AND afu.strasse_nr = mfk.strasse_nr
			AND afu.plz = mfk.plz
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS Personendaten_gleich,
		CASE
			WHEN mfk.vorname IS NULL
			AND mfk.aname IS NULL
			THEN 
				TRUE 
			ELSE 
				FALSE
		END Kein_Match_MFK,
		CASE
			WHEN afu.vorname = mfk.vorname
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS Vorname_gleich,
		CASE
			WHEN afu.aname = mfk.aname 
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS Nachname_gleich,
		CASE
			WHEN afu.strasse_nr = mfk.strasse_nr
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS Adresse_gleich,
		CASE
			WHEN afu.plz = mfk.plz
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS PLZ_gleich,
		CASE
			WHEN afu.ort = mfk.ort
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS Ort_gleich,
		CASE
			WHEN afu.bootslaenge = mfk.bootslaenge 
				THEN 
					TRUE 
				ELSE 
					FALSE
		END AS Bootslaenge_gleich,
		afu.geometrie
	FROM
		daten_afu AS afu
	LEFT JOIN daten_mfk AS mfk 
		ON afu.bootskennzeichen = mfk.bootskennzeichen
)

INSERT INTO afu_bootsanbindeplaetze_mfk.main.abgleich_mfk(
	Bootsanbindeplatz_ID,
	bootskennzeichen,
	Vorname_MFK,
	Nachname_MFK,
	Adresse_MFK,
	PLZ_MFK,
	Ort_MFK,
	MFK_Bootslaenge,
	MFK_Bootsbreite,
	MFK_Motorenstaerke_Boot,
	Personendaten_gleich,
	Kein_Match_MFK,
	Vorname_gleich,
	Nachname_gleich,
	Adresse_gleich,
	PLZ_gleich,
	Ort_gleich,
	Bootslaenge_gleich
)

SELECT 
	Bootsanbindeplatz_ID,
	bootskennzeichen,
	Vorname_MFK,
	Nachname_MFK,
	Adresse_MFK,
	PLZ_MFK,
	Ort_MFK,
	MFK_Bootslaenge,
	MFK_Bootsbreite,
	MFK_Motorenstaerke_Boot,
	Personendaten_gleich,
	Kein_Match_MFK,
	Vorname_gleich,
	Nachname_gleich,
	Adresse_gleich,
	PLZ_gleich,
	Ort_gleich,
	Bootslaenge_gleich
FROM
	abgleich