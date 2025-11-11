COPY (
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
		afu_bootsanbindeplaetze_mfk.main.abgleich_mfk)
TO ${exportPathAbgleich} WITH (FORMAT GDAL, DRIVER 'GPKG');