-- delete previous data that should be replaced
DELETE FROM ${DB_Schema_QRcat}.qrcat_toxischunguenstigster_sektor;
DELETE FROM ${DB_Schema_QRcat}.qrcat_letalflaeche;
DELETE FROM ${DB_Schema_QRcat}.qrcat_szenario;
DELETE FROM ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit;
DELETE FROM ${DB_Schema_QRcat}.qrcat_toxreferenzszenario;
DELETE FROM ${DB_Schema_QRcat}.qrcat_fwert;

-- Insert dummy entries to allow szenarios to reference dummy entries, that can later be corrected in post-processing
-- insert dummy in qrcat_toxreferenzszenario
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_fwert
     (t_id, t_ili_tid, fwert, bemerkung)
     VALUES(99999, uuid_generate_v4(), 0, 'dummy');

-- insert dummy in qrcat_toxreferenzszenario
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_toxreferenzszenario
     (t_id, t_ili_tid, stoff, typstoff, lrsz90_refletalitaetsradius, lrsz1_refletalitaetsradius, bi_stoffspez_exponent, lw90_letalwert, lw1_letalwert)
     VALUES(99999, uuid_generate_v4(), 'dummy', 'fluessig', 0, 0, 0, 0, 0);
   
-- insert dummy in qrcat_detailszenario_grundhaeufigkeit
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit
    (t_id, t_ili_tid, beschreibung, szenario_art, abkuerzung_detailszenario, acode, grundhaeufigkeit_szenario, wahrscheinlichkeit_grundhaeufigkeit_art, relevant_asz, relevant_msz, relevant_q_stoff)
    VALUES(99999, uuid_generate_v4(), 'dummy', 'Brand', 'lb', 'lb_ft4', 0.000001, 'pro_Jahr', false, false, false);

-- insert dummy in qrcat_szenario
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_szenario
   (t_id,t_ili_tid, szenario_titel, geometrie, szenario_art, wahrscheinlichkeit_szenario, asz_relevante_freisetzungsflaeche, msz_relevante_freigesetzte_stoffmenge, q_stoff_stoffspezverbrennungswaerme, lsz_90, lsz_1, betriebsfaktor_f_anz, bemerkung, f_bdo, f_car, f_sik, f_smn, id_detailszenarioghk, id_toxreferenzszenario, id_bereich, id_betrieb, id_stoff, id_stoff_in_bereich)
   VALUES(99999, uuid_generate_v4(), 'dummy', ST_GeometryFromText('POINT(0 0)'), 'Brand', 0.9, 0, 0, 50, 10, 20, 1, '{"szenario_id":99999,"f_bdo":2,"f_car":2,"f_sik":2,"f_smn":2,"id_detailszenarioghk":17,"id_toxreferenzszenario":5}', 99999, 99999, 99999, 99999, 99999, 99999, 324646, 324091, 302375, 325290);


