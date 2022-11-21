-- Remove temporary Bemerkungen used for migration
-- F-Werte
UPDATE ${DB_Schema_QRcat}.qrcat_fwert
	SET bemerkung = NULL;

-- remove dummy record
DELETE FROM ${DB_Schema_QRcat}.qrcat_fwert WHERE t_id = 99999;

-- Detailszenario-Grundhäufigkeit
UPDATE ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit
	SET bemerkung = NULL;

-- remove dummy record
DELETE FROM ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit WHERE t_id = 99999;

-- Toxreferenzszenario
UPDATE ${DB_Schema_QRcat}.qrcat_toxreferenzszenario
	SET bemerkung = NULL;

-- remove dummy record
DELETE FROM ${DB_Schema_QRcat}.qrcat_toxreferenzszenario WHERE t_id = 99999;

-- Szenario
UPDATE ${DB_Schema_QRcat}.qrcat_szenario
	SET bemerkung = NULL;
