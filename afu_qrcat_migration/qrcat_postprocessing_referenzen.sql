-- postprocessing F-Werte
-- ----------------------
-- F_BDO-Werte
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
	SET f_bdo = fbdo.t_id
FROM
   ${DB_Schema_QRcat}.qrcat_fwert fbdo
     WHERE fbdo.bemerkung = (s.bemerkung::jsonb -> 'f_bdo')::varchar;
     
-- F_CAR-Werte
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
	SET f_car = fcar.t_id
FROM
   ${DB_Schema_QRcat}.qrcat_fwert fcar
     WHERE fcar.bemerkung = (s.bemerkung::jsonb -> 'f_car')::varchar;
     
-- F_SIK-Werte
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
	SET f_sik = fsik.t_id
FROM
   ${DB_Schema_QRcat}.qrcat_fwert fsik
     WHERE fsik.bemerkung = (s.bemerkung::jsonb -> 'f_sik')::varchar;
     
-- F_SMN-Werte
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
	SET f_smn = fsmn.t_id
FROM
   ${DB_Schema_QRcat}.qrcat_fwert fsmn
     WHERE fsmn.bemerkung = (s.bemerkung::jsonb -> 'f_smn')::varchar;
     
-- postprocessing weitere Referenzen
-- ---------------------------------
-- id_detailszenarioghk
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
  SET id_detailszenarioghk = ghk.t_id
 FROM
   ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit ghk
     WHERE ghk.bemerkung = (s.bemerkung::jsonb -> 'id_detailszenarioghk')::varchar;

-- id_toxreferenzszenario
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
	SET id_toxreferenzszenario = toxr.t_id
FROM
   ${DB_Schema_QRcat}.qrcat_toxreferenzszenario toxr
     WHERE toxr.bemerkung = (s.bemerkung::jsonb -> 'id_toxreferenzszenario')::varchar;
     
-- id_toxreferenzszenario, NULL-Werte behandeln
UPDATE ${DB_Schema_QRcat}.qrcat_szenario s
	SET id_toxreferenzszenario = NULL
     WHERE id_toxreferenzszenario = 99999;
     
-- Referenzen Letalfläche korrigieren
UPDATE ${DB_Schema_QRcat}.qrcat_letalflaeche l
    SET id_szenario = s.t_id
 FROM ${DB_Schema_QRcat}.qrcat_szenario s
      WHERE s.t_id != 99999 AND l.bevoelkerung_anzahl::integer = (s.bemerkung::jsonb -> 'szenario_id')::integer;

-- Referenzen toxisch ungünstigster Sektor
UPDATE ${DB_Schema_QRcat}.qrcat_toxischunguenstigster_sektor sekt
    SET id_szenario = szen.t_id
 FROM ${DB_Schema_QRcat}.qrcat_szenario szen
      WHERE szen.t_id != 99999 AND sekt.bevoelkerung_anzahl::integer = (szen.bemerkung::jsonb -> 'szenario_id')::integer;
