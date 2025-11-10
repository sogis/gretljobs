COPY (
	SELECT
		Bootsanbindeplatz_ID,
		bootskennzeichen,
		Personendaten_gleich,
		Kein_Match_MFK,
		Vorname_gleich,
		Nachname_gleich,
		Adresse_gleich,
		PLZ_gleich,
		Bootslaenge_gleich
	FROM
		afu_bootsanbindeplaetze_mfk.main.abgleich_mfk)
TO ${exportPathAbgleich} WITH (FORMAT GDAL, DRIVER 'GPKG');