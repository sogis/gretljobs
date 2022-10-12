-- delete previous data that should be replaced
DELETE FROM ${DB_Schema_QRcat}.qrcat_szenario;
DELETE FROM ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit;
DELETE FROM ${DB_Schema_QRcat}.qrcat_toxreferenzszenario;
DELETE FROM ${DB_Schema_QRcat}.qrcat_fwert;

-- Insert dummy entries to allow szenarios to reference dummy entries, that can later be corrected in post-processing
-- insert dummy in qrcat_toxreferenzszenario
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_fwert
     (t_id, t_ili_tid, fwert, bemerkung)
     VALUES(1, uuid_generate_v4(), 0, 'dummy');

-- insert dummy in qrcat_toxreferenzszenario
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_toxreferenzszenario
     (t_id, t_ili_tid, stoff, typstoff, lrsz90_refletalitaetsradius, lrsz1_refletalitaetsradius, bi_stoffspez_exponent, lw90_letalwert, lw1_letalwert)
     VALUES(1, uuid_generate_v4(), 'dummy', 'fluessig', 0, 0, 0, 0, 0);
   
-- insert dummy in qrcat_detailszenario_grundhaeufigkeit
INSERT INTO
  ${DB_Schema_QRcat}.qrcat_detailszenario_grundhaeufigkeit
    (t_id, t_ili_tid, beschreibung, szenario_art, abkuerzung_detailszenario, acode, grundhaeufigkeit_szenario, wahrscheinlichkeit_grundhaeufigkeit_art, relevant_asz, relevant_msz, relevant_q_stoff)
    VALUES(1, uuid_generate_v4(), 'dummy', 'Brand', 'lb', 'lb_ft4', 0.000001, 'pro_Jahr', false, false, false);



