SELECT
   wkb_geometry AS geometrie, 
   CASE WHEN r_lr_prozent = 10 THEN 'r_lr_1' WHEN r_lr_prozent = 100 THEN 'r_lr_90' END AS letalitaetsradius_art,
   round(r_p_lr::numeric,2) AS letalitaetsradius,
   CASE WHEN typ = 'vz' THEN 'Wohnbevoelkerung' WHEN typ = 'bz' THEN 'Arbeitsbevoelkerung' WHEN typ = 'vzbz' THEN 'WohnUndArbeitsbevoelkerung' END AS bevoelkerung_typ,
	 -- temporary storing the id, as the old data doesn't hold the population
   szenario_id AS bevoelkerung_anzahl,
   risiko AS risikozahl,
   n_tote AS anzahl_tote,
   99999 AS id_szenario
FROM
 qrcat.betbev_ot_letalflaechen_pt
  -- only select records where find a correspondence to a Szenario
  WHERE szenario_id IN (SELECT szenario_id FROM qrcat."tbl_RCAT_SZENARIO" WHERE id_assoziation IS NOT NULL AND id_assoziation NOT IN (325329,325132,423613))
;
