SELECT 
  t_id, 
  t_ili_tid, 
  stoff, 
  typstoff, 
  lrsz90_refletalitaetsradius, 
  lrsz1_refletalitaetsradius, 
  bi_stoffspez_exponent, 
  lw90_letalwert, 
  lw1_letalwert, 
  bemerkung 
FROM 
  ${DB_Schema_QRcat}.qrcat_toxreferenzszenario;