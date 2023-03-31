DELETE FROM awjf_efj_geodaten_upload_v1.gebiete_gebiet
;

INSERT INTO 
    awjf_efj_geodaten_upload_v1.gebiete_gebiet ( 
        identifikator,
        geometrie_flaeche,
        typ 
    )
SELECT 
    nummer AS identifikator, 
    geometrie AS geometrie_flaeche, 
    'Jagdrevier' AS typ
FROM 
    awjf_jagdreviere_jagdbanngebiete_v1.jagdreviere_jagdreviere
;

INSERT INTO 
    awjf_efj_geodaten_upload_v1.gebiete_gebiet ( 
        identifikator,
        geometrie_flaeche,
        typ 
    )
SELECT 
    9999 AS identifikator, 
    geometrie AS geometrie_flaeche, 
    'Kanton' AS typ
FROM 
    agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze
;

INSERT INTO 
    awjf_efj_geodaten_upload_v1.gebiete_gebiet ( 
        identifikator,
        geometrie_linie,
        typ 
    )
SELECT 
    CASE 
    	WHEN revierid = 'A1' THEN 1::TEXT 
    	WHEN revierid = 'A2' THEN 2::TEXT
    	WHEN revierid = 'A3' THEN 3::TEXT
    	WHEN revierid = 'A4' THEN 4::TEXT
    	WHEN revierid = 'A5' THEN 5::TEXT
    	WHEN revierid = 'A6' THEN 6::TEXT
    	WHEN revierid = 'B' THEN 10::TEXT
    	WHEN revierid = 'CH' THEN 23::TEXT
    	WHEN revierid = 'D' THEN 20::TEXT
    	WHEN revierid = 'E' THEN 11::TEXT
    	WHEN revierid = 'EK' THEN 12::TEXT
    	WHEN revierid = 'LS' THEN 21::TEXT
    	WHEN revierid = 'LT' THEN 22::TEXT
    	WHEN revierid = 'S1' THEN 901::TEXT
    	WHEN revierid = 'S2' THEN 902::TEXT
    	WHEN revierid = 'S3' THEN 903::TEXT
    	ELSE revierid
    END AS identifikator, 
    ST_Multi(ST_RemoveRepeatedPoints(ST_Union(geometrie), 0.001)) AS geometrie_linie, 
    'Fischereirevier' AS typ
FROM 
    afu_gewaesser_v1.fischrevierabschnitt_v 
GROUP BY 
    revierid
;

INSERT INTO 
    awjf_efj_geodaten_upload_v1.transfermetadaten_datenbestand (
        gueltig_ab
    )
SELECT 
    now() AS gueltig_ab 
;